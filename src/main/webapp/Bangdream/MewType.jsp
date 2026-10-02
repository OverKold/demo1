<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2026/10/2
  Time: 0:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>瓦塔西哇MewTypeDesu!</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/Titleico/Mugendai_MewType_ON_icon.ico">
    <style>
        body{
            margin: 0;
            min-height: 100vh;
            padding: 40px 30px;
            font-family: "Segoe UI", "Microsoft YaHei", sans-serif;
            color: #3a3a4a;
            background: linear-gradient(135deg, #fdf9e7, #faf3d4, #f7eec8, #fbf6e0);
            background-size: 400% 400%;
            animation: bgFlow 20s ease infinite;
            overflow-x: hidden;
            position: relative;
        }
        @keyframes bgFlow{
            0%{ background-position: 0% 50%; }
            50%{ background-position: 100% 50%; }
            100%{ background-position: 0% 50%; }
        }
        h1, p, a{ position: relative; z-index: 1; }
        a{ color: #b8961f; text-decoration: none; font-weight: 600; }
        a:hover{ opacity: 0.8; }
        .float-icon{
            position: fixed;
            top: 0;
            z-index: 0;
            pointer-events: none;
            will-change: transform;
            animation-name: floatUp;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            filter: saturate(0.9);
        }
        @keyframes floatUp{
            0%{ transform: translate(0, 110vh) rotate(0deg); }
            50%{ transform: translate(var(--sway, 40px), 45vh) rotate(180deg); }
            100%{ transform: translate(0, -25vh) rotate(360deg); }
        }
        @media (prefers-reduced-motion: reduce){
            body{ animation: none; }
            .float-icon{ display: none; }
        }
    </style>
</head>
<body>
    <h1>我们是梦限大,请多多支持我们!</h1>
    <a href="../乐队主页.jsp">返回主页</a>

    <script>
        (function(){
            var icon = '${pageContext.request.contextPath}/Mainimgs/Mugendai_MewType_ON_icon.webp';
            for (var i = 0; i < 7; i++){
                var el = document.createElement('img');
                el.src = icon;
                el.className = 'float-icon';
                el.alt = '';
                var size = 40 + Math.random() * 50;
                el.style.width = size + 'px';
                el.style.height = size + 'px';
                el.style.left = (Math.random() * 100) + 'vw';
                el.style.opacity = (0.12 + Math.random() * 0.12).toFixed(2);
                var dur = 16 + Math.random() * 16;
                el.style.animationDuration = dur + 's';
                el.style.animationDelay = (-Math.random() * dur) + 's';
                el.style.setProperty('--sway', (Math.random() * 160 - 80) + 'px');
                document.body.appendChild(el);
            }
        })();
    </script>
</body>
</html>
