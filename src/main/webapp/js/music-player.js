(function () {
    try { init(); } catch (e) {}
    function init() {
        var ctx = '';
        try {
            var cs = document.currentScript;
            if (cs && cs.src) { var m = cs.src.indexOf('/js/music-player.js'); if (m >= 0) ctx = cs.src.substring(0, m); }
        } catch (e) {}

        var FALLBACK = [{ cat: '未分类', files: ['绝对不是岚宝宝 - 哈基米Stay With Me (Phonk).mp3', 'monitoring.ogg'] }];

        var KEY = 'bgm.v1';
        var st = { c: null, f: null, t: 0, playing: false, vol: 0.8 };
        try {
            var s = JSON.parse(localStorage.getItem(KEY) || '{}');
            if (s && typeof s === 'object') {
                if (typeof s.c === 'string') st.c = s.c;
                if (typeof s.f === 'string') st.f = s.f;
                if (typeof s.t === 'number') st.t = s.t;
                if (typeof s.playing === 'boolean') st.playing = s.playing;
                if (typeof s.vol === 'number') st.vol = s.vol;
            }
        } catch (e) {}

        var css = '' +
            '#bgm{position:fixed;right:16px;bottom:16px;z-index:9999;font-family:"Segoe UI","Microsoft YaHei",sans-serif}' +
            '#bgm-fab{width:52px;height:52px;border-radius:50%;border:none;cursor:pointer;font-size:22px;color:#fff;background:linear-gradient(135deg,#6ba3c7,#8f7bd0);box-shadow:0 6px 18px rgba(0,0,0,.35);display:flex;align-items:center;justify-content:center}' +
            '#bgm-panel{display:none;position:absolute;right:0;bottom:64px;width:248px;padding:10px 12px;border-radius:14px;background:rgba(30,28,42,.82);border:1px solid rgba(255,255,255,.12);backdrop-filter:blur(10px);color:#eceaf4;box-shadow:0 8px 24px rgba(0,0,0,.4)}' +
            '#bgm.open #bgm-panel{display:block}' +
            '#bgm-title{font-size:13px;font-weight:700;margin-bottom:8px;color:#f0c674}' +
            '#bgm-cat{width:100%;box-sizing:border-box;margin-bottom:8px;padding:6px 8px;border-radius:9px;border:1px solid rgba(255,255,255,.14);background:rgba(40,36,58,.95);color:#eceaf4;font-size:13px;font-family:inherit;outline:none;cursor:pointer}' +
            '#bgm-tracks{list-style:none;margin:0 0 8px;padding:0;max-height:180px;overflow:auto}' +
            '#bgm-tracks li{font-size:13px;padding:7px 9px;border-radius:9px;margin-bottom:5px;cursor:pointer;background:rgba(255,255,255,.06);white-space:nowrap;overflow:hidden;text-overflow:ellipsis}' +
            '#bgm-tracks li:hover{background:rgba(255,255,255,.12)}' +
            '#bgm-tracks li.on{background:linear-gradient(135deg,#6ba3c7,#8f7bd0);color:#fff}' +
            '#bgm-ctrl{display:flex;align-items:center;gap:8px}' +
            '#bgm-ctrl button{flex:0 0 auto;width:34px;height:34px;border-radius:9px;border:none;cursor:pointer;font-size:15px;color:#fff;background:rgba(255,255,255,.14)}' +
            '#bgm-vol{flex:1;width:100%}' +
            '#bgm-hint{font-size:11px;color:#f0c674;margin-top:6px;display:none}';
        var style = document.createElement('style'); style.type = 'text/css'; style.appendChild(document.createTextNode(css)); document.head.appendChild(style);

        var wrap = document.createElement('div'); wrap.id = 'bgm';
        wrap.innerHTML =
            '<div id="bgm-panel">' +
            '<div id="bgm-title">🎵 背景音乐</div>' +
            '<select id="bgm-cat" title="选择分区"></select>' +
            '<ul id="bgm-tracks"></ul>' +
            '<div id="bgm-ctrl">' +
            '<button id="bgm-prev" title="上一首">⏮</button>' +
            '<button id="bgm-play" title="播放/暂停">▶</button>' +
            '<button id="bgm-next" title="下一首">⏭</button>' +
            '<input id="bgm-vol" class="bgm-vol" type="range" min="0" max="1" step="0.01" title="音量">' +
            '</div>' +
            '<div id="bgm-hint">被浏览器拦了自动播放？点一下任意处即可续播</div>' +
            '</div>' +
            '<button id="bgm-fab" title="音乐">🎵</button>';
        document.body.appendChild(wrap);

        var ul = wrap.querySelector('#bgm-tracks');
        var catSel = wrap.querySelector('#bgm-cat');
        var btnPlay = wrap.querySelector('#bgm-play');
        var fab = wrap.querySelector('#bgm-fab');
        var hint = wrap.querySelector('#bgm-hint');
        var vol = wrap.querySelector('#bgm-vol'); vol.value = st.vol;

        var audio = new Audio(); audio.preload = 'auto'; audio.volume = st.vol;

        var CATS = [];            // [{ cat, files:[相对路径] }]
        var TRACKS = [];          // 当前分区的文件路径数组
        var lis = [];
        var cur = 0, curCat = 0;

        // ===== 响度归一化 =====
        var GKEY = 'bgm.gain.v1';
        var gains = {};
        try { gains = JSON.parse(localStorage.getItem(GKEY) || '{}') || {}; } catch (e) { gains = {}; }
        function saveGains() { try { localStorage.setItem(GKEY, JSON.stringify(gains)); } catch (e) {} }

        var TARGET = 0.10;
        var curGain = 1;
        var AC = window.AudioContext || window.webkitAudioContext;
        var actx = null, srcNode = null, gainNode = null, compNode = null, useWA = false;

        function gainFor(i) { var f = gains[TRACKS[i]]; return (typeof f === 'number' && isFinite(f) && f > 0) ? f : 1; }
        function applyGain() {
            curGain = gainFor(cur);
            if (useWA && gainNode) {
                audio.volume = st.vol;
                try { gainNode.gain.setTargetAtTime(curGain, actx.currentTime, 0.05); } catch (e) { gainNode.gain.value = curGain; }
            } else {
                audio.volume = Math.max(0, Math.min(1, st.vol * curGain));
            }
        }
        function ensureGraph() {
            if (actx || !AC) return;
            try {
                actx = new AC();
                srcNode = actx.createMediaElementSource(audio);
                gainNode = actx.createGain();
                compNode = actx.createDynamicsCompressor();
                compNode.threshold.value = -6; compNode.knee.value = 6; compNode.ratio.value = 12;
                compNode.attack.value = 0.003; compNode.release.value = 0.25;
                srcNode.connect(gainNode); gainNode.connect(compNode); compNode.connect(actx.destination);
                useWA = true; applyGain();
            } catch (e) { useWA = false; }
        }
        function resumeCtx() { if (actx && actx.state === 'suspended') { try { actx.resume(); } catch (e) {} } }
        function firstGesture() { ensureGraph(); resumeCtx(); document.removeEventListener('pointerdown', firstGesture, true); document.removeEventListener('keydown', firstGesture, true); }
        document.addEventListener('pointerdown', firstGesture, true);
        document.addEventListener('keydown', firstGesture, true);

        function computeRMS(buffer) {
            var sum = 0, n = 0, chs = buffer.numberOfChannels;
            for (var c = 0; c < chs; c++) {
                var d = buffer.getChannelData(c), step = Math.max(1, Math.floor(d.length / 200000));
                for (var j = 0; j < d.length; j += step) { sum += d[j] * d[j]; n++; }
            }
            return n ? Math.sqrt(sum / n) : 0;
        }
        function analyze(i) {
            var file = TRACKS[i];
            if (!file || !AC || gains[file] !== undefined) return;
            gains[file] = 1;
            fetch(urlOf(i)).then(function (r) { return r.ok ? r.arrayBuffer() : null; }).then(function (buf) {
                if (!buf) { delete gains[file]; return; }
                var tmp = new AC();
                var done = function (decoded) {
                    var rms = computeRMS(decoded);
                    gains[file] = rms > 0 ? Math.max(0.4, Math.min(3, TARGET / rms)) : 1;
                    saveGains(); if (i === cur) applyGain();
                    try { tmp.close(); } catch (e) {}
                };
                var fail = function () { delete gains[file]; saveGains(); try { tmp.close(); } catch (e) {} };
                tmp.decodeAudioData(buf, done, fail);
            }).catch(function () { delete gains[file]; });
        }

        // ===== 工具 =====
        function encodePath(p) { var a = p.split('/'), r = []; for (var i = 0; i < a.length; i++) r.push(encodeURIComponent(a[i])); return r.join('/'); }
        function urlOf(i) { return ctx + '/Music/' + encodePath(TRACKS[i]); }
        function baseName(n) { return n.substring(n.lastIndexOf('/') + 1); }
        function pretty(n) { return baseName(n).replace(/\.[^.]+$/, ''); }
        function mark() { for (var i = 0; i < lis.length; i++) lis[i].className = (i === cur ? 'on' : ''); if (lis[cur] && lis[cur].scrollIntoView) { try { lis[cur].scrollIntoView({ block: 'nearest' }); } catch (e) {} } }
        function save() { try { localStorage.setItem(KEY, JSON.stringify({ c: CATS[curCat] ? CATS[curCat].cat : null, f: TRACKS[cur], t: st.t, playing: st.playing, vol: st.vol })); } catch (e) {} }
        function ui() { btnPlay.textContent = st.playing ? '⏸' : '▶'; }
        function seek(t) { try { if (t > 0 && isFinite(t)) audio.currentTime = t; } catch (e) {} }

        function buildCatBar() {
            catSel.innerHTML = '';
            for (var i = 0; i < CATS.length; i++) { var o = document.createElement('option'); o.value = i; o.textContent = CATS[i].cat + '（' + CATS[i].files.length + '）'; catSel.appendChild(o); }
            catSel.value = curCat;
        }
        function buildList() {
            ul.innerHTML = ''; lis = [];
            TRACKS.forEach(function (file, i) {
                var li = document.createElement('li'); li.textContent = pretty(file); li.title = file;
                li.onclick = function () { load(i, true); };
                ul.appendChild(li); lis.push(li);
            });
        }
        function setCategory(idx, keepPlay) {
            if (!CATS.length) return;
            curCat = ((idx % CATS.length) + CATS.length) % CATS.length;
            TRACKS = CATS[curCat].files;
            cur = 0; st.t = 0;
            buildCatBar(); buildList(); mark();
            if (TRACKS.length) { audio.src = urlOf(0); applyGain(); analyze(0); }
            save();
            if (keepPlay && TRACKS.length) play();
        }
        function load(i, autoplay) {
            if (!TRACKS.length) return;
            cur = ((i % TRACKS.length) + TRACKS.length) % TRACKS.length;
            st.t = 0; audio.src = urlOf(cur); mark(); save();
            applyGain(); analyze(cur);
            if (autoplay) play();
        }
        function play() {
            st.playing = true; ui(); resumeCtx();
            var p = audio.play();
            if (p && p.catch) p.catch(function () { st.playing = false; ui(); if (hint) hint.style.display = 'block'; });
            save();
        }
        function pause() { st.playing = false; audio.pause(); ui(); save(); }
        function toggle() { if (audio.paused) { seek(st.t); play(); } else pause(); }

        audio.addEventListener('loadedmetadata', function () { seek(st.t); });
        audio.addEventListener('timeupdate', function () { st.t = audio.currentTime; });
        audio.addEventListener('ended', function () { load(cur + 1, true); });
        audio.addEventListener('play', function () { if (hint) hint.style.display = 'none'; });

        fab.onclick = function () { wrap.classList.toggle('open'); };
        btnPlay.onclick = toggle;
        wrap.querySelector('#bgm-prev').onclick = function () { load(cur - 1, st.playing); };
        wrap.querySelector('#bgm-next').onclick = function () { load(cur + 1, st.playing); };
        catSel.onchange = function () { setCategory(parseInt(catSel.value, 10), st.playing); };
        vol.oninput = function () { st.vol = parseFloat(vol.value); applyGain(); save(); };

        setInterval(function () { if (st.playing) save(); }, 2000);
        window.addEventListener('pagehide', save);
        window.addEventListener('beforeunload', save);
        document.addEventListener('visibilitychange', function () { if (document.hidden) save(); });

        function normalizeCats(list) {
            var cats = [];
            if (Array.isArray(list)) {
                if (list.length && typeof list[0] === 'string') {
                    cats.push({ cat: '未分类', files: list.slice() });
                } else {
                    list.forEach(function (o) { if (o && Array.isArray(o.files)) cats.push({ cat: String(o.cat || '未分类'), files: o.files.slice() }); });
                }
            }
            cats.forEach(function (c) { c.files.sort(function (a, b) { var x = pretty(a).toLowerCase(), y = pretty(b).toLowerCase(); return x < y ? -1 : x > y ? 1 : 0; }); });
            if (cats.length > 1) {
                var all = []; cats.forEach(function (c) { all = all.concat(c.files); });
                cats.unshift({ cat: '⭐ 全部', files: all });
            }
            return cats;
        }

        function start() {
            if (!CATS.length) { wrap.style.display = 'none'; return; }
            var ci = 0;
            if (st.c) { for (var i = 0; i < CATS.length; i++) { if (CATS[i].cat === st.c) { ci = i; break; } } }
            curCat = ci; TRACKS = CATS[curCat].files;
            var k = st.f ? TRACKS.indexOf(st.f) : -1;
            cur = k >= 0 ? k : 0;
            buildCatBar(); buildList(); mark(); ui();
            if (TRACKS.length) { audio.src = urlOf(cur); applyGain(); analyze(cur); }
            if (st.playing && TRACKS.length) {
                play();
                var resumeOnce = function () {
                    if (!audio.paused) { detach(); return; }
                    resumeCtx(); seek(st.t); var p = audio.play(); if (p && p.catch) p.catch(function () {});
                    detach();
                };
                function detach() { document.removeEventListener('click', resumeOnce, true); }
                document.addEventListener('click', resumeOnce, true);
            }
        }

        fetch(ctx + '/music?list=1').then(function (r) { return r.ok ? r.json() : []; })
            .then(function (list) { CATS = normalizeCats(list); start(); })
            .catch(function () { CATS = FALLBACK; start(); });
    }
})();