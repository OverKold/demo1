/* 通用表情选择器：绑定「😊按钮 + 面板 + 分类页签 + 网格」，点表情回调 send(cat, file) */
window.StickerPicker = (function () {
    function $(id) { return document.getElementById(id); }
    function attach(o) {
        var toggle = $(o.toggle), panel = $(o.panel), tabs = $(o.tabs), grid = $(o.grid);
        if (!toggle || !panel || !tabs || !grid) return;
        var loaded = false, cats = null;

        function firstFrame(cv, src) {
            var im = new Image();
            im.onload = function () {
                var w = 52, h = 52, dpr = window.devicePixelRatio || 1;
                cv.width = Math.round(w * dpr); cv.height = Math.round(h * dpr);
                var g = cv.getContext('2d'), s = Math.min(w / im.width, h / im.height);
                var dw = im.width * s, dh = im.height * s;
                g.drawImage(im, (w - dw) / 2 * dpr, (h - dh) / 2 * dpr, dw * dpr, dh * dpr);
            };
            im.src = src;
        }
        function close() { panel.style.display = 'none'; }
        function show(cat) {
            var ts = tabs.querySelectorAll('.sp-tab');
            for (var i = 0; i < ts.length; i++) ts[i].classList.toggle('on', ts[i].textContent === cat);
            grid.innerHTML = '';
            var files = (cats && cats[cat]) || [];
            if (!files.length) { grid.innerHTML = '<div class="sp-empty">该分类暂无表情</div>'; return; }
            files.forEach(function (item) {
                var src = o.ctx + '/QQimgs/' + encodeURIComponent(cat) + '/' + encodeURIComponent(item.n), el;
                if (item.a) { el = document.createElement('canvas'); firstFrame(el, src); }
                else { el = document.createElement('img'); el.src = src; el.loading = 'lazy'; }
                el.alt = item.n; el.title = item.n;
                el.onclick = function () { o.send(cat, item.n); close(); };
                grid.appendChild(el);
            });
        }
        function load() {
            grid.innerHTML = '<div class="sp-empty">加载中…</div>';
            fetch(o.ctx + '/chat?stickers=1').then(function (r) { return r.json(); }).then(function (data) {
                cats = data; loaded = true; tabs.innerHTML = '';
                var keys = Object.keys(data);
                if (!keys.length) { grid.innerHTML = '<div class="sp-empty">还没有表情包</div>'; return; }
                keys.forEach(function (cat) {
                    var t = document.createElement('span'); t.className = 'sp-tab'; t.textContent = cat;
                    t.onclick = function () { show(cat); };
                    tabs.appendChild(t);
                });
                show(keys[0]);
            }).catch(function () { grid.innerHTML = '<div class="sp-empty">加载失败</div>'; });
        }
        toggle.onclick = function () {
            var hidden = (panel.style.display === 'none' || panel.style.display === '');
            panel.style.display = hidden ? 'flex' : 'none';
            if (hidden && !loaded) load();
        };
    }
    return { attach: attach };
})();