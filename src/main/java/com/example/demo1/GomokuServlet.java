package com.example.demo1;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Deque;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

/** 五子棋联机房间：15路棋盘、黑先、连五判胜；空位可用「🤖 加机器人」补位测试。 */
@WebServlet(name = "gomokuServlet", value = "/gomoku")
public class GomokuServlet extends HttpServlet {

    private static final int N = 15;
    private static final long MEMBER_TTL = 45_000L;
    private static final long MSG_TTL = 10 * 60_000L;
    private static final int MAX_MSG = 60;
    private static final int MAX_ROOM = 32, MAX_NAME = 24, MAX_TEXT = 200;
    private static final Random RND = new Random();

    static final class Member { final String name; volatile long lastSeen; Member(String n) { name = n; lastSeen = System.currentTimeMillis(); } }
    static final class Msg {
        final String name, text, sc, sf; final long time;
        Msg(String n, String t, long tm) { this(n, t, null, null, tm); }
        Msg(String n, String t, String c, String f, long tm) { name = n; text = t; sc = c; sf = f; time = tm; }
    }
    static final class Room {
        final Map<String, Member> members = new LinkedHashMap<>();
        final Deque<Msg> msgs = new ArrayDeque<>();
        final int[][] board = new int[N][N];
        String black, white;              // 玩家名，null = 空位
        boolean blackBot, whiteBot;       // 该座位是机器人
        int turn = 1;                     // 1 黑 2 白
        int phase = 0;                    // 0 等待 1 对局 2 结束
        int winner = 0;                   // 0 无/平 1 黑胜 2 白胜
        int lastX = -1, lastY = -1, moves = 0;
        List<int[]> line;                 // 五连坐标
        volatile long lastMoveAt;         // 上一次落子的时间戳（配合机器人思考延迟动画）
        final Deque<Snap> hist = new ArrayDeque<>();   // 每步落子前的快照，用于悔棋
        String undoReq;                   // 发起悔棋请求的玩家名（需对方同意）
    }

    /** 落子前局面快照，悔棋时回退 */
    static final class Snap {
        final int[][] board; final int turn, lastX, lastY, moves, phase, winner; final List<int[]> line;
        Snap(Room r) {
            board = new int[N][];
            for (int i = 0; i < N; i++) board[i] = r.board[i].clone();
            turn = r.turn; lastX = r.lastX; lastY = r.lastY; moves = r.moves; phase = r.phase; winner = r.winner; line = r.line;
        }
    }

