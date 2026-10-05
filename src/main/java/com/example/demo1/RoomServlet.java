package com.example.demo1;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Deque;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.TreeMap;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet(name = "roomServlet", value = "/room")
public class RoomServlet extends HttpServlet {

    private static final long MEMBER_TTL = 45 * 1000L;
    private static final long MSG_TTL = 10 * 60 * 1000L;
    private static final int MAX_MSG = 100, MAX_TEXT = 200, MAX_NAME = 16, MAX_ROOM = 24;
    private static final Random RNG = new Random();

    // ================= 牌 / 牌型 =================
    static final class Card {
        final int id, rank, joker; final String label, suit;
        Card(int id, int rank, String label, String suit, int joker) { this.id = id; this.rank = rank; this.label = label; this.suit = suit; this.joker = joker; }
        String json() { return "{\"id\":" + id + ",\"rank\":"+rank+",\"label\":\"" + esc(label) + "\",\"suit\":\"" + esc(suit) + "\",\"joker\":" + joker + "}"; }
    }
    static List<Card> buildDeck() {
        String[] SUITS = {"♠", "♥", "♣", "♦"};
        int[] ranks = {3,4,5,6,7,8,9,10,11,12,13,14,16};
        String[] labels = {"3","4","5","6","7","8","9","10","J","Q","K","A","2"};
        List<Card> deck = new ArrayList<>(); int id = 0;
        for (String s : SUITS) for (int i = 0; i < ranks.length; i++) deck.add(new Card(id++, ranks[i], labels[i], s, 0));
        deck.add(new Card(id++, 17, "小王", "", 1));
        deck.add(new Card(id++, 18, "大王", "", 2));
        return deck;
    }
    static final class Combo {
        final String type; final int rank, len;
        Combo(String t, int r, int l) { type = t; rank = r; len = l; }
    }
    static boolean consec(int[] a) { for (int i = 1; i < a.length; i++) if (a[i] != a[i - 1] + 1) return false; return true; }
    static int indexOf(int[] a, int v) { for (int i = 0; i < a.length; i++) if (a[i] == v) return i; return -1; }
    static boolean allEq2(int[] a) { for (int v : a) if (v != 2) return false; return true; }

    static Combo classify(List<Card> cards) {
        int n = cards.size(); if (n == 0) return null;
        TreeMap<Integer, Integer> cnt = new TreeMap<>();
        for (Card c : cards) cnt.merge(c.rank, 1, Integer::sum);
        int uniq = cnt.size();
        int[] ranks = new int[uniq], counts = new int[uniq]; int idx = 0, maxRank = 0;
        for (Map.Entry<Integer, Integer> e : cnt.entrySet()) { ranks[idx] = e.getKey(); counts[idx] = e.getValue(); if (e.getKey() > maxRank) maxRank = e.getKey(); idx++; }
        if (n == 2 && cnt.getOrDefault(17, 0) == 1 && cnt.getOrDefault(18, 0) == 1) return new Combo("rocket", 19, 1);
        if (n == 1) return new Combo("single", ranks[0], 1);
        if (n == 2 && uniq == 1) return new Combo("pair", ranks[0], 1);
        if (n == 3 && uniq == 1) return new Combo("triple", ranks[0], 1);
        if (n == 4 && uniq == 1) return new Combo("bomb", ranks[0], 1);
        if (n == 4 && uniq == 2) { int ir = indexOf(counts, 3); if (ir >= 0) return new Combo("triple1", ranks[ir], 1); }
        if (n == 5 && uniq == 2) { int a = indexOf(counts, 3), b = indexOf(counts, 2); if (a >= 0 && b >= 0) return new Combo("triple2", ranks[a], 1); }
        if (uniq == n && n >= 5 && maxRank <= 14 && consec(ranks)) return new Combo("straight", maxRank, n);
        if (n >= 6 && n % 2 == 0 && n / 2 >= 3 && allEq2(counts) && maxRank <= 14 && consec(ranks)) return new Combo("pairStraight", maxRank, n / 2);
        Combo pl = planeClassify(ranks, counts, uniq, n);
        if (pl != null) return pl;
        return null;
    }
    // 飞机：连续三张（3..A，不含2/王）。type0=不带(3k) type1=带单(4k) type2=带对(5k)
    static Combo planeClassify(int[] ranks, int[] counts, int uniq, int n) {
        int[][] cand = { {3, 0}, {4, 1}, {5, 2} };
        for (int[] cd : cand) {
            if (n % cd[0] != 0) continue;
            int k = n / cd[0];
            if (k < 2) continue;
            Combo c = tryPlaneWin(ranks, counts, uniq, k, cd[1]);
            if (c != null) return c;
        }
        return null;
    }
    static Combo tryPlaneWin(int[] ranks, int[] counts, int uniq, int k, int type) {
        for (int start = 0; start + k <= uniq; start++) {
            boolean bodyOk = true;
            for (int j = 0; j < k; j++) {
                int i = start + j;
                if (ranks[i] > 14 || counts[i] < 3 || (j > 0 && ranks[i] != ranks[i - 1] + 1)) { bodyOk = false; break; }
            }
            if (!bodyOk) continue;
            int top = ranks[start + k - 1];
            if (type == 0) {
                if (uniq != k) continue;
                boolean all3 = true; for (int i = 0; i < uniq; i++) if (counts[i] != 3) { all3 = false; break; }
                if (all3) return new Combo("plane", top, k);
            } else if (type == 1) {
                return new Combo("plane1", top, k);
            } else {
                boolean even = true; int pairs = 0;
                for (int i = 0; i < uniq; i++) {
                    int rem = counts[i] - ((i >= start && i < start + k) ? 3 : 0);
                    if (rem < 0 || rem % 2 != 0) { even = false; break; }
                    pairs += rem / 2;
                }
                if (even && pairs == k) return new Combo("plane2", top, k);
            }
        }
        return null;
    }

