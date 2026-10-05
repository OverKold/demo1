<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>五子棋 · 联机房间</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sticker-picker.css">
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; padding: 20px 16px 46px; min-height: 100vh; color: #eceaf4; font-family: "Segoe UI", "Microsoft YaHei", sans-serif; background: linear-gradient(160deg, #241f31, #2e2a3d 60%, #262233); }
        h1 { margin: 6px 0 2px; font-size: 26px; text-align: center; }
        .sub { margin: 0 0 18px; color: #b7b4c6; font-size: 13px; text-align: center; }
        .lobby { max-width: 960px; margin: 0 auto 16px; padding: 14px 16px; border-radius: 14px; background: rgba(255,255,255,.06); border: 1px solid rgba(255,255,255,.10); }
        .mh { margin-bottom: 8px; color: #f0c674; font-size: 13px; }
        .roomlist { margin: 0; padding: 0; list-style: none; display: flex; flex-direction: column; gap: 6px; }
        .rl-item { display: flex; align-items: center; justify-content: space-between; gap: 10px; padding: 8px 12px; border-radius: 10px; background: rgba(255,255,255,.05); font-size: 14px; }
        .rl-meta { color: #b7b4c6; font-size: 12px; }
        .rl-empty { padding: 6px; color: #b7b4c6; font-size: 13px; text-align: center; }
        .rl-join { padding: 6px 14px; border: none; border-radius: 8px; color: #fff; font-size: 13px; cursor: pointer; background: linear-gradient(135deg,#6ba3c7,#8f7bd0); }
        .rl-join:disabled { opacity: .45; cursor: not-allowed; }
        .msgs { height: 150px; overflow: auto; padding: 8px 10px; border-radius: 10px; background: rgba(0,0,0,.18); }
        .rmsg { margin-bottom: 5px; font-size: 13px; line-height: 1.5; }
        .rmsg .rw { margin-right: 4px; color: #8fc0e0; font-weight: 600; }
        .rmsg.me .rw { color: #8fd0a0; }
        .back { display: inline-block; margin: 6px 0 2px; padding: 8px 16px; border-radius: 999px; border: 1px solid rgba(143,192,224,.4); background: rgba(143,192,224,.14); color: #bfe0f2; font-size: 16px; font-weight: 700; text-decoration: none; }
        .back:hover { background: rgba(143,192,224,.26); }
        .rmsg.empty { margin-top: 52px; color: #b7b4c6; text-align: center; }
        .chatrow { display: flex; gap: 8px; margin-top: 8px; }
        .chatrow input { flex: 1; padding: 9px 12px; font-size: 14px; color: #fff; border: 2px solid rgba(255,255,255,.15); border-radius: 10px; background: rgba(255,255,255,.08); outline: none; }
        .chatrow input:focus { border-color: #6ba3c7; }
        .chatrow button { padding: 0 16px; font-size: 14px; font-weight: 600; color: #fff; border: none; border-radius: 10px; cursor: pointer; background: linear-gradient(135deg,#6ba3c7,#8f7bd0); }
        .stk-btn { width: 42px; padding: 0; font-size: 18px; }
        .board-wrap { display: flex; flex-wrap: wrap; gap: 16px; margin-top: 10px; }
        #board { flex: 0 0 auto; max-width: 100%; border-radius: 10px; background: #d8a75b; cursor: pointer; touch-action: manipulation; }
        .side { flex: 1; min-width: 250px; }
        .status { margin-bottom: 10px; min-height: 20px; font-size: 14px; }
        .btns { display: flex; gap: 8px; margin-bottom: 10px; }
        .btns button { padding: 8px 14px; border: none; border-radius: 9px; color: #fff; font-size: 13px; cursor: pointer; background: rgba(255,255,255,.14); }
        .members { margin: 0 0 12px; padding: 0; list-style: none; font-size: 13px; }
        .members li { margin-bottom: 4px; padding: 4px 8px; border-radius: 8px; background: rgba(255,255,255,.05); }
        .tip { color: #f0c674; font-size: 13px; align-self: center; }
        .home { text-align: center; margin: 20px 0 8px; }
        .home a { color: #8fc0e0; text-decoration: none; font-size: 15px; font-weight: 600; }
        .home a:hover { color: #bfe0f2; text-decoration: underline; }
        .ghost { background: rgba(255,255,255,.14) !important; }
    </style>
    <script src="${pageContext.request.contextPath}/js/sticker-picker.js"></script>
</head>
<body>
<h1>⚫ 五子棋 · 联机房间</h1>
<p class="sub">两位真人入座后自动开局（黑先），连成五子获胜；第三人进入为观战。</p>

<div class="lobby">
    <div class="mh">🔥 进行中的房间（点「进入」直接加入）</div>
    <ul class="roomlist" id="roomList"><li class="rl-empty">加载中…</li></ul>
</div>

<div class="lobby">
    <div class="mh">📣 大厅喊话 · 找人下棋（全服可见，和乐队主页聊天互通）</div>
    <div class="msgs" id="lobbyMsgs"><div class="rmsg empty">还没有人喊话</div></div>
    <div class="sticker-panel" id="lobbyStickerPanel">
        <div class="sp-tabs" id="lobbySpTabs"></div>
        <div class="sp-grid" id="lobbySpGrid"><div class="sp-empty">加载中…</div></div>
    </div>
    <div class="chatrow">
        <button id="lobbySticker" type="button" class="stk-btn" title="发表情">😊</button>
        <input id="lobbyInput" type="text" maxlength="200" placeholder="喊话：来个五子棋的，房间号 xxx…" autocomplete="off">
        <button id="lobbySend">发送</button>
    </div>
</div>

<div class="lobby">
    <div class="chatrow">
        <input id="roomId" type="text" maxlength="32" placeholder="输入房间号，如：a" autocomplete="off">
        <button id="btnJoin">进入房间</button>
        <button id="btnBot" type="button" class="ghost">🤖 加机器人</button>
        <button id="btnLeave" type="button" class="ghost">🚪 退出此对局</button>
        <span class="tip" id="roomTip"></span>
    </div>
    <div class="board-wrap">
        <canvas id="board" width="480" height="480"></canvas>
        <div class="side">
            <div class="mh">对局状态</div>
            <div class="status" id="status">未加入房间</div>
            <div class="btns"><button id="btnSound" type="button">🔊 落子声：开</button></div>
            <div class="btns">
                <button id="btnUndo" type="button" style="display:none">↩ 悔棋</button>
                <button id="btnUndoYes" type="button" style="display:none">✅ 同意悔棋</button>
                <button id="btnUndoNo" type="button" style="display:none">❌ 拒绝</button>
            </div>
            <div class="btns">
                <button id="btnResign" type="button" style="display:none">认输</button>
                <button id="btnRestart" type="button" style="display:none">重开（换先手）</button>
            </div>
            <div class="mh">房间成员</div>
            <ul class="members" id="memberList"></ul>
            <div class="mh">房间聊天</div>
            <div class="msgs" id="roomMsgs"><div class="rmsg empty">还没有聊天</div></div>
            <div class="sticker-panel" id="roomStickerPanel">
                <div class="sp-tabs" id="roomSpTabs"></div>
                <div class="sp-grid" id="roomSpGrid"><div class="sp-empty">加载中…</div></div>
            </div>
            <div class="chatrow">
                <button id="roomSticker" type="button" class="stk-btn" title="发表情">😊</button>
                <input id="roomInput" type="text" maxlength="200" placeholder="和房间队友聊天…" autocomplete="off">
                <button id="roomSend">发送</button>
            </div>
        </div>
    </div>
</div>

<div class="home"><a href="${pageContext.request.contextPath}/乐队主页.jsp">← 返回乐队主页</a></div>

<script>
    (function () {
        var ctx = '${pageContext.request.contextPath}';
        var N = 15, CELL = 32, PAD = 16;
        function $(id) { return document.getElementById(id); }
        function myName() { return (sessionStorage.getItem('visitorName') || '').trim(); }
        function ensureName() { var n = myName(); if (!n) { n = (prompt('给自己起个名字：', '') || '').trim(); if (n) sessionStorage.setItem('visitorName', n); } return n; }

        var room = { id: '' }, last = null, timer = null;
        function setTip(t) { $('roomTip').textContent = t || ''; }
        function body() { var b = new URLSearchParams(); b.set('id', room.id); b.set('name', myName()); return b; }

        function joinRoom() {
            if (!ensureName()) { alert('先取个名字才能进房间'); return; }
            var id = ($('roomId').value || '').trim();
            if (!id) { alert('请输入房间号'); return; }
            room.id = id; prevLast = undefined;
            if (!timer) { poll(); timer = setInterval(poll, 1500); } else poll();
            loadRooms();
        }
        function leaveRoom() {
            if (!room.id) return;
            var b = body(); b.set('action', 'leave');
            fetch(ctx + '/gomoku', { method: 'POST', body: b }).then(function () {
                if (timer) { clearInterval(timer); timer = null; }
                room.id = ''; last = null; draw();
                $('memberList').innerHTML = ''; renderMsgs([]);
                $('status').textContent = '未加入房间';
                $('btnResign').style.display = 'none'; $('btnRestart').style.display = 'none';
            }).catch(function () {});
        }
        function poll() {
            if (!room.id || !myName()) return;
            fetch(ctx + '/gomoku?id=' + encodeURIComponent(room.id) + '&name=' + encodeURIComponent(myName()))
                .then(function (r) { return r.json(); })
                .then(function (d) { if (d && !d.error) { last = d; render(d); } })
                .catch(function () {});
        }
        function act(o) {
            if (!room.id) { alert('请先进入房间'); return; }
            var b = body();
            Object.keys(o).forEach(function (k) { b.set(k, o[k]); });
            fetch(ctx + '/gomoku', { method: 'POST', body: b }).then(function (r) { return r.json(); }).then(function (j) {
                if (j && j.ok === false) setTip('⚠ ' + (j.error || '操作失败'));
                else if (j && j.need) setTip('⏳ 已发送悔棋请求，等待对方同意…');
                else if (j && j.undone) setTip('↩ 已悔棋');
                else if (j && j.cancel) setTip('已取消悔棋请求');
                else setTip('');
                poll();
            }).catch(function () {});
        }

        function stone(g, x, y, black, scale) {
            var cx = PAD + x * CELL, cy = PAD + y * CELL, r = (CELL / 2 - 2) * (scale == null ? 1 : scale);
            g.beginPath(); g.arc(cx, cy, r, 0, Math.PI * 2);
            g.fillStyle = black ? '#1b1b1b' : '#f6f3ec'; g.fill();
            g.lineWidth = 1; g.strokeStyle = black ? '#000' : '#bdb8ab'; g.stroke();
        }
        var anim = null, animRaf = null, prevLast, soundOn = localStorage.getItem('gomoku_sound') !== '0', audioCtx = null;
        function ensureAudio() { if (!audioCtx) { try { audioCtx = new (window.AudioContext || window.webkitAudioContext)(); } catch (e) { } } if (audioCtx && audioCtx.state === 'suspended') audioCtx.resume(); }
        function playPlace() {
            if (!soundOn) return; ensureAudio(); if (!audioCtx) return;
            var t = audioCtx.currentTime, o = audioCtx.createOscillator(), gain = audioCtx.createGain();
            o.type = 'triangle'; o.frequency.setValueAtTime(380, t); o.frequency.exponentialRampToValueAtTime(120, t + 0.09);
            gain.gain.setValueAtTime(0.0001, t); gain.gain.exponentialRampToValueAtTime(0.5, t + 0.006); gain.gain.exponentialRampToValueAtTime(0.0001, t + 0.2);
            o.connect(gain); gain.connect(audioCtx.destination); o.start(t); o.stop(t + 0.22);
        }
        function startMoveAnim(x, y) { anim = { x: x, y: y, start: performance.now() }; if (!animRaf) tickAnim(); }
        function tickAnim() { animRaf = requestAnimationFrame(function () { if (!anim) { animRaf = null; return; } if (performance.now() - anim.start >= 320) { anim = null; animRaf = null; draw(); return; } draw(); tickAnim(); }); }
        function animScale() { if (!anim) return 1; var p = (performance.now() - anim.start) / 320; if (p > 1) p = 1; return 1 + 0.9 * Math.pow(1 - p, 2.4); }
        function draw() {
            var cv = $('board'), g = cv.getContext('2d');
            g.clearRect(0, 0, cv.width, cv.height);
            g.strokeStyle = 'rgba(92,60,18,.8)'; g.lineWidth = 1;
            for (var i = 0; i < N; i++) {
                var p = PAD + i * CELL;
                g.beginPath(); g.moveTo(PAD, p + .5); g.lineTo(PAD + (N - 1) * CELL, p + .5); g.stroke();
                g.beginPath(); g.moveTo(p + .5, PAD); g.lineTo(p + .5, PAD + (N - 1) * CELL); g.stroke();
            }
            if (!last) return;
            var b = last.board || '', lx = last.last ? last.last[0] : -1, ly = last.last ? last.last[1] : -1;
            if (lx >= 0 && ly >= 0) { g.fillStyle = 'rgba(240,198,116,.30)'; g.beginPath(); g.arc(PAD + lx * CELL, PAD + ly * CELL, CELL / 2 - 1, 0, Math.PI * 2); g.fill(); }
            for (var y = 0; y < N; y++) for (var x = 0; x < N; x++) {
                var v = b.charAt(y * N + x); if (v !== '1' && v !== '2') continue;
                stone(g, x, y, v === '1', (anim && anim.x === x && anim.y === y) ? animScale() : 1);
            }
            if (lx >= 0 && ly >= 0) { g.strokeStyle = '#e05a6a'; g.lineWidth = 2; g.beginPath(); g.arc(PAD + lx * CELL, PAD + ly * CELL, CELL / 2 - 3, 0, Math.PI * 2); g.stroke(); }
            if (last.line && last.line.length >= 4) {
                g.beginPath(); g.strokeStyle = '#f0c674'; g.lineWidth = 3;
                g.moveTo(PAD + last.line[0] * CELL, PAD + last.line[1] * CELL);
                for (var k = 2; k + 1 < last.line.length; k += 2) g.lineTo(PAD + last.line[k] * CELL, PAD + last.line[k + 1] * CELL);
                g.stroke();
            }
        }
        function render(st) {
            var l = st.last || [-1, -1], key = (l[0] >= 0 && l[1] >= 0) ? (l[0] + ',' + l[1]) : '';
            if (prevLast !== undefined && key && key !== prevLast) { startMoveAnim(l[0], l[1]); playPlace(); }
            prevLast = key;
            draw();
            var name = myName(), ul = $('memberList'); ul.innerHTML = '';
            (st.members || []).forEach(function (m) { var li = document.createElement('li'); li.textContent = m + (m === name ? '（你）' : ''); ul.appendChild(li); });
            renderMsgs(st.msg || []);
            var black = st.black || '空位（等待入座）', white = st.white || '空位（等待入座）', s;
            if (st.phase === 0) s = '⚫ ' + black + '　⚪ ' + white + (st.black && st.white ? '　—— 黑先，点棋盘落子即开局' : '　—— 还需一位真人入座');
            else if (st.phase === 1) s = '轮到 ' + (st.turn === 1 ? '⚫ ' + black : '⚪ ' + white) + (st.myColor !== 0 && st.myColor === st.turn ? '（你）' : '');
            else s = st.winner === 0 ? '本局结束 · 平局（棋盘下满）' : (st.winner === 1 ? '🏆  ' + black + ' 获胜！' : '🏆 ⚪ ' + white + ' 获胜！');
            $('status').textContent = s;
            var undoBy = st.undoBy || '';
            var isP = st.myColor !== 0, hasUndo = (st.phase === 1 || st.phase === 2) && isP;
            $('btnUndo').style.display = (hasUndo && !undoBy) ? '' : 'none';
            var oppAsk = undoBy && undoBy !== name;
            $('btnUndoYes').style.display = (oppAsk && isP) ? '' : 'none';
            $('btnUndoNo').style.display = (oppAsk || (undoBy && undoBy === name)) ? '' : 'none';
            $('btnUndoNo').textContent = (undoBy === name) ? '↩ 取消请求' : '❌ 拒绝';
            if (undoBy === name) $('status').textContent = s + '　⏳ 已向 ' + (st.myColor === 1 ? st.white : st.black) + ' 请求悔棋，等待同意…';
            else if (oppAsk) $('status').textContent = s + '　⏳ ' + undoBy + ' 想悔棋，是否同意？';
            $('btnResign').style.display = (st.phase === 1 && st.myColor !== 0) ? '' : 'none';
            $('btnRestart').style.display = (st.phase === 2 && st.myColor !== 0) ? '' : 'none';
        }
        function stkImg(sc, sf) { var i = document.createElement('img'); i.src = ctx + '/QQimgs/' + encodeURIComponent(sc) + '/' + encodeURIComponent(sf); i.alt = sf; i.style.cssText = 'max-width:90px;max-height:90px;vertical-align:middle;border-radius:6px'; return i; }
        function fillMsgs(box, list, emptyText) {
            var atBottom = box.scrollHeight - box.scrollTop - box.clientHeight < 30, my = myName();
            box.innerHTML = '';
            if (!list || !list.length) { box.innerHTML = '<div class="rmsg empty">' + emptyText + '</div>'; return; }
            list.forEach(function (m) {
                var d = document.createElement('div'); d.className = 'rmsg' + (m.n === my ? ' me' : '');
                var w = document.createElement('span'); w.className = 'rw'; w.textContent = m.n + '：';
                var t = document.createElement('span');
                if (m.sf) t.appendChild(stkImg(m.sc, m.sf)); else t.textContent = m.t;
                d.appendChild(w); d.appendChild(t); box.appendChild(d);
            });
            if (atBottom) box.scrollTop = box.scrollHeight;
        }
        function renderMsgs(list) { fillMsgs($('roomMsgs'), list, '还没有聊天'); }

        $('board').addEventListener('click', function (e) {
            var cv = $('board'), rect = cv.getBoundingClientRect();
            var mx = (e.clientX - rect.left) * (cv.width / rect.width);
            var my = (e.clientY - rect.top) * (cv.height / rect.height);
            var x = Math.round((mx - PAD) / CELL), y = Math.round((my - PAD) / CELL);
            if (x < 0 || y < 0 || x >= N || y >= N) return;
            act({ action: 'move', x: x, y: y });
        });

        function loadRooms() {
            fetch(ctx + '/gomoku?list=1').then(function (r) { return r.json(); }).then(function (list) {
                var ul = $('roomList'); ul.innerHTML = '';
                if (!list || !list.length) { ul.innerHTML = '<li class="rl-empty">暂无房间，输入房间号即可开一个</li>'; return; }
                list.forEach(function (rm) {
                    var li = document.createElement('li'); li.className = 'rl-item';
                    var info = document.createElement('span');
                    var b = document.createElement('b'); b.textContent = rm.id;
                    var meta = document.createElement('span'); meta.className = 'rl-meta';
                    var ph = rm.phase === 1 ? '对局中' : rm.phase === 2 ? '已结束' : '等待入座';
                    meta.textContent = ' ' + ph + ' · ' + ((rm.players && rm.players.length) ? rm.players.join('、') : rm.members + ' 人');
                    info.appendChild(b); info.appendChild(meta); li.appendChild(info);
                    var btn = document.createElement('button'); btn.className = 'rl-join';
                    if (rm.canJoin) { btn.textContent = '进入'; btn.onclick = function () { $('roomId').value = rm.id; joinRoom(); }; }
                    else { btn.textContent = '满/进行中'; btn.disabled = true; }
                    li.appendChild(btn); ul.appendChild(li);
                });
            }).catch(function () {});
        }

        function loadLobby() { fetch(ctx + '/chat').then(function (r) { return r.json(); }).then(function (l) { fillMsgs($('lobbyMsgs'), l, '还没有人喊话'); }).catch(function () {}); }
        function sendLobby() {
            var n = ensureName(); if (!n) { alert('先取个名字才能喊话'); return; }
            var inp = $('lobbyInput'), text = (inp.value || '').trim(); if (!text) return;
            var b = new URLSearchParams(); b.set('name', n); b.set('text', text);
            fetch(ctx + '/chat', { method: 'POST', body: b }).then(function () { inp.value = ''; loadLobby(); }).catch(function () {});
        }
        function sendLobbySticker(cat, file) {
            var n = ensureName(); if (!n) { alert('先取个名字才能发表情'); return; }
            var b = new URLSearchParams(); b.set('name', n); b.set('scat', cat); b.set('sfile', file);
            fetch(ctx + '/chat', { method: 'POST', body: b }).then(loadLobby).catch(function () {});
        }

        $('btnJoin').onclick = joinRoom;
        $('btnBot').onclick = function () { act({ action: 'addbot' }); };
        $('btnLeave').onclick = function () {
            leaveRoom();
            var el = $('roomList'); if (el && el.scrollIntoView) el.scrollIntoView({ behavior: 'smooth' });
        };
        $('btnResign').onclick = function () { if (confirm('确定认输？')) act({ action: 'resign' }); };
        $('btnRestart').onclick = function () { act({ action: 'restart' }); };
        $('btnUndo').onclick = function () { act({ action: 'undo' }); };
        $('btnUndoYes').onclick = function () { act({ action: 'undoYes' }); };
        $('btnUndoNo').onclick = function () { act({ action: 'undoNo' }); };
        $('roomSend').onclick = function () {
            if (!room.id) { alert('请先进入房间'); return; }
            var i = $('roomInput'), t = (i.value || '').trim(); if (!t) return;
            act({ action: 'chat', text: t }); i.value = '';
        };
        $('roomInput').addEventListener('keydown', function (e) { if (e.key === 'Enter') $('roomSend').onclick(); });
        $('lobbySend').onclick = sendLobby;
        $('lobbyInput').addEventListener('keydown', function (e) { if (e.key === 'Enter') sendLobby(); });

        function updateSoundBtn() { var b = $('btnSound'); if (b) b.textContent = soundOn ? '🔊 落子声：开' : '🔇 落子声：关'; }
        $('btnSound').onclick = function () { soundOn = !soundOn; localStorage.setItem('gomoku_sound', soundOn ? '1' : '0'); updateSoundBtn(); if (soundOn) { ensureAudio(); playPlace(); } };
        updateSoundBtn();
        ['pointerdown', 'keydown'].forEach(function (ev) { document.addEventListener(ev, ensureAudio); });

        var rp = /[?&]room=([^&]*)/.exec(location.search); if (rp) { try { $('roomId').value = decodeURIComponent(rp[1]); } catch (e) {} }
        draw();
        loadRooms(); setInterval(loadRooms, 5000);
        loadLobby(); setInterval(loadLobby, 3000);
        window.addEventListener('beforeunload', function () {
            if (room.id && myName()) { try { var b = body(); b.set('action', 'leave'); fetch(ctx + '/gomoku', { method: 'POST', body: b, keepalive: true }); } catch (e) {} }
        });
    })();
</script>
<script src="${pageContext.request.contextPath}/js/presence.js"></script>
<script src="${pageContext.request.contextPath}/js/music-player.js?v=2"></script>
</body>
</html>