    @SuppressWarnings("unchecked")
    private Map<String, Room> rooms() {
        Object o = getServletContext().getAttribute("GOMOKU_ROOMS");
        if (o == null) synchronized (this) {
            if (getServletContext().getAttribute("GOMOKU_ROOMS") == null) {
                o = new ConcurrentHashMap<String, Room>();
                getServletContext().setAttribute("GOMOKU_ROOMS", o);
            }
        }
        return (Map<String, Room>) o;
    }
    private Room room(String id) {
        Map<String, Room> m = rooms(); Room r = m.get(id);
        if (r == null) { r = new Room(); Room old = m.putIfAbsent(id, r); if (old != null) r = old; }
        return r;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        if (req.getParameter("list") != null) { writeList(resp); return; }
        String id = clean(req.getParameter("id"), MAX_ROOM), name = clean(req.getParameter("name"), MAX_NAME);
        if (id == null || id.isEmpty() || name == null || name.isEmpty()) { write(resp, "{\"error\":\"no room/name\"}"); return; }
        Room r = room(id); String json;
        synchronized (r) {
            touch(r, name, System.currentTimeMillis());
            if (needsReset(r)) resetToLobby(r);
            seat(r, name);
            botPlay(r);
            json = state(r, name);
        }
        write(resp, json);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        String id = clean(req.getParameter("id"), MAX_ROOM), name = clean(req.getParameter("name"), MAX_NAME);
        String action = req.getParameter("action");
        if (id == null || id.isEmpty() || name == null || name.isEmpty()) { write(resp, "{\"ok\":false,\"error\":\"缺少房间或名字\"}"); return; }
        Room r = room(id); String out;
        synchronized (r) {
            long now = System.currentTimeMillis();
            touch(r, name, now);
            seat(r, name);
            switch (action == null ? "" : action) {
                case "leave": {
                    r.members.remove(name);
                    if (name.equals(r.undoReq)) r.undoReq = null;
                    boolean isB = name.equals(r.black), isW = name.equals(r.white);
                    if (isB || isW) {
                        if (r.phase == 0) {                    // 等待阶段：直接空出座位
                            if (isB) { r.black = null; r.blackBot = false; }
                            else { r.white = null; r.whiteBot = false; }
                        } else {                               // 对局中：转成电脑接管（同斗地主），稍后若已无真人则自动重置
                            if (isB) { r.black = "电脑·黑"; r.blackBot = true; }
                            else { r.white = "电脑·白"; r.whiteBot = true; }
                        }
                    }
                    out = "{\"ok\":true}"; break;
                }
                case "chat": {
                    String text = clean(req.getParameter("text"), MAX_TEXT);
                    String sc = clean(req.getParameter("scat"), 20), sf = clean(req.getParameter("sfile"), 120);
                    if (safe(sc) && safe(sf)) r.msgs.addLast(new Msg(name, "", sc, sf, now));
                    else if (text != null && !text.isEmpty()) r.msgs.addLast(new Msg(name, text, now));
                    while (r.msgs.size() > MAX_MSG) r.msgs.pollFirst();
                    out = "{\"ok\":true}"; break;
                }
                case "addbot": {
                    if (r.phase != 0) out = "{\"ok\":false,\"error\":\"只有等待入座时可以加机器人\"}";
                    else if (r.blackBot && r.whiteBot) out = "{\"ok\":false,\"error\":\"两个座位都是机器人了\"}";
                    else if (r.blackBot && r.white == null && r.black != null && !name.equals(r.black)) { r.white = name; out = "{\"ok\":true}"; }
                    else if (r.whiteBot && r.black == null && r.white != null && !name.equals(r.white)) { r.black = name; out = "{\"ok\":true}"; }
                    else if (r.black == null) { r.black = "机器人·黑"; r.blackBot = true; out = "{\"ok\":true}"; }
                    else if (r.white == null) { r.white = "机器人·白"; r.whiteBot = true; out = "{\"ok\":true}"; }
                    else out = "{\"ok\":false,\"error\":\"两个座位都满了\"}";
                    break;
                }
                case "move": {
                    out = move(r, name, req.getParameter("x"), req.getParameter("y")); break;
                }
                case "resign": {
                    if (r.phase != 1 || !isPlayer(r, name)) out = "{\"ok\":false,\"error\":\"现在不能认输\"}";
                    else { r.winner = name.equals(r.black) ? 2 : 1; r.phase = 2; out = "{\"ok\":true}"; }
                    break;
                }
                case "undo": {
                    out = undoReq(r, name); break;
                }
                case "undoYes": {
                    if (r.undoReq == null) out = "{\"ok\":false,\"error\":\"没有待处理的悔棋请求\"}";
                    else if (r.undoReq.equals(name)) out = "{\"ok\":false,\"error\":\"不能回应自己的悔棋请求\"}";
                    else if (!isPlayer(r, name)) out = "{\"ok\":false,\"error\":\"只有棋手可以回应\"}";
                    else {
                        String who = r.undoReq;
                        int reqColor = who.equals(r.black) ? 1 : 2;
                        if (doUndo(r, reqColor)) { sys(r, who + " 悔棋成功"); out = "{\"ok\":true,\"undone\":true}"; }
                        else { r.undoReq = null; out = "{\"ok\":false,\"error\":\"已无可悔的棋\"}"; }
                    }
                    break;
                }
                case "undoNo": {
                    if (r.undoReq == null) out = "{\"ok\":false,\"error\":\"没有待处理的悔棋请求\"}";
                    else if (r.undoReq.equals(name)) { r.undoReq = null; out = "{\"ok\":true}"; }        // 请求者撤回
                    else if (!isPlayer(r, name)) out = "{\"ok\":false,\"error\":\"只有棋手可以回应\"}";
                    else { sys(r, name + " 拒绝了对方的悔棋请求"); r.undoReq = null; out = "{\"ok\":true}"; }
                    break;
                }
                case "restart": {
                    if (!isPlayer(r, name)) out = "{\"ok\":false,\"error\":\"只有对局双方可以重开\"}";
                    else {
                        for (int[] row : r.board) Arrays.fill(row, 0);
                        String t = r.black; r.black = r.white; r.white = t;
                        boolean tb = r.blackBot; r.blackBot = r.whiteBot; r.whiteBot = tb;      // 换先手
                        r.turn = 1; r.phase = 0; r.winner = 0; r.line = null;
                        r.lastX = r.lastY = -1; r.moves = 0;
                        r.hist.clear(); r.undoReq = null;
                        botPlay(r);
                        out = "{\"ok\":true}";
                    }
                    break;
                }
                default: out = "{\"ok\":false,\"error\":\"未知操作\"}";
            }
            botPlay(r);
            if (needsReset(r)) resetToLobby(r);
        }
        write(resp, out);
    }