    static boolean beats(Combo a, Combo b) {
        if (a == null) return false;
        if (b == null) return true;
        if (a.type.equals("rocket")) return true;
        if (b.type.equals("rocket")) return false;
        if (a.type.equals("bomb")) return b.type.equals("bomb") ? a.rank > b.rank : true;
        if (b.type.equals("bomb")) return false;
        if (!a.type.equals(b.type) || a.len != b.len) return false;
        return a.rank > b.rank;
    }

    // ================= AI 找牌 =================
    static TreeMap<Integer, List<Card>> group(List<Card> hand) {
        TreeMap<Integer, List<Card>> g = new TreeMap<>();
        for (Card c : hand) { List<Card> l = g.get(c.rank); if (l == null) { l = new ArrayList<>(); g.put(c.rank, l); } l.add(c); }
        return g;
    }
    static List<Card> sub(List<Card> l, int k) { return new ArrayList<>(l.subList(0, k)); }
    static List<Card> smallestOther(TreeMap<Integer, List<Card>> g, int exclude, int need) {
        for (Map.Entry<Integer, List<Card>> e : g.entrySet()) { if (e.getKey() == exclude) continue; if (e.getValue().size() >= need) return sub(e.getValue(), need); }
        return null;
    }
    static List<Card> genStraight(TreeMap<Integer, List<Card>> g, int L, int minTop, int need) {
        for (int top = minTop + 1; top <= 14; top++) {
            int start = top - L + 1; if (start < 3) continue;
            boolean ok = true;
            for (int r = start; r <= top; r++) { List<Card> l = g.get(r); if (l == null || l.size() < need) { ok = false; break; } }
            if (ok) { List<Card> out = new ArrayList<>(); for (int r = start; r <= top; r++) out.addAll(sub(g.get(r), need)); return out; }
        }
        return null;
    }
    static List<Card> findBeating(List<Card> hand, Combo t) {
        TreeMap<Integer, List<Card>> g = group(hand);
        if (t.type.equals("single")) { for (Map.Entry<Integer, List<Card>> e : g.entrySet()) if (e.getKey() > t.rank) return sub(e.getValue(), 1); }
        else if (t.type.equals("pair")) { for (Map.Entry<Integer, List<Card>> e : g.entrySet()) if (e.getKey() > t.rank && e.getValue().size() >= 2) return sub(e.getValue(), 2); }
        else if (t.type.equals("triple")) { for (Map.Entry<Integer, List<Card>> e : g.entrySet()) if (e.getKey() > t.rank && e.getValue().size() >= 3) return sub(e.getValue(), 3); }
        else if (t.type.equals("triple1")) { for (Map.Entry<Integer, List<Card>> e : g.entrySet()) if (e.getKey() > t.rank && e.getValue().size() >= 3) { List<Card> k = smallestOther(g, e.getKey(), 1); if (k != null) { List<Card> r = sub(e.getValue(), 3); r.addAll(k); return r; } } }
        else if (t.type.equals("triple2")) { for (Map.Entry<Integer, List<Card>> e : g.entrySet()) if (e.getKey() > t.rank && e.getValue().size() >= 3) { List<Card> k = smallestOther(g, e.getKey(), 2); if (k != null) { List<Card> r = sub(e.getValue(), 3); r.addAll(k); return r; } } }
        else if (t.type.equals("straight")) return genStraight(g, t.len, t.rank, 1);
        else if (t.type.equals("pairStraight")) return genStraight(g, t.len, t.rank, 2);
        else if (t.type.equals("bomb")) { for (Map.Entry<Integer, List<Card>> e : g.entrySet()) if (e.getKey() > t.rank && e.getValue().size() == 4) return sub(e.getValue(), 4); if (g.containsKey(17) && g.containsKey(18)) { List<Card> r = new ArrayList<>(); r.add(g.get(17).get(0)); r.add(g.get(18).get(0)); return r; } }
        else if (t.type.equals("plane")) { List<Card> r = genPlane(g, t.len, t.rank, 0); if (r != null) return r; }
        else if (t.type.equals("plane1")) { List<Card> r = genPlane(g, t.len, t.rank, 1); if (r != null) return r; }
        else if (t.type.equals("plane2")) { List<Card> r = genPlane(g, t.len, t.rank, 2); if (r != null) return r; }
        return null;
    }
    static List<Card> genPlane(TreeMap<Integer, List<Card>> g, int k, int minTop, int wingType) {
        for (int start = 3; start + k - 1 <= 14; start++) {
            int top = start + k - 1;
            if (top <= minTop) continue;
            boolean bodyOk = true;
            for (int r = start; r <= top; r++) { List<Card> l = g.get(r); if (l == null || l.size() < 3) { bodyOk = false; break; } }
            if (!bodyOk) continue;
            List<Card> body = new ArrayList<>();
            for (int r = start; r <= top; r++) body.addAll(sub(g.get(r), 3));
            if (wingType == 0) return body;
            if (wingType == 1) {
                List<Card> pool = new ArrayList<>();
                for (Map.Entry<Integer, List<Card>> e : g.entrySet()) { int r = e.getKey(); List<Card> l = e.getValue(); int from = (r >= start && r <= top) ? 3 : 0; for (int i = from; i < l.size(); i++) pool.add(l.get(i)); }
                if (pool.size() < k) continue;
                List<Card> res = new ArrayList<>(body); res.addAll(pool.subList(0, k)); return res;
            } else {
                List<Card> res = new ArrayList<>(body); int need = k;
                for (Map.Entry<Integer, List<Card>> e : g.entrySet()) {
                    int r = e.getKey(); List<Card> l = e.getValue(); int from = (r >= start && r <= top) ? 3 : 0; int avail = l.size() - from;
                    int canTake = Math.min(avail / 2, need);
                    for (int p = 0; p < canTake; p++) { res.add(l.get(from + 2 * p)); res.add(l.get(from + 2 * p + 1)); }
                    need -= canTake; if (need == 0) break;
                }
                if (need > 0) continue;
                return res;
            }
        }
        return null;
    }
    static List<Card> aiLead(List<Card> hand) { Card min = hand.get(0); for (Card c : hand) if (c.rank < min.rank) min = c; List<Card> r = new ArrayList<>(); r.add(min); return r; }
    static int handScore(List<Card> hand) {
        TreeMap<Integer, Integer> cnt = new TreeMap<>(); for (Card c : hand) cnt.merge(c.rank, 1, Integer::sum);
        int sc = 0;
        for (Map.Entry<Integer, Integer> e : cnt.entrySet()) {
            int r = e.getKey(), n = e.getValue();
            if (r == 18) sc += 8; else if (r == 17) sc += 6; else if (r == 16) sc += 2 * n; else if (r == 14) sc += n;
            if (n == 4) sc += 6;
        }
        return sc;
    }

