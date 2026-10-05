package com.example.demo1;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Deque;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 狼人杀联机房间（纯真人，无 AI 补位）。
 * 板子：5人 = 1狼+预言家+女巫+2民；8人 = 2狼+预言家+女巫+猎人+3民。无警长。
 * 流程：夜晚（狼刀 → 预言家验 → 女巫救/毒）→ 白天（讨论 120s → 投票放逐）→ 循环；猎人被刀或被放逐可开枪（被毒不能）。
 * 各阶段限时到点自动跳过（无后台线程，靠请求驱动推进）。
 */
@WebServlet(name = "werewolfServlet", value = "/werewolf")
public class WerewolfServlet extends HttpServlet {

    private static final long MEMBER_TTL = 45_000L, MSG_TTL = 10 * 60_000L;
    private static final int MAX_MSG = 80, MAX_ROOM = 32, MAX_NAME = 24, MAX_TEXT = 200;
    private static final int NIGHT_MS = 60_000, DISC_MS = 120_000, VOTE_MS = 60_000, SHOOT_MS = 60_000;

    private static final String WOLF = "狼人", SEER = "预言家", WITCH = "女巫", HUNTER = "猎人", VILL = "平民";
    private static final Random RND = new Random();

    static final class Member { final String name; volatile long lastSeen; Member(String n) { name = n; lastSeen = System.currentTimeMillis(); } }
    static final class Msg {
        final String name, text, sc, sf; final long time;
        Msg(String n, String t, long tm) { this(n, t, null, null, tm); }
        Msg(String n, String t, String c, String f, long tm) { name = n; text = t; sc = c; sf = f; time = tm; }
    }
    static final class P { final String name; volatile boolean alive = true, ready, bot; volatile String role = ""; P(String n) { name = n; } }

    static final class Room {
        final Map<String, Member> members = new LinkedHashMap<>();
        final Deque<Msg> msgs = new ArrayDeque<>();
        final Deque<Msg> wmsgs = new ArrayDeque<>();
        final List<P> players = new ArrayList<>();
        final Map<String, String> submitted = new HashMap<>();      // 当前步骤：玩家 -> 提交内容
        final Map<String, String> seer = new LinkedHashMap<>();     // 被验人 -> 狼人/好人
        final List<String> log = new ArrayList<>();
        int preset = 5, phase = 0, nightStep = 0, round = 0, afterShoot = 1;
        long deadline;
        String wolfVictim, exiled, winner, shootActor;
        boolean witchSaveUsed, witchPoisonUsed;
    }