    /** 空位自动入座（仅等待阶段；两座位满则为观战） */
    private void seat(Room r, String name) {
        if (r.phase != 0 || name == null || name.isEmpty()) return;
        if (name.equals(r.black) || name.equals(r.white)) return;
        if (r.black == null) r.black = name;
        else if (r.white == null) r.white = name;
    }

    /** 轮到机器人时立刻落子（请求驱动，无需后台线程） */
    private void botPlay(Room r) {
        int guard = 0;
        while (guard++ < 2) {
            if (r.phase == 2 || r.black == null || r.white == null) return;
            boolean botTurn = (r.turn == 1 && r.blackBot) || (r.turn == 2 && r.whiteBot);
            if (!botTurn) return;
            if (System.currentTimeMillis() - r.lastMoveAt < 450) return;   // 思考延迟：让玩家这步先动画落定
            int me = r.turn, op = me == 1 ? 2 : 1;
            int[] t = bestCell(r, me, 5); if (t == null) t = bestCell(r, op, 5);
            if (t == null) t = bestCell(r, me, 4); if (t == null) t = bestCell(r, op, 4);
            if (t == null) t = bestCell(r, me, 3); if (t == null) t = bestCell(r, op, 3);
            if (t == null) t = nearLast(r);
            if (t == null) return;
            pushSnap(r);
            r.board[t[1]][t[0]] = me; r.lastX = t[0]; r.lastY = t[1]; r.moves++;
            r.lastMoveAt = System.currentTimeMillis();
            if (r.phase == 0) r.phase = 1;
            List<int[]> win = checkWin(r, t[0], t[1], me);
            if (win != null) { r.line = win; r.winner = me; r.phase = 2; }
            else if (r.moves >= N * N) { r.winner = 0; r.phase = 2; }
            else r.turn = op;
        }
    }
    private int[] bestCell(Room r, int color, int need) {
        for (int y = 0; y < N; y++) for (int x = 0; x < N; x++) {
            if (r.board[y][x] != 0) continue;
            if (runAt(r, x, y, color) >= need) return new int[]{x, y};
        }
        return null;
    }
    private int runAt(Room r, int x, int y, int c) {
        int[][] dirs = {{1, 0}, {0, 1}, {1, 1}, {1, -1}};
        int best = 1;
        for (int[] d : dirs) {
            int n = 1;
            for (int s = 1; s < N; s++) { int nx = x + d[0] * s, ny = y + d[1] * s; if (out(nx, ny) || r.board[ny][nx] != c) break; n++; }
            for (int s = 1; s < N; s++) { int nx = x - d[0] * s, ny = y - d[1] * s; if (out(nx, ny) || r.board[ny][nx] != c) break; n++; }
            if (n > best) best = n;
        }
        return best;
    }
    private int[] nearLast(Room r) {
        if (r.moves == 0) return new int[]{7, 7};
        List<int[]> pool = new ArrayList<>();
        for (int y = 0; y < N; y++) for (int x = 0; x < N; x++) {
            if (r.board[y][x] != 0) continue;
            boolean near = false;
            for (int dy = -1; dy <= 1 && !near; dy++) for (int dx = -1; dx <= 1; dx++) {
                int nx = x + dx, ny = y + dy;
                if (!out(nx, ny) && r.board[ny][nx] != 0) { near = true; break; }
            }
            if (near) pool.add(new int[]{x, y});
        }
        return pool.isEmpty() ? new int[]{7, 7} : pool.get(RND.nextInt(pool.size()));
    }