    // ================= 房间 / 对局 =================
    static final class Member { final String name; volatile long lastSeen; Member(String n) { name = n; lastSeen = System.currentTimeMillis(); } }
    static final class Msg {
        final String name, text, sc, sf; final long time;
        Msg(String n, String t, long tm) { this(n, t, null, null, tm); }
        Msg(String n, String t, String c, String f, long tm) { name = n; text = t; sc = c; sf = f; time = tm; }
    }
    static final class Seat { String name = null; boolean ai = false; List<Card> hand = new ArrayList<>(); }
    static final class Game {
        final Seat[] seats = {new Seat(), new Seat(), new Seat()};
        List<Card> bottom = new ArrayList<>();
        int landlord = -1, turn = -1, phase = 0; // 0 lobby 1 bid 2 play 3 over
        final List<Integer> bidOrder = new ArrayList<>(); int bidIdx = 0;
        int bidStage = 0, bidCaller = -1, robHolder = -1, robCount = 0, robIdx = 0, robLen = 0;
        final boolean[] declined = new boolean[3];
        final int[] robOrder = new int[2];

        Integer lastSeat = null; Combo lastCombo = null; List<Card> lastCards = null; int passes = 0;
        final List<List<Card>> seatPlay = new ArrayList<>(); final boolean[] seatPass = new boolean[3];
        int winner = -1;
        Game() { seatPlay.add(null); seatPlay.add(null); seatPlay.add(null); }
    }
    static final class Room {
        final Map<String, Member> members = new LinkedHashMap<>();
        final Deque<Msg> msgs = new ArrayDeque<>();
        Game game = new Game();
    }

