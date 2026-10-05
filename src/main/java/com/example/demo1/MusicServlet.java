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

        List<File> subDirs = new ArrayList<>();
        List<String> rootFiles = new ArrayList<>();
        if (dir != null && dir.isDirectory()) {
            File[] fs = dir.listFiles();
            if (fs != null) {
                for (File f : fs) {
                    String n = f.getName();
                    if (n.startsWith(".")) continue;                 // 跳过隐藏
                    if (f.isDirectory()) subDirs.add(f);             // 子文件夹 = 分区
                    else if (isAudio(n)) rootFiles.add(n);           // 根目录散曲
                }
            }
        }
        subDirs.sort((a, b) -> a.getName().compareToIgnoreCase(b.getName()));
        Collections.sort(rootFiles, String.CASE_INSENSITIVE_ORDER);

        StringBuilder sb = new StringBuilder("[");
        boolean first = true;
        for (File d : subDirs) {
            List<String> files = new ArrayList<>();
            collect(dir, d, files);                                  // 递归收集该分区音频
            if (files.isEmpty()) continue;
            Collections.sort(files, String.CASE_INSENSITIVE_ORDER);
            if (!first) sb.append(',');
            first = false;
            sb.append("{\"cat\":\"").append(esc(d.getName())).append("\",\"files\":[");
            appendFiles(sb, files);
            sb.append("]}");
        }
        if (!rootFiles.isEmpty()) {
            if (!first) sb.append(',');
            sb.append("{\"cat\":\"未分类\",\"files\":[");
            appendFiles(sb, rootFiles);
            sb.append("]}");
        }
        sb.append(']');

        resp.setContentType("application/json;charset=UTF-8");
        resp.setHeader("Cache-Control", "no-store");
        PrintWriter out = resp.getWriter();
        out.write(sb.toString());
        out.flush();
    }

    private static boolean isAudio(String name) {
        int d = name.lastIndexOf('.');
        String ext = d > 0 ? name.substring(d + 1).toLowerCase() : "";
        return ALLOW_EXT.contains(ext);
    }

    /** 递归收集 root 之下 dir 子树内的音频，返回相对 root 的路径（用 / 分隔） */
    private static void collect(File root, File dir, List<String> out) {
        File[] fs = dir.listFiles();
        if (fs == null) return;
        for (File f : fs) {
            String n = f.getName();
            if (n.startsWith(".")) continue;
            if (f.isDirectory()) collect(root, f, out);
            else if (isAudio(n)) out.add(rel(root, f));
        }
    }

    private static String rel(File root, File f) {
        String r = root.getAbsolutePath(), p = f.getAbsolutePath();
        if (p.startsWith(r)) {
            p = p.substring(r.length());
            if (p.startsWith(File.separator)) p = p.substring(File.separator.length());
        }
        return p.replace(File.separatorChar, '/');
    }

    private static void appendFiles(StringBuilder sb, List<String> files) {
        for (int i = 0; i < files.size(); i++) {
            if (i > 0) sb.append(',');
            sb.append('"').append(esc(files.get(i))).append('"');
        }
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