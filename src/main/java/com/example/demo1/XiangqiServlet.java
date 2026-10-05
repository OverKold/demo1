package com.example.demo1;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayDeque;
import java.util.Deque;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

/** 中国象棋联机房间：9x10 棋盘、红先、完整走法校验（蹩马腿/塞象眼/炮翻山/士帅九宫/过河兵/白脸将），送将判非法。 */
@WebServlet(name = "xiangqiServlet", value = "/xiangqi")
public class XiangqiServlet extends HttpServlet {

    private static final int W = 9, H = 10, CELLS = W * H;
    private static final long MEMBER_TTL = 45_000L, MSG_TTL = 10 * 60_000L;
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
        String[] board = initial();
        String red, black;              // 玩家名，null = 空位
        boolean redBot, blackBot;       // 该座位是机器人
        int turn = 1;                   // 1 红（先手）2 黑
        int phase = 0;                  // 0 等待 1 对局 2 结束
        String winner = "";
        int lastFrom = -1, lastTo = -1;
        boolean check;                  // 当前行棋方是否被将军
        volatile long lastMoveAt;       // 上一次走子的时间戳（配合机器人思考延迟动画）
        final Deque<XSnap> hist = new ArrayDeque<>();   // 每步走子前的快照，用于悔棋
        String undoReq;                 // 发起悔棋请求的玩家名（需对方同意）
    }

    /** 走子前局面快照，悔棋时回退 */
    static final class XSnap {
        final String[] board; final int turn, lastFrom, lastTo, phase; final String winner; final boolean check;
        XSnap(Room r) { board = r.board.clone(); turn = r.turn; lastFrom = r.lastFrom; lastTo = r.lastTo; phase = r.phase; winner = r.winner; check = r.check; }
    }

    private static String[] initial() {
        String[] b = new String[CELLS];
        for (int i = 0; i < CELLS; i++) b[i] = "";
        String[] back = {"R", "M", "E", "A", "K", "A", "E", "M", "R"};
        for (int x = 0; x < W; x++) { b[x] = "b" + back[x]; b[9 * W + x] = "r" + back[x]; }
        b[2 * W + 1] = "bC"; b[2 * W + 7] = "bC";
        b[7 * W + 1] = "rC"; b[7 * W + 7] = "rC";
        for (int x = 0; x < W; x += 2) { b[3 * W + x] = "bP"; b[6 * W + x] = "rP"; }
        return b;
    }

    // ================= 走法 =================
    private static int sideOf(String p) { return p.charAt(0) == 'r' ? 1 : 2; }
    private static boolean inPalace(int x, int y, int side) { return x >= 3 && x <= 5 && (side == 1 ? y >= 7 : y <= 2); }
    private static boolean inOwnHalf(int y, int side) { return side == 1 ? y >= 5 : y <= 4; }
    private static boolean crossedRiver(int y, int side) { return side == 1 ? y <= 4 : y >= 5; }

    /** 两点之间（不含端点）是否畅通 */
    private static int screens(String[] b, int fx, int fy, int tx, int ty) {
        int n = 0;
        if (fx == tx) { for (int y = Math.min(fy, ty) + 1; y < Math.max(fy, ty); y++) if (!b[y * W + fx].isEmpty()) n++; }
        else if (fy == ty) { for (int x = Math.min(fx, tx) + 1; x < Math.max(fx, tx); x++) if (!b[fy * W + x].isEmpty()) n++; }
        else return -1;
        return n;
    }
    private static boolean clear(String[] b, int fx, int fy, int tx, int ty) { return screens(b, fx, fy, tx, ty) == 0; }

    /** 伪合法：只判棋子自身走法与路径，不管送将 */
    private static boolean canMove(String[] b, int fx, int fy, int tx, int ty) {
        if (fx < 0 || fy < 0 || tx < 0 || ty < 0 || fx >= W || fy >= H || tx >= W || ty >= H) return false;
        String p = b[fy * W + fx];
        if (p.isEmpty() || (fx == tx && fy == ty)) return false;
        String t = b[ty * W + tx];
        int side = sideOf(p);
        if (!t.isEmpty() && sideOf(t) == side) return false;
        int dx = tx - fx, dy = ty - fy, ax = Math.abs(dx), ay = Math.abs(dy);
        switch (p.charAt(1)) {
            case 'R': return (dx == 0 || dy == 0) && clear(b, fx, fy, tx, ty);
            case 'C': {
                if (dx != 0 && dy != 0) return false;
                int n = screens(b, fx, fy, tx, ty);
                return t.isEmpty() ? n == 0 : n == 1;
            }
            case 'M': {
                if (!((ax == 2 && ay == 1) || (ax == 1 && ay == 2))) return false;
                int lx = fx + (ax == 2 ? dx / 2 : 0), ly = fy + (ay == 2 ? dy / 2 : 0);   // 蹩马腿
                return b[ly * W + lx].isEmpty();
            }
            case 'A': return ax == 1 && ay == 1 && inPalace(tx, ty, side);
            case 'K': return ax + ay == 1 && inPalace(tx, ty, side);
            case 'E': {
                if (ax != 2 || ay != 2 || !inOwnHalf(ty, side)) return false;
                return b[((fy + ty) / 2) * W + (fx + tx) / 2].isEmpty();                    // 塞象眼
            }
            case 'P': {
                int fwd = side == 1 ? -1 : 1;
                if (dx == 0 && dy == fwd) return true;
                return dy == 0 && ax == 1 && crossedRiver(fy, side);                        // 过河兵可横走
            }
            default: return false;
        }
    }

    private static int findKing(String[] b, int side) {
        String k = (side == 1 ? "rK" : "bK");
        for (int i = 0; i < CELLS; i++) if (k.equals(b[i])) return i;
        return -1;
    }
    /** 白脸将：两帅同列且中间无子 */
    private static boolean kingsFacing(String[] b) {
        int rk = findKing(b, 1), bk = findKing(b, 2);
        if (rk < 0 || bk < 0) return false;
        int x = rk % W;
        if (bk % W != x) return false;
        int a = rk / W, c = bk / W;
        for (int y = Math.min(a, c) + 1; y < Math.max(a, c); y++) if (!b[y * W + x].isEmpty()) return false;
        return true;
    }
    private static boolean inCheck(String[] b, int side) {
        int k = findKing(b, side);
        if (k < 0) return true;
        int kx = k % W, ky = k / W, enemy = side == 1 ? 2 : 1;
        for (int i = 0; i < CELLS; i++) {
            String p = b[i];
            if (p.isEmpty() || sideOf(p) != enemy) continue;
            if (canMove(b, i % W, i / W, kx, ky)) return true;
        }
        return kingsFacing(b);
    }
    private static boolean legalMove(String[] b, int side, int fx, int fy, int tx, int ty) {
        if (!canMove(b, fx, fy, tx, ty)) return false;
        String[] c = b.clone();
        c[ty * W + tx] = c[fy * W + fx]; c[fy * W + fx] = "";
        return !inCheck(c, side);
    }
    private static boolean hasAnyLegal(String[] b, int side) {
        for (int i = 0; i < CELLS; i++) {
            String p = b[i];
            if (p.isEmpty() || sideOf(p) != side) continue;
            int fx = i % W, fy = i / W;
            for (int ty = 0; ty < H; ty++) for (int tx = 0; tx < W; tx++)
                if (legalMove(b, side, fx, fy, tx, ty)) return true;
        }
        return false;
    }

    // ================= 房间 =================
    @SuppressWarnings("unchecked")
    private Map<String, Room> rooms() {
        Object o = getServletContext().getAttribute("XQ_ROOMS");
        if (o == null) synchronized (this) {
            if (getServletContext().getAttribute("XQ_ROOMS") == null) {
                o = new ConcurrentHashMap<String, Room>();
                getServletContext().setAttribute("XQ_ROOMS", o);
            }
        }
        return (Map<String, Room>) o;
    }
    private Room room(String id) {
        Map<String, Room> m = rooms(); Room r = m.get(id);
        if (r == null) { r = new Room(); Room old = m.putIfAbsent(id, r); if (old != null) r = old; }
        return r;
    }
    private void touch(Room r, String name, long now) {
        Member m = r.members.get(name);
        if (m == null) r.members.put(name, new Member(name)); else m.lastSeen = now;
        r.members.entrySet().removeIf(e -> now - e.getValue().lastSeen > MEMBER_TTL);
        while (!r.msgs.isEmpty() && now - r.msgs.peekFirst().time > MSG_TTL) r.msgs.pollFirst();
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
                    boolean isR = name.equals(r.red), isB = name.equals(r.black);
                    if (isR || isB) {
                        if (r.phase == 0) {                    // 等待阶段：直接空出座位
                            if (isR) { r.red = null; r.redBot = false; }
                            else { r.black = null; r.blackBot = false; }
                        } else {                               // 对局中：转成电脑接管（同斗地主），稍后若已无真人则自动重置
                            if (isR) { r.red = "电脑·红"; r.redBot = true; }
                            else { r.black = "电脑·黑"; r.blackBot = true; }
                            if (r.winner == null) r.winner = "";
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
                    else if (r.red == null) { r.red = "机器人·红"; r.redBot = true; out = "{\"ok\":true}"; }
                    else if (r.black == null) { r.black = "机器人·黑"; r.blackBot = true; out = "{\"ok\":true}"; }
                    else out = "{\"ok\":false,\"error\":\"两个座位都满了\"}";
                    break;
                }
                case "move": {
                    out = move(r, name, req.getParameter("fx"), req.getParameter("fy"), req.getParameter("tx"), req.getParameter("ty"));
                    break;
                }
                case "resign": {
                    if (r.phase != 1 || !isPlayer(r, name)) out = "{\"ok\":false,\"error\":\"现在不能认输\"}";
                    else { r.winner = name.equals(r.red) ? r.black : r.red; r.phase = 2; if (r.winner == null) r.winner = ""; out = "{\"ok\":true}"; }
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
                        int reqColor = who.equals(r.red) ? 1 : 2;
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
                        r.board = initial();
                        String t = r.red; r.red = r.black; r.black = t;
                        boolean tb = r.redBot; r.redBot = r.blackBot; r.blackBot = tb;      // 换先后手
                        r.turn = 1; r.phase = 0; r.winner = ""; r.check = false;
                        r.lastFrom = r.lastTo = -1;
                        r.hist.clear(); r.undoReq = null;
                        botPlay(r);
                        out = "{\"ok\":true}";
                    }
                    break;
                }
                default: out = "{\"ok\":false,\"error\":\"未知操作\"}";
            }
            if (needsReset(r)) resetToLobby(r);
        }
        write(resp, out);
    }

    private String move(Room r, String name, String fxS, String fyS, String txS, String tyS) {
        if (r.phase == 2) return "{\"ok\":false,\"error\":\"本局已结束\"}";
        if (r.red == null || r.black == null) return "{\"ok\":false,\"error\":\"等待两位玩家入座\"}";
        if (!isPlayer(r, name)) return "{\"ok\":false,\"error\":\"你不是本局棋手（观战中）\"}";
        int side = name.equals(r.red) ? 1 : 2;
        if (r.turn != side) return "{\"ok\":false,\"error\":\"还没轮到你\"}";
        int fx, fy, tx, ty;
        try { fx = Integer.parseInt(fxS.trim()); fy = Integer.parseInt(fyS.trim()); tx = Integer.parseInt(txS.trim()); ty = Integer.parseInt(tyS.trim()); }
        catch (Exception e) { return "{\"ok\":false,\"error\":\"坐标非法\"}"; }
        String p = (fy >= 0 && fy < H && fx >= 0 && fx < W) ? r.board[fy * W + fx] : "";
        if (p.isEmpty() || sideOf(p) != side) return "{\"ok\":false,\"error\":\"那不是你的棋子\"}";
        if (!legalMove(r.board, side, fx, fy, tx, ty)) return "{\"ok\":false,\"error\":\"不能这样走（送将或不符规则）\"}";
        pushSnap(r);
        r.board[ty * W + tx] = r.board[fy * W + fx];
        r.board[fy * W + fx] = "";
        r.lastFrom = fy * W + fx; r.lastTo = ty * W + tx;
        r.lastMoveAt = System.currentTimeMillis();
        if (r.phase == 0) r.phase = 1;
        r.turn = side == 1 ? 2 : 1;
        r.check = inCheck(r.board, r.turn);
        if (!hasAnyLegal(r.board, r.turn)) {          // 将死 / 困毙
            r.phase = 2;
            r.winner = side == 1 ? r.red : r.black;
            if (r.winner == null) r.winner = "";
        }
        return "{\"ok\":true}";
    }
    private static boolean isPlayer(Room r, String n) { return n.equals(r.red) || n.equals(r.black); }

    // ================= 悔棋 =================
    private void pushSnap(Room r) {
        r.hist.addLast(new XSnap(r));
        while (r.hist.size() > 300) r.hist.pollFirst();
    }
    private String undoReq(Room r, String name) {
        if (r.phase == 0 || r.hist.isEmpty()) return "{\"ok\":false,\"error\":\"现在不能悔棋\"}";
        if (!isPlayer(r, name)) return "{\"ok\":false,\"error\":\"只有棋手可以悔棋\"}";
        if (r.undoReq != null && !r.undoReq.equals(name)) return "{\"ok\":false,\"error\":\"对方已发起悔棋，请先处理\"}";
        if (r.undoReq != null) { r.undoReq = null; return "{\"ok\":true,\"cancel\":true}"; }   // 再点一次 = 取消
        int myColor = name.equals(r.red) ? 1 : 2;
        boolean oppBot = myColor == 1 ? r.blackBot : r.redBot;
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
    private static void restore(Room r, XSnap s) {
        r.board = s.board; r.turn = s.turn; r.lastFrom = s.lastFrom; r.lastTo = s.lastTo; r.phase = s.phase; r.winner = s.winner; r.check = s.check;
    }
    private void sys(Room r, String text) {
        r.msgs.addLast(new Msg("系统", text, System.currentTimeMillis()));
        while (r.msgs.size() > MAX_MSG) r.msgs.pollFirst();
    }

    // ================= 只剩电脑 / 无真人 → 自动重置，释放房间号 =================
    private static boolean needsReset(Room r) {
        boolean rh = r.red != null && !r.redBot, bh = r.black != null && !r.blackBot;
        if (rh || bh) return false;                                                          // 仍有真人棋手
        return r.phase != 0 || r.red != null || r.black != null;                             // 座位被占用（电脑/未收的残局）才需要重置
    }
    private void resetToLobby(Room r) {
        r.board = initial();
        r.red = r.black = null; r.redBot = r.blackBot = false;
        r.turn = 1; r.phase = 0; r.winner = ""; r.check = false;
        r.lastFrom = r.lastTo = -1;
        r.hist.clear(); r.undoReq = null;
    }

    /** 空位自动入座（仅等待阶段）；已坐一个位的人不会占第二个，两满则为观战 */
    private void seat(Room r, String name) {
        if (r.phase != 0 || name == null || name.isEmpty()) return;
        if (name.equals(r.red) || name.equals(r.black)) return;
        if (r.red == null) r.red = name;
        else if (r.black == null) r.black = name;
    }

    /** 轮到机器人时立刻走子：吃子优先（按子力价值），其余带随机扰动 */
    private void botPlay(Room r) {
        int guard = 0;
        while (guard++ < 2) {
            if (r.phase == 2 || r.red == null || r.black == null) return;
            boolean botTurn = (r.turn == 1 && r.redBot) || (r.turn == 2 && r.blackBot);
            if (!botTurn) return;
            if (System.currentTimeMillis() - r.lastMoveAt < 450) return;   // 思考延迟：让玩家这步先动画落定
            int side = r.turn, bestF = -1, bestT = -1, bestV = -1;
            for (int i = 0; i < CELLS; i++) {
                String p = r.board[i];
                if (p.isEmpty() || sideOf(p) != side) continue;
                int fx = i % W, fy = i / W;
                for (int ty = 0; ty < H; ty++) for (int tx = 0; tx < W; tx++) {
                    if (!legalMove(r.board, side, fx, fy, tx, ty)) continue;
                    String tgt = r.board[ty * W + tx];
                    int v = (tgt.isEmpty() ? 0 : val(tgt.charAt(1))) + RND.nextInt(3);
                    if (v > bestV) { bestV = v; bestF = i; bestT = ty * W + tx; }
                }
            }
            if (bestF < 0) {                                   // 无路可走 = 困毙
                r.phase = 2; r.winner = side == 1 ? r.black : r.red; if (r.winner == null) r.winner = ""; return;
            }
            pushSnap(r);
            r.board[bestT] = r.board[bestF]; r.board[bestF] = "";
            r.lastFrom = bestF; r.lastTo = bestT;
            r.lastMoveAt = System.currentTimeMillis();
            if (r.phase == 0) r.phase = 1;
            r.turn = side == 1 ? 2 : 1;
            r.check = inCheck(r.board, r.turn);
            if (!hasAnyLegal(r.board, r.turn)) { r.phase = 2; r.winner = side == 1 ? r.red : r.black; if (r.winner == null) r.winner = ""; }
        }
    }
    private static int val(char t) {
        switch (t) {
            case 'R': return 9;
            case 'C': return 5;
            case 'M': return 4;
            case 'E': case 'A': return 2;
            case 'P': return 1;
            default: return 100;
        }
    }

    private void writeList(HttpServletResponse resp) throws IOException {
        long now = System.currentTimeMillis();
        StringBuilder sb = new StringBuilder("["); boolean first = true;
        for (Map.Entry<String, Room> en : rooms().entrySet()) {
            Room r = en.getValue(); StringBuilder sum = new StringBuilder();
            synchronized (r) {
                r.members.entrySet().removeIf(e -> now - e.getValue().lastSeen > MEMBER_TTL);
                int mc = r.members.size(); if (mc == 0) continue;
                StringBuilder p = new StringBuilder(); boolean has = false;
                if (r.red != null) { p.append('"').append(esc(r.red)).append('"'); has = true; }
                if (r.black != null) { if (has) p.append(','); p.append('"').append(esc(r.black)).append('"'); }
                boolean canJoin = r.phase == 0 && (r.red == null || r.black == null);
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
        sb.append("{\"phase\":").append(r.phase).append(",\"turn\":").append(r.turn).append(",\"check\":").append(r.check);
        sb.append(",\"red\":\"").append(esc(r.red == null ? "" : r.red)).append('"');
        sb.append(",\"black\":\"").append(esc(r.black == null ? "" : r.black)).append('"');
        sb.append(",\"myColor\":").append(viewer.equals(r.red) ? 1 : viewer.equals(r.black) ? 2 : 0);
        sb.append(",\"undoBy\":\"").append(esc(r.undoReq == null ? "" : r.undoReq)).append('"');
        sb.append(",\"winner\":\"").append(esc(r.winner)).append('"');
        sb.append(",\"last\":[").append(r.lastFrom).append(',').append(r.lastTo).append(']');
        sb.append(",\"board\":[");
        for (int i = 0; i < CELLS; i++) { if (i > 0) sb.append(','); sb.append('"').append(esc(r.board[i])).append('"'); }
        sb.append(']');
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
        PrintWriter o = resp.getWriter(); o.write(json); o.flush();
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