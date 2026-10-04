package com.example.demo1;

import jakarta.servlet.ServletContext;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Collections;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

@WebServlet(name = "onlineServlet", value = "/online")
public class OnlineServlet extends HttpServlet {

    private static final long TTL_MS = 45_000L;

    public static final class Visitor {
        public final String name;
        public volatile long lastSeen;
        public volatile String page;
        Visitor(String n) { name = n; lastSeen = System.currentTimeMillis(); }
    }

    @SuppressWarnings("unchecked")
    public static Map<String, Visitor> visitors(ServletContext ctx) {
        Object o = ctx.getAttribute("VISITORS");
        if (o == null) {
            synchronized (ctx) {
                o = ctx.getAttribute("VISITORS");
                if (o == null) { o = new ConcurrentHashMap<String, Visitor>(); ctx.setAttribute("VISITORS", o); }
            }
        }
        return (Map<String, Visitor>) o;
    }

    @SuppressWarnings("unchecked")
    public static Set<String> muted(ServletContext ctx) {
        Object o = ctx.getAttribute("MUTED");
        if (o == null) {
            synchronized (ctx) {
                o = ctx.getAttribute("MUTED");
                if (o == null) { o = Collections.newSetFromMap(new ConcurrentHashMap<String, Boolean>()); ctx.setAttribute("MUTED", o); }
            }
        }
        return (Set<String>) o;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, Visitor> map = visitors(getServletContext());
        long now = System.currentTimeMillis();

        String name = req.getParameter("name");
        if (name != null) {
            name = name.trim();
            if (name.length() > 16) name = name.substring(0, 16);
            if (!name.isEmpty()) {
                Visitor v = map.get(name);
                if (v == null) { v = new Visitor(name); map.put(name, v); }
                v.lastSeen = now;
                String page = req.getParameter("page");
                if (page != null && !page.trim().isEmpty()) v.page = clean(page, 40);
            }
        }

        for (Map.Entry<String, Visitor> e : map.entrySet()) {
            if (now - e.getValue().lastSeen > TTL_MS) map.remove(e.getKey());
        }

        StringBuilder json = new StringBuilder(128);
        json.append('[');
        boolean first = true;
        for (String n : map.keySet()) {
            if (!first) json.append(',');
            first = false;
            json.append('"').append(esc(n)).append('"');
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
        Map<String, Visitor> map = visitors(getServletContext());
        String leave = req.getParameter("leave");
        if (leave != null) {
            leave = leave.trim();
            if (!leave.isEmpty()) map.remove(leave);
        }
        resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
        resp.setHeader("Cache-Control", "no-store");
    }

    private static String clean(String s, int max) {
        s = s.trim();
        if (s.length() > max) s = s.substring(0, max);
        StringBuilder b = new StringBuilder();
        for (int i = 0; i < s.length(); i++) {
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
}