package com.example.demo1;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Deque;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentLinkedDeque;

@WebServlet(name = "chatServlet", value = "/chat")
public class ChatServlet extends HttpServlet {

    private static final long TTL_MS   = 10 * 60 * 1000L;
    private static final int  MAX_MSG  = 300;
    private static final int  MAX_TEXT = 200;
    private static final int  MAX_NAME = 16;

    private static final String[] STICKER_CAT_ARR = {"熊喵喵", "基米斗", "OurNotes", "扫码表情包", "杂项"};
    private static final Set<String> STICKER_CATS = new HashSet<String>(Arrays.asList(STICKER_CAT_ARR));
    private static final String[] STICKER_EXTS = {".png", ".jpg", ".jpeg", ".gif", ".webp"};

    private static final class Msg {
        final String name, text; final long time;
        final String sc, sf;
        Msg(String n, String t, long tm) { this(n, t, tm, null, null); }
        Msg(String n, String t, long tm, String c, String f) { name = n; text = t; time = tm; sc = c; sf = f; }
    }

    @SuppressWarnings("unchecked")
    private Deque<Msg> store() {
        Object o = getServletContext().getAttribute("CHAT");
        if (o == null) {
            synchronized (getServletContext()) {
                o = getServletContext().getAttribute("CHAT");
                if (o == null) {
                    o = new ConcurrentLinkedDeque<Msg>();
                    getServletContext().setAttribute("CHAT", o);
                }
            }
        }
        return (Deque<Msg>) o;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (req.getParameter("stickers") != null) { writeStickerCatalog(resp); return; }

        Deque<Msg> q = store();
        long now = System.currentTimeMillis();
        purge(q, now);

        StringBuilder json = new StringBuilder(256);
        json.append('[');
        boolean first = true;
        for (Msg m : q) {
            if (!first) json.append(',');
            first = false;
            json.append("{\"n\":\"").append(esc(m.name))
                    .append("\",\"t\":\"").append(esc(m.text == null ? "" : m.text)).append("\"");
            if (m.sc != null) {
                json.append(",\"sc\":\"").append(esc(m.sc))
                        .append("\",\"sf\":\"").append(esc(m.sf)).append('"');
            }
            json.append(",\"tms\":").append(m.time).append('}');
        }
        json.append(']');

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        PrintWriter out = resp.getWriter();
        out.write(json.toString());
        out.flush();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        Deque<Msg> q = store();
        long now = System.currentTimeMillis();

        String name = clean(req.getParameter("name"), MAX_NAME);
        String text = clean(req.getParameter("text"), MAX_TEXT);
        if (name != null && OnlineServlet.muted(getServletContext()).contains(name)) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);   // 403 = 被禁言
            resp.setHeader("Cache-Control", "no-store");
            return;
        }
        if (name != null && !name.isEmpty()) {
            String scat = req.getParameter("scat");
            String sfile = req.getParameter("sfile");
            if (validSticker(scat, sfile)) {
                q.addLast(new Msg(name, null, now, scat, sfile));
                while (q.size() > MAX_MSG) q.pollFirst();
            } else if (text != null && !text.isEmpty()) {
                q.addLast(new Msg(name, text, now));
                while (q.size() > MAX_MSG) q.pollFirst();
            }
        }
        purge(q, now);

        resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
        resp.setHeader("Cache-Control", "no-store");
    }

    private static void purge(Deque<Msg> q, long now) {
        Msg head;
        while ((head = q.peekFirst()) != null && now - head.time > TTL_MS) q.pollFirst();
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
        StringBuilder b = new StringBuilder(s.length() + 8);
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"':  b.append("\\\""); break;
                case '\\': b.append("\\\\"); break;
                case '\n': b.append("\\n");  break;
                case '\r': b.append("\\r");  break;
                case '\t': b.append("\\t");  break;
                default: if (c < 0x20) b.append(' '); else b.append(c);
            }
        }
        return b.toString();
    }

    private boolean validSticker(String cat, String file) {
        if (cat == null || !STICKER_CATS.contains(cat)) return false;
        if (file == null || file.isEmpty() || file.contains("..") || file.contains("/") || file.contains("\\")) return false;
        String lower = file.toLowerCase();
        boolean extOk = false;
        for (String e : STICKER_EXTS) { if (lower.endsWith(e)) { extOk = true; break; } }
        if (!extOk) return false;
        String real = getServletContext().getRealPath("/QQimgs/" + cat);
        return real != null && new File(real, file).isFile();
    }

    private void writeStickerCatalog(HttpServletResponse resp) throws IOException {
        StringBuilder sb = new StringBuilder(512);
        sb.append('{');
        boolean firstCat = true;
        for (String cat : STICKER_CAT_ARR) {
            if (!firstCat) sb.append(',');
            firstCat = false;
            sb.append('"').append(esc(cat)).append("\":[");
            String real = getServletContext().getRealPath("/QQimgs/" + cat);
            File dir = real != null ? new File(real) : null;
            File[] fs = (dir != null && dir.isDirectory()) ? dir.listFiles() : null;
            if (fs != null) {
                List<File> picked = new ArrayList<File>();
                for (File f : fs) {
                    String n = f.getName().toLowerCase();
                    for (String e : STICKER_EXTS) { if (n.endsWith(e)) { picked.add(f); break; } }
                }
                Collections.sort(picked, (a, b) -> a.getName().compareToIgnoreCase(b.getName()));
                boolean firstF = true;
                for (File f : picked) {
                    if (!firstF) sb.append(',');
                    firstF = false;
                    sb.append("{\"n\":\"").append(esc(f.getName()))
                            .append("\",\"a\":").append(StickerUtil.isAnimated(f)).append('}');
                }
            }
            sb.append(']');
        }
        sb.append('}');
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        resp.getWriter().write(sb.toString());
        resp.getWriter().flush();
    }
}
