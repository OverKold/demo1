(function () {
    try {
        var path = decodeURIComponent(location.pathname);
        var bi = path.indexOf('/Bangdream/');
        var si = path.indexOf('/表情包目录/');
        var gi = path.indexOf('/游戏/');
        var ctx, page;
        if (bi >= 0) {
            ctx = path.substring(0, bi);
            var file = path.substring(path.lastIndexOf('/') + 1).replace(/\.jsp$/i, '');
            var names = {
                'Mygo': 'MyGO!!!!!', 'Avemujica': 'Ave Mujica', 'MewType': '梦限大MewType',
                'millsage': 'millsage', '一家DumbRock': '一家DumbRock'
            };
            page = names[file] || file;
        } else if (si >= 0) {
            ctx = path.substring(0, si);
            var name2 = path.substring(path.lastIndexOf('/') + 1).replace(/\.jsp$/i, '');
            if (name2 === '表情包浏览') {
                var cat = '熊喵喵';
                var m = /[?&]cat=([^&]*)/.exec(location.search);
                if (m) { try { cat = decodeURIComponent(m[1].replace(/\+/g, ' ')); } catch (e) {} }
                page = '表情包·' + cat;
            } else if (name2 === '收藏表情包') {
                page = '表情包收藏';
            } else {
                page = '表情包';
            }
        } else if (gi >= 0) {
            ctx = path.substring(0, gi);
            var gname = path.substring(path.lastIndexOf('/') + 1).replace(/\.jsp$/i, '');
            page = (gname === '斗地主') ? '斗地主🃏' : gname;
        } else {
            return;
        }
        function beat() {
            var visitor = sessionStorage.getItem('visitorName') || '';
            if (!visitor) return;
            fetch(ctx + '/online?name=' + encodeURIComponent(visitor) + '&page=' + encodeURIComponent(page))
                .catch(function () {});
        }
        beat();
        setInterval(beat, 10000);
    } catch (e) {}
})();