    // ================= 房间存储 =================
    @SuppressWarnings("unchecked")
    private Map<String, Room> rooms() {
        Object o = getServletContext().getAttribute("WW_ROOMS");
        if (o == null) synchronized (this) {
            if (getServletContext().getAttribute("WW_ROOMS") == null) {
                o = new ConcurrentHashMap<String, Room>();
                getServletContext().setAttribute("WW_ROOMS", o);
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
        while (!r.wmsgs.isEmpty() && now - r.wmsgs.peekFirst().time > MSG_TTL) r.wmsgs.pollFirst();
    }

    /** 机器人按当前步骤自动提交 */
    private void botAct(Room r, P p) {
        List<String> cands = new ArrayList<>();
        for (P q : alive(r)) {
            if (q.name.equals(p.name)) continue;
            if (r.phase == 1 && r.nightStep == 0 && WOLF.equals(q.role)) continue;   // 狼不刀队友
            cands.add(q.name);
        }
        if (cands.isEmpty()) { r.submitted.put(p.name, ""); return; }
        String pick = cands.get(RND.nextInt(cands.size()));
        if (r.phase == 1 && r.nightStep == 2) {                       // 女巫
            String sv = "0", pz = "0";
            if (!r.witchSaveUsed && r.wolfVictim != null && !r.wolfVictim.isEmpty() && RND.nextInt(3) > 0) sv = r.wolfVictim;
            else if (!r.witchPoisonUsed && RND.nextInt(4) == 0) pz = pick;
            r.submitted.put(p.name, "s:" + sv + "|p:" + pz);
            return;
        }
        if (r.phase == 1 && r.nightStep == 0 && RND.nextInt(6) == 0) { r.submitted.put(p.name, ""); return; }   // 偶尔空刀
        if (r.phase == 3 && RND.nextInt(5) == 0) { r.submitted.put(p.name, ""); return; }                      // 偶尔弃票
        r.submitted.put(p.name, pick);
    }

    // ================= 小工具 =================
    private P player(Room r, String n) { if (n == null) return null; for (P p : r.players) if (p.name.equals(n)) return p; return null; }
    private int seat(Room r, String n) { for (int i = 0; i < r.players.size(); i++) if (r.players.get(i).name.equals(n)) return i + 1; return 0; }
    private String seatOf(Room r, String n) { int s = seat(r, n); return s > 0 ? s + "号(" + n + ")" : n; }
    private List<P> alive(Room r) { List<P> l = new ArrayList<>(); for (P p : r.players) if (p.alive) l.add(p); return l; }
    private List<P> aliveRole(Room r, String role) { List<P> l = new ArrayList<>(); for (P p : r.players) if (p.alive && role.equals(p.role)) l.add(p); return l; }
    private void log(Room r, String s) { r.log.add(s); if (r.log.size() > 60) r.log.remove(0); }
    private void kill(Room r, String n) { P p = player(r, n); if (p != null) p.alive = false; }
    private boolean isAdmin(HttpServletRequest req) { HttpSession s = req.getSession(false); return s != null && Boolean.TRUE.equals(s.getAttribute("ADMIN")); }

    // ================= 状态机推进 =================
    private List<P> actors(Room r) {
        List<P> none = new ArrayList<>();
        if (r.phase == 1) {
            if (r.nightStep == 0) return aliveRole(r, WOLF);
            if (r.nightStep == 1) return aliveRole(r, SEER);
            return aliveRole(r, WITCH);
        }
        if (r.phase == 3) return alive(r);
        if (r.phase == 4) { P p = player(r, r.shootActor); return (p != null && p.alive) ? Collections.singletonList(p) : none; }
        return none;
    }

    /** 请求驱动推进：到点或所有人都已操作则往下走 */
    private void pump(Room r, long now) {
        int guard = 0;
        while (guard++ < 30) {
            if (r.phase == 0 || r.phase == 5) return;
            if (r.phase == 2) {                                   // 讨论只看时间
                if (now < r.deadline) return;
            } else {
                List<P> acts = actors(r);
                for (P p : acts) if (p.bot && !r.submitted.containsKey(p.name)) botAct(r, p);
                boolean all = true;
                for (P p : acts) if (!r.submitted.containsKey(p.name)) { all = false; break; }
                if (!all && now < r.deadline) return;
                for (P p : acts) if (!r.submitted.containsKey(p.name)) r.submitted.put(p.name, "");
            }
            next(r, now);
        }
    }

    private void next(Room r, long now) {
        if (r.phase == 2) {   // 讨论结束 → 投票
            r.phase = 3; r.deadline = now + VOTE_MS; r.submitted.clear();
            log(r, "☀ 讨论结束，开始投票（" + (VOTE_MS / 1000) + " 秒）");
            return;
        }
        if (r.phase == 3) { tally(r, now); return; }
        if (r.phase == 4) { doShoot(r); if (checkWin(r)) return; if (r.afterShoot == 1) toDay(r, now); else startNight(r, now); return; }
        if (r.phase != 1) return;

        if (r.nightStep == 0) {                       // 狼刀
            r.wolfVictim = majority(r);
            r.submitted.clear();
            if (r.wolfVictim != null && !r.wolfVictim.isEmpty()) log(r, "🌙 狼人选择刀掉 " + seatOf(r, r.wolfVictim) + "。");
            else log(r, "🌙 狼人选择空刀。");
            if (!aliveRole(r, SEER).isEmpty()) { r.nightStep = 1; r.deadline = now + NIGHT_MS; }
            else if (!aliveRole(r, WITCH).isEmpty()) { r.nightStep = 2; r.deadline = now + NIGHT_MS; }
            else resolveNight(r, now);
            return;
        }
        if (r.nightStep == 1) {                       // 预言家
            List<P> ss = aliveRole(r, SEER);
            if (!ss.isEmpty()) {
                String tgt = r.submitted.get(ss.get(0).name);
                P t = player(r, tgt);
                if (t != null) { r.seer.put(t.name, WOLF.equals(t.role) ? "狼人" : "好人"); log(r, "🔮 预言家查验了 " + seatOf(r, t.name) + "。"); }
            }
            r.submitted.clear();
            if (!aliveRole(r, WITCH).isEmpty()) { r.nightStep = 2; r.deadline = now + NIGHT_MS; }
            else resolveNight(r, now);
            return;
        }
        resolveNight(r, now);                          // 女巫之后结算
    }

    private String majority(Room r) {
        Map<String, Integer> cnt = new LinkedHashMap<>();
        for (Map.Entry<String, String> e : r.submitted.entrySet()) {
            String v = e.getValue();
            if (v == null || v.isEmpty()) continue;
            cnt.merge(v, 1, Integer::sum);
        }
        String top = null; int max = 0;
        for (Map.Entry<String, Integer> e : cnt.entrySet()) if (e.getValue() > max) { max = e.getValue(); top = e.getKey(); }
        return top == null ? "" : top;
    }

    private void resolveNight(Room r, long now) {
        String saved = null, poisoned = null;
        List<P> ws = aliveRole(r, WITCH);
        String witch = ws.isEmpty() ? null : ws.get(0).name;
        String raw = witch == null ? null : r.submitted.get(witch);
        if (raw != null) { saved = pick(raw, "s:"); poisoned = pick(raw, "p:"); }
        r.submitted.clear();
        if (saved != null && !saved.isEmpty()) r.witchSaveUsed = true;
        if (poisoned != null && !poisoned.isEmpty()) r.witchPoisonUsed = true;

        List<String> deaths = new ArrayList<>();
        P wv = player(r, r.wolfVictim);
        if (wv != null && wv.alive && !wv.name.equals(saved)) deaths.add(wv.name);
        P pv = player(r, poisoned);
        if (pv != null && pv.alive && !deaths.contains(pv.name)) deaths.add(pv.name);

        for (String n : deaths) kill(r, n);
        if (deaths.isEmpty()) log(r, "☀ 第 " + r.round + " 夜结算：平安夜。");
        else { StringBuilder b = new StringBuilder(); for (String n : deaths) { if (b.length() > 0) b.append('、'); b.append(seatOf(r, n)); } log(r, "☀ 昨晚倒下的是：" + b + "（身份不公开）"); }

        if (checkWin(r)) return;

        String hunter = null;
        for (String n : deaths) {
            P p = player(r, n);
            if (p != null && HUNTER.equals(p.role) && !n.equals(poisoned)) hunter = n;   // 被毒不能开枪
        }
        if (hunter != null) { r.phase = 4; r.shootActor = hunter; r.afterShoot = 1; r.deadline = now + SHOOT_MS; log(r, "🔫 " + seatOf(r, hunter) + " 号猎人可以开枪。"); return; }
        toDay(r, now);
    }
    private static String pick(String raw, String key) {
        int i = raw.indexOf(key);
        if (i < 0) return null;
        int j = raw.indexOf('|', i);
        String v = (j < 0 ? raw.substring(i + 2) : raw.substring(i + 2, j)).trim();
        return (v.isEmpty() || "0".equals(v)) ? null : v;
    }

    private void toDay(Room r, long now) {
        r.phase = 2; r.nightStep = 0; r.deadline = now + DISC_MS;
        log(r, "💬 天亮了，自由讨论（" + (DISC_MS / 1000) + " 秒）");
    }

    private void tally(Room r, long now) {
        Map<String, Integer> cnt = new LinkedHashMap<>();
        for (P p : alive(r)) { String v = r.submitted.get(p.name); if (v == null || v.isEmpty()) continue; cnt.merge(v, 1, Integer::sum); }
        r.submitted.clear();
        String top = null; int max = 0; boolean tie = false;
        for (Map.Entry<String, Integer> e : cnt.entrySet()) {
            if (e.getValue() > max) { max = e.getValue(); top = e.getKey(); tie = false; }
            else if (e.getValue() == max) tie = true;
        }
        if (top == null || tie) { r.exiled = null; log(r, "🗳 投票" + (top == null ? "无人投票" : "平票") + "，本轮无人出局。"); }
        else { r.exiled = top; kill(r, top); log(r, "🗳 " + seatOf(r, top) + " 号被放逐（" + max + " 票）。"); }
        if (checkWin(r)) return;
        P ex = player(r, r.exiled);
        if (ex != null && HUNTER.equals(ex.role)) { r.phase = 4; r.shootActor = ex.name; r.afterShoot = 2; r.deadline = System.currentTimeMillis() + SHOOT_MS; log(r, "🔫 被放逐的猎人可以开枪。"); return; }
        startNight(r, now);
    }

    private void doShoot(Room r) {
        String actor = r.shootActor, t = actor == null ? null : r.submitted.get(actor);
        r.submitted.clear(); r.shootActor = null;
        P p = player(r, t);
        if (p != null && p.alive) { kill(r, p.name); log(r, "🔫 " + seatOf(r, actor) + " 号猎人开枪带走了 " + seatOf(r, p.name) + "。"); }
        else log(r, "🔫 猎人没有开枪。");
    }

    private void startNight(Room r, long now) {
        r.round++; r.phase = 1; r.nightStep = 0; r.wolfVictim = null; r.submitted.clear();
        r.deadline = now + NIGHT_MS;
        log(r, "🌙 第 " + r.round + " 夜，天黑请闭眼（狼刀 " + (NIGHT_MS / 1000) + " 秒）");
    }

    private boolean checkWin(Room r) {
        int w = aliveRole(r, WOLF).size(), all = alive(r).size(), g = all - w;
        if (w == 0) { over(r, "好人阵营"); return true; }
        if (w >= g) { over(r, "狼人阵营"); return true; }
        return false;
    }
    private void over(Room r, String winner) {
        r.phase = 5; r.winner = winner;
        StringBuilder b = new StringBuilder("🏁 本局结束 · " + winner + "获胜！身份：");
        for (P p : r.players) { if (b.length() > 20) b.append('、'); b.append(seatOf(r, p.name)).append('=').append(p.role).append(p.alive ? "" : "(死)"); }
        log(r, b.toString());
    }

    // ================= HTTP =================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        long now = System.currentTimeMillis();
        if (req.getParameter("list") != null) { writeList(resp, now); return; }
        String id = clean(req.getParameter("id"), MAX_ROOM), name = clean(req.getParameter("name"), MAX_NAME);
        if (id == null || id.isEmpty() || name == null || name.isEmpty()) { write(resp, "{\"error\":\"no room/name\"}"); return; }
        Room r = room(id); String json; boolean admin = isAdmin(req);
        synchronized (r) { touch(r, name, now); autoSeat(r, name); pump(r, now); json = state(r, name, now, admin); }
        write(resp, json);
    }

    /** GET 轮询时自动入座（仅等待阶段）：有空位就坐，满员且有机器人则顶替，行为与其它联机游戏一致 */
    private void autoSeat(Room r, String name) {
        if (r.phase != 0 || name == null || name.isEmpty() || player(r, name) != null) return;
        if (r.players.size() < r.preset) {
            r.players.add(new P(name)); log(r, "📣 " + name + " 入座 " + seatOf(r, name) + "（" + r.players.size() + "/" + r.preset + "）");
        } else {
            P bot = null; for (P p : r.players) if (p.bot) bot = p;
            if (bot != null) { r.players.remove(bot); r.players.add(new P(name)); log(r, "🤖 " + bot.name + " 让位，" + name + " 入座 " + seatOf(r, name)); }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        long now = System.currentTimeMillis();
        String id = clean(req.getParameter("id"), MAX_ROOM), name = clean(req.getParameter("name"), MAX_NAME);
        String action = req.getParameter("action");
        if (id == null || id.isEmpty() || name == null || name.isEmpty()) { write(resp, "{\"ok\":false,\"error\":\"缺少房间或名字\"}"); return; }
        Room r = room(id); String out;
        synchronized (r) {
            touch(r, name, now); pump(r, now);
            P me = player(r, name);
            switch (action == null ? "" : action) {
                case "join": {
                    if (r.phase == 0) {
                        int ps = parseInt(req.getParameter("preset"), r.preset);
                        if (r.players.isEmpty() && (ps == 5 || ps == 8)) r.preset = ps;
                        if (me == null) {
                            if (r.players.size() < r.preset) {
                                r.players.add(new P(name)); log(r, "📣 " + name + " 入座 " + seatOf(r, name) + "（" + r.players.size() + "/" + r.preset + "）");
                            } else {
                                P bot = null; for (P p : r.players) if (p.bot) bot = p;            // 满员：找最后一个机器人让位
                                if (bot != null) {
                                    r.players.remove(bot); r.players.add(new P(name));
                                    log(r, "🤖 " + bot.name + " 让位，" + name + " 入座 " + seatOf(r, name) + "（" + r.players.size() + "/" + r.preset + "）");
                                } else log(r, "📣 " + name + " 进入观战");                          // 全是真人才只能观战
                            }
                        }
                    }
                    out = "{\"ok\":true}"; break;
                }
                case "leave": {
                    r.members.remove(name);
                    if (me != null) {
                        if (r.phase == 0) { r.players.remove(me); log(r, " " + name + " 离座"); }
                        else if (me.alive) { me.alive = false; log(r, "⚠ " + seatOf(r, name) + " 号中途离场，视为出局"); checkWin(r); }
                    }
                    if (r.members.isEmpty()) { resetToLobby(r); }                                 // 房间再无任何真人：结束并重置、清机器人
                    out = "{\"ok\":true}"; break;
                }
                case "ready": {
                    if (me != null && r.phase == 0) me.ready = !me.ready;
                    out = "{\"ok\":true}"; break;
                }
                case "addbot": {
                    if (r.phase != 0) out = "{\"ok\":false,\"error\":\"只有等待开局时可以加机器人\"}";
                    else if (r.players.size() >= r.preset) out = "{\"ok\":false,\"error\":\"座位已满\"}";
                    else {
                        int k = 1;
                        while (player(r, "机器人" + k) != null) k++;
                        P bp = new P("机器人" + k);
                        bp.bot = true; bp.ready = true;
                        r.players.add(bp);
                        log(r, "🤖 补位 " + bp.name + "（" + r.players.size() + "/" + r.preset + "）");
                        out = "{\"ok\":true}";
                    }
                    break;
                }
                case "fillbots": {
                    if (r.phase != 0) out = "{\"ok\":false,\"error\":\"只有等待开局时可以补满\"}";
                    else {
                        int added = 0;
                        while (r.players.size() < r.preset) {
                            int k = 1;
                            while (player(r, "机器人" + k) != null) k++;
                            P bp = new P("机器人" + k);
                            bp.bot = true; bp.ready = true;
                            r.players.add(bp); added++;
                        }
                        if (added > 0) log(r, "🤖 一键补满 " + added + " 个机器人（" + r.players.size() + "/" + r.preset + "）");
                        out = "{\"ok\":true}";
                    }
                    break;
                }
                case "delbot": {
                    if (r.phase != 0) out = "{\"ok\":false,\"error\":\"只有等待开局时可以移除机器人\"}";
                    else {
                        P last = null;
                        for (P p : r.players) if (p.bot) last = p;
                        if (last == null) out = "{\"ok\":false,\"error\":\"房间里没有机器人\"}";
                        else { r.players.remove(last); log(r, "🤖 移除了 " + last.name + "（" + r.players.size() + "/" + r.preset + "）"); out = "{\"ok\":true}"; }
                    }
                    break;
                }
                case "start": {
                    if (r.phase != 0) out = "{\"ok\":false,\"error\":\"游戏已在进行中\"}";
                    else if (me == null) out = "{\"ok\":false,\"error\":\"请先入座再开局（观战席不能开局）\"}";
                    else if (r.players.size() != r.preset) out = "{\"ok\":false,\"error\":\"人数未满，还差 " + (r.preset - r.players.size()) + " 人（可用「🤖 加机器人 / 一键补满」凑满再开）\"}";
                    else { start(r, now); out = "{\"ok\":true}"; }
                    break;
                }
                case "act": {
                    String tgt = clean(req.getParameter("target"), MAX_NAME);
                    List<P> acts = actors(r);
                    boolean can = false;
                    for (P p : acts) if (p.name.equals(name)) can = true;
                    if (!can) out = "{\"ok\":false,\"error\":\"现在不需要你操作\"}";
                    else if (r.phase == 1 && r.nightStep == 2) out = "{\"ok\":false,\"error\":\"女巫请用「用药」提交\"}";
                    else {
                        P t = player(r, tgt);
                        if (t != null && (!t.alive || t.name.equals(name))) t = null;
                        r.submitted.put(name, t == null ? "" : t.name);
                        out = "{\"ok\":true}";
                    }
                    break;
                }
                case "witch": {
                    List<P> ws = aliveRole(r, WITCH);
                    if (r.phase != 1 || r.nightStep != 2 || ws.isEmpty() || !ws.get(0).name.equals(name)) out = "{\"ok\":false,\"error\":\"现在不是你的回合\"}";
                    else {
                        String sv = clean(req.getParameter("save"), MAX_NAME), pz = clean(req.getParameter("poison"), MAX_NAME);
                        P s = player(r, sv), z = player(r, pz);
                        String S = (s != null && s.alive) ? s.name : "0";
                        String Z = (z != null && z.alive && !z.name.equals(name)) ? z.name : "0";
                        if (!"0".equals(S) && !"0".equals(Z)) out = "{\"ok\":false,\"error\":\"解药和毒药不能同一晚使用\"}";
                        else if (!"0".equals(S) && r.witchSaveUsed) out = "{\"ok\":false,\"error\":\"解药已经用过了\"}";
                        else if (!"0".equals(Z) && r.witchPoisonUsed) out = "{\"ok\":false,\"error\":\"毒药已经用过了\"}";
                        else { r.submitted.put(name, "s:" + S + "|p:" + Z); out = "{\"ok\":true}"; }
                    }
                    break;
                }
                case "chat": {
                    String text = clean(req.getParameter("text"), MAX_TEXT);
                    String sc = clean(req.getParameter("scat"), 20), sf = clean(req.getParameter("sfile"), 120);
                    if (safe(sc) && safe(sf)) r.msgs.addLast(new Msg(name, "", sc, sf, now));
                    else if (text != null && !text.isEmpty()) r.msgs.addLast(new Msg(name, text, now));
                    while (r.msgs.size() > MAX_MSG) r.msgs.pollFirst();
                    out = "{\"ok\":true}"; break;
                }
                case "wchat": {
                    if (me == null || !WOLF.equals(me.role) || (!me.alive && r.phase != 5)) out = "{\"ok\":false,\"error\":\"你不是狼人，狼聊不可用\"}";
                    else {
                        String text = clean(req.getParameter("text"), MAX_TEXT);
                        String sc = clean(req.getParameter("scat"), 20), sf = clean(req.getParameter("sfile"), 120);
                        if (safe(sc) && safe(sf)) r.wmsgs.addLast(new Msg(name, "", sc, sf, now));
                        else if (text != null && !text.isEmpty()) r.wmsgs.addLast(new Msg(name, text, now));
                        while (r.wmsgs.size() > MAX_MSG) r.wmsgs.pollFirst();
                        out = "{\"ok\":true}";
                    }
                    break;
                }
                case "restart": {
                    if (me == null) out = "{\"ok\":false,\"error\":\"只有入座玩家可以重开\"}";
                    else {
                        for (P p : r.players) { p.alive = true; p.role = ""; p.ready = false; }
                        r.phase = 0; r.round = 0; r.nightStep = 0; r.seer.clear(); r.submitted.clear();
                        r.witchSaveUsed = r.witchPoisonUsed = false; r.winner = null; r.exiled = null; r.shootActor = null; r.wolfVictim = null;
                        log(r, "🔄 " + name + " 重开了对局，请重新准备");
                        out = "{\"ok\":true}";
                    }
                    break;
                }
                case "adminskip": {
                    if (!isAdmin(req)) out = "{\"ok\":false,\"error\":\"只有管理员可以跳过阶段\"}";
                    else if (r.phase == 0 || r.phase == 5) out = "{\"ok\":false,\"error\":\"当前没有进行中的阶段\"}";
                    else { log(r, "⏭ 管理员跳过了当前阶段（" + phaseText(r) + "）"); r.deadline = 0; pump(r, now); out = "{\"ok\":true}"; }
                    break;
                }
                default: out = "{\"ok\":false,\"error\":\"未知操作\"}";
            }
            if (r.members.isEmpty()) resetToLobby(r);                                          // 兜底：无人则释放房间
            pump(r, System.currentTimeMillis());
        }
        write(resp, out);
    }

    /** 房间里没有任何真人（bots/幽灵不占位）时：移除全部机器人与离场玩家，整局重置回大厅 */
    private void resetToLobby(Room r) {
        r.players.removeIf(p -> p.bot || !r.members.containsKey(p.name));
        for (P p : r.players) { p.alive = true; p.role = ""; p.ready = false; }
        r.phase = 0; r.round = 0; r.nightStep = 0; r.seer.clear(); r.submitted.clear();
        r.witchSaveUsed = r.witchPoisonUsed = false;
        r.winner = null; r.exiled = null; r.shootActor = null; r.wolfVictim = null; r.deadline = 0;
        if (!r.players.isEmpty()) log(r, "🔄 房间只剩人机，已自动结束并重置");
    }

    private void start(Room r, long now) {
        List<String> roles = new ArrayList<>();
        if (r.preset == 5) roles.addAll(Arrays.asList(WOLF, SEER, WITCH, VILL, VILL));
        else roles.addAll(Arrays.asList(WOLF, WOLF, SEER, WITCH, HUNTER, VILL, VILL, VILL));
        Collections.shuffle(roles);
        for (int i = 0; i < r.players.size(); i++) { P p = r.players.get(i); p.role = roles.get(i); p.alive = true; }
        r.seer.clear(); r.submitted.clear(); r.witchSaveUsed = r.witchPoisonUsed = false;
        r.winner = null; r.exiled = null; r.shootActor = null; r.wolfVictim = null;
        r.round = 1; r.phase = 1; r.nightStep = 0; r.deadline = now + NIGHT_MS;
        log(r, "🎬 游戏开始（" + r.preset + " 人局：" + (r.preset == 5 ? "1狼+预言家+女巫+2民" : "2狼+预言家+女巫+猎人+3民") + "）");
        log(r, "🌙 第 1 夜，天黑请闭眼（狼刀 " + (NIGHT_MS / 1000) + " 秒）");
    }

    private void writeList(HttpServletResponse resp, long now) throws IOException {
        StringBuilder sb = new StringBuilder("["); boolean first = true;
        for (Map.Entry<String, Room> en : rooms().entrySet()) {
            Room r = en.getValue(); StringBuilder sum = new StringBuilder();
            synchronized (r) {
                r.members.entrySet().removeIf(e -> now - e.getValue().lastSeen > MEMBER_TTL);
                int mc = r.members.size(); if (mc == 0) continue;
                boolean hasBot = false; for (P p : r.players) if (p.bot) { hasBot = true; break; }
                boolean canJoin = r.phase == 0 && (r.players.size() < r.preset || hasBot);
                sum.append("{\"id\":\"").append(esc(en.getKey())).append("\",\"preset\":").append(r.preset)
                        .append(",\"phase\":").append(r.phase).append(",\"seated\":").append(r.players.size())
                        .append(",\"members\":").append(mc).append(",\"canJoin\":").append(canJoin).append('}');
            }
            if (sum.length() == 0) continue;
            if (!first) sb.append(','); first = false; sb.append(sum);
        }
        sb.append(']'); write(resp, sb.toString());
    }

    private String state(Room r, String viewer, long now, boolean admin) {
        StringBuilder sb = new StringBuilder(1024);
        sb.append("{\"preset\":").append(r.preset).append(",\"phase\":").append(r.phase)
                .append(",\"am\":").append(admin)
                .append(",\"phaseText\":\"").append(phaseText(r)).append('"')
                .append(",\"nightStep\":").append(r.nightStep)
                .append(",\"round\":").append(r.round)
                .append(",\"remain\":").append(Math.max(0, r.deadline - now))
                .append(",\"winner\":\"").append(esc(r.winner == null ? "" : r.winner)).append('"')
                .append(",\"owner\":\"").append(esc(r.players.isEmpty() ? "" : r.players.get(0).name)).append('"');
        sb.append(",\"players\":[");
        for (int i = 0; i < r.players.size(); i++) {
            P p = r.players.get(i);
            if (i > 0) sb.append(',');
            String role = (viewer.equals(p.name) || !p.alive || r.phase == 5) ? p.role : "";
            sb.append("{\"seat\":").append(i + 1).append(",\"name\":\"").append(esc(p.name))
                    .append("\",\"alive\":").append(p.alive).append(",\"ready\":").append(p.ready)
                    .append(",\"role\":\"").append(esc(role)).append("\",\"bot\":").append(p.bot).append('}');
        }
        sb.append(']');

        // 我
        P me = player(r, viewer);
        sb.append(",\"me\":");
        if (me == null) sb.append("null");
        else {
            String prompt = null;
            if (me.alive && !r.submitted.containsKey(me.name)) {
                if (r.phase == 1 && r.nightStep == 0 && WOLF.equals(me.role)) prompt = "wolf";
                else if (r.phase == 1 && r.nightStep == 1 && SEER.equals(me.role)) prompt = "seer";
                else if (r.phase == 1 && r.nightStep == 2 && WITCH.equals(me.role)) prompt = "witch";
                else if (r.phase == 3) prompt = "vote";
                else if (r.phase == 4 && viewer.equals(r.shootActor)) prompt = "shoot";
            }
            List<String> cands = new ArrayList<>();
            if (prompt != null) for (P p : alive(r)) if (!p.name.equals(viewer)) cands.add(p.name);
            sb.append("{\"seat\":").append(seat(r, viewer)).append(",\"alive\":").append(me.alive)
                    .append(",\"ready\":").append(me.ready)
                    .append(",\"role\":\"").append(esc(me.role)).append('"')
                    .append(",\"prompt\":").append(prompt == null ? "null" : '"' + prompt + '"')
                    .append(",\"done\":").append(r.submitted.containsKey(me.name));
            sb.append(",\"cands\":["); for (int i = 0; i < cands.size(); i++) { if (i > 0) sb.append(','); sb.append('"').append(esc(cands.get(i))).append('"'); } sb.append(']');
            sb.append(",\"seer\":["); boolean f2 = true;
            for (Map.Entry<String, String> e : r.seer.entrySet()) { if (!f2) sb.append(','); f2 = false; sb.append("{\"t\":\"").append(esc(seatOf(r, e.getKey()))).append("\",\"r\":\"").append(e.getValue()).append("\"}"); }
            sb.append(']');
            sb.append(",\"witch\":{\"victim\":\"").append(esc(r.nightStep == 2 && WITCH.equals(me.role) && r.wolfVictim != null ? seatOf(r, r.wolfVictim) : "")).append('"')
                    .append(",\"saveUsed\":").append(r.witchSaveUsed).append(",\"poisonUsed\":").append(r.witchPoisonUsed).append('}');
            sb.append('}');
        }

        sb.append(",\"log\":["); for (int i = 0; i < r.log.size(); i++) { if (i > 0) sb.append(','); sb.append('"').append(esc(r.log.get(i))).append('"'); } sb.append(']');
        sb.append(",\"members\":["); boolean f = true;
        for (String n : r.members.keySet()) { if (!f) sb.append(','); f = false; sb.append('"').append(esc(n)).append('"'); }
        sb.append(']');
        sb.append(",\"msg\":["); f = true;
        for (Msg m : r.msgs) {
            if (now - m.time > MSG_TTL) continue;
            if (!f) sb.append(','); f = false;
            sb.append("{\"n\":\"").append(esc(m.name)).append("\",\"t\":\"").append(esc(m.text)).append('"');
            if (m.sf != null) sb.append(",\"sc\":\"").append(esc(m.sc)).append("\",\"sf\":\"").append(esc(m.sf)).append('"');
            sb.append(",\"tms\":").append(m.time).append('}');
        }
        sb.append(']');
        P mw = player(r, viewer);
        if ((mw != null && WOLF.equals(mw.role)) || r.phase == 5) {
            sb.append(",\"wmsg\":["); f = true;
            for (Msg m : r.wmsgs) {
                if (now - m.time > MSG_TTL) continue;
                if (!f) sb.append(','); f = false;
                sb.append("{\"n\":\"").append(esc(m.name)).append("\",\"t\":\"").append(esc(m.text)).append('"');
                if (m.sf != null) sb.append(",\"sc\":\"").append(esc(m.sc)).append("\",\"sf\":\"").append(esc(m.sf)).append('"');
                sb.append(",\"tms\":").append(m.time).append('}');
            }
            sb.append(']');
        }
        sb.append("}");
        return sb.toString();
    }
    private String phaseText(Room r) {
        switch (r.phase) {
            case 0: return "等待开局";
            case 1: return "第 " + r.round + " 夜 · " + (r.nightStep == 0 ? "狼人行动" : r.nightStep == 1 ? "预言家行动" : "女巫行动");
            case 2: return "第 " + r.round + " 天 · 自由讨论";
            case 3: return "第 " + r.round + " 天 · 投票放逐";
            case 4: return "猎人开枪";
            default: return "已结束";
        }
    }

    private static int parseInt(String s, int def) { try { return Integer.parseInt(s.trim()); } catch (Exception e) { return def; } }
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