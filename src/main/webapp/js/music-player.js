(function () {
    try { init(); } catch (e) {}
    function init() {
        // 从脚本自身 URL 推导 contextPath，最稳（各子目录页面都能算对）
        var ctx = '';
        try {
            var cs = document.currentScript;
            if (cs && cs.src) { var m = cs.src.indexOf('/js/music-player.js'); if (m >= 0) ctx = cs.src.substring(0, m); }
        } catch (e) {}

        // 曲库：文件名对应 webapp/Music 下的真实文件（可继续往数组里加）
        var TRACKS = [
            { name: '哈基米 · Stay With Me (Phonk)', file: '绝对不是岚宝宝 - 哈基米Stay With Me (Phonk).mp3' },
            { name: 'Monitoring', file: 'monitoring.ogg' }
        ];
        function urlOf(i) { return ctx + '/Music/' + encodeURIComponent(TRACKS[i].file); }

        var KEY = 'bgm.v1';
        var st = { i: 0, t: 0, playing: false, vol: 0.8 };
        try {
            var s = JSON.parse(localStorage.getItem(KEY) || '{}');
            if (s && typeof s === 'object') {
                if (typeof s.i === 'number' && TRACKS[s.i]) st.i = s.i;
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

        var audio = new Audio(); audio.preload = 'auto'; audio.volume = st.vol;

        var ul = wrap.querySelector('#bgm-tracks');
        var lis = [];
        TRACKS.forEach(function (t, i) {
            var li = document.createElement('li'); li.textContent = t.name; li.title = t.name;
            li.onclick = function () { load(i, true); };
            ul.appendChild(li); lis.push(li);
        });
        var btnPlay = wrap.querySelector('#bgm-play');
        var fab = wrap.querySelector('#bgm-fab');
        var hint = wrap.querySelector('#bgm-hint');

        function mark() { for (var i = 0; i < lis.length; i++) lis[i].className = (i === st.i ? 'on' : ''); }
        function save() { try { localStorage.setItem(KEY, JSON.stringify({ i: st.i, t: st.t, playing: st.playing, vol: st.vol })); } catch (e) {} }
        function ui() { btnPlay.textContent = st.playing ? '⏸' : '▶'; }
        function seek(t) { try { if (t > 0 && isFinite(t)) audio.currentTime = t; } catch (e) {} }
        function load(i, autoplay) {
            st.i = (i + TRACKS.length) % TRACKS.length; st.t = 0;
            audio.src = urlOf(st.i); mark(); save();
            if (autoplay) play();
        }
        function play() {
            st.playing = true; ui();
            var p = audio.play();
            if (p && p.catch) p.catch(function () { st.playing = false; ui(); if (hint) hint.style.display = 'block'; });
            save();
        }
        function pause() { st.playing = false; audio.pause(); ui(); save(); }
        function toggle() { if (audio.paused) { seek(st.t); play(); } else pause(); }

        audio.addEventListener('loadedmetadata', function () { seek(st.t); });
        audio.addEventListener('timeupdate', function () { st.t = audio.currentTime; });
        audio.addEventListener('ended', function () { load(st.i + 1, true); });
        audio.addEventListener('play', function () { if (hint) hint.style.display = 'none'; });

        fab.onclick = function () { wrap.classList.toggle('open'); };
        btnPlay.onclick = toggle;
        wrap.querySelector('#bgm-prev').onclick = function () { load(st.i - 1, st.playing); };
        wrap.querySelector('#bgm-next').onclick = function () { load(st.i + 1, st.playing); };
        var vol = wrap.querySelector('#bgm-vol'); vol.value = st.vol;
        vol.oninput = function () { st.vol = parseFloat(vol.value); audio.volume = st.vol; save(); };

        setInterval(function () { if (st.playing) save(); }, 2000);
        window.addEventListener('pagehide', save);
        window.addEventListener('beforeunload', save);
        document.addEventListener('visibilitychange', function () { if (document.hidden) save(); });

        // 初始化：定位到上次的曲目；若上次在播则尝试续播
        mark(); ui(); audio.src = urlOf(st.i);
        if (st.playing) {
            play();
            var resumeOnce = function () {
                if (!audio.paused) { detach(); return; }
                seek(st.t); var p = audio.play(); if (p && p.catch) p.catch(function () {});
                detach();
            };
            function detach() { document.removeEventListener('click', resumeOnce, true); }
            document.addEventListener('click', resumeOnce, true);
        }
    }
})();