    @SuppressWarnings("unchecked")
    private Map<String, Room> rooms() {
        Object o = getServletContext().getAttribute("ROOMS");
        if (o == null) synchronized (this) { if (getServletContext().getAttribute("ROOMS") == null) { o = new ConcurrentHashMap<String, Room>(); getServletContext().setAttribute("ROOMS", o); } }
        return (Map<String, Room>) o;
    }
    private Room room(String id) {
        Map<String, Room> map = rooms(); Room r = map.get(id);
        if (r == null) { r = new Room(); Room old = map.putIfAbsent(id, r); if (old != null) r = old; }
        return r;
    }
    // 房间列表：只展示还有人（未过 TTL）在场的房间，供他人一键加入
    private void writeRoomList(HttpServletResponse resp) throws IOException {
        long now = System.currentTimeMillis();
        StringBuilder sb = new StringBuilder("[");
        boolean first = true;
        for (Map.Entry<String, Room> en : rooms().entrySet()) {
            Room r = en.getValue();
            String summary;
            synchronized (r) {
                r.members.entrySet().removeIf(e -> now - e.getValue().lastSeen > MEMBER_TTL);
                int memberCount = r.members.size();
                if (memberCount == 0) continue;
                Game g = r.game;
                StringBuilder players = new StringBuilder();
                int freeSeats = 0, np = 0;
                for (int i = 0; i < 3; i++) {
                    if (g.seats[i].name != null && !g.seats[i].ai) { if (np++ > 0) players.append(','); players.append('"').append(esc(g.seats[i].name)).append('"'); }
                    if (g.seats[i].name == null) freeSeats++;
                }
                boolean canJoin = g.phase == 0 && freeSeats > 0;
                summary = "{\"id\":\"" + esc(en.getKey()) + "\",\"phase\":\"" + phaseStr(g.phase) + "\""
                        + ",\"players\":[" + players + "]"
                        + ",\"members\":" + memberCount
                        + ",\"canJoin\":" + canJoin + "}";
            }
            if (!first) sb.append(',');
            first = false;
            sb.append(summary);
        }
        sb.append(']');
        write(resp, sb.toString());
    }
    private static int seatOf(Game g, String name) { for (int i = 0; i < 3; i++) if (name != null && name.equals(g.seats[i].name)) return i; return -1; }

