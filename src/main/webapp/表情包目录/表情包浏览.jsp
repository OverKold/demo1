<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ page import="java.io.File" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="com.example.demo1.StickerUtil" %>

<%
    String[] ALLOW = {"熊喵喵", "基米斗", "OurNotes", "扫码表情包", "杂项"};
    String cat = request.getParameter("cat");
    if (cat == null || cat.isEmpty()) cat = "熊喵喵";
    boolean ok = false;
    for (int i = 0; i < ALLOW.length; i++) if (ALLOW[i].equals(cat)) { ok = true; break; }
    if (!ok) { response.sendError(404); return; }

    String ctxp = request.getContextPath();
    boolean isAdmin = Boolean.TRUE.equals(session.getAttribute("ADMIN"));

    File dir = new File(application.getRealPath("/QQimgs/" + cat));
    File[] all = dir.isDirectory() ? dir.listFiles() : null;
    List<File> list = new ArrayList<File>();
    if (all != null) {
        for (int i = 0; i < all.length; i++) {
            String n = all[i].getName().toLowerCase();
            if (n.endsWith(".png") || n.endsWith(".jpg") || n.endsWith(".jpeg") || n.endsWith(".gif") || n.endsWith(".webp"))
                list.add(all[i]);
        }
    }
    File[] files = list.toArray(new File[0]);
    Arrays.sort(files, new Comparator<File>() {
        public int compare(File a, File b) { return a.getName().compareToIgnoreCase(b.getName()); }
    });
    String catEnc = URLEncoder.encode(cat, "UTF-8").replace("+", "%20");
    response.setHeader("Cache-Control", "no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
%>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><%= cat %> · 表情包</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/collection.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/Titleico/Bangdream.png">
</head>
<body>
<div class="blob" style="width:320px;height:320px;background:#6ba3c7;top:12%;left:6%"></div>
<div class="blob" style="width:260px;height:260px;background:#8f7bd0;bottom:14%;right:8%;animation-delay:-10s"></div>

<div class="wrap">
    <h1 class="page-title"><%= cat %> 表情包</h1>
    <p class="page-sub">点图片可放大 · 右下角可下载<%= isAdmin ? " · 你是管理员，可上传/删除" : "" %></p>
    <% if (isAdmin) { %><p style="text-align:center;color:#8f7bd0;font-size:12px;word-break:break-all;margin-bottom:18px">📁 部署目录：<%= dir.getAbsolutePath() %></p><% } %>

    <div class="topbar">
        <div class="tabs">
            <a class="tab <%= "熊喵喵".equals(cat) ? "on" : "" %>" href="表情包浏览.jsp?cat=熊喵喵">熊喵喵</a>
            <a class="tab <%= "基米斗".equals(cat) ? "on" : "" %>" href="表情包浏览.jsp?cat=基米斗">基米斗</a>
            <a class="tab <%= "OurNotes".equals(cat) ? "on" : "" %>" href="表情包浏览.jsp?cat=OurNotes">Our Notes</a>
            <a class="tab <%= "扫码表情包".equals(cat) ? "on" : "" %>" href="表情包浏览.jsp?cat=扫码表情包">扫码表情包</a>
            <a class="tab <%= "杂项".equals(cat) ? "on" : "" %>" href="表情包浏览.jsp?cat=杂项">杂项</a>

        </div>

        <a class="btn ghost" href="<%= ctxp %>/乐队主页.jsp">← 返回主页</a>

    </div>

    <% if (isAdmin) { %>
    <form class="upload" id="uploadForm" action="<%= ctxp %>/sticker" method="post" enctype="multipart/form-data">
        <input type="hidden" name="cat" value="<%= cat %>">
        <input type="file" name="file" accept="image/png,image/jpeg,image/gif,image/webp" multiple required>
        <button class="btn" type="submit">批量上传</button>
        <span class="tip">仅管理员可见 · 可一次选多张 · 支持 png/jpg/gif/webp，单张 ≤ 10MB</span>
        <span class="tip" id="upTip" style="color:#8f7bd0"></span>
    </form>
    <% } %>

    <div class="grid">
        <%
            for (int i = 0; i < files.length; i++) {
                String name = files[i].getName();
                String enc = URLEncoder.encode(name, "UTF-8").replace("+", "%20");
                String src = ctxp + "/QQimgs/" + catEnc + "/" + enc;
                boolean isGif = StickerUtil.isAnimated(files[i]);

        %>
        <div class="sticker">
            <% if (isGif) { %>
            <div class="thumb gif" data-full="<%= src %>">
                <canvas class="gif-static"></canvas>
                <span class="gif-badge">GIF</span>
            </div>
            <% } else { %>
            <div class="thumb" data-full="<%= src %>"><img src="<%= src %>" alt="<%= name %>" loading="lazy"></div>
            <% } %>
            <div class="foot"><span class="nm"><%= name %></span><% if (isAdmin) { %><button class="del" data-cat="<%= cat %>" data-file="<%= name %>">删除</button><% } %><a class="dl" href="<%= src %>" download>下载</a></div>
        </div>
        <%
            }
            if (files.length == 0) {
        %>
        <div class="empty">这个分类还没有表情包～<%= isAdmin ? "用上面的表单上传第一张吧" : "管理员可以上传" %></div>
        <%
            }
        %>
    </div>
</div>

<div class="lightbox" id="lb"><button class="close" id="lbClose" aria-label="关闭">×</button><img id="lbImg" src="" alt=""></div>
<script>
    (function(){
        var lb = document.getElementById('lb'), img = document.getElementById('lbImg');
        document.querySelectorAll('.thumb').forEach(function(t){
            t.addEventListener('click', function(){ img.src = t.getAttribute('data-full'); lb.classList.add('show'); });
        });
        function close(){ lb.classList.remove('show'); img.src = ''; }
        lb.addEventListener('click', function(e){ if (e.target === lb || e.target.id === 'lbClose') close(); });
        document.addEventListener('keydown', function(e){ if (e.key === 'Escape') close(); });

        // GIF 缩略图：canvas 只画第一帧，保持静态不自动播放（点开大图才动）
        document.querySelectorAll('.thumb.gif').forEach(function(box){
            var canvas = box.querySelector('canvas');
            var src = box.getAttribute('data-full');
            if (!canvas || !src) return;
            var im = new Image();
            im.onload = function(){
                var w = box.clientWidth || 200, h = box.clientHeight || 200;
                var dpr = window.devicePixelRatio || 1;
                canvas.width = Math.round(w * dpr); canvas.height = Math.round(h * dpr);
                var g = canvas.getContext('2d');
                g.clearRect(0, 0, canvas.width, canvas.height);
                var scale = Math.min(w / im.width, h / im.height);
                var dw = im.width * scale, dh = im.height * scale;
                var dx = (w - dw) / 2, dy = (h - dh) / 2;
                g.drawImage(im, dx * dpr, dy * dpr, dw * dpr, dh * dpr);
            };
            im.src = src;
        });

        document.querySelectorAll('.del').forEach(function(btn){
            btn.addEventListener('click', function(){
                if (!confirm('确定删除这张表情包？此操作不可恢复。')) return;
                var body = new URLSearchParams();
                body.set('action', 'delete');
                body.set('cat', btn.getAttribute('data-cat'));
                body.set('file', btn.getAttribute('data-file'));
                btn.disabled = true;
                fetch('<%= ctxp %>/sticker', {method: 'POST', body: body})
                    .then(function(r){ return r.json(); })
                    .then(function(j){
                        if (j && j.ok) { var card = btn.closest('.sticker'); if (card) card.remove(); }
                        else { alert('删除失败：文件可能已不存在'); btn.disabled = false; }
                    })
                    .catch(function(){ alert('删除请求失败'); btn.disabled = false; });
            });
        });

        var upForm = document.getElementById('uploadForm');
        if (upForm) {
            upForm.addEventListener('submit', function (e) {
                e.preventDefault();
                var fileInput = upForm.querySelector('input[type=file]');
                var btn = upForm.querySelector('button[type=submit]');
                var tip = document.getElementById('upTip');
                if (!fileInput.files.length) { alert('请先选择图片'); return; }
                var fd = new FormData();
                fd.append('cat', upForm.querySelector('[name=cat]').value);
                for (var i = 0; i < fileInput.files.length; i++) fd.append('file', fileInput.files[i]);
                btn.disabled = true;
                if (tip) tip.textContent = '上传中…（' + fileInput.files.length + ' 张）';
                fetch(upForm.action, { method: 'POST', body: fd }).then(function (r) {
                    if (r.ok) { if (tip) tip.textContent = '上传成功，正在刷新…'; location.reload(); }
                    else { alert('上传失败（' + r.status + '），请确认是否管理员登录/文件是否过大'); btn.disabled = false; if (tip) tip.textContent = ''; }
                }).catch(function () { alert('上传请求失败'); btn.disabled = false; if (tip) tip.textContent = ''; });
            });
        }
    })();

</script>
<script src="${pageContext.request.contextPath}/js/presence.js"></script>
<script src="${pageContext.request.contextPath}/js/music-player.js?v=3"></script>

</body>
</html>