<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>表情包收藏</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/collection.css">
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/Titleico/Bangdream.png">
</head>
<body>
<div class="blob" style="width:320px;height:320px;background:#6ba3c7;top:10%;left:8%"></div>
<div class="blob" style="width:280px;height:280px;background:#8f7bd0;bottom:12%;right:10%;animation-delay:-8s"></div>
<div class="blob" style="width:220px;height:220px;background:#f0c674;top:42%;right:32%;animation-delay:-15s"></div>

<div class="wrap">
    <h1 class="page-title">表情包收藏</h1>
    <p class="page-sub">挑一个分类进去逛逛 · 普通访客可下载，管理员可上传</p>
    <div class="topbar" style="justify-content:center">
        <a class="btn ghost" href="${pageContext.request.contextPath}/乐队主页.jsp">← 返回主页</a>
    </div>
    <div class="cards">
        <a class="cat-card" href="表情包浏览.jsp?cat=熊喵喵">
            <span class="emoji">🐱</span><h3>熊喵喵</h3><p>猫猫系表情包</p>
        </a>
        <a class="cat-card" href="表情包浏览.jsp?cat=基米斗">
            <span class="emoji">🥊</span><h3>基米斗</h3><p>斗图专用</p>
        </a>
        <a class="cat-card" href="表情包浏览.jsp?cat=OurNotes">
            <span class="emoji">📔</span><h3>Our Notes</h3><p>日常记录</p>
        </a>
        <a class="cat-card" href="表情包浏览.jsp?cat=扫码表情包">
            <span class="emoji">📷</span><h3>扫码表情包</h3><p>扫码专属表情包</p>
        </a>
        <a class="cat-card" href="表情包浏览.jsp?cat=杂项">
            <span class="emoji">📦</span><h3>杂项</h3><p> miscellaneous · 杂七杂八</p>
        </a>
    </div>
</div>
<script src="${pageContext.request.contextPath}/js/music-player.js"></script>
</body>
</html>
