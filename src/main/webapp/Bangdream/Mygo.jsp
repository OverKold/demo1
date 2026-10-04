<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2026/10/2
  Time: 0:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>It's Mygo!!!!!</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/Titleico/MyGO!!!!!_ON_icon.ico">
    <style>
        .Mygo p{
            font-size: 20px;
        }
        body{
            margin: 0;
            min-height: 100vh;
            padding: 40px 30px;
            font-family: "Segoe UI", "Microsoft YaHei", sans-serif;
            color: #3a3a4a;
            background: linear-gradient(135deg, #eaf6fb, #d6ecf5, #c9e4f0, #e3f3fa);
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
        a{ color: #1c7fb0; text-decoration: none; font-weight: 600; }
        a:hover{ opacity: 0.8; }

        .note{
            position: relative;
            z-index: 1;
            text-align: center;
            font-size: 12px;
            color: #8a97a2;
            letter-spacing: 1px;
            margin: 0 0 10px;
        }
        h1{
            text-align: center;
            font-size: 40px;
            letter-spacing: 2px;
            color: #2a3d4a;
            margin: 16px 0 24px;
            text-shadow: 0 2px 10px rgba(28, 127, 176, 0.12);
        }
        .motto{
            position: relative;
            z-index: 1;
            max-width: 640px;
            margin: 4px auto 44px;
            padding: 34px 40px 26px;
            text-align: center;
            font-style: italic;
            color: #4a5a66;
            background: rgba(255, 255, 255, 0.42);
            border-left: 4px solid #1c7fb0;
            border-right: 4px solid #1c7fb0;
            border-radius: 14px;
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
            box-shadow: 0 6px 20px rgba(28, 127, 176, 0.10);
        }
        .motto .jp{
            display: block;
            font-size: 22px;
            line-height: 1.7;
            color: #1c7fb0;
            font-weight: 600;
        }
        .motto .cn{
            display: block;
            margin-top: 10px;
            font-size: 16px;
            line-height: 1.7;
            color: #66727c;
        }
        /* 左上对称的开引号 */
        .motto::before{
            content: "\201C";
            position: absolute;
            left: 18px;
            top: -6px;
            font-family: Georgia, "Times New Roman", serif;
            font-size: 92px;
            line-height: 1;
            color: rgba(28, 127, 176, 0.16);
            pointer-events: none;
        }
        /* 右下对称的闭引号：用上引号旋转180°，与左上完全镜像 */
        .motto::after{
            content: "\201C";
            transform: rotate(180deg);
            position: absolute;
            right: 18px;
            bottom: -6px;
            font-family: Georgia, "Times New Roman", serif;
            font-size: 92px;
            line-height: 1;
            color: rgba(28, 127, 176, 0.16);
            pointer-events: none;
        }
        .motto .ch{
            transition: opacity 0.12s ease;
        }
        .back-link{
            position: relative;
            z-index: 1;
            display: block;
            width: max-content;
            margin: 40px auto 0;
            padding: 10px 26px;
            font-size: 15px;
            font-weight: 600;
            color: #1c7fb0;
            text-decoration: none;
            background: rgba(255, 255, 255, 0.6);
            border: 1px solid rgba(28, 127, 176, 0.35);
            border-radius: 999px;
            transition: all 0.3s ease;
        }
        .back-link:hover{
            background: #1c7fb0;
            color: #ffffff;
            opacity: 1;
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(28, 127, 176, 0.3);
        }
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
            --sway: 40px;
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

        .char-section{
            position: relative;
            z-index: 1;
            margin-top: 40px;
        }
        .char-section > h2{
            text-align: center;
            color: #1c7fb0;
            font-size: 32px;
            letter-spacing: 3px;
            margin-bottom: 28px;
        }
        .char-grid{
            display: flex;
            flex-wrap: wrap;
            gap: 22px;
            justify-content: center;
        }
        .char-card{
            width: 300px;
            padding: 20px 20px 24px;
            text-align: center;
            background: rgba(255, 255, 255, 0.55);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border: 1px solid rgba(28, 127, 176, 0.25);
            border-radius: 16px;
            box-shadow: 0 6px 20px rgba(28, 127, 176, 0.12);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .char-card:hover{
            transform: translateY(-8px);
            box-shadow: 0 12px 28px rgba(28, 127, 176, 0.22);
        }
        .char-avatar{
            width: 100%;
            height: 260px;
            margin: 0 auto 16px;
            border-radius: 14px;
            background: linear-gradient(135deg, #eaf6fb, #cdeaf6);
            color: #1c7fb0;
            font-size: 36px;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border: 1px solid rgba(28, 127, 176, 0.30);
        }
        .char-avatar img{
            width: 100%;
            height: 100%;
            object-fit: contain;
            object-position: center bottom;
        }
        .char-card .desc{
            margin: 0;
            font-size: 14px;
            line-height: 1.6;
            color: #55606a;
        }

        .char-name-row{
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-bottom: 4px;
        }
        .role-badge{
            font-size: 12px;
            font-weight: 600;
            color: #ffffff;
            background: var(--c, #1c7fb0);
            padding: 2px 10px;
            border-radius: 999px;
            white-space: nowrap;
        }
        .char-meta{
            margin: 2px 0 8px;
            font-size: 12.5px;
            color: #7a8792;
            text-align: center;
        }
        .char-color{
            margin: 0 0 12px;
            font-size: 12.5px;
            color: #66727c;
            text-align: center;
        }
        .color-dot{
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: var(--c, #1c7fb0);
            border: 1px solid rgba(0,0,0,0.12);
            vertical-align: middle;
            margin-right: 4px;
        }
        .char-info{
            text-align: left;
            font-size: 13px;
            line-height: 1.6;
            color: #55606a;
            border-top: 1px dashed rgba(28, 127, 176, 0.25);
            padding-top: 12px;
            margin-bottom: 12px;
        }
        .char-info .row{
            display: flex;
            gap: 8px;
            margin: 5px 0;
        }
        .char-info .label{
            flex: 0 0 34px;
            color: #1c7fb0;
            font-weight: 600;
        }
        .char-bio{
            margin: 0;
            font-size: 13px;
            line-height: 1.7;
            color: #4a5a66;
            text-align: left;
            background: rgba(28, 127, 176, 0.06);
            border-radius: 10px;
            padding: 10px 12px;
        }
        .char-source{
            position: relative;
            z-index: 1;
            text-align: center;
            font-size: 12px;
            color: #8a97a2;
            margin: 28px 0 0;
            letter-spacing: 0.5px;
        }
        .char-source a{ color: #1c7fb0; }

        .char-avatar img{ cursor: zoom-in; }
        /* 每张卡片里隐藏的完整资料，克隆进灯箱右侧展示 */
        .char-detail{ display: none; }
        .lightbox{
            position: fixed;
            inset: 0;
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
            background: rgba(20, 25, 35, 0.75);
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
            opacity: 0;
            visibility: hidden;
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }
        .lightbox.open{
            opacity: 1;
            visibility: visible;
        }
        .lb-inner{
            display: flex;
            align-items: stretch;
            gap: 32px;
            max-width: 94vw;
            max-height: 88vh;
            padding: 28px 32px;
            background: rgba(255, 255, 255, 0.94);
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.4);
            transform: scale(0.92);
            transition: transform 0.3s ease;
        }
        .lightbox.open .lb-inner{
            transform: scale(1);
        }
        .lb-figure{
            flex: 0 0 auto;
            display: flex;
            align-items: center;
            justify-content: center;
            max-width: 46vw;
        }
        .lb-figure img{
            max-width: 100%;
            max-height: 82vh;
            object-fit: contain;
            object-position: center bottom;
            border-radius: 14px;
            background: linear-gradient(135deg, #eaf6fb, #cdeaf6);
            border: 1px solid rgba(28, 127, 176, 0.25);
        }
        .lb-detail{
            flex: 1 1 auto;
            min-width: 260px;
            max-width: 400px;
            overflow-y: auto;
            max-height: 82vh;
            padding-right: 6px;
            text-align: left;
        }
        .lb-detail .char-name-row{ margin-bottom: 6px; }
        .lb-detail .char-name-row h3{ margin: 0; font-size: 24px; color: #2a3d4a; }
        .lb-detail .char-meta,
        .lb-detail .char-color{ text-align: left; margin: 3px 0; }
        .lb-detail .char-info{ margin: 14px 0; }
        .lb-detail .char-bio{ margin-bottom: 12px; }
        .lb-detail .char-origin{
            margin: 0;
            font-size: 12px;
            line-height: 1.6;
            color: #8a97a2;
            border-top: 1px dashed rgba(28, 127, 176, 0.25);
            padding-top: 10px;
        }
        .lb-close{
            position: absolute;
            top: 20px;
            right: 28px;
            color: #ffffff;
            font-size: 34px;
            line-height: 1;
            cursor: pointer;
            user-select: none;
            z-index: 1;
            transition: opacity 0.2s ease;
        }
        .lb-close:hover{ opacity: 0.7; }
        @media (max-width: 720px){
            .lb-inner{ flex-direction: column; overflow-y: auto; }
            .lb-figure{ max-width: 100%; }
            .lb-detail{ max-width: 100%; overflow-y: visible; }
        }
    </style>
</head>
<body>
<p class="note"><%= "所有角色立绘皆采用官方PV中的立绘" %></p>
    <h1>请多多支持<span style="color: deepskyblue">Mygo!!!!!</span></h1>

<div class="motto">
    <span class="jp"><span style="color: deepskyblue">迷子</span>でもいい、<span style="color: deepskyblue">迷子</span>でも進め。</span>
    <span class="cn">不畏<span style="color: deepskyblue">迷茫</span>，<span style="color: deepskyblue">迷茫</span>着也要砥砺前行。</span>
</div>

    <div class="char-section">
        <h2>成员介绍</h2>
        <div class="char-grid">

            <div class="char-card" style="--c:#77BBDD;">
                <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/Mygo/tomori.png" alt="高松灯" loading="lazy"></div>
                <div class="char-name-row">
                    <h3>高松 灯</h3>
                    <span class="role-badge">主唱 / 作词</span>
                </div>
                <p class="char-meta">11月22日 · 天蝎座 · CV 羊宫妃那</p>
                <p class="char-color"><span class="color-dot"></span>代表色 #77BBDD</p>
                <div class="char-info">
                    <div class="row"><span class="label">喜欢</span><span>金平糖（像星星的小圆糖）</span></div>
                    <div class="row"><span class="label">讨厌</span><span>红鱼子酱、明太鱼子酱</span></div>
                    <div class="row"><span class="label">兴趣</span><span>收集光滑小物（创可贴、石头）</span></div>
                </div>
                <p class="char-bio">自认不擅长歌唱却仍努力吟唱，把心声写进每一段作词；容易寂寞，常感受着孤独。</p>
                <div class="char-detail">
                    <div style="--c:#77BBDD;">
                        <div class="char-name-row">
                            <h3>高松 灯</h3>
                            <span class="role-badge">主唱 / 作词</span>
                        </div>
                        <p class="char-meta">11月22日 · 天蝎座 · CV 羊宫妃那</p>
                        <p class="char-color"><span class="color-dot"></span>代表色 #77BBDD</p>
                        <div class="char-info">
                            <div class="row"><span class="label">喜欢</span><span>金平糖——小小圆圆的，形状也有像星星一样的</span></div>
                            <div class="row"><span class="label">讨厌</span><span>红鱼子酱和明太鱼子酱，觉得好像是直接吃了有生命的东西一样</span></div>
                            <div class="row"><span class="label">兴趣</span><span>收集东西，比如创可贴、石头之类光滑的东西，大小正正好好</span></div>
                        </div>
                        <p class="char-bio">虽然自认不是那么擅长唱歌，但仍会努力去唱。由灯写在笔记本上的作词，之后交给立希谱曲。对成员的评价：乐奈有实力，爽世待人温柔，爱音正一同努力着——立希："那我呢？"容易感到寂寞，常感受着孤独。</p>
                        <p class="char-origin">姓氏来源：东京都丰岛区高松。</p>
                    </div>
                </div>
            </div>

            <div class="char-card" style="--c:#FF8899;">
                <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/Mygo/anon.png" alt="千早爱音" loading="lazy"></div>
                <div class="char-name-row">
                    <h3>千早 爱音</h3>
                    <span class="role-badge">吉他手</span>
                </div>
                <p class="char-meta">9月8日 · 处女座 · CV 立石凛</p>
                <p class="char-color"><span class="color-dot"></span>代表色 #FF8899</p>
                <div class="char-info">
                    <div class="row"><span class="label">乐器</span><span>ESP ULTRATONE Anon Custom</span></div>
                    <div class="row"><span class="label">喜欢</span><span>熏三文鱼、水果三明治</span></div>
                    <div class="row"><span class="label">讨厌</span><span>梅干等偏酸的食物</span></div>
                    <div class="row"><span class="label">兴趣</span><span>看美容视频、追流行</span></div>
                </div>
                <p class="char-bio">昵称"小爱音"，即使练习辛苦也努力克服；觉得立希很唠叨。</p>
                <div class="char-detail">
                    <div style="--c:#FF8899;">
                        <div class="char-name-row">
                            <h3>千早 爱音</h3>
                            <span class="role-badge">吉他手</span>
                        </div>
                        <p class="char-meta">9月8日 · 处女座 · CV 立石凛</p>
                        <p class="char-color"><span class="color-dot"></span>代表色 #FF8899</p>
                        <div class="char-info">
                            <div class="row"><span class="label">乐器</span><span>ESP ULTRATONE Anon Custom (See Thru Surf Green)</span></div>
                            <div class="row"><span class="label">喜欢</span><span>熏三文鱼和水果三明治</span></div>
                            <div class="row"><span class="label">讨厌</span><span>梅干，和其他比较酸的东西</span></div>
                            <div class="row"><span class="label">兴趣</span><span>看美容方面的视频，主要是想了解现在流行的东西</span></div>
                        </div>
                        <p class="char-bio">昵称是爱音或者小爱音。即使为了Live而进行的练习都很辛苦，爱音还是很努力去克服困难。觉得立希很唠叨。</p>
                        <p class="char-origin">姓氏来源：东京都丰岛区千早。</p>
                    </div>
                </div>
            </div>

            <div class="char-card" style="--c:#77DD77;">
                <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/Mygo/rana.png" alt="要乐奈" loading="lazy"></div>
                <div class="char-name-row">
                    <h3>要 乐奈</h3>
                    <span class="role-badge">主音吉他</span>
                </div>
                <p class="char-meta">2月22日 · 双鱼座 · CV 青木阳菜</p>
                <p class="char-color"><span class="color-dot"></span>代表色 #77DD77</p>
                <div class="char-info">
                    <div class="row"><span class="label">乐器</span><span>ESP POTBELLY Rāna Custom</span></div>
                    <div class="row"><span class="label">喜欢</span><span>抹茶、荞麦面</span></div>
                    <div class="row"><span class="label">讨厌</span><span>韭菜、山药泥</span></div>
                    <div class="row"><span class="label">兴趣</span><span>吸猫</span></div>
                </div>
                <p class="char-bio">"因为有趣所以加入乐队"，实力派吉他手，对猫极感兴趣。</p>
                <div class="char-detail">
                    <div style="--c:#77DD77;">
                        <div class="char-name-row">
                            <h3>要 乐奈</h3>
                            <span class="role-badge">主音吉他</span>
                        </div>
                        <p class="char-meta">2月22日 · 双鱼座 · CV 青木阳菜</p>
                        <p class="char-color"><span class="color-dot"></span>代表色 #77DD77</p>
                        <div class="char-info">
                            <div class="row"><span class="label">乐器</span><span>ESP POTBELLY Rāna Custom (Distressed See Thru Wine Red)</span></div>
                            <div class="row"><span class="label">喜欢</span><span>抹茶，还有荞麦面</span></div>
                            <div class="row"><span class="label">讨厌</span><span>韭菜，还有山药泥也不喜欢</span></div>
                            <div class="row"><span class="label">兴趣</span><span>吸猫，对猫很有兴趣</span></div>
                        </div>
                        <p class="char-bio">"因为觉得很有趣所以就加入了乐队。"实力派吉他手，对猫极感兴趣，常常凭感觉行动。</p>
                        <p class="char-origin">姓氏来源：东京都丰岛区要町。</p>
                    </div>
                </div>
            </div>

            <div class="char-card" style="--c:#FFDD88;">
                <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/Mygo/soyo.png" alt="长崎素世" loading="lazy"></div>
                <div class="char-name-row">
                    <h3>长崎 素世</h3>
                    <span class="role-badge">贝斯手</span>
                </div>
                <p class="char-meta">5月27日 · 双子座 · CV 小日向美香</p>
                <p class="char-color"><span class="color-dot"></span>代表色 #FFDD88</p>
                <div class="char-info">
                    <div class="row"><span class="label">乐器</span><span>ESP GB Soyo Custom</span></div>
                    <div class="row"><span class="label">喜欢</span><span>蔬菜通心粉汤、红茶</span></div>
                    <div class="row"><span class="label">讨厌</span><span>内脏类（不喜欢那种口感）</span></div>
                    <div class="row"><span class="label">兴趣</span><span>aroma香薰（按心情选香）</span></div>
                </div>
                <p class="char-bio">和刚组乐队不久的大家一起快乐努力；被灯夸"温柔"而十分高兴。</p>
                <div class="char-detail">
                    <div style="--c:#FFDD88;">
                        <div class="char-name-row">
                            <h3>长崎 素世</h3>
                            <span class="role-badge">贝斯手</span>
                        </div>
                        <p class="char-meta">5月27日 · 双子座 · CV 小日向美香</p>
                        <p class="char-color"><span class="color-dot"></span>代表色 #FFDD88</p>
                        <div class="char-info">
                            <div class="row"><span class="label">乐器</span><span>ESP GB Soyo Custom (3 Tone Sunburst)</span></div>
                            <div class="row"><span class="label">喜欢</span><span>蔬菜通心粉汤，也经常喝红茶</span></div>
                            <div class="row"><span class="label">讨厌</span><span>内脏之类的东西，不太喜欢那种口感</span></div>
                            <div class="row"><span class="label">兴趣</span><span>aroma香薰，根据心情选香：想爽快舒畅用柠檬香草，想安稳入睡用香柠檬</span></div>
                        </div>
                        <p class="char-bio">和才刚刚开始组乐队还没多久的大家一起快乐努力着。对于被灯说自己很温柔而感到很高兴。</p>
                        <p class="char-origin">姓氏来源：东京都丰岛区長崎。</p>
                    </div>
                </div>
            </div>

            <div class="char-card" style="--c:#7777AA;">
                <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/Mygo/riki.png" alt="椎名立希" loading="lazy"></div>
                <div class="char-name-row">
                    <h3>椎名 立希</h3>
                    <span class="role-badge">鼓手 / 作曲</span>
                </div>
                <p class="char-meta">8月9日 · 狮子座 · CV 林鼓子</p>
                <p class="char-color"><span class="color-dot"></span>代表色 #7777AA</p>
                <div class="char-info">
                    <div class="row"><span class="label">乐器</span><span>Pearl Masters Maple Gum</span></div>
                    <div class="row"><span class="label">喜欢</span><span>杏仁豆腐</span></div>
                    <div class="row"><span class="label">讨厌</span><span>香菇、魔芋丝（幼时被名字取笑）</span></div>
                    <div class="row"><span class="label">兴趣</span><span>收集熊猫周边</span></div>
                </div>
                <p class="char-bio">负责作曲，把灯的世界观谱成曲；觉得灯的歌声与LIVE很棒，却嘴硬不承认。</p>
                <div class="char-detail">
                    <div style="--c:#7777AA;">
                        <div class="char-name-row">
                            <h3>椎名 立希</h3>
                            <span class="role-badge">鼓手 / 作曲</span>
                        </div>
                        <p class="char-meta">8月9日 · 狮子座 · CV 林鼓子</p>
                        <p class="char-color"><span class="color-dot"></span>代表色 #7777AA</p>
                        <div class="char-info">
                            <div class="row"><span class="label">乐器</span><span>Pearl Masters Maple Gum (Chrome Contrail)</span></div>
                            <div class="row"><span class="label">喜欢</span><span>杏仁豆腐</span></div>
                            <div class="row"><span class="label">讨厌</span><span>香菇和魔芋丝，其实不是讨厌吃，只是小时候因为名字（たき）被取笑过</span></div>
                            <div class="row"><span class="label">兴趣</span><span>收集熊猫周边</span></div>
                        </div>
                        <p class="char-bio">同时也负责作曲，拿到灯的歌词以后，创作出切合她世界观的歌曲。觉得灯的歌声很好听、歌词也很不错、LIVE也真的很棒，却嘴硬不肯承认这一点。</p>
                        <p class="char-origin">姓氏来源：东京都丰岛区椎名町（历史地名，在今南長崎町和目白町）。</p>
                    </div>
                </div>
            </div>

        </div>
        <p class="char-source">※ 角色信息引用自
            <a href="https://zh.moegirl.org.cn" target="_blank" rel="noopener">萌娘百科</a>
            的角色设定
        </p>
    </div>

    <a class="back-link" href="../乐队主页.jsp">← 返回主页</a>

    <script src="${pageContext.request.contextPath}/js/presence.js"></script>
    <script src="${pageContext.request.contextPath}/js/music-player.js"></script>

    <script>
        (function(){
            var icon = '${pageContext.request.contextPath}/Mainimgs/MyGO!!!!!_ON_icon.png';
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

        (function(){
            var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
            var lines = [
                document.querySelector('.motto .jp'),
                document.querySelector('.motto .cn')
            ];
            var all = [];

            function splitChars(el){
                var chars = [];
                (function walk(node){
                    Array.prototype.slice.call(node.childNodes).forEach(function(k){
                        if (k.nodeType === 3){                 // 文本节点：逐字拆成 span
                            var frag = document.createDocumentFragment();
                            k.nodeValue.split('').forEach(function(c){
                                var s = document.createElement('span');
                                s.className = 'ch';
                                s.textContent = c;
                                frag.appendChild(s);
                                chars.push(s);
                            });
                            node.replaceChild(frag, k);
                        } else if (k.nodeType === 1){          // 元素节点(彩色span)：继续深入，保留颜色
                            walk(k);
                        }
                    });
                })(el);
                return chars;
            }

            lines.forEach(function(el){
                if (el) all = all.concat(splitChars(el));
            });

            if (reduce) return;                                // 关闭动画则直接完整显示

            all.forEach(function(s){ s.style.opacity = '0'; });
            all.forEach(function(s, i){
                setTimeout(function(){ s.style.opacity = '1'; }, 45 * i);
            });
        })();
    </script>

    <script>
        (function(){
            var box = document.createElement('div');
            box.className = 'lightbox';
            box.innerHTML =
                '<span class="lb-close">&times;</span>' +
                '<div class="lb-inner">' +
                    '<div class="lb-figure"><img alt=""></div>' +
                    '<div class="lb-detail"></div>' +
                '</div>';
            document.body.appendChild(box);

            var bigImg = box.querySelector('.lb-figure img');
            var detailEl = box.querySelector('.lb-detail');

            function open(src, detailHtml){
                bigImg.src = src;
                detailEl.innerHTML = detailHtml || '';
                detailEl.scrollTop = 0;
                box.classList.add('open');
                document.body.style.overflow = 'hidden';
            }
            function close(){
                box.classList.remove('open');
                document.body.style.overflow = '';
            }

            document.querySelectorAll('.char-card').forEach(function(card){
                var av = card.querySelector('.char-avatar img');
                var detail = card.querySelector('.char-detail');
                if (!av || !detail) return;
                av.addEventListener('click', function(){
                    open(av.src, detail.innerHTML);
                });
            });

            box.addEventListener('click', function(e){
                if (e.target === box) close();
            });
            box.querySelector('.lb-close').addEventListener('click', close);
            document.addEventListener('keydown', function(e){
                if (e.key === 'Escape') close();
            });
        })();
    </script>
</body>
</html>
