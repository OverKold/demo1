<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2026/10/2
  Time: 0:45
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Famliy DumbRock!</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/Titleico/Ikka_Dumb_Rock!_ON_icon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/band-common.css">
    <style>
        body{
            --page-bg: linear-gradient(135deg, #241408, #2c1a0c, #201208, #301c0a);
            --ink: #f0dcc4;
            --ink-strong: #ffe9d2;
            --ink-soft: #c8a887;
            --ink-faint: #95755a;
            --accent: #f5a340;
            --accent-soft: rgba(245, 163, 64, 0.45);
            --card-bg: rgba(44, 26, 12, 0.55);
            --card-border: rgba(245, 163, 64, 0.35);
            --avatar-bg: linear-gradient(135deg, #2e1a0c, #241208);
            --bio-bg: rgba(245, 163, 64, 0.10);
            --quote: rgba(200, 190, 230, 0.30);
            --sep: rgba(245, 200, 150, 0.55);
            --lb-bg: rgba(36, 20, 8, 0.96);
        }
        h1{
            font-weight: 800;
            color: #f5a340;
            text-shadow: 0 3px 0 rgba(0, 0, 0, 0.35), 0 6px 18px rgba(245, 163, 64, 0.3);
        }
        .motto .jp{ color: #f5a340; }
        .motto .cn{ color: #ffc46b; }
        /* 放克感：悬停时卡片轻微歪头，像贴纸 */
        .char-card:hover{
            transform: translateY(-8px) rotate(-1.5deg);
        }
    </style>
</head>
<body>
<p class="note"><%= "所有角色立绘皆采用官方PV中的立绘" %></p>
<h1>我们就像一家人,一家DumbRock!</h1>

<div class="motto">
    <span class="tag">FUNKY · GROOVY · FAMILY</span>
    <span class="jp">始めようか、マイ・ファミリー！</span>
    <div class="sep"></div>
    <span class="cn">开始吧，My Family!</span>
</div>

<div class="char-section">
    <h2>成员介绍</h2>
    <div class="char-grid">

        <div class="char-card" style="--c:#FF7700;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/一家Dumbrock/raika.jpg" alt="须贺蕾叶" loading="lazy"></div>
            <div class="char-name-row">
                <h3>须贺 蕾叶</h3>
                <span class="role-badge">主唱 / 吉他</span>
            </div>
            <p class="char-meta">7月28日 · 162cm · CV 橘芽衣</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #FF7700</p>
            <div class="char-info">
                <div class="row"><span class="label">性格</span><span>开朗直率、活力充沛，有点大剌剌</span></div>
                <div class="row"><span class="label">特点</span><span>典型行动派，身体动得比头脑快</span></div>
            </div>
            <p class="char-bio">待人正向又尊重，但一旦决定便不会改变心意的固执派。</p>
            <div class="char-detail">
                <div style="--c:#FF7700;">
                    <div class="char-name-row">
                        <h3>须贺 蕾叶</h3>
                        <span class="role-badge">主唱 / 吉他</span>
                    </div>
                    <p class="char-meta">7月28日 · 162cm · CV 橘芽衣</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #FF7700</p>
                    <div class="char-info">
                        <div class="row"><span class="label">性格</span><span>开朗直率、活力充沛，个性又有些大剌剌；典型的行动派，身体动得比头脑还快</span></div>
                        <div class="row"><span class="label">待人</span><span>基本上对待他人保持尊重且正向，但也有着一旦决定便不会改变心意的固执一面</span></div>
                    </div>
                    <p class="char-bio">开朗直率的行动派，待人尊重正向，却有着一旦决定便不会改变心意的固执一面。</p>
                    <p class="char-origin">姓氏疑似取自杉并区成宗须贺神社（位于成田东町5丁目）；乐器型号：Fender American Professional Classic Telecaster®。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#22CCFF;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/一家Dumbrock/miku.jpg" alt="马桥心玖" loading="lazy"></div>
            <div class="char-name-row">
                <h3>马桥 心玖</h3>
                <span class="role-badge">主唱 / 吉他</span>
            </div>
            <p class="char-meta">10月4日 · 162cm · CV 凉泉樱花</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #22CCFF</p>
            <div class="char-info">
                <div class="row"><span class="label">性格</span><span>待人亲切，性格温和</span></div>
                <div class="row"><span class="label">处事</span><span>坚定务实，信任前不轻易吐露真心</span></div>
            </div>
            <p class="char-bio">不过度干涉他人，也不希望被别人干涉的务实派。</p>
            <div class="char-detail">
                <div style="--c:#22CCFF;">
                    <div class="char-name-row">
                        <h3>马桥 心玖</h3>
                        <span class="role-badge">主唱 / 吉他</span>
                    </div>
                    <p class="char-meta">10月4日 · 162cm · CV 凉泉樱花</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #22CCFF</p>
                    <div class="char-info">
                        <div class="row"><span class="label">性格</span><span>待人亲切，性格温和</span></div>
                        <div class="row"><span class="label">处事</span><span>处事坚定，属于务实派，但在完全信任对方前不会轻易吐露真心；不会过度干涉他人，也不希望别人来干涉自己</span></div>
                    </div>
                    <p class="char-bio">温和又务实，在完全信任对方前不吐露真心；不干涉他人，也不愿被干涉。</p>
                    <p class="char-origin">姓氏疑似取自杉并区马桥町（今阿佐谷町、高圆寺町、梅里町各一部分）；乐器型号：Fender American Professional Classic Stratocaster® (Faded Dakota Red)。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#448888;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/一家Dumbrock/yomogi.jpg" alt="矢仓蓬咲" loading="lazy"></div>
            <div class="char-name-row">
                <h3>矢仓 蓬咲</h3>
                <span class="role-badge">贝斯手</span>
            </div>
            <p class="char-meta">5月6日 · 168cm · CV 花宫初奈</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #448888</p>
            <div class="char-info">
                <div class="row"><span class="label">性格</span><span>容易怯场、抗压性低、不擅交流</span></div>
                <div class="row"><span class="label">现状</span><span>把自己关在宿舍，大学自主休学中</span></div>
            </div>
            <p class="char-bio">内心憧憬不良少年漫画里的角色，却始终没能付诸行动。</p>
            <div class="char-detail">
                <div style="--c:#448888;">
                    <div class="char-name-row">
                        <h3>矢仓 蓬咲</h3>
                        <span class="role-badge">贝斯手</span>
                    </div>
                    <p class="char-meta">5月6日 · 168cm · CV 花宫初奈</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #448888</p>
                    <div class="char-info">
                        <div class="row"><span class="label">性格</span><span>容易怯场、抗压性低，且不擅长与人交流</span></div>
                        <div class="row"><span class="label">现状</span><span>目前把自己关在宿舍里，大学处于自主休学状态</span></div>
                    </div>
                    <p class="char-bio">内心非常憧憬不良少年漫画里的角色，在脑中演过无数次，却始终没能付诸行动。</p>
                    <p class="char-origin">姓氏疑似取自杉并区矢仓桥（亦或是矢仓台山、矢仓台遗迹，二者均在杉并区）；乐器型号：Fender American Professional II Jazz Bass® (Olympic White)。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#FF55AA;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/一家Dumbrock/chieri.jpg" alt="梅里千樱梨" loading="lazy"></div>
            <div class="char-name-row">
                <h3>梅里 千樱梨</h3>
                <span class="role-badge">鼓手</span>
            </div>
            <p class="char-meta">4月2日 · 154cm · CV 菱川花菜</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #FF55AA</p>
            <div class="char-info">
                <div class="row"><span class="label">性格</span><span>任性却让人无法讨厌的叛逆期少女</span></div>
                <div class="row"><span class="label">特点</span><span>自我表现欲强，嗓门特别大</span></div>
            </div>
            <p class="char-bio">常因应变能力不足而搞砸，但她从不因此气馁。</p>
            <div class="char-detail">
                <div style="--c:#FF55AA;">
                    <div class="char-name-row">
                        <h3>梅里 千樱梨</h3>
                        <span class="role-badge">鼓手</span>
                    </div>
                    <p class="char-meta">4月2日 · 154cm · CV 菱川花菜</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #FF55AA</p>
                    <div class="char-info">
                        <div class="row"><span class="label">性格</span><span>任性却让人无法讨厌的叛逆期少女</span></div>
                        <div class="row"><span class="label">特点</span><span>自我表现欲强，不过常因为应变能力不足而搞砸，但她从不因此气馁；嗓门特别大</span></div>
                    </div>
                    <p class="char-bio">自我表现欲强的叛逆期少女，常因应变能力不足而搞砸，却从不气馁，嗓门特别大。</p>
                    <p class="char-origin">姓氏疑似取自杉并区梅里町。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#9999FF;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/一家Dumbrock/shizuku.jpg" alt="四宫宁月" loading="lazy"></div>
            <div class="char-name-row">
                <h3>四宫 宁月</h3>
                <span class="role-badge">键盘手</span>
            </div>
            <p class="char-meta">3月5日 · 143cm · CV 远野光</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #9999FF</p>
            <div class="char-info">
                <div class="row"><span class="label">定位</span><span>乐团中最年幼且充满谜团的成员</span></div>
                <div class="row"><span class="label">气质</span><span>超龄沉稳，用词略显深晦</span></div>
            </div>
            <p class="char-bio">精湛的钢琴技艺与思考方式，隐约透露绝非平凡的出身。</p>
            <div class="char-detail">
                <div style="--c:#9999FF;">
                    <div class="char-name-row">
                        <h3>四宫 宁月</h3>
                        <span class="role-badge">键盘手</span>
                    </div>
                    <p class="char-meta">3月5日 · 143cm · CV 远野光</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #9999FF</p>
                    <div class="char-info">
                        <div class="row"><span class="label">定位</span><span>乐团中最年幼且充满谜团的成员，散发着超龄的沉稳气质，说起话来用词略显深晦</span></div>
                        <div class="row"><span class="label">出身</span><span>无论是价值观、思考方式，还是那异常精湛的钢琴技艺，都隐约透露着她绝非平凡的出身背景</span></div>
                    </div>
                    <p class="char-bio">最年幼却充满谜团，超龄沉稳；价值观、思考与精湛的钢琴技艺，都透露着绝非平凡的出身。</p>
                    <p class="char-origin">姓氏疑似取自杉并区四宫町（今上井草町2丁目和今川町2丁目的各一部分）。</p>
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

<script>
    (function(){
        var icon = '${pageContext.request.contextPath}/Mainimgs/Ikka_Dumb_Rock!_ON_icon.png';
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
<script src="${pageContext.request.contextPath}/js/music-player.js?v=3"></script>

</body>
</html>
