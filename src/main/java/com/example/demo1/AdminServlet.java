package com.example.demo1;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Set;

@WebServlet(name = "adminServlet", value = "/admin/*")
public class AdminServlet extends HttpServlet {

    private static final String SALT = "bd1-yumemita-2026";

    // 管理员 id → 密码哈希（正式环境填入哈希后删除 BOOTSTRAP_MAP）
    private static final Map<String, String> ADMIN_HASHES = new LinkedHashMap<String, String>();
    // 引导明文（仅开发用，生成哈希后删除整个 Map）
    private static final Map<String, String> BOOTSTRAP_MAP = new LinkedHashMap<String, String>();
    static {
        ADMIN_HASHES.put("OverKold", "");
        BOOTSTRAP_MAP.put("OverKold", "070525");
        ADMIN_HASHES.put("OverRide", "");
        BOOTSTRAP_MAP.put("OverRide", "0915");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getPathInfo();
        if ("/check".equals(path)) {
            json(resp, "{\"isAdmin\":" + isAdmin(req) + "}");
        } else if ("/status".equals(path)) {
            if (!isAdmin(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }
            json(resp, statusJson());
        } else if ("/logout".equals(path)) {
            HttpSession s = req.getSession(false);
            if (s != null) { s.removeAttribute("ADMIN"); s.removeAttribute("ADMIN_ID"); }
            resp.setStatus(204);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String path = req.getPathInfo();
        if ("/login".equals(path)) {
            String id = req.getParameter("adminId");
            String pw = req.getParameter("password");
            if (checkLogin(id, pw)) {
                HttpSession s = req.getSession(true);
                s.setAttribute("ADMIN", Boolean.TRUE);
                s.setAttribute("ADMIN_ID", id);
                json(resp, "{\"isAdmin\":true}");
            } else {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            }
            return;
        }
        if (!isAdmin(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN); return; }

        Set<String> muted = OnlineServlet.muted(getServletContext());
        String name = req.getParameter("name");
        if (name != null) name = name.trim();
        if ("/mute".equals(path)) {
            if (name != null && !name.isEmpty()) muted.add(name);
            resp.setStatus(204);
        } else if ("/unmute".equals(path)) {
            if (name != null) muted.remove(name);
            resp.setStatus(204);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && Boolean.TRUE.equals(s.getAttribute("ADMIN"));
    }

    private String statusJson() {
        Map<String, OnlineServlet.Visitor> map = OnlineServlet.visitors(getServletContext());
        Set<String> muted = OnlineServlet.muted(getServletContext());
        long now = System.currentTimeMillis();
        StringBuilder sb = new StringBuilder(256);
        sb.append('[');
        boolean first = true;
        for (OnlineServlet.Visitor v : map.values()) {
            if (now - v.lastSeen > 45_000L) continue;
            if (!first) sb.append(',');
            first = false;
            sb.append("{\"name\":\"").append(esc(v.name))
                    .append("\",\"page\":\"").append(esc(v.page == null ? "未知" : v.page))
                    .append("\",\"lastSeen\":").append(v.lastSeen)
                    .append(",\"muted\":").append(muted.contains(v.name))
                    .append('}');
        }
        sb.append(']');
        return sb.toString();
    }

    private static boolean checkLogin(String id, String input) {
        if (id == null || id.trim().isEmpty()) return false;
        id = id.trim();
        if (input == null || input.isEmpty()) return false;

        String storedHash = ADMIN_HASHES.get(id);
        if (storedHash == null) return false;

        String expected;
        if (storedHash.isEmpty()) {
            String plain = BOOTSTRAP_MAP.get(id);
            if (plain == null) return false;
            expected = hash(SALT + plain);
        } else {
            expected = storedHash;
        }
        return constantTimeEquals(expected, hash(SALT + input));
    }

    private static String hash(String s) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] d = md.digest(s.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : d) sb.append(String.format("%02x", b));
            return sb.toString();
        } catch (Exception e) { throw new RuntimeException(e); }
    }

    private static boolean constantTimeEquals(String a, String b) {
        if (a == null || b == null || a.length() != b.length()) return false;
        int r = 0;
        for (int i = 0; i < a.length(); i++) r |= a.charAt(i) ^ b.charAt(i);
        return r == 0;
    }

    private static void json(HttpServletResponse resp, String body) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        PrintWriter out = resp.getWriter();
        out.write(body);
        out.flush();
    }

    private static String esc(String s) {
        if (s == null) return "";
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

    // 在 IDEA 里右键 Run 'AdminServlet.main()' → 打印所有管理员哈希，填入 ADMIN_HASHES 并删除 BOOTSTRAP_MAP
    public static void main(String[] args) {
        System.out.println("===== 把下面的哈希填进 ADMIN_HASHES，然后删除 BOOTSTRAP_MAP =====");
        for (Map.Entry<String, String> e : BOOTSTRAP_MAP.entrySet()) {
            System.out.println("ADMIN_HASHES.put(\"" + e.getKey() + "\", \"" + hash(SALT + e.getValue()) + "\");");
        }
    }
}