    private void touch(Room r, String name, long now) {
        Member m = r.members.get(name);
        if (m == null) r.members.put(name, new Member(name)); else m.lastSeen = now;
        r.members.entrySet().removeIf(e -> now - e.getValue().lastSeen > MEMBER_TTL);
        while (!r.msgs.isEmpty() && now - r.msgs.peekFirst().time > MSG_TTL) r.msgs.pollFirst();
    }

    private String move(Room r, String name, String xs, String ys) {
        if (r.phase == 2) return "{\"ok\":false,\"error\":\"本局已结束\"}";
        if (r.black == null || r.white == null) return "{\"ok\":false,\"error\":\"等待两位玩家入座\"}";
        if (!isPlayer(r, name)) return "{\"ok\":false,\"error\":\"你不是本局棋手（观战中）\"}";
        int color = name.equals(r.black) ? 1 : 2;
        if (r.turn != color) return "{\"ok\":false,\"error\":\"还没轮到你\"}";
        int x, y;
        try { x = Integer.parseInt(xs.trim()); y = Integer.parseInt(ys.trim()); }
        catch (Exception e) { return "{\"ok\":false,\"error\":\"坐标非法\"}"; }
        if (x < 0 || y < 0 || x >= N || y >= N || r.board[y][x] != 0) return "{\"ok\":false,\"error\":\"这里不能落子\"}";
        pushSnap(r);
        r.board[y][x] = color; r.lastX = x; r.lastY = y; r.moves++;
        r.lastMoveAt = System.currentTimeMillis();
        if (r.phase == 0) r.phase = 1;                       // 第一手自动开局
        List<int[]> win = checkWin(r, x, y, color);
        if (win != null) { r.line = win; r.winner = color; r.phase = 2; }
        else if (r.moves >= N * N) { r.winner = 0; r.phase = 2; }
        else r.turn = color == 1 ? 2 : 1;
        return "{\"ok\":true}";
    }

    private static boolean isPlayer(Room r, String n) { return n.equals(r.black) || n.equals(r.white); }

