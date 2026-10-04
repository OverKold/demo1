package com.example.demo1;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@WebServlet(name = "changelogServlet", value = "/changelog")
public class ChangelogServlet extends HttpServlet {

    private static final int MAX_LEN = 20000;
    private static final String DEFAULT_TEXT =
            "# 更新日志\n" +
                    "这里记录每天更新了什么，供大家查看。\n" +
                    "管理员登录后点右上角「✏️ 编辑」即可修改。\n";

    private final Object lock = new Object();

    // 存放位置：优先 -Dchangelog.path / 环境变量 CHANGELOG_PATH，
    // 否则用固定绝对路径 ${user.home}/.demo1-data/changelog.txt。
    // 不用 ${catalina.base}：IDEA 内置 Tomcat 的 catalina.base 是每次运行可能重建的临时目录，
    // 重启后 data/changelog.txt 会被清掉，导致更新日志“看起来被清空”。
    private Path file() {
        String custom = System.getProperty("changelog.path", System.getenv("CHANGELOG_PATH"));
        if (custom != null && !custom.isEmpty()) return Paths.get(custom);
        String home = System.getProperty("user.home");
        if (home == null || home.isEmpty()) home = System.getProperty("java.io.tmpdir");
        return Paths.get(home, ".demo1-data", "changelog.txt");
    }

    private String read() {
        Path p = file();
        try {
            if (Files.exists(p)) return new String(Files.readAllBytes(p), StandardCharsets.UTF_8);
        } catch (IOException ignore) { }
        return DEFAULT_TEXT;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String text;
        synchronized (lock) { text = read(); }
        json(resp, "{\"text\":\"" + esc(text) + "\",\"canEdit\":" + isAdmin(req) + "}");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!isAdmin(req)) { resp.sendError(HttpServletResponse.SC_FORBIDDEN, "只有管理员能编辑"); return; }
        req.setCharacterEncoding("UTF-8");
        String text = req.getParameter("text");
        if (text == null) text = "";
        if (text.length() > MAX_LEN) text = text.substring(0, MAX_LEN);
        Path p = file();
        try {
            synchronized (lock) {
                if (p.getParent() != null) Files.createDirectories(p.getParent());
                Files.write(p, text.getBytes(StandardCharsets.UTF_8));
            }
        } catch (IOException e) {
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "保存失败");
            return;
        }
        json(resp, "{\"ok\":true}");
    }

    private boolean isAdmin(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return s != null && Boolean.TRUE.equals(s.getAttribute("ADMIN"));
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
}