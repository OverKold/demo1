<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2026/10/2
  Time: 0:45
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>millsage...</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/Titleico/Millsage_ON_icon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/band-common.css">
    <style>
        body{
            --page-bg: linear-gradient(135deg, #171226, #1e1533, #161028, #221739);
            --ink: #d6cdec;
            --ink-strong: #e8e0fa;
            --ink-soft: #a99cc8;
            --ink-faint: #7e739c;
            --accent: #b466e5;
            --accent-soft: rgba(180, 102, 229, 0.40);
            --card-bg: rgba(34, 24, 58, 0.50);
            --card-border: rgba(180, 102, 229, 0.30);
            --avatar-bg: linear-gradient(135deg, #241a3e, #1a1230);
            --bio-bg: rgba(180, 102, 229, 0.10);
            --quote: rgba(190, 180, 230, 0.30);
            --sep: rgba(214, 204, 242, 0.55);
            --lb-bg: rgba(26, 18, 44, 0.96);
        }
        h1{
            font-weight: 500;
            letter-spacing: 6px;
            background: linear-gradient(120deg, #c98ff0, #b466e5, #8f7bff, #c98ff0);
            background-size: 220% auto;
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            -webkit-text-fill-color: transparent;
            filter: drop-shadow(0 0 16px rgba(180, 102, 229, 0.45));
            animation: h1Shine 7s linear infinite;
        }
        @keyframes h1Shine{
            to{ background-position: 220% center; }
        }
        @media (prefers-reduced-motion: reduce){
            h1{ animation: none; }
        }
        .motto .jp{ color: #b466e5; }
        .motto .cn{ color: #c98ff0; }
    </style>
</head>
<body>
<p class="note"><%= "所有角色立绘皆采用官方PV中的立绘" %></p>
<h1>我会拯救millsage的大家..</h1>

<div class="motto">
    <span class="tag">祝福 · 仅有一次的人生</span>
    <span class="jp">両手いっぱいの幸せを、あなたに。</span>
    <div class="sep"></div>
    <span class="cn">将双手满载的幸福，献给你。</span>
</div>

<div class="char-section">
    <h2>成员介绍</h2>
    <div class="char-grid">

        <div class="char-card" style="--c:#99FF99;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/Millsage/hotaru.jpg" alt="汐见萤" loading="lazy"></div>
            <div class="char-name-row">
                <h3>汐见 萤</h3>
                <span class="role-badge">键盘 / 主唱</span>
            </div>
            <p class="char-meta">3月12日 · 152cm · CV 药师寺李有</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #99FF99</p>
            <div class="char-info">
                <div class="row"><span class="label">天赋</span><span>古典钢琴大赛获奖无数，「乐坛的天使」</span></div>
                <div class="row"><span class="label">性格</span><span>纯真、情感丰富，也有不谙世事的一面</span></div>
            </div>
            <p class="char-bio">心地善良的音乐天才，以天才般的歌唱与演奏带领着 millsage。</p>
            <div class="char-detail">
                <div style="--c:#99FF99;">
                    <div class="char-name-row">
                        <h3>汐见 萤</h3>
                        <span class="role-badge">键盘 / 主唱</span>
                    </div>
                    <p class="char-meta">3月12日 · 152cm · CV 药师寺李有</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #99FF99</p>
                    <div class="char-info">
                        <div class="row"><span class="label">天赋</span><span>自幼便在各项古典钢琴大赛中获奖无数，被誉为是「乐坛的天使」</span></div>
                        <div class="row"><span class="label">性格</span><span>性格纯真、情感丰富，但也有着不谙世事的一面</span></div>
                    </div>
                    <p class="char-bio">心地善良的音乐天才。以键盘手兼主唱的身份，凭借天才般的歌唱与演奏，成为整个乐队的核心。</p>
                    <p class="char-origin">姓氏疑似取自江东区汐见桥；乐器型号：未公开。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#FF4444;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/Millsage/natsume.jpg" alt="伊泽枣" loading="lazy"></div>
            <div class="char-name-row">
                <h3>伊泽 枣</h3>
                <span class="role-badge">吉他手</span>
            </div>
            <p class="char-meta">3月30日 · 161cm · CV 千春</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #FF4444</p>
            <div class="char-info">
                <div class="row"><span class="label">性格</span><span>极度自信、自尊心强</span></div>
                <div class="row"><span class="label">习惯</span><span>常霸占学校顶楼弹吉他</span></div>
            </div>
            <p class="char-bio">极度自信的作曲担当，对自己不认可的对象总怀敌意、处处渴望展现优越感。</p>
            <div class="char-detail">
                <div style="--c:#FF4444;">
                    <div class="char-name-row">
                        <h3>伊泽 枣</h3>
                        <span class="role-badge">吉他手</span>
                    </div>
                    <p class="char-meta">3月30日 · 161cm · CV 千春</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #FF4444</p>
                    <div class="char-info">
                        <div class="row"><span class="label">性格</span><span>极度自信的作曲负责人，自尊心极强，对自己不认可的对象总是表现敌意，且处处渴望展现自己的优越感</span></div>
                        <div class="row"><span class="label">习惯</span><span>经常霸占着学校顶楼，在那里弹奏吉他</span></div>
                    </div>
                    <p class="char-bio">极度自信的作曲负责人，对自己不认可的对象总是表现敌意，且处处渴望展现自己的优越感。</p>
                    <p class="char-origin">姓氏疑似取自江东区旧伊泽町（今位于福住一丁目）；乐器型号：Ibanez RG j.custom RG8570-RS (Red Spinel)。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#5555FF;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/Millsage/nagi.jpg" alt="琴平凪" loading="lazy"></div>
            <div class="char-name-row">
                <h3>琴平 凪</h3>
                <span class="role-badge">吉他手</span>
            </div>
            <p class="char-meta">12月10日 · 163cm · CV 结川麻希</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #5555FF</p>
            <div class="char-info">
                <div class="row"><span class="label">性格</span><span>气质沉着稳重，比同龄人更显成熟</span></div>
                <div class="row"><span class="label">人气</span><span>女校里有人悄悄为她成立粉丝会</span></div>
            </div>
            <p class="char-bio">举手投足间尽显从容的少女，成熟魅力让人忍不住多看一眼。</p>
            <div class="char-detail">
                <div style="--c:#5555FF;">
                    <div class="char-name-row">
                        <h3>琴平 凪</h3>
                        <span class="role-badge">吉他手</span>
                    </div>
                    <p class="char-meta">12月10日 · 163cm · CV 结川麻希</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #5555FF</p>
                    <div class="char-info">
                        <div class="row"><span class="label">性格</span><span>气质沉着稳重的少女，举手投足间的从容，经常让人感受到她比同龄人更显成熟的魅力</span></div>
                        <div class="row"><span class="label">人气</span><span>据说她所就读的女校里，还有人悄悄为她成立了粉丝会</span></div>
                    </div>
                    <p class="char-bio">气质沉着稳重的少女，举手投足间的从容尽显超越同龄人的成熟魅力。</p>
                    <p class="char-origin">姓氏疑似取自江东区琴平桥；乐器型号：PRS Custom 24 10 Top Faded Whale Blue。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#77FFFF;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/Millsage/mahoro.jpg" alt="滨崎茉幌" loading="lazy"></div>
            <div class="char-name-row">
                <h3>滨崎 茉幌</h3>
                <span class="role-badge">贝斯手</span>
            </div>
            <p class="char-meta">7月16日 · 158cm · CV 伊驹祐里惠</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #77FFFF</p>
            <div class="char-info">
                <div class="row"><span class="label">定位</span><span>乐团中担任统筹角色</span></div>
                <div class="row"><span class="label">性格</span><span>亲切随和，和谁都能相处融洽</span></div>
            </div>
            <p class="char-bio">比任何人都珍惜与团员共处的时光，身边有两位儿时玩伴。</p>
            <div class="char-detail">
                <div style="--c:#77FFFF;">
                    <div class="char-name-row">
                        <h3>滨崎 茉幌</h3>
                        <span class="role-badge">贝ス手</span>
                    </div>
                    <p class="char-meta">7月16日 · 158cm · CV 伊驹祐里惠</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #77FFFF</p>
                    <div class="char-info">
                        <div class="row"><span class="label">定位</span><span>乐团中担任统筹角色，个性亲切随和，和谁都能相处融洽</span></div>
                        <div class="row"><span class="label">心情</span><span>她比任何人都珍惜在大家一起组建的乐团中，与团员们共处的时光</span></div>
                    </div>
                    <p class="char-bio">亲切随和、统筹全局，比谁都珍惜与团员共处的时光；有两位儿时玩伴。</p>
                    <p class="char-origin">姓氏疑似取自江东区滨崎桥；乐器型号：Ibanez BTB1835。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#EE99EE;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/Millsage/houka.jpg" alt="和泉朋花" loading="lazy"></div>
            <div class="char-name-row">
                <h3>和泉 朋花</h3>
                <span class="role-badge">鼓手</span>
            </div>
            <p class="char-meta">10月24日 · 157cm · CV 咲川雏乃</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #EE99EE</p>
            <div class="char-info">
                <div class="row"><span class="label">性格</span><span>气质出众、慧人怜爱</span></div>
                <div class="row"><span class="label">特点</span><span>善于社交又俏皮，班上的人气王</span></div>
            </div>
            <p class="char-bio">对那种具有压倒性的「才能」，抱持着强烈兴趣。</p>
            <div class="char-detail">
                <div style="--c:#EE99EE;">
                    <div class="char-name-row">
                        <h3>和泉 朋花</h3>
                        <span class="role-badge">鼓手</span>
                    </div>
                    <p class="char-meta">10月24日 · 157cm · CV 咲川雏乃</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #EE99EE</p>
                    <div class="char-info">
                        <div class="row"><span class="label">性格</span><span>气质出众、慧人怜爱的少女</span></div>
                        <div class="row"><span class="label">特点</span><span>善于社交且懂得拿捏分寸，同时又带点俏皮，是班上备受欢迎的人气王</span></div>
                    </div>
                    <p class="char-bio">善于社交、懂得拿捏分寸又带点俏皮的人气王，对具有压倒性的「才能」抱持着强烈兴趣。</p>
                    <p class="char-origin">姓氏疑似取自江东区深川和泉守屋敷地。</p>
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
        var icon = '${pageContext.request.contextPath}/Mainimgs/Millsage_ON_icon.webp';
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