    // ================= 悔棋 =================
    private void pushSnap(Room r) {
        r.hist.addLast(new Snap(r));
        while (r.hist.size() > 240) r.hist.pollFirst();
    }
    private String undoReq(Room r, String name) {
        if (r.phase == 0 || r.hist.isEmpty()) return "{\"ok\":false,\"error\":\"现在不能悔棋\"}";
        if (!isPlayer(r, name)) return "{\"ok\":false,\"error\":\"只有棋手可以悔棋\"}";
        if (r.undoReq != null && !r.undoReq.equals(name)) return "{\"ok\":false,\"error\":\"对方已发起悔棋，请先处理\"}";
        if (r.undoReq != null) { r.undoReq = null; return "{\"ok\":true,\"cancel\":true}"; }   // 再点一次 = 取消
        int myColor = name.equals(r.black) ? 1 : 2;
        boolean oppBot = myColor == 1 ? r.whiteBot : r.blackBot;
        if (oppBot) {                                                                          // 对手是机器人：直接悔
            if (doUndo(r, myColor)) { sys(r, name + " 悔棋成功"); return "{\"ok\":true,\"undone\":true}"; }
            return "{\"ok\":false,\"error\":\"已无可悔的棋\"}";
        }
        r.undoReq = name;                                                                      // 对手是真人：等待同意
        return "{\"ok\":true,\"need\":true}";
    }
    private boolean doUndo(Room r, int reqColor) {
        if (r.hist.isEmpty()) return false;
        restore(r, r.hist.pollLast());
        if (r.turn != reqColor && !r.hist.isEmpty()) restore(r, r.hist.pollLast());          // 回退一整轮，落回请求方的回合
        r.undoReq = null;
        return true;
    }
    private static void restore(Room r, Snap s) {
        for (int i = 0; i < N; i++) r.board[i] = s.board[i].clone();
        r.turn = s.turn; r.lastX = s.lastX; r.lastY = s.lastY; r.moves = s.moves; r.phase = s.phase; r.winner = s.winner; r.line = s.line;
    }
    private void sys(Room r, String text) {
        r.msgs.addLast(new Msg("系统", text, System.currentTimeMillis()));
        while (r.msgs.size() > MAX_MSG) r.msgs.pollFirst();
    }

    // ================= 只剩电脑 / 无真人 → 自动重置，释放房间号 =================
    private static boolean needsReset(Room r) {
        boolean bh = r.black != null && !r.blackBot, wh = r.white != null && !r.whiteBot;
        if (bh || wh) return false;                                                          // 仍有真人棋手
        return r.phase != 0 || r.black != null || r.white != null || r.moves > 0;            // 座位被占用（电脑/未收的残局）才需要重置
    }
    private void resetToLobby(Room r) {
        for (int[] row : r.board) Arrays.fill(row, 0);
        r.black = r.white = null; r.blackBot = r.whiteBot = false;
        r.turn = 1; r.phase = 0; r.winner = 0; r.line = null;
        r.lastX = r.lastY = -1; r.moves = 0;
        r.hist.clear(); r.undoReq = null;
    }

    private List<int[]> checkWin(Room r, int x, int y, int c) {
        int[][] dirs = {{1, 0}, {0, 1}, {1, 1}, {1, -1}};
        for (int[] d : dirs) {
            List<int[]> line = new ArrayList<>();
            line.add(new int[]{x, y});
            for (int s = 1; s < N; s++) { int nx = x + d[0] * s, ny = y + d[1] * s; if (out(nx, ny) || r.board[ny][nx] != c) break; line.add(new int[]{nx, ny}); }
            for (int s = 1; s < N; s++) { int nx = x - d[0] * s, ny = y - d[1] * s; if (out(nx, ny) || r.board[ny][nx] != c) break; line.add(0, new int[]{nx, ny}); }
            if (line.size() >= 5) return line;
        }
        return null;
    }
    private static boolean out(int x, int y) { return x < 0 || y < 0 || x >= N || y >= N; }

    private void writeList(HttpServletResponse resp) throws IOException {
        long now = System.currentTimeMillis();
        StringBuilder sb = new StringBuilder("["); boolean first = true;
        for (Map.Entry<String, Room> en : rooms().entrySet()) {
            Room r = en.getValue(); StringBuilder sum = new StringBuilder();
            synchronized (r) {
                r.members.entrySet().removeIf(e -> now - e.getValue().lastSeen > MEMBER_TTL);
                int mc = r.members.size(); if (mc == 0) continue;
                StringBuilder p = new StringBuilder(); int np = 0;
                if (r.black != null) { p.append('"').append(esc(r.black)).append('"'); np++; }
                if (r.white != null) { if (np > 0) p.append(','); p.append('"').append(esc(r.white)).append('"'); }
                boolean canJoin = r.phase == 0 && (r.black == null || r.white == null);
                sum.append("{\"id\":\"").append(esc(en.getKey())).append("\",\"phase\":").append(r.phase)
                        .append(",\"players\":[").append(p).append("],\"members\":").append(mc)
                        .append(",\"canJoin\":").append(canJoin).append('}');
            }
            if (sum.length() == 0) continue;
            if (!first) sb.append(','); first = false; sb.append(sum);
        }
        sb.append(']'); write(resp, sb.toString());
    }