    // ---------- 对局推进（自动跑电脑，直到需要真人操作） ----------
    private void drive(Game g) {
        int guard = 0;
        while (guard++ < 500) {
            if (g.phase == 1) {
                if (g.bidStage == 0) {
                    int seat = g.bidOrder.get(g.bidIdx);
                    if (g.seats[seat].ai) {
                        if (handScore(g.seats[seat].hand) >= 6) startRob(g, seat);
                        else { g.declined[seat] = true; g.bidIdx++; if (g.bidIdx >= 3) forceLandlord(g); }
                    } else break;
                } else {
                    if (g.robIdx >= g.robLen) { finishRob(g); continue; }
                    int seat = g.robOrder[g.robIdx];
                    if (g.seats[seat].ai) {
                        if (handScore(g.seats[seat].hand) >= 9) { g.robHolder = seat; g.robCount++; }
                        g.robIdx++;
                    } else break;
                }
            } else if (g.phase == 2) {
                if (g.seats[g.turn].ai) aiMove(g, g.turn);
                else break;
            } else break;
        }
    }
    private int bidActor(Game g) {
        if (g.phase != 1) return -1;
        if (g.bidStage == 0) return g.bidOrder.get(g.bidIdx);
        return (g.robIdx < g.robLen) ? g.robOrder[g.robIdx] : -1;
    }
    private void startRob(Game g, int caller) {
        g.bidCaller = caller; g.robHolder = caller; g.bidStage = 1; g.robCount = 0; g.robIdx = 0;
        int len = 0;
        for (int i = g.bidIdx + 1; i < 3; i++) g.robOrder[len++] = g.bidOrder.get(i);
        g.robLen = len;
    }
    private void finishRob(Game g) { setLandlord(g, g.robHolder); }
    private void setLandlord(Game g, int seat) {
        g.landlord = seat;
        g.seats[seat].hand.addAll(g.bottom);
        sortHand(g.seats[seat].hand);
        g.phase = 2; g.turn = seat; g.lastSeat = null; g.lastCombo = null; g.lastCards = null; g.passes = 0; newTrick(g);
    }
    private void forceLandlord(Game g) {
        int best = g.bidOrder.get(0);
        for (int i = 1; i < 3; i++) { int s = g.bidOrder.get(i); if (handScore(g.seats[s].hand) > handScore(g.seats[best].hand)) best = s; }
        setLandlord(g, best);
    }
    private void aiMove(Game g, int seat) {
        List<Card> hand = g.seats[seat].hand;
        boolean lead = (g.lastSeat == null || g.lastSeat == seat);
        if (lead) { List<Card> c = aiLead(hand); commitPlay(g, seat, c, classify(c)); }
        else { List<Card> mv = findBeating(hand, g.lastCombo); if (mv != null && classify(mv) != null) commitPlay(g, seat, mv, classify(mv)); else passHandler(g, seat); }
    }
    private void newTrick(Game g) { for (int i = 0; i < 3; i++) { g.seatPlay.set(i, null); g.seatPass[i] = false; } }
    private void commitPlay(Game g, int seat, List<Card> cards, Combo combo) {
        if (g.lastSeat == null) newTrick(g);
        List<Card> hand = g.seats[seat].hand;
        for (Card c : cards) hand.remove(c);
        g.seatPlay.set(seat, cards); g.seatPass[seat] = false;
        g.lastSeat = seat; g.lastCombo = combo; g.lastCards = cards; g.passes = 0;
        if (hand.isEmpty()) { g.winner = seat; g.phase = 3; return; }
        g.turn = (seat + 1) % 3;
    }
    private void passHandler(Game g, int seat) {
        g.seatPlay.set(seat, null); g.seatPass[seat] = true; g.passes++;
        if (g.passes >= 2) { g.turn = g.lastSeat; g.lastSeat = null; g.lastCombo = null; g.lastCards = null; g.passes = 0; newTrick(g); }
        else g.turn = (seat + 1) % 3;
    }
    private void startGame(Game g) {
        for (int i = 0; i < 3; i++) if (g.seats[i].name == null) { g.seats[i].ai = true; g.seats[i].name = "电脑" + (char) ('A' + i); }
        List<Card> deck = buildDeck(); Collections.shuffle(deck);
        g.seats[0].hand = new ArrayList<Card>(deck.subList(0, 17));
        g.seats[1].hand = new ArrayList<Card>(deck.subList(17, 34));
        g.seats[2].hand = new ArrayList<Card>(deck.subList(34, 51));
        g.bottom = new ArrayList<>(deck.subList(51, 54));
        sortHand(g.seats[0].hand); sortHand(g.seats[1].hand); sortHand(g.seats[2].hand);
        g.landlord = -1; g.winner = -1; g.lastSeat = null; g.lastCombo = null; g.lastCards = null; g.passes = 0; newTrick(g);
        g.bidOrder.clear(); int s = RNG.nextInt(3); g.bidOrder.add(s); g.bidOrder.add((s + 1) % 3); g.bidOrder.add((s + 2) % 3); g.bidIdx = 0;
        g.bidStage = 0; g.bidCaller = -1; g.robHolder = -1; g.robCount = 0; g.robIdx = 0; g.robLen = 0;
        g.declined[0] = g.declined[1] = g.declined[2] = false;

        g.phase = 1; g.turn = g.bidOrder.get(0);
        drive(g);
    }
    private static void sortHand(List<Card> h) { h.sort((a, b) -> a.rank != b.rank ? a.rank - b.rank : a.id - b.id); }

