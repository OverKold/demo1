(function () {
    var SELF = document.currentScript ? document.currentScript.src : '';
    var CTX = SELF.replace(/\/js\/bdav\.js(\?.*)?$/, '');
    // 每个头像只写脸的位置 '水平% 垂直%'（把该点放到圆框中心）；没列的用 DEF
    var FACE = {
        'AveMujica/Saki.jpg': '56% 30%',
        'AveMujica/htn.jpg': '56% 32%',
        'AveMujica/mtm.jpg': '56% 26%',
        'AveMujica/tmls.jpg': '55% 32%',
        'MewType/arl.jpg': '68% 32%',
        'MewType/tdz.jpg': '60% 30%',
        'Millsage/mahoro.jpg': '50% 32%',
        '一家Dumbrock/yomogi.jpg': '42% 27%',
        '一家Dumbrock/miku.jpg': '60% 26%'
    };
    var DEF = '50% 25%';
    var SPAN = 0.45;
    var OUT = 160;
    var cache = {};

    function srcUrl(p) { return CTX + '/BangDreamsimg/' + p.split('/').map(encodeURIComponent).join('/'); }

    function draw(el, path, pos) {
        var rec = cache[path];
        if (!rec || !rec.img || !rec.img.complete || !rec.img.naturalWidth) return;
        var img = rec.img, iw = img.naturalWidth, ih = img.naturalHeight;
        var s = Math.min(iw, ih) * SPAN;
        var a = (pos || DEF).split(' ');
        var fx = parseFloat(a[0]) / 100, fy = parseFloat(a[1]) / 100;
        var sx = Math.max(0, Math.min(iw - s, iw * fx - s / 2));
        var sy = Math.max(0, Math.min(ih - s, ih * fy - s / 2));
        var key = path + '|' + pos + '|' + OUT;
        var data = cache[key];
        if (!data) {
            var cv = document.createElement('canvas');
            cv.width = cv.height = OUT;
            var cx = cv.getContext('2d');
            cx.imageSmoothingEnabled = true;
            cx.imageSmoothingQuality = 'high';
            cx.drawImage(img, sx, sy, s, s, 0, 0, OUT, OUT);
            data = cv.toDataURL('image/png');
            cache[key] = data;
        }
        el.style.backgroundImage = 'url(' + data + ')';
        el.style.backgroundSize = 'cover';
        el.style.backgroundPosition = 'center';
    }

    function repaint(path) {
        var els = document.querySelectorAll('[data-av="' + path + '"]');
        for (var i = 0; i < els.length; i++) draw(els[i], path, FACE[path] || DEF);
    }

    function paint(el, path) {
        if (!el || !path) return;
        el.setAttribute('data-av', path);
        var pos = FACE[path] || DEF;
        var rec = cache[path];
        if (!rec) {
            rec = cache[path] = { img: new Image(), url: srcUrl(path) };
            rec.img.onload = function () { repaint(path); };
            rec.img.src = rec.url;
        }
        draw(el, path, pos);
    }

    // 名字 -> 头像 映射（来自 /online，全站共享）
    var MAP = {};
    function refreshMap() {
        try {
            fetch(CTX + '/online', { cache: 'no-store' }).then(function (r) { return r.json(); }).then(function (list) {
                if (!Array.isArray(list)) return;
                var m = {};
                list.forEach(function (it) {
                    var n = (typeof it === 'string') ? it : it.n;
                    var av = (typeof it === 'string') ? '' : (it.av || '');
                    if (n) m[n] = av;
                });
                MAP = m;
            }).catch(function () {});
        } catch (e) {}
    }
    function byName(name) {
        if (!name) return '';
        var av = MAP[name];
        if (av) return av;
        try {
            if (name === (sessionStorage.getItem('visitorName') || '')) return localStorage.getItem('visitorAvatar') || '';
        } catch (e) {}
        return '';
    }

    // 生成头像圆片：按名字查映射，查不到显示默认 🙂
    function badge(name, size) {
        var s = size || 28;
        var el = document.createElement('span');
        el.style.cssText = 'display:inline-block;width:' + s + 'px;height:' + s + 'px;border-radius:50%;overflow:hidden;flex:0 0 auto;vertical-align:middle;background:#3a3746 no-repeat center/cover;';
        var av = byName(name);
        if (av) {
            paint(el, av);
        } else {
            el.style.display = 'inline-flex';
            el.style.alignItems = 'center';
            el.style.justifyContent = 'center';
            el.style.fontSize = Math.round(s * 0.58) + 'px';
            el.textContent = '🙂';
        }
        return el;
    }

    refreshMap();
    setInterval(refreshMap, 5000);
    window.addEventListener('focus', refreshMap);

    window.BDAv = { paint: paint, badge: badge, byName: byName, refreshMap: refreshMap, FACE: FACE, DEF: DEF };
})();