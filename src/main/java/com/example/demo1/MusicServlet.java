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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet(name = "musicServlet", value = "/music")
public class MusicServlet extends HttpServlet {

    private static final Set<String> ALLOW_EXT =
            new HashSet<>(Arrays.asList("mp3", "ogg", "oga", "wav", "m4a", "aac", "flac"));

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (req.getParameter("list") == null) { resp.sendError(HttpServletResponse.SC_NOT_FOUND); return; }

        String real = getServletContext().getRealPath("/Music");
        File dir = real != null ? new File(real) : null;
        File[] fs = (dir != null && dir.isDirectory()) ? dir.listFiles() : null;

        List<String> names = new ArrayList<>();
        if (fs != null) {
            for (File f : fs) {
                if (!f.isFile()) continue;
                String n = f.getName();
                if (n.startsWith(".")) continue;                 // 跳过隐藏文件
                int d = n.lastIndexOf('.');
                String ext = d > 0 ? n.substring(d + 1).toLowerCase() : "";
                if (ALLOW_EXT.contains(ext)) names.add(n);       // 只收音频
            }
        }
        Collections.sort(names, String.CASE_INSENSITIVE_ORDER);

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < names.size(); i++) {
            if (i > 0) sb.append(',');
            sb.append('"').append(esc(names.get(i))).append('"');
        }
        sb.append(']');

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        PrintWriter out = resp.getWriter();
        out.write(sb.toString());
        out.flush();
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