    // ---------- HTTP ----------
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        if (req.getParameter("list") != null) { writeRoomList(resp); return; }
        String id = clean(req.getParameter("id"), MAX_ROOM);
        String name = clean(req.getParameter("name"), MAX_NAME);
        if (id == null || id.isEmpty() || name == null || name.isEmpty()) { write(resp, "{\"error\":\"no room/name\"}"); return; }
        Room r = room(id);
        String json;
        synchronized (r) {
            long now = System.currentTimeMillis();
            Member m = r.members.get(name);
            if (m == null) r.members.put(name, new Member(name)); else m.lastSeen = now;
            Game g = r.game;
            // 对局中若已无任何真人（三座全 AI），自动放弃回到大厅，避免卡房间号
            if (g.phase != 0 && allAi(g)) resetToLobby(g);
            if (g.phase == 0) { int free = seatOf(g, name); if (free < 0) for (int i = 0; i < 3; i++) if (g.seats[i].name == null) { g.seats[i].name = name; g.seats[i].ai = false; break; } }
            // 轮询也推进电脑回合，解决"轮到电脑却没人触发→对局卡住不动"
            drive(g);
            r.members.entrySet().removeIf(e -> now - e.getValue().lastSeen > MEMBER_TTL);
            while (!r.msgs.isEmpty() && now - r.msgs.peekFirst().time > MSG_TTL) r.msgs.pollFirst();
            json = stateJson(g, r, name);
        }
        write(resp, json);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        String id = clean(req.getParameter("id"), MAX_ROOM);
        String name = clean(req.getParameter("name"), MAX_NAME);
        String action = req.getParameter("action");
        if (id == null || id.isEmpty() || name == null || name.isEmpty()) { write(resp, "{\"ok\":false,\"error\":\"缺少房间或名字\"}"); return; }
        Room r = room(id);
        String out;
        synchronized (r) {
            Game g = r.game;
            Member m = r.members.get(name); if (m == null) r.members.put(name, new Member(name)); else m.lastSeen = System.currentTimeMillis();
            int seat = seatOf(g, name);
            if ("leave".equals(action)) {
                r.members.remove(name);
                if (seat >= 0) { if (g.phase == 0) { g.seats[seat].name = null; g.seats[seat].ai = false; } else { g.seats[seat].ai = true; g.seats[seat].name = "电脑" + (char) ('A' + seat); drive(g); } }
                out = "{\"ok\":true}";
            } else if ("chat".equals(action)) {
                String text = clean(req.getParameter("text"), MAX_TEXT);
                String sc = clean(req.getParameter("scat"), 20), sf = clean(req.getParameter("sfile"), 120);
                if (safeName(sc) && safeName(sf)) {
                    r.msgs.addLast(new Msg(name, "", sc, sf, System.currentTimeMillis()));
                } else if (text != null && !text.isEmpty()) {
                    r.msgs.addLast(new Msg(name, text, System.currentTimeMillis()));
                }
                while (r.msgs.size() > MAX_MSG) r.msgs.pollFirst();
                out = "{\"ok\":true}";
            } else if ("start".equals(action)) {
                if (g.phase == 0 || g.phase == 3) { if (g.phase == 3) resetSeats(g); startGame(g); out = "{\"ok\":true}"; }
                else out = "{\"ok\":false,\"error\":\"对局进行中\"}";
            } else if ("bid".equals(action)) {
                boolean call = "1".equals(req.getParameter("call"));
                int actor = bidActor(g);
                if (g.phase != 1 || seat < 0 || actor != seat) out = "{\"ok\":false,\"error\":\"现在不能叫\"}";
                else {
                    if (g.bidStage == 0) {
                        if (call) startRob(g, seat);
                        else { g.declined[seat] = true; g.bidIdx++; if (g.bidIdx >= 3) forceLandlord(g); }
                    } else {
                        if (call) { g.robHolder = seat; g.robCount++; }
                        g.robIdx++;
                        if (g.robIdx >= g.robLen) finishRob(g);
                    }
                    drive(g); out = "{\"ok\":true}";
                }
            } else if ("play".equals(action)) {
                if (g.phase != 2 || seat < 0 || g.turn != seat) { out = "{\"ok\":false,\"error\":\"还没轮到你\"}"; }
                else {
                    List<Card> chosen = pickByIds(g.seats[seat].hand, req.getParameter("ids"));
                    if (chosen.isEmpty()) { out = "{\"ok\":false,\"error\":\"请先选牌\"}"; }
                    else {
                        Combo c = classify(chosen);
                        if (c == null) out = "{\"ok\":false,\"error\":\"不是合法牌型\"}";
                        else if (g.lastSeat != null && g.lastSeat != seat && !beats(c, g.lastCombo)) out = "{\"ok\":false,\"error\":\"管不上上家的牌\"}";
                        else { commitPlay(g, seat, chosen, c); drive(g); out = "{\"ok\":true}"; }
                    }
                }
            } else if ("pass".equals(action)) {
                if (g.phase != 2 || seat < 0 || g.turn != seat) out = "{\"ok\":false,\"error\":\"还没轮到你\"}";
                else if (g.lastSeat == null || g.lastSeat == seat) out = "{\"ok\":false,\"error\":\"轮到你先出，不能不要\"}";
                else { passHandler(g, seat); drive(g); out = "{\"ok\":true}"; }
            } else if ("hint".equals(action)) {
                if (g.phase != 2 || seat < 0 || g.turn != seat) out = "{\"ok\":false,\"error\":\"还没轮到你\"}";
                else {
                    List<Card> hand = g.seats[seat].hand;
                    boolean lead = (g.lastSeat == null || g.lastSeat == seat);
                    List<Card> mv = lead ? aiLead(hand) : findBeating(hand, g.lastCombo);
                    if (mv == null || mv.isEmpty() || classify(mv) == null) out = "{\"ok\":true,\"none\":true}";
                    else {
                        StringBuilder hs = new StringBuilder("{\"ok\":true,\"ids\":[");
                        for (int i = 0; i < mv.size(); i++) { if (i > 0) hs.append(','); hs.append(mv.get(i).id); }
                        hs.append("]}"); out = hs.toString();
                    }
                }
            } else out = "{\"ok\":false,\"error\":\"未知操作\"}";

        }
        write(resp, out);
    }
    private void resetSeats(Game g) { for (int i = 0; i < 3; i++) { g.seats[i].name = null; g.seats[i].ai = false; g.seats[i].hand.clear(); } }
    private static boolean allAi(Game g) { return g.seats[0].ai && g.seats[1].ai && g.seats[2].ai; }
    private void resetToLobby(Game g) {
        g.phase = 0; g.landlord = -1; g.winner = -1; g.turn = -1;
        g.lastSeat = null; g.lastCombo = null; g.lastCards = null; g.passes = 0;
        g.bidOrder.clear(); g.bidIdx = 0; g.bottom.clear(); newTrick(g);
        g.bidStage = 0; g.bidCaller = -1; g.robHolder = -1; g.robCount = 0; g.robIdx = 0; g.robLen = 0;
        g.declined[0] = g.declined[1] = g.declined[2] = false;

        for (int i = 0; i < 3; i++) { g.seats[i].name = null; g.seats[i].ai = false; g.seats[i].hand.clear(); }
    }
    private List<Card> pickByIds(List<Card> hand, String ids) {
        List<Card> out = new ArrayList<>(); if (ids == null || ids.isEmpty()) return out;
        for (String s : ids.split(",")) { try { int id = Integer.parseInt(s.trim()); for (Card c : hand) if (c.id == id) { out.add(c); break; } } catch (Exception ignore) {} }
        return out;
    }

    // ---------- JSON ----------
    private String stateJson(Game g, Room r, String viewer) {
        StringBuilder sb = new StringBuilder(512);
        int mySeat = seatOf(g, viewer);
        boolean canFollow = true;
        if (g.phase == 2 && mySeat >= 0 && g.turn == mySeat && g.lastSeat != null && g.lastSeat != mySeat)
            canFollow = findBeating(g.seats[mySeat].hand, g.lastCombo) != null;

        sb.append("{\"phase\":\"").append(phaseStr(g.phase)).append("\",\"turn\":").append(g.turn)
                .append(",\"landlord\":").append(g.landlord).append(",\"mySeat\":").append(mySeat)
                .append(",\"winner\":").append(g.winner)
                .append(",\"bidTurn\":").append(g.phase == 1 ? bidActor(g) : -1)
                .append(",\"bidStage\":").append(g.bidStage)
                .append(",\"robHolder\":").append(g.bidStage == 1 ? g.robHolder : -1)
                .append(",\"robCount\":").append(g.robCount)
                .append(",\"canFollow\":").append(canFollow);

        sb.append(",\"seats\":[");
        for (int i = 0; i < 3; i++) { if (i > 0) sb.append(','); sb.append("{\"name\":\"").append(esc(g.seats[i].name == null ? "" : g.seats[i].name))
                .append("\",\"ai\":").append(g.seats[i].ai).append(",\"count\":").append(g.seats[i].hand.size()).append('}'); }
        sb.append(']');
        sb.append(",\"hand\":").append(cardsJson(mySeat >= 0 ? g.seats[mySeat].hand : new ArrayList<Card>()));
        sb.append(",\"bottom\":").append(g.phase >= 2 ? cardsJson(g.bottom) : "[]");
        if (g.lastSeat != null && g.lastCards != null) sb.append(",\"lastPlay\":{\"seat\":").append(g.lastSeat).append(",\"cards\":").append(cardsJson(g.lastCards)).append('}');
        else sb.append(",\"lastPlay\":null");
        sb.append(",\"seatPlay\":[");
        for (int i = 0; i < 3; i++) { if (i > 0) sb.append(','); if (g.seatPass[i]) sb.append("{\"pass\":true}"); else if (g.seatPlay.get(i) != null) sb.append("{\"cards\":").append(cardsJson(g.seatPlay.get(i))).append('}'); else sb.append("null"); }
        sb.append(']');
        sb.append(",\"members\":["); boolean first = true;
        for (String n : r.members.keySet()) { if (!first) sb.append(','); first = false; sb.append('"').append(esc(n)).append('"'); }
        sb.append(']');
        sb.append(",\"msg\":["); first = true; long now = System.currentTimeMillis();
        for (Msg x : r.msgs) { if (now - x.time > MSG_TTL) continue; if (!first) sb.append(','); first = false; sb.append("{\"n\":\"").append(esc(x.name)).append("\",\"t\":\"").append(esc(x.text)).append('"'); if (x.sf != null) sb.append(",\"sc\":\"").append(esc(x.sc)).append("\",\"sf\":\"").append(esc(x.sf)).append('"'); sb.append(",\"tms\":").append(x.time).append('}'); }
        sb.append(']');
        sb.append('}');
        return sb.toString();
    }
    private static String phaseStr(int p) { return new String[]{"lobby", "bid", "play", "over"}[p]; }
    private static String cardsJson(List<Card> cards) { StringBuilder b = new StringBuilder('[' + 0); b.append('['); for (int i = 0; i < cards.size(); i++) { if (i > 0) b.append(','); b.append(cards.get(i).json()); } b.append(']'); return b.toString(); }

    private void write(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        PrintWriter out = resp.getWriter(); out.write(json); out.flush();
    }
    private static boolean safeName(String s) {
        return s != null && !s.isEmpty() && s.indexOf('/') < 0 && s.indexOf('\\') < 0 && !s.contains("..");
    }
    private static String clean(String s, int max) {
        if (s == null) return null; s = s.trim(); StringBuilder b = new StringBuilder();
        for (int i = 0; i < s.length() && b.length() < max; i++) { char c = s.charAt(i); if (c == '\n' || c == '\r') b.append(' '); else if (c < 0x20) { } else b.append(c); }
        return b.toString();
    }
    private static String esc(String s) {
        if (s == null) return ""; StringBuilder b = new StringBuilder(s.length() + 8);
        for (int i = 0; i < s.length(); i++) { char c = s.charAt(i); switch (c) { case '"': b.append("\\\""); break; case '\\': b.append("\\\\"); break; case '\n': b.append("\\n"); break; case '\r': b.append("\\r"); break; case '\t': b.append("\\t"); break; default: if (c < 0x20) b.append(' '); else b.append(c); } }
        return b.toString();
    }
}