    private String state(Room r, String viewer) {
        StringBuilder sb = new StringBuilder(1024);
        sb.append("{\"phase\":").append(r.phase).append(",\"turn\":").append(r.turn).append(",\"winner\":").append(r.winner);
        sb.append(",\"black\":\"").append(esc(r.black == null ? "" : r.black)).append('"');
        sb.append(",\"white\":\"").append(esc(r.white == null ? "" : r.white)).append('"');
        sb.append(",\"myColor\":").append(viewer.equals(r.black) ? 1 : viewer.equals(r.white) ? 2 : 0);
        sb.append(",\"undoBy\":\"").append(esc(r.undoReq == null ? "" : r.undoReq)).append('"');
        sb.append(",\"last\":[").append(r.lastX).append(',').append(r.lastY).append(']');
        sb.append(",\"line\":");
        if (r.line == null) sb.append("null");
        else { sb.append('['); for (int i = 0; i < r.line.size(); i++) { if (i > 0) sb.append(','); sb.append(r.line.get(i)[0]).append(',').append(r.line.get(i)[1]); } sb.append(']'); }
        sb.append(",\"board\":\"");
        for (int y = 0; y < N; y++) for (int x = 0; x < N; x++) sb.append(r.board[y][x]);
        sb.append('"');
        sb.append(",\"members\":["); boolean f = true;
        for (String n : r.members.keySet()) { if (!f) sb.append(','); f = false; sb.append('"').append(esc(n)).append('"'); }
        sb.append(']');
        sb.append(",\"msg\":["); f = true; long now = System.currentTimeMillis();
        for (Msg m : r.msgs) {
            if (now - m.time > MSG_TTL) continue;
            if (!f) sb.append(','); f = false;
            sb.append("{\"n\":\"").append(esc(m.name)).append("\",\"t\":\"").append(esc(m.text)).append('"');
            if (m.sf != null) sb.append(",\"sc\":\"").append(esc(m.sc)).append("\",\"sf\":\"").append(esc(m.sf)).append('"');
            sb.append(",\"tms\":").append(m.time).append('}');
        }
        sb.append("]}");
        return sb.toString();
    }

    private static boolean safe(String s) {
        return s != null && !s.isEmpty() && s.indexOf('/') < 0 && s.indexOf('\\') < 0 && !s.contains("..");
    }

    private void write(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        PrintWriter out = resp.getWriter(); out.write(json); out.flush();
    }

    private static String clean(String s, int max) {
        if (s == null) return null;
        s = s.trim();
        StringBuilder b = new StringBuilder();
        for (int i = 0; i < s.length() && b.length() < max; i++) {
            char c = s.charAt(i);
            if (c == '\n' || c == '\r') b.append(' ');
            else if (c < 0x20) { }
            else b.append(c);
        }
        return b.toString();
    }

    private static String esc(String s) {
        if (s == null) return "";
        StringBuilder b = new StringBuilder(s.length() + 8);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"': b.append("\\\""); break;
                case '\\': b.append("\\\\"); break;
                case '\n': b.append("\\n"); break;
                case '\r': b.append("\\r"); break;
                case '\t': b.append("\\t"); break;
                default: if (c < 0x20) b.append(' '); else b.append(c);
            }
        }
        return b.toString();
    }
}
