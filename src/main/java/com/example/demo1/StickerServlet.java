package com.example.demo1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@WebServlet(name = "stickerServlet", value = "/sticker")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1MB 进内存，超出落临时文件
        maxFileSize = 10L * 1024 * 1024,      // 单文件 10MB
        maxRequestSize = 200L * 1024 * 1024   // 整个请求 200MB，支持一次批量上传
)
public class StickerServlet extends HttpServlet {

    private static final Set<String> ALLOW_CAT = new HashSet<String>(Arrays.asList("熊喵喵", "基米斗", "OurNotes", "扫码表情包", "杂项"));
    private static final Set<String> ALLOW_EXT = new HashSet<String>(Arrays.asList("png", "jpg", "jpeg", "gif", "webp"));

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException, ServletException {
        HttpSession s = req.getSession(false);
        if (s == null || !Boolean.TRUE.equals(s.getAttribute("ADMIN"))) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN, "只有管理员能操作");
            return;
        }

        String action = req.getParameter("action");
        if ("delete".equals(action)) {
            handleDelete(req, resp);
            return;
        }

        String cat = req.getParameter("cat");
        if (cat == null || !ALLOW_CAT.contains(cat)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "非法分类");
            return;
        }

        String real = getServletContext().getRealPath("/QQimgs/" + cat);
        if (real == null) { resp.sendError(500, "无法解析目录"); return; }
        File dir = new File(real);
        if (!dir.exists() && !dir.mkdirs()) { resp.sendError(500, "无法创建目录"); return; }

        int saved = 0;
        for (Part part : req.getParts()) {
            if (!"file".equals(part.getName()) || part.getSize() == 0) continue;
            String ct = part.getContentType();
            if (ct == null || !ct.toLowerCase().startsWith("image/")) continue;
            String ext = extOf(part.getSubmittedFileName());
            if (ext == null || !ALLOW_EXT.contains(ext)) continue;
            String name = System.currentTimeMillis() + "_" + saved + "_" + sanitizeBase(part.getSubmittedFileName()) + "." + ext;
            File target = new File(dir, name);
            try (InputStream in = part.getInputStream()) {
                Files.copy(in, target.toPath(), StandardCopyOption.REPLACE_EXISTING);
            }
            saved++;
        }

        back(resp, req, cat);
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String cat = req.getParameter("cat");
        String file = req.getParameter("file");
        if (cat == null || !ALLOW_CAT.contains(cat)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "非法分类");
            return;
        }
        if (file == null || file.isEmpty() || file.contains("..") || file.contains("/") || file.contains("\\")) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "非法文件名");
            return;
        }
        String real = getServletContext().getRealPath("/QQimgs/" + cat);
        if (real == null) { resp.sendError(500, "无法解析目录"); return; }
        File target = new File(real, file);
        boolean deleted = target.isFile() && target.delete();
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write("{\"ok\":" + deleted + "}");
    }

    private void back(HttpServletResponse resp, HttpServletRequest req, String cat) throws IOException {
        // Location 响应头只能是 ASCII，含中文会被 Tomcat 丢弃导致重定向失效（表现为“上传失败但其实已存”）。
        // 因此对路径的每一段分别做百分号编码，保证 Location 合法可跟随。
        String url = req.getContextPath()
                + "/" + enc("表情包目录")
                + "/" + enc("表情包浏览.jsp")
                + "?cat=" + enc(cat);
        resp.sendRedirect(url);
    }
    private static String enc(String s) throws java.io.UnsupportedEncodingException {
        return URLEncoder.encode(s, "UTF-8").replace("+", "%20");
    }

    private static String extOf(String fn) {
        if (fn == null) return null;
        int d = fn.lastIndexOf('.');
        if (d < 0 || d == fn.length() - 1) return null;
        return fn.substring(d + 1).toLowerCase();
    }

    private static String sanitizeBase(String fn) {
        if (fn == null) return "img";
        int d = fn.lastIndexOf('.');
        String base = d > 0 ? fn.substring(0, d) : fn;
        base = base.replaceAll("[^\\p{L}\\p{N}_-]", "_");
        if (base.isEmpty()) base = "img";
        if (base.length() > 40) base = base.substring(0, 40);
        return base;
    }
}