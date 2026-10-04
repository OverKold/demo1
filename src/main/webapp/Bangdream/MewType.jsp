<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 2026/10/2
  Time: 0:45
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>瓦塔西哇MewTypeDesu!</title>
    <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/Titleico/Mugendai_MewType_ON_icon.ico">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/band-common.css">
    <style>
        body{
            --page-bg: linear-gradient(135deg, #141226, #1d1633, #161a2e, #20122e);
            --ink: #dfe3ff;
            --ink-strong: #f0f2ff;
            --ink-soft: #aab3dd;
            --ink-faint: #7d84ad;
            --accent: #ff8fb3;
            --accent-soft: rgba(143, 184, 255, 0.45);
            --card-bg: rgba(30, 26, 56, 0.55);
            --card-border: rgba(255, 143, 179, 0.35);
            --avatar-bg: linear-gradient(135deg, #241a3a, #1a2036);
            --bio-bg: rgba(143, 184, 255, 0.10);
            --quote: rgba(170, 160, 230, 0.30);
            --sep: linear-gradient(90deg, #ff8fb3, #8fb8ff);
            --lb-bg: rgba(24, 20, 44, 0.96);
        }
        /* 粉→蓝霓虹渐变标题 */
        h1{
            background: linear-gradient(90deg, #ff8fb3, #8fb8ff);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
        }
        .motto .jp{
            background: linear-gradient(#FF7788, #2288DD);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            -webkit-text-fill-color: transparent;
        }
        /* 中文行：#FF7788 上到下 #2288DD 渐变（纵向渐变不受拆字影响，无需 fixed） */
        .motto .cn,
        .motto .cn .ch{
            background: linear-gradient(#FF7788, #2288DD);
            -webkit-background-clip: text;
            background-clip: text;
            color: transparent;
            -webkit-text-fill-color: transparent;
        }
        .band-hero{
            --hero-bg: linear-gradient(160deg, #241a3a, #141226);
            --hero-title-grad: linear-gradient(90deg, #ff8fb3, #8fb8ff);
        }
    </style>
</head>
<body>
<p class="note"><%= "所有角色立绘皆采用官方PV中的立绘" %></p>
<h1>我们是梦限大,请多多支持我们!</h1>

<div class="motto">
    <span class="tag">ネオ・アイドル</span>
    <span class="cn">梦想无限大！</span>
    <div class="sep"></div>
    <span class="jp">夢は、限りなく大きく！</span>
</div>

<div class="char-section">
    <h2>成员介绍</h2>
    <div class="char-grid">

        <div class="char-card" style="--c:#FFEE55;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/MewType/arl.jpg" alt="仲町阿拉蕾" loading="lazy"></div>
            <div class="char-name-row">
                <h3>仲町 阿拉蕾</h3>
                <span class="role-badge">主唱</span>
            </div>
            <p class="char-meta">8月16日 · 154cm · 耳廓狐耳</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #FFEE55</p>
            <div class="char-info">
                <div class="row"><span class="label">喜欢</span><span>唱歌、说话</span></div>
                <div class="row"><span class="label">性格</span><span>开朗元气、闲不住</span></div>
            </div>
            <p class="char-bio">用强有力的歌声带领梦限大MewType在音乐方面前进的 Powerful Girl。</p>
            <div class="char-detail">
                <div style="--c:#FFEE55;">
                    <div class="char-name-row">
                        <h3>仲町 阿拉蕾</h3>
                        <span class="role-badge">主唱</span>
                    </div>
                    <p class="char-meta">8月16日 · 154cm · 耳廓狐耳</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #FFEE55</p>
                    <div class="char-info">
                        <div class="row"><span class="label">喜欢</span><span>非常喜欢唱歌和说话</span></div>
                        <div class="row"><span class="label">性格</span><span>基本都很开朗元气，但有时会白忙一场，有时也会情绪低落，拥有闲不住的性格</span></div>
                    </div>
                    <p class="char-bio">通过强有力的歌声，带领梦限大MewType在音乐方面前进的 Powerful Girl。</p>
                    <p class="char-origin">姓氏取自文京区旧大冢仲町（今位于大冢三丁目与四丁目）或旧（小石川）仲町（今位于春日一丁目）；头饰为耳廓狐耳。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#FFBBCC;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/MewType/nnk.jpg" alt="宫永野乃花" loading="lazy"></div>
            <div class="char-name-row">
                <h3>宫永 野乃花</h3>
                <span class="role-badge">主音吉他</span>
            </div>
            <p class="char-meta">4月17日 · 161cm · 兔耳</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #FFBBCC</p>
            <div class="char-info">
                <div class="row"><span class="label">性格</span><span>天真烂漫、性格软萌</span></div>
                <div class="row"><span class="label">定位</span><span>自由又快乐的 Mood Maker</span></div>
            </div>
            <p class="char-bio">人见人爱的氛围制造者，站上舞台便能用演奏把观众带进音乐的世界。</p>
            <div class="char-detail">
                <div style="--c:#FFBBCC;">
                    <div class="char-name-row">
                        <h3>宫永 野乃花</h3>
                        <span class="role-badge">主音吉他</span>
                    </div>
                    <p class="char-meta">4月17日 · 161cm · 兔耳</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #FFBBCC</p>
                    <div class="char-info">
                        <div class="row"><span class="label">性格</span><span>梦限大MewType的天真烂漫、性格软萌的吉他手，人见人爱</span></div>
                        <div class="row"><span class="label">定位</span><span>是个自由又快乐的 Mood Maker</span></div>
                    </div>
                    <p class="char-bio">一旦站上舞台，就能在自己最享受音乐的同时通过演奏把观众带进音乐的世界。</p>
                    <p class="char-origin">姓氏取自文京区旧根津宫永町（今位于根津二丁目）；头饰为兔耳。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#4477CC;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/MewType/ricu.jpg" alt="峰月律" loading="lazy"></div>
            <div class="char-name-row">
                <h3>峰月 律</h3>
                <span class="role-badge">节奏吉他</span>
            </div>
            <p class="char-meta">2月7日 · 157cm · 熊耳</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #4477CC</p>
            <div class="char-info">
                <div class="row"><span class="label">性格</span><span>认真又坦率的优等生</span></div>
                <div class="row"><span class="label">特点</span><span>食欲在梦限大成员中排第一</span></div>
            </div>
            <p class="char-bio">冷静地支撑着乐队音乐的节奏吉他手，偶尔会做出超出大家预想的举动。</p>
            <div class="char-detail">
                <div style="--c:#4477CC;">
                    <div class="char-name-row">
                        <h3>峰月 律</h3>
                        <span class="role-badge">节奏吉他</span>
                    </div>
                    <p class="char-meta">2月7日 · 157cm · 熊耳</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #4477CC</p>
                    <div class="char-info">
                        <div class="row"><span class="label">性格</span><span>认真的优等生，冷静地支撑着梦限大MewType的音乐</span></div>
                        <div class="row"><span class="label">特点</span><span>也许由于那份认真，偶尔会做出超出大家预想的举动；食欲在梦限大成员中是第一名</span></div>
                    </div>
                    <p class="char-bio">冷静支撑乐队音乐节奏的吉他手，也许因为认真，偶尔会做出超出大家预想的举动。</p>
                    <p class="char-origin">姓氏取自文京区西片二丁目—白山一丁目间的峰月坂；头饰为熊耳。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#9977CC;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/MewType/tdz.jpg" alt="藤都子" loading="lazy"></div>
            <div class="char-name-row">
                <h3>藤 都子</h3>
                <span class="role-badge">键盘手</span>
            </div>
            <p class="char-meta">9月19日 · 16岁 · 155cm · 狗耳</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #9977CC</p>
            <div class="char-info">
                <div class="row"><span class="label">身份</span><span>现役漫画家，兼任键盘手</span></div>
                <div class="row"><span class="label">特点</span><span>兼顾乐队与漫画的工作狂超人</span></div>
            </div>
            <p class="char-bio">乖巧的外表下，用扎实的技术与全力以赴的热情支撑着整个乐队。</p>
            <div class="char-detail">
                <div style="--c:#9977CC;">
                    <div class="char-name-row">
                        <h3>藤 都子</h3>
                        <span class="role-badge">键盘手</span>
                    </div>
                    <p class="char-meta">9月19日 · 16岁 · 155cm · 狗耳</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #9977CC</p>
                    <div class="char-info">
                        <div class="row"><span class="label">身份</span><span>现役漫画家，兼任梦限大MewType的键盘手</span></div>
                        <div class="row"><span class="label">特点</span><span>乖巧的外表下，通过扎实的技术与对任何事都全力以赴的热情支撑着整个乐队</span></div>
                    </div>
                    <p class="char-bio">同时兼顾乐队和漫画家，能够完成超出常人想象的任务量的工作狂超人。</p>
                    <p class="char-origin">姓氏取自文京区小日向四丁目的藤坂；头饰为狗耳。</p>
                </div>
            </div>
        </div>

        <div class="char-card" style="--c:#EE5577;">
            <div class="char-avatar"><img src="${pageContext.request.contextPath}/BangDreamsimg/MewType/yuno.jpg" alt="千石由乃" loading="lazy"></div>
            <div class="char-name-row">
                <h3>千石 由乃</h3>
                <span class="role-badge">DJ · 音控</span>
            </div>
            <p class="char-meta">11月4日 · 151cm · 雪貂耳</p>
            <p class="char-color"><span class="color-dot"></span>代表色 #EE5577</p>
            <div class="char-info">
                <div class="row"><span class="label">定位</span><span>松弛系 DJ 兼音控师</span></div>
                <div class="row"><span class="label">性格</span><span>宅女，外表冷酷、实则重情义</span></div>
            </div>
            <p class="char-bio">作为梦限大音乐的中心，掌控整支乐队的节奏。</p>
            <div class="char-detail">
                <div style="--c:#EE5577;">
                    <div class="char-name-row">
                        <h3>千石 由乃</h3>
                        <span class="role-badge">DJ · 音控</span>
                    </div>
                    <p class="char-meta">11月4日 · 151cm · 雪貂耳</p>
                    <p class="char-color"><span class="color-dot"></span>代表色 #EE5577</p>
                    <div class="char-info">
                        <div class="row"><span class="label">定位</span><span>梦限大MewType的松弛系 DJ 兼音控师，作为梦限大音乐的中心，掌控整支乐队的节奏</span></div>
                        <div class="row"><span class="label">性格</span><span>平时是个不怎么出门的宅女，和人接触时总是冷酷又平淡，但其实也有重情重义的一面</span></div>
                    </div>
                    <p class="char-bio">作为梦限大音乐的中心，掌控整支乐队的节奏；外冷内热的宅女。</p>
                    <p class="char-origin">姓氏取自文京区千石；头饰为雪貂耳。</p>
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
        var lines = Array.prototype.slice.call(document.querySelectorAll('.motto .cn, .motto .jp'));
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
