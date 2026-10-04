<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            font-family: "Segoe UI", "Microsoft YaHei", sans-serif;
            background: linear-gradient(-45deg, #3a3d52, #4a4458, #3f4a5c, #453f52, #3a3d52);
            background-size: 400% 400%;
            animation: gradientFlow 22s ease infinite;
            overflow-x: hidden;
            position: relative;
        }

        @keyframes gradientFlow {
            0% {
                background-position: 0% 50%;
            }
            50% {
                background-position: 100% 50%;
            }
            100% {
                background-position: 0% 50%;
            }
        }

        .float-icon {
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

        @keyframes floatUp {
            0% {
                transform: translate(0, 110vh) rotate(0deg);
            }
            50% {
                transform: translate(var(--sway, 40px), 45vh) rotate(180deg);
            }
            100% {
                transform: translate(0, -25vh) rotate(360deg);
            }
        }

        td:first-child::before {
            content: "";
            display: inline-block;
            width: 46px;
            height: 46px;
            margin-right: 14px;
            vertical-align: middle;
            background: no-repeat center / contain;
            border-radius: 50%;
            box-shadow: 0 2px 8px rgba(120, 90, 160, 0.25);
            transition: transform .35s ease;
        }

        tr:hover td:first-child::before {
            transform: scale(1.12) rotate(6deg);
        }

        #Mygo td:first-child::before {
            background-image: url('${pageContext.request.contextPath}/Mainimgs/MyGO!!!!!_ON_icon.png');
        }

        #AveMujica td:first-child::before {
            background-image: url('${pageContext.request.contextPath}/Mainimgs/AveMujica.png');
        }

        #MewType td:first-child::before {
            background-image: url('${pageContext.request.contextPath}/Mainimgs/Mugendai_MewType_ON_icon.webp');
        }

        #millsage td:first-child::before {
            background-image: url('${pageContext.request.contextPath}/Mainimgs/Millsage_ON_icon.webp');
        }

        #一家DumbRock td:first-child::before {
            background-image: url('${pageContext.request.contextPath}/Mainimgs/Ikka_Dumb_Rock!_ON_icon.png');
        }

        h1 {
            text-align: center;
            font-size: 50px;
            padding: 60px 0 40px;
            color: #eceaf4;
            letter-spacing: 4px;
            text-shadow: 0 2px 12px rgba(0, 0, 0, 0.25);
            position: relative;
            z-index: 1;
        }

        table {
            margin: 0 auto 80px;
            border-collapse: separate;
            border-spacing: 0 14px;
            position: relative;
            z-index: 1;
            background: rgba(255, 255, 255, 0.06);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-radius: 18px;
            padding: 10px 20px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.20);
        }

        td {
            padding: 18px 34px;
            color: #e6e4ee;
            font-size: 18px;
            transition: all .35s ease;
        }

        tr {
            transition: transform .35s ease;
            cursor: pointer;
        }

        tr:hover {
            transform: translateX(10px) scale(1.02);
        }

        td:first-child {
            border-radius: 12px 0 0 12px;
        }

        td:last-child {
            border-radius: 0 12px 12px 0;
        }

        a {
            color: #f0eef7;
            text-decoration: none;
            font-weight: 600;
            transition: all .3s ease;
        }

        a:hover {
            opacity: .85;
            letter-spacing: 1px;
        }

        #Mygo td {
            border: 2px solid #6ba3c7;
            background: rgba(107, 163, 199, 0.12);
        }

        #AveMujica td {
            border: 2px solid #b56b6b;
            background: rgba(181, 107, 107, 0.12);
        }

        #MewType td {
            border: 2px solid #d9c86b;
            background: rgba(217, 200, 107, 0.12);
        }

        #millsage td {
            border: 2px solid #b8b8c4;
            background: rgba(184, 184, 196, 0.10);
        }

        #一家DumbRock td {
            border: 2px solid #d99a5b;
            background: rgba(217, 154, 91, 0.12);
        }

        .go-collection {
            display: flex;
            justify-content: center;
            gap: 16px;
            flex-wrap: wrap;
            margin: 6px 0 70px;
            position: relative;
            z-index: 1;
        }

        .go-collection a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 26px;
            border-radius: 999px;
            text-decoration: none;
            color: #fff;
            font-weight: 600;
            font-size: 16px;
            letter-spacing: 1px;
            background: linear-gradient(135deg, #c2456a, #8f7bd0);
            box-shadow: 0 8px 24px rgba(0, 0, 0, .28);
            transition: transform .3s ease, box-shadow .3s ease, filter .2s;
        }

        .go-collection a:hover {
            transform: translateY(-3px) scale(1.03);
            box-shadow: 0 14px 32px rgba(0, 0, 0, .36);
            filter: brightness(1.06);
        }

        .go-collection a:active {
            transform: scale(.97);
        }

        /* 面板通用（在线 + 聊天） */
        .online-panel, .chat-panel {
            position: fixed;
            z-index: 6;
            max-width: 90vw;
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-radius: 14px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.22);
            color: #eceaf4;
            font-size: 14px;
            overflow: hidden;
        }

        .online-panel { top: 18px; right: 18px; width: 200px; }
        .online-body { height: 220px; }

        .chat-panel { left: 18px; bottom: 18px; width: 340px; }
        .chat-msgs { height: 260px; }
        .sticker-panel { max-height: 240px; }

        .online-head, .chat-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 12px 14px;
            cursor: pointer;
            user-select: none;
            font-weight: 600;
            letter-spacing: 1px;
            background: rgba(255, 255, 255, 0.06);
        }

        .online-head .toggle, .chat-head .toggle {
            font-size: 13px;
            opacity: .8;
        }

        .online-body, .chat-msgs {
            height: 220px;
            overflow: auto;
            padding: 10px 14px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .online-body .empty, .chat-msgs .empty {
            color: #b7b4c6;
            text-align: center;
            margin-top: 90px;
        }

        .online-body .name {
            display: flex;
            align-items: center;
        }

        .online-body .name.me {
            color: #fff;
            font-weight: 600;
        }

        .online-body .name .dot {
            width: 12px;
            height: 12px;
            margin-right: 8px;
            background: #8fc0e0;
            border-radius: 50%;
            animation: blink 1.5s infinite;
        }

        @keyframes blink {
            0%, 100% { opacity: 1; }
            50% { opacity: .5; }
        }

        .online-panel.collapsed .online-body, .chat-panel.collapsed .chat-body {
            display: none;
        }

        /* 名字/密码输入 */
        .name-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.75);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10;
        }

        .name-card {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-radius: 14px;
            padding: 24px 32px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.22);
            color: #eceaf4;
            font-size: 14px;
            width: 340px;
            max-width: 90vw;
        }

        .name-card h2 {
            font-size: 24px;
            margin-bottom: 12px;
        }

        .name-card p {
            margin-bottom: 12px;
        }

        .name-card input {
            width: 100%;
            padding: 10px 12px;
            font-size: 14px;
            border: 2px solid rgba(255, 255, 255, 0.15);
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.08);
            color: #fff;
            outline: none;
            margin-bottom: 10px;
        }

        .name-card input:focus {
            border-color: #6ba3c7;
        }

        .name-card .hint {
            font-size: 12px;
            color: #b7b4c6;
            margin: 0 0 4px;
        }

        .name-card button {
            width: 100%;
            padding: 10px 12px;
            font-size: 14px;
            font-weight: 600;
            color: #fff;
            cursor: pointer;
            border: none;
            border-radius: 10px;
            background: linear-gradient(135deg, #6ba3c7, #8f7bd0);
        }

        .name-card button:hover {
            filter: brightness(1.08);
        }

        .name-card button:active {
            transform: scale(.97);
        }

        /* 聊天 */
        .chat-msg {
            line-height: 1.4;
            word-break: break-word;
        }

        .chat-msg .meta {
            font-size: 12px;
            opacity: .7;
            margin-right: 6px;
        }

        .chat-msg .who {
            font-weight: 600;
            color: #8fc0e0;
            margin-right: 4px;
        }

        .chat-msg.me .who {
            color: #f0c674;
        }

        .chat-input {
            display: flex;
            gap: 8px;
            padding: 10px 12px;
            border-top: 1px solid rgba(255, 255, 255, 0.12);
        }

        .chat-input input {
            flex: 1;
            padding: 9px 12px;
            font-size: 14px;
            border: 2px solid rgba(255, 255, 255, 0.15);
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.08);
            color: #fff;
            outline: none;
        }

        .chat-input input:focus {
            border-color: #6ba3c7;
        }

        .chat-input button {
            padding: 0 16px;
            font-size: 14px;
            font-weight: 600;
            color: #fff;
            cursor: pointer;
            border: none;
            border-radius: 10px;
            background: linear-gradient(135deg, #6ba3c7, #8f7bd0);
        }

        /* 聊天表情气泡：统一尺寸，方框内 contain 显示 */
        .chat-msg .stk { display: inline-block; vertical-align: middle; margin: 2px 0; }
        .chat-msg .stk img {
            width: 90px; height: 90px; object-fit: contain;
            border-radius: 8px; background: rgba(0, 0, 0, .18);
        }

        /* 表情选择面板：紧凑网格，固定高度，内部滚动 */
        .sticker-panel {
            display: none;
            height: 190px;
            flex-direction: column;
            border-top: 1px solid rgba(255, 255, 255, .12);
        }
        .sp-tabs { flex: 0 0 auto; display: flex; gap: 6px; padding: 8px 10px 4px; flex-wrap: wrap; }
        .sp-tab { padding: 3px 10px; font-size: 12px; border-radius: 999px; cursor: pointer; color: #cfcbe0; background: rgba(255, 255, 255, .08); border: 1px solid rgba(255, 255, 255, .10); }
        .sp-tab.on { color: #fff; background: linear-gradient(135deg, #6ba3c7, #8f7bd0); border-color: transparent; }
        .sp-grid { flex: 1 1 auto; min-height: 0; display: grid; grid-template-columns: repeat(auto-fill, minmax(52px, 1fr)); gap: 6px; padding: 6px 10px 10px; overflow: auto; align-content: start; }
        .sp-grid img { width: 100%; height: 52px; object-fit: contain; border-radius: 6px; cursor: pointer; background: rgba(0, 0, 0, .18); transition: transform .15s; }
        .sp-grid img:hover { transform: scale(1.1); }
        .sp-empty { grid-column: 1 / -1; text-align: center; color: #b7b4c6; font-size: 13px; padding: 12px 0; }
        #stickerToggle { padding: 0 10px; font-size: 18px; background: rgba(255, 255, 255, .12); }
        #stickerToggle:hover { background: rgba(255, 255, 255, .22); }

        /* 聊天区加高，给表情面板留出空间 */
        .chat-msgs { height: 260px; }

        /* ===== 手机端适配 ===== */
        @media (max-width: 640px) {
            h1 { font-size: 30px; padding: 34px 0 22px; letter-spacing: 2px; }
            table { padding: 4px 10px; margin-bottom: 46px; }
            td { padding: 14px; font-size: 15px; }
            td:first-child::before { width: 34px; height: 34px; margin-right: 10px; }
            .go-collection { margin-bottom: 40px; }
            .go-collection a { padding: 10px 20px; font-size: 15px; }

            .online-panel { top: 12px; right: 12px; width: 44vw; max-width: 190px; }
            .online-body { height: 150px; }

            .chat-panel { left: 10px; right: 10px; bottom: 10px; width: auto; }
            .chat-msgs { height: 240px; max-height: 34vh; }
            .sticker-panel { max-height: 32vh; }

            /* 输入框 16px 防止 iOS 聚焦时自动放大页面 */
            .chat-input input, .name-card input { font-size: 16px; }

            .name-card { padding: 20px 18px; }
            .admin-card { max-height: 86vh; }
            .admin-btn, .logout-btn { padding: 8px 12px; font-size: 13px; }
        }

        /* 管理员 */
        .admin-btn {
            position: fixed;
            top: 18px;
            left: 18px;
            z-index: 7;
            display: none;
            align-items: center;
            gap: 6px;
            padding: 9px 15px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            color: #fff;
            background: linear-gradient(135deg, #c2456a, #8f7bd0);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
        }

        .logout-btn {
            position: fixed;
            bottom: 18px;
            right: 18px;
            z-index: 7;
            display: none;
            align-items: center;
            gap: 6px;
            padding: 9px 15px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            color: #eceaf4;
            background: rgba(255, 255, 255, 0.14);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
        }

        .logout-btn:hover {
            background: rgba(255, 255, 255, 0.24);
        }

        .login-btn {
            position: fixed;
            bottom: 18px;
            right: 18px;
            z-index: 7;
            display: none;
            align-items: center;
            gap: 6px;
            padding: 9px 15px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            color: #fff;
            background: linear-gradient(135deg, #6ba3c7, #8f7bd0);
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.3);
        }

        .login-btn:hover {
            filter: brightness(1.08);
        }

        .admin-login-overlay {
            position: fixed;
            inset: 0;
            z-index: 16;
            display: none;
            align-items: center;
            justify-content: center;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
        }

        .admin-login-overlay.show {
            display: flex;
        }

        .name-card .ghost {
            margin-top: 8px;
            background: rgba(255, 255, 255, 0.14);
        }

        .admin-overlay {
            position: fixed;
            inset: 0;
            z-index: 15;
            display: none;
            align-items: center;
            justify-content: center;
            background: rgba(0, 0, 0, 0.7);
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
        }

        .admin-card {
            width: 600px;
            max-width: 94vw;
            max-height: 82vh;
            display: flex;
            flex-direction: column;
            background: rgba(40, 38, 54, 0.96);
            border-radius: 16px;
            box-shadow: 0 16px 48px rgba(0, 0, 0, 0.5);
            color: #eceaf4;
            overflow: hidden;
        }

        .admin-card .ac-head {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px 20px;
            background: rgba(255, 255, 255, 0.06);
            font-weight: 600;
            letter-spacing: 1px;
        }

        .admin-card .ac-actions {
            display: flex;
            gap: 10px;
        }

        .admin-card .ac-actions button {
            padding: 6px 12px;
            font-size: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            color: #fff;
            background: rgba(255, 255, 255, 0.14);
        }

        .ap-cols {
            display: flex;
            gap: 12px;
            padding: 10px 16px 4px;
            font-size: 12px;
            color: #b7b4c6;
        }

        .ap-list {
            padding: 6px 16px 16px;
            overflow: auto;
        }

        .ap-row {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 10px 12px;
            border-radius: 10px;
            background: rgba(255, 255, 255, 0.05);
            margin-bottom: 8px;
            font-size: 14px;
        }

        .ap-name {
            font-weight: 600;
            min-width: 96px;
        }

        .ap-page {
            flex: 1;
            color: #8fc0e0;
        }

        .ap-time {
            color: #b7b4c6;
            font-size: 12px;
            min-width: 52px;
            text-align: right;
        }

        .ap-mute {
            padding: 6px 12px;
            font-size: 12px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            color: #fff;
            background: #c2456a;
        }

        .ap-mute.on {
            background: #5a8f5a;
        }

        .ap-empty {
            text-align: center;
            color: #b7b4c6;
            padding: 30px 0;
        }

        @media (prefers-reduced-motion: reduce) {
            body {
                animation: none;
            }

            .float-icon {
                display: none;
            }

            .online-body .name .dot {
                animation: none;
            }
        }
    </style>
    <title>角色介绍</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/Titleico/Bangdream.png">
</head>
<body>
<div class="name-overlay" id="nameOverlay">
    <div class="name-card">
        <h2>欢迎来到邦邦世界</h2>
        <p>输入名字，即可作为访客进入</p>
        <input id="nameInput" type="text" maxlength="16" placeholder="你的名字…" autocomplete="off">
        <button id="nameJoin">进入</button>
        <p class="hint" style="text-align:center;margin-top:12px">管理员？进入后点右下角「🔑 登录」</p>
    </div>
</div>

<div class="online-panel" id="onlinePanel">
    <div class="online-head" id="onlineHead">
        <span>🟢 在线 <span id="onlineCount">0</span> 人</span>
        <span class="toggle">收起</span>
    </div>
    <div class="online-body" id="onlineBody">
        <div class="empty">加载中…</div>
    </div>
</div>

<div class="chat-panel" id="chatPanel">
    <div class="chat-head" id="chatHead">
        <span>💬 聊天室</span>
        <span class="toggle">收起</span>
    </div>
    <div class="chat-body">
        <div class="chat-msgs" id="chatMsgs">
            <div class="empty">还没有消息…（10 分钟后自动消失）</div>
        </div>
        <div class="sticker-panel" id="stickerPanel" style="display:none">
            <div class="sp-tabs" id="spTabs"></div>
            <div class="sp-grid" id="spGrid"><div class="sp-empty">加载中…</div></div>
        </div>
        <div class="chat-input">
            <button id="stickerToggle" type="button" title="发表情">😊</button>
            <input id="chatInput" type="text" maxlength="200" placeholder="说点什么…" autocomplete="off">
            <button id="chatSend">发送</button>
        </div>

    </div>
</div>

<button class="admin-btn" id="adminBtn">🛡 管理员后台</button>
<button class="logout-btn" id="logoutBtn">🚪 注销</button>
<button class="login-btn" id="loginBtn">🔑 登录</button>
<div class="admin-login-overlay" id="adminLoginOverlay">
    <div class="name-card">
        <h2>管理员登录</h2>
        <p class="hint">管理员 ID</p>
        <input id="adminIdInput" type="text" maxlength="32" placeholder="输入管理员ID" autocomplete="off">
        <p class="hint">密码</p>
        <input id="pwInput" type="password" maxlength="32" placeholder="输入密码" autocomplete="off">
        <button id="adminLoginBtn">登录</button>
        <button id="adminLoginCancel" class="ghost">取消</button>
    </div>
</div>

<div class="admin-overlay" id="adminOverlay">
    <div class="admin-card">
        <div class="ac-head">
            <span>🛡 管理员后台 · 在线管理</span>
            <div class="ac-actions">
                <button id="adminLogout">🚪 注销</button>
                <button id="adminClose">✕ 关闭</button>
            </div>
        </div>
        <div class="ap-cols">
            <span>用户</span><span style="flex:1">所在页面</span><span style="min-width:52px;text-align:right">活跃</span><span style="min-width:64px"></span>
        </div>
        <div class="ap-list" id="adminList"></div>
    </div>
</div>

<h1><%= "选择你的乐队" %>

</h1>
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

<div class="go-collection">
    <a href="${pageContext.request.contextPath}/表情包目录/收藏表情包.jsp">🎨 去表情包收藏</a>
    <a href="${pageContext.request.contextPath}/游戏/斗地主.jsp">🎮 去斗地主</a>
</div>

<style>
    .cl-wrap { max-width: 720px; margin: 26px auto 40px; padding: 18px 22px; border-radius: 16px;
        background: rgba(255,255,255,.06); border: 1px solid rgba(255,255,255,.12);
        box-shadow: 0 8px 30px rgba(0,0,0,.25); color: #e8e6f0; }
    .cl-head { display: flex; align-items: center; justify-content: space-between; margin-bottom: 10px; }
    .cl-title { font-size: 20px; font-weight: 700; letter-spacing: .5px; }
    .cl-edit-btn { border: none; border-radius: 8px; padding: 6px 14px; cursor: pointer; color: #fff;
        background: rgba(143,123,208,.85); font-size: 13px; align-items: center; }
    .cl-edit-btn:hover { background: rgba(143,123,208,1); }
    .cl-body { line-height: 1.7; font-size: 15px; }
    .cl-h { margin: 14px 0 6px; color: #cbb8ff; }
    h2.cl-h { font-size: 20px; } h3.cl-h { font-size: 17px; } h4.cl-h { font-size: 15px; }
    .cl-p { margin: 6px 0; }
    .cl-ul { margin: 6px 0 6px 22px; padding: 0; }
    .cl-ul li { margin: 3px 0; }
    .cl-body code { background: rgba(0,0,0,.28); padding: 1px 6px; border-radius: 5px; font-size: 13px; }
    .cl-empty, .cl-loading { color: #b7b4c6; padding: 10px 0; }
    .cl-textarea { width: 100%; box-sizing: border-box; min-height: 260px; resize: vertical;
        border-radius: 10px; border: 1px solid rgba(255,255,255,.18); padding: 12px 14px;
        background: rgba(0,0,0,.25); color: #e8e6f0; font: 14px/1.6 Consolas, Monaco, monospace; }
    .cl-editor-actions { display: flex; align-items: center; gap: 10px; margin-top: 10px; }
    .cl-hint { flex: 1; font-size: 12px; color: #b7b4c6; }
    .cl-save, .cl-cancel { border: none; border-radius: 8px; padding: 7px 16px; cursor: pointer; color: #fff; font-size: 13px; }
    .cl-save { background: #5a8f5a; } .cl-save:hover { background: #6aa86a; }
    .cl-cancel { background: rgba(255,255,255,.14); }
</style>
<div class="cl-wrap">
    <div class="cl-head">
        <span class="cl-title">📰 更新日志</span>
        <button class="cl-edit-btn" id="clEditBtn" type="button" style="display:none">✏️ 编辑</button>
    </div>
    <div class="cl-body" id="clBody"><div class="cl-loading">加载中…</div></div>
    <div class="cl-editor" id="clEditor" style="display:none">
        <textarea id="clText" class="cl-textarea" placeholder="# 2026-10-04&#10;- 新增杂项表情包分类&#10;- 修复上传后误报失败"></textarea>
        <div class="cl-editor-actions">
            <span class="cl-hint">语法：# 大标题、## 小标题、### 小标题、- 列表项、**加粗**、`代码`，空行分段</span>
            <button class="cl-save" id="clSave" type="button">💾 保存</button>
            <button class="cl-cancel" id="clCancel" type="button">取消</button>
        </div>
    </div>
</div>
<script>
    (function () {
        var ctx = '${pageContext.request.contextPath}';
        var body = document.getElementById('clBody');
        var editBtn = document.getElementById('clEditBtn');
        var editor = document.getElementById('clEditor');
        var textarea = document.getElementById('clText');
        var saveBtn = document.getElementById('clSave');
        var cancelBtn = document.getElementById('clCancel');
        var raw = '';

        function escHtml(s) { return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;'); }
        function inline(s) {
            s = escHtml(s);
            s = s.replace(/\*\*([^*]+)\*\*/g, '<strong>$1</strong>');
            s = s.replace(/`([^`]+)`/g, '<code>$1</code>');
            return s;
        }
        function render(text) {
            var lines = (text || '').replace(/\r\n/g, '\n').split('\n');
            var html = '', inList = false, m;
            function closeList() { if (inList) { html += '</ul>'; inList = false; } }
            for (var i = 0; i < lines.length; i++) {
                var t = lines[i].trim();
                if (!t) { closeList(); continue; }
                if ((m = /^###\s+(.*)$/.exec(t))) { closeList(); html += '<h4 class="cl-h">' + inline(m[1]) + '</h4>'; }
                else if ((m = /^##\s+(.*)$/.exec(t))) { closeList(); html += '<h3 class="cl-h">' + inline(m[1]) + '</h3>'; }
                else if ((m = /^#\s+(.*)$/.exec(t))) { closeList(); html += '<h2 class="cl-h">' + inline(m[1]) + '</h2>'; }
                else if ((m = /^[-*]\s+(.*)$/.exec(t))) { if (!inList) { html += '<ul class="cl-ul">'; inList = true; } html += '<li>' + inline(m[1]) + '</li>'; }
                else { closeList(); html += '<p class="cl-p">' + inline(t) + '</p>'; }
            }
            closeList();
            body.innerHTML = html || '<div class="cl-empty">暂无更新内容</div>';
        }
        function load() {
            fetch(ctx + '/changelog').then(function (r) { return r.json(); }).then(function (j) {
                raw = j.text || '';
                render(raw);
                editBtn.style.display = j.canEdit ? 'inline-flex' : 'none';
            }).catch(function () { body.innerHTML = '<div class="cl-empty">加载失败</div>'; });
        }
        editBtn.addEventListener('click', function () {
            textarea.value = raw;
            editor.style.display = 'block';
            body.style.display = 'none';
            editBtn.style.display = 'none';
            textarea.focus();
        });
        cancelBtn.addEventListener('click', function () {
            editor.style.display = 'none';
            body.style.display = '';
            editBtn.style.display = 'inline-flex';
        });
        saveBtn.addEventListener('click', function () {
            var b = new URLSearchParams();
            b.set('text', textarea.value);
            saveBtn.disabled = true; saveBtn.textContent = '保存中…';
            fetch(ctx + '/changelog', { method: 'POST', body: b }).then(function (r) {
                return r.json().catch(function () { return {}; });
            }).then(function (j) {
                saveBtn.disabled = false; saveBtn.textContent = '💾 保存';
                if (j && j.ok) {
                    raw = textarea.value; render(raw);
                    editor.style.display = 'none'; body.style.display = ''; editBtn.style.display = 'inline-flex';
                } else { alert('保存失败，请确认是否管理员登录'); }
            }).catch(function () { saveBtn.disabled = false; saveBtn.textContent = '💾 保存'; alert('保存请求失败'); });
        });
        // 管理员在本页登录后（无需刷新）也即时显示编辑按钮
        window.addEventListener('bd:auth', function (e) {
            if (editor.style.display !== 'none') return;
            editBtn.style.display = (e && e.detail) ? 'inline-flex' : 'none';
        });
        load();
    })();
</script>

<script>
    (function () {
        var base = '${pageContext.request.contextPath}';
        var icons = [
            base + '/Mainimgs/MyGO!!!!!_ON_icon.png', base + '/Mainimgs/AveMujica.png',
            base + '/Mainimgs/Mugendai_MewType_ON_icon.webp', base + '/Mainimgs/Millsage_ON_icon.webp',
            base + '/Mainimgs/Ikka_Dumb_Rock!_ON_icon.png'
        ];
        for (var i = 0; i < 14; i++) {
            var el = document.createElement('img');
            el.src = icons[Math.floor(Math.random() * icons.length)];
            el.className = 'float-icon';
            el.alt = '';
            var size = 28 + Math.random() * 46;
            el.style.width = size + 'px';
            el.style.height = size + 'px';
            el.style.left = (Math.random() * 100) + 'vw';
            el.style.opacity = (0.10 + Math.random() * 0.15).toFixed(2);
            var dur = 18 + Math.random() * 20;
            el.style.animationDuration = dur + 's';
            el.style.animationDelay = (-Math.random() * dur) + 's';
            el.style.setProperty('--sway', (Math.random() * 160 - 80) + 'px');
            document.body.appendChild(el);
        }
        document.querySelectorAll('table tr').forEach(function (row) {
            row.addEventListener('click', function (e) {
                if (e.target.closest('a')) return;
                var link = row.querySelector('a');
                if (link) window.location.href = link.href;
            });
        });
    })();
</script>

<script>
    (function () {
        var ctx = '${pageContext.request.contextPath}';
        var overlay = document.getElementById('nameOverlay');
        var nameInput = document.getElementById('nameInput');
        var joinBtn = document.getElementById('nameJoin');
        var panel = document.getElementById('onlinePanel');
        var head = document.getElementById('onlineHead');
        var body = document.getElementById('onlineBody');
        var countEl = document.getElementById('onlineCount');
        var toggle = head.querySelector('.toggle');
        var adminBtn = document.getElementById('adminBtn');
        var logoutBtn = document.getElementById('logoutBtn');
        var loginBtn = document.getElementById('loginBtn');
        var adOverlay = document.getElementById('adminLoginOverlay');
        var adminIdInput = document.getElementById('adminIdInput');
        var pwInput = document.getElementById('pwInput');
        var adLoginBtn = document.getElementById('adminLoginBtn');
        var adCancelBtn = document.getElementById('adminLoginCancel');
        var myName = sessionStorage.getItem('visitorName') || '';
        var timer = null;

        head.addEventListener('click', function () {
            panel.classList.toggle('collapsed');
            toggle.textContent = panel.classList.contains('collapsed') ? '展开' : '收起';
        });

        function render(list) {
            body.innerHTML = '';
            if (!list.length) {
                var e = document.createElement('div');
                e.className = 'empty';
                e.textContent = '暂时只有你…';
                body.appendChild(e);
                countEl.textContent = '0';
                return;
            }
            list.forEach(function (n) {
                var row = document.createElement('div');
                row.className = 'name' + (n === myName ? ' me' : '');
                var dot = document.createElement('span');
                dot.className = 'dot';
                var nm = document.createElement('span');
                nm.textContent = n + (n === myName ? '（你）' : '');
                row.appendChild(dot);
                row.appendChild(nm);
                body.appendChild(row);
            });
            countEl.textContent = list.length;
        }

        function beat() {
            fetch(ctx + '/online?name=' + encodeURIComponent(myName) + '&page=' + encodeURIComponent('选择乐队主页'))
                .then(function (r) {
                    return r.json();
                }).then(render).catch(function () {
            });
        }

        // 根据是否管理员，切换右下角按钮与后台入口
        function applyAuth(isAdmin) {
            if (isAdmin) {
                adminBtn.style.display = 'inline-flex';
                logoutBtn.style.display = 'inline-flex';
                loginBtn.style.display = 'none';
            } else {
                adminBtn.style.display = 'none';
                logoutBtn.style.display = 'none';
                loginBtn.style.display = 'inline-flex';
            }
            try { window.dispatchEvent(new CustomEvent('bd:auth', { detail: !!isAdmin })); } catch (e) { }
        }

        function refreshAuth() {
            fetch(ctx + '/admin/check').then(function (r) {
                return r.json();
            }).then(function (j) {
                applyAuth(j && j.isAdmin);
            }).catch(function () {
                applyAuth(false);
            });
        }

        // 访客进入：只需名字
        function doEnter(name) {
            myName = name;
            sessionStorage.setItem('visitorName', name);
            overlay.style.display = 'none';
            beat();
            if (timer) clearInterval(timer);
            timer = setInterval(beat, 10000);
            refreshAuth();
        }

        // 管理员登录弹层
        function openAdminLogin() {
            adminIdInput.value = '';
            pwInput.value = '';
            adOverlay.classList.add('show');
            setTimeout(function () {
                adminIdInput.focus();
            }, 50);
        }

        function closeAdminLogin() {
            adOverlay.classList.remove('show');
        }

        function doAdminLogin() {
            var id = (adminIdInput.value || '').trim();
            var pw = (pwInput.value || '').trim();
            if (!id || !pw) {
                alert('请输入管理员ID和密码');
                return;
            }
            adLoginBtn.disabled = true;
            var old = adLoginBtn.textContent;
            adLoginBtn.textContent = '验证中…';
            var b = new URLSearchParams();
            b.set('adminId', id);
            b.set('password', pw);
            fetch(ctx + '/admin/login', {method: 'POST', body: b}).then(function (r) {
                adLoginBtn.disabled = false;
                adLoginBtn.textContent = old;
                if (r.ok) {
                    closeAdminLogin();
                    applyAuth(true);
                } else {
                    alert('管理员ID或密码错误');
                }
            }).catch(function () {
                adLoginBtn.disabled = false;
                adLoginBtn.textContent = old;
            });
        }

        // 注销：退回访客（保留在线名字）
        function doLogout() {
            try {
                fetch(ctx + '/admin/logout', {method: 'POST'});
            } catch (e) {
            }
            applyAuth(false);
        }

        joinBtn.addEventListener('click', function () {
            var v = (nameInput.value || '').trim();
            if (!v) {
                nameInput.focus();
                return;
            }
            doEnter(v);
        });
        nameInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') joinBtn.click();
        });

        loginBtn.addEventListener('click', openAdminLogin);
        adLoginBtn.addEventListener('click', doAdminLogin);
        adCancelBtn.addEventListener('click', closeAdminLogin);
        adminIdInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') pwInput.focus();
        });
        pwInput.addEventListener('keydown', function (e) {
            if (e.key === 'Enter') doAdminLogin();
        });
        logoutBtn.addEventListener('click', doLogout);

        window.addEventListener('pagehide', function () {
            if (myName && navigator.sendBeacon) {
                try {
                    navigator.sendBeacon(ctx + '/online?leave=' + encodeURIComponent(myName));
                } catch (e) {
                }
            }
        });
        window.addEventListener('pageshow', function (e) {
            if (e.persisted && myName) {
                beat();
                if (!timer) timer = setInterval(beat, 10000);
            }
        });

        if (myName) doEnter(myName);
        else {
            overlay.style.display = 'flex';
            setTimeout(function () {
                nameInput.focus();
            }, 50);
        }
    })();

</script>

<script>
    (function () {
        var ctx = '${pageContext.request.contextPath}';
        var btn = document.getElementById('adminBtn');
        var overlay = document.getElementById('adminOverlay');
        var list = document.getElementById('adminList');
        var closeBtn = document.getElementById('adminClose');
        var logoutBtn = document.getElementById('adminLogout');
        var timer = null;

        function load() {
            fetch(ctx + '/admin/status').then(function (r) {
                if (r.status === 403) {
                    btn.style.display = 'none';
                    close();
                    return null;
                }
                return r.json();
            }).then(function (data) {
                if (data) render(data);
            }).catch(function () {
            });
        }

        function render(data) {
            var now = Date.now();
            list.innerHTML = '';
            if (!data.length) {
                list.innerHTML = '<div class="ap-empty">当前无人在线</div>';
                return;
            }
            data.forEach(function (v) {
                var row = document.createElement('div');
                row.className = 'ap-row';
                var nm = document.createElement('span');
                nm.className = 'ap-name';
                nm.textContent = v.name;
                var pg = document.createElement('span');
                pg.className = 'ap-page';
                pg.textContent = v.page;
                var tm = document.createElement('span');
                tm.className = 'ap-time';
                tm.textContent = Math.round((now - v.lastSeen) / 1000) + 's前';
                var mb = document.createElement('button');
                mb.className = 'ap-mute' + (v.muted ? ' on' : '');
                mb.textContent = v.muted ? '取消禁言' : '禁言';
                mb.onclick = function () {
                    mute(v.name, !v.muted);
                };
                row.appendChild(nm);
                row.appendChild(pg);
                row.appendChild(tm);
                row.appendChild(mb);
                list.appendChild(row);
            });
        }

        function mute(name, on) {
            var b = new URLSearchParams();
            b.set('name', name);
            fetch(ctx + '/admin/' + (on ? 'mute' : 'unmute'), {method: 'POST', body: b}).then(load).catch(function () {
            });
        }

        function open() {
            overlay.style.display = 'flex';
            load();
            if (!timer) timer = setInterval(load, 4000);
        }

        function close() {
            overlay.style.display = 'none';
            if (timer) {
                clearInterval(timer);
                timer = null;
            }
        }

        btn.addEventListener('click', open);
        closeBtn.addEventListener('click', close);
        logoutBtn.addEventListener('click', function () {
            fetch(ctx + '/admin/logout', {method: 'POST'}).then(function () {
                btn.style.display = 'none';
                var lo = document.getElementById('logoutBtn'); if (lo) lo.style.display = 'none';
                var lg = document.getElementById('loginBtn'); if (lg) lg.style.display = 'inline-flex';
                close();
            });
        });
        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) close();
        });
    })();
</script>

<script>
    (function () {
        var ctx = '${pageContext.request.contextPath}';
        var msgs = document.getElementById('chatMsgs');
        var input = document.getElementById('chatInput');
        var sendBtn = document.getElementById('chatSend');
        var head = document.getElementById('chatHead');
        var panel = document.getElementById('chatPanel');
        var toggle = head.querySelector('.toggle');
        var stToggle = document.getElementById('stickerToggle');
        var stPanel = document.getElementById('stickerPanel');
        var stTabs = document.getElementById('spTabs');
        var stGrid = document.getElementById('spGrid');
        var stLoaded = false, stCats = null;

        head.addEventListener('click', function () {
            panel.classList.toggle('collapsed');
            toggle.textContent = panel.classList.contains('collapsed') ? '展开' : '收起';
        });

        function fmt(tms) {
            var d = new Date(tms);
            var p = function (x) { return (x < 10 ? '0' : '') + x; };
            return p(d.getHours()) + ':' + p(d.getMinutes());
        }

        function render(list) {
            var myName = sessionStorage.getItem('visitorName') || '';
            var atBottom = msgs.scrollHeight - msgs.scrollTop - msgs.clientHeight < 30;
            msgs.innerHTML = '';
            if (!list.length) {
                var e = document.createElement('div');
                e.className = 'empty';
                e.textContent = '还没有消息…（10 分钟后自动消失）';
                msgs.appendChild(e);
                return;
            }
            list.forEach(function (m) {
                var line = document.createElement('div');
                line.className = 'chat-msg' + (m.n === myName ? ' me' : '');
                var meta = document.createElement('span');
                meta.className = 'meta';
                meta.textContent = fmt(m.tms);
                var who = document.createElement('span');
                who.className = 'who';
                who.textContent = m.n + '：';
                line.appendChild(meta);
                line.appendChild(who);
                if (m.sc) {
                    var s = document.createElement('span');
                    s.className = 'stk';
                    var im = document.createElement('img');
                    im.src = ctx + '/QQimgs/' + encodeURIComponent(m.sc) + '/' + encodeURIComponent(m.sf);
                    im.alt = m.sf;
                    im.loading = 'lazy';
                    s.appendChild(im);
                    line.appendChild(s);
                } else {
                    var txt = document.createElement('span');
                    txt.textContent = m.t;
                    line.appendChild(txt);
                }
                msgs.appendChild(line);
            });
            if (atBottom) msgs.scrollTop = msgs.scrollHeight;
        }

        function pull() {
            fetch(ctx + '/chat').then(function (r) { return r.json(); }).then(render).catch(function () {});
        }

        function send() {
            var name = (sessionStorage.getItem('visitorName') || '').trim();
            var text = (input.value || '').trim();
            if (!name || !text) { input.focus(); return; }
            var body = new URLSearchParams();
            body.set('name', name);
            body.set('text', text);
            fetch(ctx + '/chat', {method: 'POST', body: body}).then(function (r) {
                if (r.status === 403) alert('你已被管理员禁言，无法发言');
                return r;
            }).then(pull).catch(function () {});
            input.value = '';
        }

        sendBtn.addEventListener('click', send);
        input.addEventListener('keydown', function (e) { if (e.key === 'Enter') send(); });

        function openStickers() {
            var hidden = (stPanel.style.display === 'none' || stPanel.style.display === '');
            stPanel.style.display = hidden ? 'flex' : 'none';
            if (hidden && !stLoaded) loadStickers();
        }

        function loadStickers() {
            stGrid.innerHTML = '<div class="sp-empty">加载中…</div>';
            fetch(ctx + '/chat?stickers=1').then(function (r) { return r.json(); }).then(function (data) {
                stCats = data; stLoaded = true;
                stTabs.innerHTML = '';
                var keys = Object.keys(data);
                if (!keys.length) { stGrid.innerHTML = '<div class="sp-empty">还没有表情包</div>'; return; }
                keys.forEach(function (cat) {
                    var t = document.createElement('span');
                    t.className = 'sp-tab';
                    t.textContent = cat;
                    t.addEventListener('click', function () { showCat(cat); });
                    stTabs.appendChild(t);
                });
                showCat(keys[0]);
            }).catch(function () { stGrid.innerHTML = '<div class="sp-empty">加载失败</div>'; });
        }

        function showCat(cat) {
            var tabs = stTabs.querySelectorAll('.sp-tab');
            for (var i = 0; i < tabs.length; i++) tabs[i].classList.toggle('on', tabs[i].textContent === cat);
            stGrid.innerHTML = '';
            var files = (stCats && stCats[cat]) || [];
            if (!files.length) { stGrid.innerHTML = '<div class="sp-empty">该分类暂无表情</div>'; return; }
            files.forEach(function (item) {
                var f = item.n, animated = item.a;
                var src = ctx + '/QQimgs/' + encodeURIComponent(cat) + '/' + encodeURIComponent(f);
                var el;
                if (animated) { el = document.createElement('canvas'); drawFirstFrame(el, src); }
                else { el = document.createElement('img'); el.src = src; el.loading = 'lazy'; }
                el.alt = f; el.title = f;
                el.addEventListener('click', function () { sendSticker(cat, f); });
                stGrid.appendChild(el);
            });
        }

        function drawFirstFrame(canvas, src) {
            var im = new Image();
            im.onload = function () {
                var w = 52, h = 52, dpr = window.devicePixelRatio || 1;
                canvas.width = Math.round(w * dpr); canvas.height = Math.round(h * dpr);
                var g = canvas.getContext('2d');
                g.clearRect(0, 0, canvas.width, canvas.height);
                var scale = Math.min(w / im.width, h / im.height);
                var dw = im.width * scale, dh = im.height * scale;
                var dx = (w - dw) / 2, dy = (h - dh) / 2;
                g.drawImage(im, dx * dpr, dy * dpr, dw * dpr, dh * dpr);
            };
            im.src = src;
        }

        function sendSticker(cat, file) {
            var name = (sessionStorage.getItem('visitorName') || '').trim();
            if (!name) { alert('请先输入名字进入'); return; }
            var body = new URLSearchParams();
            body.set('name', name);
            body.set('scat', cat);
            body.set('sfile', file);
            fetch(ctx + '/chat', {method: 'POST', body: body}).then(function (r) {
                if (r.status === 403) alert('你已被管理员禁言，无法发送表情');
                return r;
            }).then(pull).catch(function () {});
            stPanel.style.display = 'none';
        }

        stToggle.addEventListener('click', openStickers);

        pull();
        setInterval(pull, 4000);
    })();
</script>
<script src="${pageContext.request.contextPath}/js/music-player.js"></script>
</body>
</html>