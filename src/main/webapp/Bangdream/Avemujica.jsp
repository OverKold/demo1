<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2026/10/2
  Time: 0:22
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>欢迎来到Avemujica的世界</title>
    <link rel="icon" type="image/png" href="${pageContext.request.contextPath}/Titleico/AveMujica.png">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/band-common.css">
    <style>
        body{
            --page-bg: linear-gradient(135deg, #170b10, #241017, #1a0d14, #2a121a);
            --font: Georgia, "Times New Roman", "KaiTi", "Microsoft YaHei", serif;
            --ink: #d8c9cf;
            --ink-strong: #e9d7de;
            --ink-soft: #b9a4ac;
            --ink-faint: #8a7580;
            --accent: #c2456a;
            --accent-soft: rgba(201, 168, 106, 0.45);
            --card-bg: rgba(38, 18, 26, 0.55);
            --card-border: rgba(201, 168, 106, 0.35);
            --avatar-bg: linear-gradient(135deg, #2a141c, #1c0e14);
            --bio-bg: rgba(194, 69, 106, 0.12);
            --quote: rgba(200, 180, 220, 0.28);
            --sep: rgba(222, 202, 212, 0.55);
            --lb-bg: rgba(30, 15, 22, 0.96);
        }
        h1{
            color: #c9a86a;
            text-shadow: 0 2px 14px rgba(201, 168, 106, 0.25);
        }
        .motto .jp{ color: #c2456a; }
        .motto .cn{ color: #d76a8c; }
        .motto .tag{ color: #c9a86a; }
    </style>
</head>
<body>
<p class="note"><%= "所有角色立绘皆采用官方PV中的立绘" %></p>
<h1>这里是精英乐团'AveMujica'</h1>

<div class="motto">
    <span class="tag">マスカレード · 假面舞会</span>
    <span class="jp">…ようこそ。Ave Mujicaの世界へ</span>
    <div class="sep"></div>
    <span class="cn">…欢迎来到Ave Mujica的世界</span>
</div>

<div class="char-section">
    <h2>成员介绍</h2>
    <div class="char-grid">
        <%-- 若立绘与角色对不上，只需改对应卡片 img 的文件名 --%>

        <div class="char-card" style="--c:#BB9955;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/AveMujica/htn.jpg" alt="三角初华" loading="lazy"></div>
            <div class="char-name-row">
                <h3>Doloris</h3>
                <span class="role-badge">主唱 / 主音吉他</span>
            </div>
            <p class="char-meta">三角 初华 · 6月26日 · 巨蟹座 · CV 佐佐木李子</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #BB9955</p>
            <div class="char-info">
                <div class="row"><span class="label">学校</span><span>花咲川女子学園高中1年级</span></div>
                <div class="row"><span class="label">身份</span><span>「sumimi」吉他手，艺名"初华"</span></div>
                <div class="row"><span class="label">喜欢</span><span>观星</span></div>
            </div>
            <p class="char-bio">受幼时相识的祥子邀请，立即加入 Ave Mujica，担当作词。</p>
            <div class="char-detail">
                <div style="--c:#BB9955;">
                    <div class="char-name-row">
                        <h3>Doloris</h3>
                        <span class="role-badge">主唱 / 主音吉他</span>
                    </div>
                    <p class="char-meta">三角 初华 · 6月26日 · 巨蟹座 · CV 佐佐木李子</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #BB9955</p>
                    <div class="char-info">
                        <div class="row"><span class="label">学校</span><span>花咲川女子学園高中1年级，和椎名立希、八幡海铃同班，因工作关系经常缺席</span></div>
                        <div class="row"><span class="label">身份</span><span>偶像团体「sumimi」の吉他手，此时艺名为初华，是 sumimi 乐曲の作词作曲担当</span></div>
                        <div class="row"><span class="label">喜欢</span><span>观星，因其酷炫の外观而受欢迎</span></div>
                    </div>
                    <p class="char-bio">受幼时相识の丰川祥子邀请，立即加入了 Ave Mujica，担当作词。</p>
                    <p class="char-origin">Doloris 取自 Lacus Doloris（悲湖），意指悲伤。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#779977;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/AveMujica/mtm.jpg" alt="若葉睦" loading="lazy"></div>
            <div class="char-name-row">
                <h3>Mortis</h3>
                <span class="role-badge">吉他手</span>
            </div>
            <p class="char-meta">若葉 睦 · 1月14日 · 摩羯座 · CV 渡濑结月</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #779977</p>
            <div class="char-info">
                <div class="row"><span class="label">学校</span><span>月之森女子学園高中1年级</span></div>
                <div class="row"><span class="label">过去</span><span>曾是 CRYCHIC の吉他手</span></div>
                <div class="row"><span class="label">性格</span><span>沉默寡言，情感表达不多</span></div>
            </div>
            <p class="char-bio">祥子的青梅竹马，自幼学习吉他，技艺精湛。</p>
            <div class="char-detail">
                <div style="--c:#779977;">
                    <div class="char-name-row">
                        <h3>Mortis</h3>
                        <span class="role-badge">吉他手</span>
                    </div>
                    <p class="char-meta">若葉 睦 · 1月14日 · 摩羯座 · CV 渡濑結月</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #779977</p>
                    <div class="char-info">
                        <div class="row"><span class="label">学校</span><span>月之森女子学園高中1年级，曾是 CRYCHIC の吉他手</span></div>
                        <div class="row"><span class="label">性格</span><span>情感表达不多，基本上是一个沉默寡言の人</span></div>
                        <div class="row"><span class="label">家庭</span><span>父親は知名喜剧艺人若葉，母親は女演员森美奈美</span></div>
                    </div>
                    <p class="char-bio">祥子の青梅竹馬，自幼学习吉他，技艺精湛。</p>
                    <p class="char-origin">Mortis 取自 Lacus Mortis（死湖），意指死亡。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#335566;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/AveMujica/tmls.jpg" alt="八幡海铃" loading="lazy"></div>
            <div class="char-name-row">
                <h3>Timoris</h3>
                <span class="role-badge">贝斯手</span>
            </div>
            <p class="char-meta">八幡 海铃 · 4月7日 · 白羊座 · CV 冈田梦以</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #335566</p>
            <div class="char-info">
                <div class="row"><span class="label">学校</span><span>花咲川女子学園高中1年级</span></div>
                <div class="row"><span class="label">实力</span><span>贝斯职业水准，支援 30 个乐团</span></div>
                <div class="row"><span class="label">队内</span><span>负责安排成员日务，一丝不苟</span></div>
            </div>
            <p class="char-bio">贝斯技巧职业级，身兼多团支援乐手；队内统筹日程，做事一丝不苟。</p>
            <div class="char-detail">
                <div style="--c:#335566;">
                    <div class="char-name-row">
                        <h3>Timoris</h3>
                        <span class="role-badge">贝斯手</span>
                    </div>
                    <p class="char-meta">八幡 海铃 · 4月7日 · 白羊座 · CV 冈田夢以</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #335566</p>
                    <div class="char-info">
                        <div class="row"><span class="label">学校</span><span>花咲川女子学園高中1年级，和椎名立希、三角初华同班，经常互相和立希找茬</span></div>
                        <div class="row"><span class="label">实力</span><span>贝ス技巧达到了职业水准，同时担任 30 个乐团の支援乐手，体验节奏音乐</span></div>
                        <div class="row"><span class="label">队内</span><span>在 Ave Mujica 負责安排成员日務，总能一丝不苟地完成</span></div>
                    </div>
                    <p class="char-bio">贝ス技巧达到职业水准，同时身兼 30 个乐团の支援乐手；在队内负责统筹成员日程，做事一丝不苟。</p>
                    <p class="char-origin">Timoris 取自 Lacus Timoris（恐湖），意指恐怖。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#AA4477;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/AveMujica/meow.jpg" alt="祐天寺にゃむ" loading="lazy"></div>
            <div class="char-name-row">
                <h3>Amoris</h3>
                <span class="role-badge">鼓手</span>
            </div>
            <p class="char-meta">祐天寺 にゃむ · 6月1日 · 双子座 · CV 米泽茜</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #AA4477</p>
            <div class="char-info">
                <div class="row"><span class="label">学校</span><span>艺术学院高中 主修演技</span></div>
                <div class="row"><span class="label">身份</span><span>美妆博主"喵姆亲"，人气上升中</span></div>
                <div class="row"><span class="label">特点</span><span>双利手，打鼓手法华丽</span></div>
            </div>
            <p class="char-bio">人气上升中的美妆博主"喵姆亲"，主修演技、双利手，鼓点既稳又炫。</p>
            <div class="char-detail">
                <div style="--c:#AA4477;">
                    <div class="char-name-row">
                        <h3>Amoris</h3>
                        <span class="role-badge">鼓手</span>
                    </div>
                    <p class="char-meta">祐天寺 にゃむ · 6月1日 · 双子座 · CV 米泽茜</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #AA4477</p>
                    <div class="char-info">
                        <div class="row"><span class="label">身份</span><span>人气上升中、爱自称为"喵姆亲"の美妆类博主，视频主要是化妆类，但其他各種タイプ也在挑戦着</span></div>
                        <div class="row"><span class="label">学校</span><span>目前就读于艺术学院高中，主修演技</span></div>
                        <div class="row"><span class="label">特点</span><span>作为双利手，打鼓的手法十分华丽</span></div>
                    </div>
                    <p class="char-bio">人气上升中の美妆博主"喵姆亲"，视频以化妆为主、也挑战各类题材；主修演技、身为双利手，打鼓手法十分华丽。</p>
                    <p class="char-origin">Amoris 取自 Sinus Amoris（愛湾），意指愛（不只限于愛情）。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#7799CC;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/AveMujica/Saki.jpg" alt="丰川祥子" loading="lazy"></div>
            <div class="char-name-row">
                <h3>Oblivionis</h3>
                <span class="role-badge">键盘手 / 队长</span>
            </div>
            <p class="char-meta">丰川 祥子 · 2月14日 · 水瓶座 · CV 高尾奏音</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #7799CC</p>
            <div class="char-info">
                <div class="row"><span class="label">学校</span><span>羽丘女子学園高中1年级</span></div>
                <div class="row"><span class="label">身份</span><span>丰川集团大小姐，举止优雅</span></div>
                <div class="row"><span class="label">过去</span><span>曾是 CRYCHIC の键盘手</span></div>
            </div>
            <p class="char-bio">怀着守护所有成员的觉悟组建了 Ave Mujica，为其世界观倾注心血。</p>
            <div class="char-detail">
                <div style="--c:#7799CC;">
                    <div class="char-name-row">
                        <h3>Oblivionis</h3>
                        <span class="role-badge">键盘手 / 队长</span>
                    </div>
                    <p class="char-meta">丰川 祥子 · 2月14日 · 水瓶座 · CV 高尾奏音</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #7799CC</p>
                    <div class="char-info">
                        <div class="row"><span class="label">学校</span><span>羽丘女子学園高中1年级，丰川集团の大小姐，言談举止十分優雅</span></div>
                        <div class="row"><span class="label">過去</span><span>曾是 CRYCHIC の键盘手</span></div>
                    </div>
                    <p class="char-bio">怀着守护所有成员人生的觉悟组建了 Ave Mujica，为守护 Ave Mujica の世界观傾注心血。</p>
                    <p class="char-origin">Oblivionis 取自 Lacus Oblivionis（忘湖），意指忘却。</p>
                </div>
            </div>
        </div>

    </div>
    <p class="char-source">※ 角色信息引用自
        <a href="https://zh.moegirl.org.cn" target="_blank" rel="noopener">萌娘百科</a>
        の角色设定
    </p>
</div>

<a class="back-link" href="../乐队主页.jsp">← 返回主页</a>

<script>
    (function(){
        var icon = '${pageContext.request.contextPath}/Mainimgs/AveMujica.png';
        for (var i = 0; i < 7; i++){
            var el = document.createElement('img');
            el.src = icon;
            el.className = 'float-icon';
            el.alt = '';
            var size = 40 + Math.random() * 50;
            el.style.width = size + 'px';
            el.style.height = size + 'px';
            el.style.left = (Math.random() * 100) + 'vw';
            el.style.opacity = (0.10 + Math.random() * 0.12).toFixed(2);
            var dur = 16 + Math.random() * 16;
            el.style.animationDuration = dur + 's';
            el.style.animationDelay = (-Math.random() * dur) + 's';
            el.style.setProperty('--sway', (Math.random() * 160 - 80) + 'px');
            document.body.appendChild(el);
        }
    })();
</script>

<script>
    (function(){
        var reduce = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
        var lines = Array.prototype.slice.call(document.querySelectorAll('.motto .jp, .motto .cn'));
        var all = [];

        function splitChars(el){
            var chars = [];
            (function walk(node){
                Array.prototype.slice.call(node.childNodes).forEach(function(k){
                    if (k.nodeType === 3){
                        var frag = document.createDocumentFragment();
                        k.nodeValue.split('').forEach(function(c){
                            var s = document.createElement('span');
                            s.className = 'ch';
                            s.textContent = c;
                            frag.appendChild(s);
                            chars.push(s);
                        });
                        node.replaceChild(frag, k);
                    } else if (k.nodeType === 1){
                        walk(k);
                    }
                });
            })(el);
            return chars;
        }

        lines.forEach(function(el){
            if (el) all = all.concat(splitChars(el));
        });

        if (reduce) return;

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
<script src="${pageContext.request.contextPath}/js/presence.js"></script>
<script src="${pageContext.request.contextPath}/js/music-player.js"></script>

</body>
</html>
