<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <style>
        *{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body{
            min-height: 100vh;
            font-family: "Segoe UI", "Microsoft YaHei", sans-serif;
            /* 低饱和柔和渐变，护眼不刺眼 */
            background: linear-gradient(-45deg, #3a3d52, #4a4458, #3f4a5c, #453f52, #3a3d52);
            background-size: 400% 400%;
            animation: gradientFlow 22s ease infinite;
            overflow-x: hidden;
            position: relative;
        }
        @keyframes gradientFlow{
            0%{ background-position: 0% 50%; }
            50%{ background-position: 100% 50%; }
            100%{ background-position: 0% 50%; }
        }

        /* 随机飘动的乐队 logo 背景 */
        .float-icon{
            position: fixed;
            top: 0;
            z-index: 0;
            pointer-events: none;
            will-change: transform;
            animation-name: floatUp;
            animation-timing-function: linear;
            animation-iteration-count: infinite;
            filter: saturate(0.85);
        }
        @keyframes floatUp{
            0%{   transform: translate(0, 110vh) rotate(0deg); }
            50%{  transform: translate(var(--sway, 40px), 45vh) rotate(180deg); }
            100%{ transform: translate(0, -25vh) rotate(360deg); }
        }

        /* 每行第一列前显示对应乐队图标（伪元素实现，不改结构） */
        td:first-child::before{
            content: "";
            display: inline-block;
            width: 46px;
            height: 46px;
            margin-right: 14px;
            vertical-align: middle;
            background: no-repeat center / contain;
            border-radius: 50%;
            box-shadow: 0 2px 8px rgba(120,90,160,0.25);
            transition: transform 0.35s ease;
        }
        tr:hover td:first-child::before{
            transform: scale(1.12) rotate(6deg);
        }
        #Mygo td:first-child::before{
            background-image: url('${pageContext.request.contextPath}/Mainimgs/MyGO!!!!!_ON_icon.png');
        }
        #AveMujica td:first-child::before{
            background-image: url('${pageContext.request.contextPath}/Mainimgs/AveMujica.png');
        }
        #MewType td:first-child::before{
            background-image: url('${pageContext.request.contextPath}/Mainimgs/Mugendai_MewType_ON_icon.webp');
        }
        #millsage td:first-child::before{
            background-image: url('${pageContext.request.contextPath}/Mainimgs/Millsage_ON_icon.webp');
        }
        #一家DumbRock td:first-child::before{
            background-image: url('${pageContext.request.contextPath}/Mainimgs/Ikka_Dumb_Rock!_ON_icon.png');
        }

        h1{
            text-align: center;
            font-size: 50px;
            padding: 60px 0 40px;
            color: #eceaf4;
            letter-spacing: 4px;
            text-shadow: 0 2px 12px rgba(0,0,0,0.25);
            position: relative;
            z-index: 1;
        }

        table{
            margin: 0 auto 80px;
            border-collapse: separate;
            border-spacing: 0px 14px;
            position: relative;
            z-index: 1;
            background: rgba(255, 255, 255, 0.06);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-radius: 18px;
            padding: 10px 20px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.20);
        }

        td{
            padding: 18px 34px;
            color: #e6e4ee;
            font-size: 18px;
            transition: all 0.35s ease;
        }

        tr{
            transition: transform 0.35s ease;
            cursor: pointer;
        }
        tr:hover{
            transform: translateX(10px) scale(1.02);
        }

        td:first-child{
            border-radius: 12px 0 0 12px;
        }
        td:last-child{
            border-radius: 0 12px 12px 0;
        }

        a{
            color: #f0eef7;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        a:hover{
            opacity: 0.85;
            letter-spacing: 1px;
        }

        #Mygo td{
            border: 2px solid #6ba3c7;
            background: rgba(107, 163, 199, 0.12);
        }
        #AveMujica td{
            border: 2px solid #b56b6b;
            background: rgba(181, 107, 107, 0.12);
        }
        #MewType td{
            border: 2px solid #d9c86b;
            background: rgba(217, 200, 107, 0.12);
        }
        #millsage td{
            border: 2px solid #b8b8c4;
            background: rgba(184, 184, 196, 0.10);
        }
        #一家DumbRock td{
            border: 2px solid #d99a5b;
            background: rgba(217, 154, 91, 0.12);
        }

        /* 照顾晕动/关闭动画的用户 */
        @media (prefers-reduced-motion: reduce){
            body{ animation: none; }
            .float-icon{ display: none; }
        }

    </style>
    <title>角色介绍</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/Titleico/Bangdream.png">
</head>
<body>
<h1><%= "选择你的乐队" %>
</h1>
<br/>
<table>
    <tr id="Mygo">
        <td><b>迷途之子</b></td>
        <td><a href="Bangdream/Mygo.jsp">Mygo!!!!!</a></td>
    </tr>

    <tr id="AveMujica">
        <td><b>母鸡卡</b></td>
        <td><a href="Bangdream/Avemujica.jsp">AveMujica</a></td>
    </tr>

    <tr id="MewType">
        <td><b>梦限大</b></td>
        <td><a href="Bangdream/MewType.jsp">MewType</a></td>
    </tr>

    <tr id="millsage">
        <td><b>茉团</b></td>
        <td><a href="Bangdream/millsage.jsp">millsage</a></td>
    </tr>

    <tr id="一家DumbRock">
        <td><b>家团</b></td>
        <td><a href="Bangdream/一家DumbRock.jsp">一家DumbRock</a></td>
    </tr>
</table>

<script>
    (function(){
        var base = '${pageContext.request.contextPath}';
        var icons = [
            base + '/Mainimgs/MyGO!!!!!_ON_icon.png',
            base + '/Mainimgs/AveMujica.png',
            base + '/Mainimgs/Mugendai_MewType_ON_icon.webp',
            base + '/Mainimgs/Millsage_ON_icon.webp',
            base + '/Mainimgs/Ikka_Dumb_Rock!_ON_icon.png'
        ];
        var count = 14;
        for (var i = 0; i < count; i++){
            var el = document.createElement('img');
            el.src = icons[Math.floor(Math.random() * icons.length)];
            el.className = 'float-icon';
            el.alt = '';
            var size = 28 + Math.random() * 46;                 // 28~74px
            el.style.width = size + 'px';
            el.style.height = size + 'px';
            el.style.left = (Math.random() * 100) + 'vw';       // 随机横向位置
            el.style.opacity = (0.10 + Math.random() * 0.15).toFixed(2); // 0.10~0.25 低透明
            var dur = 18 + Math.random() * 20;                  // 18~38s 随机速度
            el.style.animationDuration = dur + 's';
            el.style.animationDelay = (-Math.random() * dur) + 's'; // 负延迟，一进来就在动
            el.style.setProperty('--sway', (Math.random() * 160 - 80) + 'px'); // 随机左右摆幅
            document.body.appendChild(el);
        }
    })();
    document.querySelectorAll('table tr').forEach(function(row){
        row.addEventListener('click', function(e){
            // 如果点的是链接本身，交给浏览器默认跳转，避免重复
            if (e.target.closest('a')) return;
            var link = row.querySelector('a');
            if (link) window.location.href = link.href;
        });
    });
</script>
</body>
</html>