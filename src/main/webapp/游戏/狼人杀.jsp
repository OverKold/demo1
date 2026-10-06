<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>狼人杀 · 联机房间</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sticker-picker.css">
  <style>
    * { box-sizing: border-box; }
    body { margin: 0; padding: 20px 16px 46px; min-height: 100vh; color: #eceaf4; font-family: "Segoe UI", "Microsoft YaHei", sans-serif; background: linear-gradient(160deg, #1f1b2a, #2b2436 55%, #221d2c); }
    h1 { margin: 6px 0 2px; font-size: 26px; text-align: center; }
    .sub { margin: 0 0 18px; color: #b7b4c6; font-size: 13px; text-align: center; }
    .lobby { max-width: 1080px; margin: 0 auto 16px; padding: 14px 16px; border-radius: 14px; background: rgba(255,255,255,.06); border: 1px solid rgba(255,255,255,.10); }
    .mh { margin-bottom: 8px; color: #f0c674; font-size: 13px; }
    .roomlist { margin: 0; padding: 0; list-style: none; display: flex; flex-direction: column; gap: 6px; }
    .rl-item { display: flex; align-items: center; justify-content: space-between; gap: 10px; padding: 8px 12px; border-radius: 10px; background: rgba(255,255,255,.05); font-size: 14px; }
    .rl-meta { color: #b7b4c6; font-size: 12px; }
    .rl-empty { padding: 6px; color: #b7b4c6; font-size: 13px; text-align: center; }
    .rl-join { padding: 6px 14px; border: none; border-radius: 8px; color: #fff; font-size: 13px; cursor: pointer; background: linear-gradient(135deg,#6ba3c7,#8f7bd0); }
    .rl-join:disabled { opacity: .45; cursor: not-allowed; }
    .chatrow { display: flex; gap: 8px; margin-top: 8px; }
    .chatrow input, .chatrow select { flex: 1; padding: 9px 12px; font-size: 14px; color: #eceaf4; border: 2px solid rgba(255,255,255,.15); border-radius: 10px; background: #241f31; outline: none; }
    .chatrow select { flex: 0 0 auto; cursor: pointer; }
    .chatrow select option { background: #241f31; color: #eceaf4; }
    .chatrow input::placeholder { color: #8f8ba3; }
    .chatrow input:focus { border-color: #6ba3c7; }
    .chatrow button { padding: 0 16px; font-size: 14px; font-weight: 600; color: #fff; border: none; border-radius: 10px; cursor: pointer; background: linear-gradient(135deg,#6ba3c7,#8f7bd0); }
    .stk-btn { flex: 0 0 auto; width: 42px; padding: 0; font-size: 18px; }
    .msgs { height: 150px; overflow: auto; padding: 8px 10px; border-radius: 10px; background: rgba(0,0,0,.18); }
    .rmsg { margin-bottom: 5px; font-size: 13px; line-height: 1.5; }
    .rmsg .rw { margin-right: 4px; color: #8fc0e0; font-weight: 600; }
    .rmsg.me .rw { color: #8fd0a0; }
    .home { text-align: center; margin: 20px 0 8px; }
    .home a { color: #8fc0e0; text-decoration: none; font-size: 15px; font-weight: 600; }
    .home a:hover { color: #bfe0f2; text-decoration: underline; }
    .wolf { border-color: rgba(224,90,106,.4) !important; }
    .wolf .mh { color: #e88f9a; }
    .rmsg.empty { margin-top: 52px; color: #b7b4c6; text-align: center; }
    .grid { display: flex; flex-wrap: wrap; gap: 10px; }
    .seat { width: 128px; padding: 10px; border-radius: 12px; background: rgba(255,255,255,.05); border: 1px solid rgba(255,255,255,.10); text-align: center; }
    .seat.dead { opacity: .45; }
    .seat.me { border-color: #f0c674; }
    .seat .no { font-size: 12px; color: #b7b4c6; }
    .seat .nm { font-size: 15px; font-weight: 700; margin: 3px 0; word-break: break-all; }
    .seat .rl { font-size: 12px; color: #cbb8ff; min-height: 16px; }
    .seat .st { font-size: 11px; color: #8fc0e0; }
    .banner { display: flex; align-items: center; justify-content: space-between; gap: 12px; margin-bottom: 10px; padding: 10px 14px; border-radius: 12px; background: rgba(0,0,0,.28); font-size: 15px; font-weight: 600; }
    .cd { color: #f0c674; font-variant-numeric: tabular-nums; }
    .prompt { padding: 12px 14px; border-radius: 12px; background: rgba(143,123,208,.16); border: 1px solid rgba(143,123,208,.4); margin-bottom: 12px; }
    .prompt .tip { font-size: 14px; margin-bottom: 8px; }
    .chips { display: flex; flex-wrap: wrap; gap: 6px; }
    .chip { padding: 6px 12px; border: none; border-radius: 999px; cursor: pointer; color: #fff; font-size: 13px; background: rgba(255,255,255,.12); }
    .chip:hover { background: rgba(255,255,255,.22); }
    .chip.warn { background: #c2456a; }
    .chip.ok { background: #5a8f5a; }
    .role { display: inline-block; padding: 4px 12px; border-radius: 999px; background: linear-gradient(135deg,#6ba3c7,#8f7bd0); font-size: 14px; font-weight: 700; }
    .notes { margin-top: 8px; font-size: 12px; color: #cfcbe0; }
    .log { height: 170px; overflow: auto; padding: 8px 10px; border-radius: 10px; background: rgba(0,0,0,.22); font-size: 13px; line-height: 1.6; }
    .log div { margin-bottom: 3px; color: #d8d4e6; }
    .two { display: flex; gap: 16px; flex-wrap: wrap; }
    .two > div { flex: 1; min-width: 280px; }
    .tip2 { color: #f0c674; font-size: 13px; }
    .back { display: inline-block; margin: 6px 0 2px; padding: 8px 16px; border-radius: 999px; border: 1px solid rgba(143,192,224,.4); background: rgba(143,192,224,.14); color: #bfe0f2; font-size: 16px; font-weight: 700; text-decoration: none; }
    .back:hover { background: rgba(143,192,224,.26); }
    .ghost { background: rgba(255,255,255,.14) !important; }
    .wolf { background: rgba(194,69,106,.16) !important; border: 1px solid rgba(194,69,106,.45) !important; }
  </style>
  <script src="${pageContext.request.contextPath}/js/sticker-picker.js"></script>
  <script src="${pageContext.request.contextPath}/js/bdav.js"></script>
</head>
<body>
<h1>🐺 狼人杀 · 联机房间</h1>
<p class="sub">纯真人局，坐满才能开局：<b>5 人</b>（1狼+预言家+女巫+2民）／<b>8 人</b>（2狼+预言家+女巫+猎人+3民）。无警长，各阶段限时自动跳过。</p>

<div class="lobby">
  <div class="mh">🔥 房间列表（点「进入」直接加入）</div>
  <ul class="roomlist" id="roomList"><li class="rl-empty">加载中…</li></ul>
</div>

<div class="lobby">
  <div class="mh">📣 大厅喊话 · 凑人开局（全服可见，和乐队主页聊天互通）</div>
  <div class="msgs" id="lobbyMsgs"><div class="rmsg empty">还没有人喊话</div></div>
  <div class="sticker-panel" id="lobbyStickerPanel"><div class="sp-tabs" id="lobbySpTabs"></div><div class="sp-grid" id="lobbySpGrid"><div class="sp-empty">加载中…</div></div></div>
  <div class="chatrow">
    <button id="lobbySticker" type="button" class="stk-btn" title="发表情">😊</button>
    <input id="lobbyInput" type="text" maxlength="200" placeholder="喊话：狼人杀差 2 个人，房间号 xxx…" autocomplete="off">
    <button id="lobbySend">发送</button>
  </div>
</div>

<div class="lobby">
  <div class="chatrow">
    <input id="roomId" type="text" maxlength="32" placeholder="输入房间号，如：a" autocomplete="off">
    <select id="preset"><option value="5">5 人局（1 狼）</option><option value="8">8 人局（2 狼）</option></select>
    <button id="btnJoin">进入房间</button>
    <button id="btnBot" type="button" class="ghost">🤖 加机器人</button>
    <button id="btnLeave" type="button" class="ghost">🚪 退出此对局</button>
    <button id="btnSkip" type="button" class="ghost" style="display:none">⏭ 跳过本阶段</button>
    <span class="tip2" id="roomTip"></span>
  </div>
  <div class="banner"><span id="banner">未加入房间</span><span class="cd" id="cd"></span></div>
  <div id="prompt"></div>
  <div class="grid" id="seats"></div>
  <div class="two" style="margin-top:14px">
    <div>
      <div class="mh">📜 法官播报</div>
      <div class="log" id="log"><div class="rmsg empty">还没有开局</div></div>
    </div>
    <div>
      <div class="mh">💬 房间聊天（死者也可发言）</div>
      <div class="msgs" id="roomMsgs"><div class="rmsg empty">还没有聊天</div></div>
      <div class="sticker-panel" id="roomStickerPanel"><div class="sp-tabs" id="roomSpTabs"></div><div class="sp-grid" id="roomSpGrid"><div class="sp-empty">加载中…</div></div></div>
      <div class="chatrow">
        <button id="roomSticker" type="button" class="stk-btn" title="发表情">😊</button>
        <input id="roomInput" type="text" maxlength="200" placeholder="发言…" autocomplete="off">
        <button id="roomSend">发送</button>
      </div>
      <div id="wolfBox" style="display:none">
        <div class="mh" style="color:#e78ba0">🐺 狼队私聊（仅狼人可见，白天也能用）</div>
        <div class="msgs wolf" id="wolfMsgs"><div class="rmsg empty">狼队还没有发言</div></div>
        <div class="sticker-panel" id="wolfStickerPanel"><div class="sp-tabs" id="wolfSpTabs"></div><div class="sp-grid" id="wolfSpGrid"><div class="sp-empty">加载中…</div></div></div>
        <div class="chatrow">
          <button id="wolfSticker" type="button" class="stk-btn" title="发狼聊表情">😊</button>
          <input id="wolfInput" type="text" maxlength="200" placeholder="狼队密语…" autocomplete="off">
          <button id="wolfSend">发送</button>
        </div>
      </div>
    </div>
  </div>
</div>

<div class="home"><a href="${pageContext.request.contextPath}/乐队主页.jsp">← 返回乐队主页</a></div>

<script>
  (function () {
    var ctx = '${pageContext.request.contextPath}';
    function $(id) { return document.getElementById(id); }
    function myName() { return (sessionStorage.getItem('visitorName') || localStorage.getItem('visitorName') || '').trim(); }
    function ensureName() { var n = myName(); if (!n) { n = (prompt('给自己起个名字：', localStorage.getItem('visitorName') || '') || '').trim(); if (n) { sessionStorage.setItem('visitorName', n); localStorage.setItem('visitorName', n); } } return n; }

    var room = { id: '' }, st = null, timer = null, remain = 0;
    function setTip(t) { $('roomTip').textContent = t || ''; }
    function post(o) {
      if (!room.id) { alert('请先进入房间'); return Promise.resolve(); }
      var b = new URLSearchParams(); b.set('id', room.id); b.set('name', myName());
      Object.keys(o).forEach(function (k) { b.set(k, o[k]); });
      return fetch(ctx + '/werewolf', { method: 'POST', body: b }).then(function (r) { return r.json(); }).then(function (j) {
        if (j && j.ok === false) setTip('⚠ ' + (j.error || '操作失败')); else setTip('');
        poll(); return j;
      }).catch(function () {});
    }
    function poll() {
      if (!room.id) return;
      fetch(ctx + '/werewolf?id=' + encodeURIComponent(room.id) + '&name=' + encodeURIComponent(myName()))
              .then(function (r) { return r.json(); })
              .then(function (d) { if (d && !d.error) { st = d; render(); } })
              .catch(function () {});
    }
    function joinRoom() {
      if (!ensureName()) { alert('需要名字才能进房间'); return; }
      var id = ($('roomId').value || '').trim();
      if (!id) { alert('请输入房间号'); return; }
      room.id = id;
      try { localStorage.setItem('werewolf_room', id); } catch (e) { }
      $('banner').textContent = '已进入房间 ' + id + '（' + myName() + '）';
      post({ action: 'join', preset: $('preset').value });
      if (!timer) { poll(); timer = setInterval(poll, 1500); } else poll();
      loadRooms();
    }
    function leaveRoom() {
      if (!room.id) return;
      if (timer) { clearInterval(timer); timer = null; }
      try { localStorage.removeItem('werewolf_room'); } catch (e) { }
      post({ action: 'leave' }).then(function () { room.id = ''; st = null; render(); });
    }

    function chips(list, cls, cb, extra) {
      var box = document.createElement('div'); box.className = 'chips';
      (extra || []).forEach(function (e) { var b = document.createElement('button'); b.type = 'button'; b.className = 'chip ' + (e.cls || ''); b.textContent = e.text; b.onclick = e.click; box.appendChild(b); });
      list.forEach(function (n) { var b = document.createElement('button'); b.type = 'button'; b.className = 'chip ' + (cls || ''); b.textContent = n; b.onclick = function () { cb(n); }; box.appendChild(b); });
      return box;
    }
    function renderPrompt() {
      var box = $('prompt'); box.innerHTML = '';
      if (!st || !st.me || !st.me.prompt) return;
      var me = st.me, wrap = document.createElement('div'); wrap.className = 'prompt';
      var tip = document.createElement('div'); tip.className = 'tip'; wrap.appendChild(tip);
      var cands = me.cands || [];
      if (me.prompt === 'wolf') { tip.textContent = '🐺 请选择今晚刀掉谁（不选＝空刀）'; wrap.appendChild(chips(cands, 'warn', function (n) { post({ action: 'act', target: n }); }, [{ text: '空刀（跳过）', click: function () { post({ action: 'act', target: '' }); } }])); }
      else if (me.prompt === 'seer') { tip.textContent = '🔮 请选择今晚查验谁'; wrap.appendChild(chips(cands, '', function (n) { post({ action: 'act', target: n }); })); }
      else if (me.prompt === 'witch') {
        var w = me.witch || {};
        tip.textContent = '🧪 女巫请用药。今晚被刀的是：' + (w.victim ? w.victim : '无人（或你已无法获知）') + (w.saveUsed ? '（解药已用）' : '') + (w.poisonUsed ? '（毒药已用）' : '') + '　*解药与毒药不能同晚使用';
        var save = w.saveUsed ? '' : (w.victim || '');
        var poison = '';
        var row = document.createElement('div'); row.className = 'chips';
        function mk(text, cls, s, p) { var b = document.createElement('button'); b.type = 'button'; b.className = 'chip ' + cls; b.textContent = text; b.onclick = function () { post({ action: 'witch', save: s, poison: p }); }; row.appendChild(b); }
        if (!w.saveUsed && w.victim) mk('💊 用解药救 ' + w.victim, 'ok', w.victim, '');
        if (!w.poisonUsed) cands.forEach(function (n) { mk('☠ 毒 ' + n, 'warn', '', n); });
        mk('跳过（不用药）', '', '', '');
        wrap.appendChild(row);
      }
      else if (me.prompt === 'vote') { tip.textContent = '🗳 投票放逐谁（不选＝弃票）'; wrap.appendChild(chips(cands, 'warn', function (n) { post({ action: 'act', target: n }); }, [{ text: '弃票', click: function () { post({ action: 'act', target: '' }); } }])); }
      else if (me.prompt === 'shoot') { tip.textContent = '🔫 猎人请决定要不要开枪带走谁'; wrap.appendChild(chips(cands, 'warn', function (n) { post({ action: 'act', target: n }); }, [{ text: '不开枪', click: function () { post({ action: 'act', target: '' }); } }])); }
      if (me.done) { var d = document.createElement('div'); d.className = 'tip2'; d.textContent = '✔ 已提交，等待其他人…'; wrap.appendChild(d); }
      box.appendChild(wrap);
    }
    function render() {
      var bn = $('banner');
      if (!st || !room.id) { bn.textContent = '未加入房间'; $('seats').innerHTML = ''; $('prompt').innerHTML = ''; $('cd').textContent = ''; $('wolfBox').style.display = 'none'; $('btnSkip').style.display = 'none'; renderMsgs([]); renderLog([]); return; }
      bn.textContent = st.phaseText + (st.winner ? ' · ' + st.winner + '获胜' : '');
      $('btnSkip').style.display = (st.am && st.phase >= 1 && st.phase <= 4) ? '' : 'none';
      remain = st.remain / 1000;
      renderPrompt();
      var box = $('seats'); box.innerHTML = '';
      var myN = myName();
      (st.players || []).forEach(function (p) {
        var d = document.createElement('div'); d.className = 'seat' + (p.alive ? '' : ' dead') + (p.name === myN ? ' me' : '');
        var no = document.createElement('div'); no.className = 'no'; no.textContent = '第 ' + p.seat + ' 号';
        var nm = document.createElement('div'); nm.className = 'nm'; nm.textContent = p.name + (p.bot ? ' 🤖' : '') + (p.name === myN ? '（你）' : '');
        var rl = document.createElement('div'); rl.className = 'rl'; rl.textContent = p.role || (p.alive ? '·' : '已出局');
        var stt = document.createElement('div'); stt.className = 'st';
        stt.textContent = st.phase === 0 ? (p.ready ? '已准备' : '未准备') : (p.alive ? '存活' : '出局');
        d.appendChild(no); var avb = BDAv.badge(p.name, 34); avb.style.margin = '4px 0'; d.appendChild(avb); d.appendChild(nm); d.appendChild(rl); d.appendChild(stt); box.appendChild(d);
      });
      // 我的身份 + 验人记录
      if (st.me) {
        var mine = document.createElement('div'); mine.className = 'seat me';
        var t1 = document.createElement('div'); t1.className = 'no'; t1.textContent = '我的身份';
        var t2 = document.createElement('div'); t2.style.margin = '6px 0';
        var badge = document.createElement('span'); badge.className = 'role'; badge.textContent = st.me.role || '（尚未开局）'; t2.appendChild(badge);
        var t3 = document.createElement('div'); t3.className = 'notes';
        var notes = (st.me.seer || []).map(function (x) { return x.t + '→' + x.r; }).join('　');
        t3.textContent = notes ? '验人记录：' + notes : '';
        mine.appendChild(t1); mine.appendChild(t2); mine.appendChild(t3); box.appendChild(mine);
      }
      renderMsgs(st.msg || []);
      var isWolf = !!st.me && st.me.role === '狼人';
      $('wolfBox').style.display = isWolf ? '' : 'none';
      if (isWolf) fillBox($('wolfMsgs'), st.wmsg || [], '狼队还没有发言');
      renderLog(st.log || []);
      if (st.phase === 0) {
        var pw = document.createElement('div'); pw.className = 'prompt';
        var tip = document.createElement('div'); tip.className = 'tip';
        tip.textContent = '当前 ' + (st.players || []).length + '/' + st.preset + ' 人 · 坐满才能开局' + (st.owner === myName() ? '（你是房主）' : '') + '　🤖 机器人可补位，方便一个人测试';
        pw.appendChild(tip);
        var row = document.createElement('div'); row.className = 'chips';
        var mkBtn = function (text, cls, fn) { var b = document.createElement('button'); b.type = 'button'; b.className = 'chip ' + (cls || ''); b.textContent = text; b.onclick = fn; row.appendChild(b); };
        mkBtn((st.me && st.me.ready) ? '取消准备' : '✔ 准备', '', function () { post({ action: 'ready' }); });
        mkBtn('🤖 加机器人', '', function () { post({ action: 'addbot' }); });
        mkBtn('🤖 一键补满', '', function () { post({ action: 'fillbots' }); });
        mkBtn('✖ 移除机器人', '', function () { post({ action: 'delbot' }); });
        if (st.me) mkBtn('🎬 开始游戏', 'ok', function () { post({ action: 'start' }); });
        pw.appendChild(row);
        $('prompt').innerHTML = ''; $('prompt').appendChild(pw);
      } else if (st.phase === 5) {
        var pw2 = document.createElement('div'); pw2.className = 'prompt';
        var row2 = document.createElement('div'); row2.className = 'chips';
        if (st.me) { var b3 = document.createElement('button'); b3.type = 'button'; b3.className = 'chip ok'; b3.textContent = '🔄 再来一局'; b3.onclick = function () { post({ action: 'restart' }); }; row2.appendChild(b3); }
        pw2.appendChild(row2); $('prompt').appendChild(pw2);
      }
    }
    function renderMsgs(list) {
        var box = $('roomMsgs'), atBottom = box.scrollHeight - box.scrollTop - box.clientHeight < 30, my = myName();
        box.innerHTML = '';
        if (!list || !list.length) { box.innerHTML = '<div class="rmsg empty">还没有聊天</div>'; return; }
        list.forEach(function (m) {
            var d = document.createElement('div'); d.className = 'rmsg' + (m.n === my ? ' me' : ''); d.style.cssText = 'display:flex;gap:6px;align-items:flex-start';
            d.appendChild(BDAv.badge(m.n, 26));
            var w = document.createElement('span'); w.className = 'rw'; w.textContent = m.n + '：';
            var t = document.createElement('span');
            if (m.sf) { var img = document.createElement('img'); img.src = ctx + '/QQimgs/' + encodeURIComponent(m.sc) + '/' + encodeURIComponent(m.sf); img.alt = m.sf; img.style.cssText = 'max-width:90px;max-height:90px;display:block;margin-top:2px;border-radius:6px'; t.appendChild(img); }
            else t.textContent = m.t;
            var bd = document.createElement('span'); bd.style.cssText = 'min-width:0'; bd.appendChild(w); bd.appendChild(t); d.appendChild(bd); box.appendChild(d);
        });
        if (atBottom) box.scrollTop = box.scrollHeight;
    }
    function fillBox(box, list, emptyText) {
        var atBottom = box.scrollHeight - box.scrollTop - box.clientHeight < 30, my = myName();
        box.innerHTML = '';
        if (!list || !list.length) { box.innerHTML = '<div class="rmsg empty">' + emptyText + '</div>'; return; }
        list.forEach(function (m) {
            var d = document.createElement('div'); d.className = 'rmsg' + (m.n === my ? ' me' : ''); d.style.cssText = 'display:flex;gap:6px;align-items:flex-start';
            d.appendChild(BDAv.badge(m.n, 26));
            var w = document.createElement('span'); w.className = 'rw'; w.textContent = m.n + '：';
            var t = document.createElement('span');
            if (m.sf) { var img = document.createElement('img'); img.src = ctx + '/QQimgs/' + encodeURIComponent(m.sc) + '/' + encodeURIComponent(m.sf); img.alt = m.sf; img.style.cssText = 'max-width:90px;max-height:90px;display:block;margin-top:2px;border-radius:6px'; t.appendChild(img); }
            else t.textContent = m.t;
            var bd = document.createElement('span'); bd.style.cssText = 'min-width:0'; bd.appendChild(w); bd.appendChild(t); d.appendChild(bd); box.appendChild(d);
        });
        if (atBottom) box.scrollTop = box.scrollHeight;
    }
    function renderLog(list) {
      var box = $('log'); var atBottom = box.scrollHeight - box.scrollTop - box.clientHeight < 30;
      box.innerHTML = '';
      if (!list || !list.length) { box.innerHTML = '<div class="rmsg empty">还没有开局</div>'; return; }
      list.forEach(function (s) { var d = document.createElement('div'); d.textContent = s; box.appendChild(d); });
      if (atBottom) box.scrollTop = box.scrollHeight;
    }

    function loadRooms() {
      fetch(ctx + '/werewolf?list=1').then(function (r) { return r.json(); }).then(function (list) {
        var ul = $('roomList'); ul.innerHTML = '';
        if (!list || !list.length) { ul.innerHTML = '<li class="rl-empty">暂无房间，输入房间号即可开一个</li>'; return; }
        list.forEach(function (rm) {
          var li = document.createElement('li'); li.className = 'rl-item';
          var info = document.createElement('span');
          var b = document.createElement('b'); b.textContent = rm.id;
          var meta = document.createElement('span'); meta.className = 'rl-meta';
          var ph = rm.phase === 0 ? '等待开局' : rm.phase === 5 ? '已结束' : '游戏中';
          meta.textContent = ' ' + rm.preset + '人局 · ' + ph + ' · ' + rm.seated + '/' + rm.preset + ' 入座（在场 ' + rm.members + '）';
          info.appendChild(b); info.appendChild(meta); li.appendChild(info);
          var btn = document.createElement('button'); btn.className = 'rl-join';
          if (rm.canJoin) { btn.textContent = '进入'; btn.onclick = function () { $('roomId').value = rm.id; $('preset').value = String(rm.preset); joinRoom(); }; }
          else { btn.textContent = '满/进行中'; btn.disabled = true; }
          li.appendChild(btn); ul.appendChild(li);
        });
      }).catch(function () {});
    }

    function fillLobby(list) {
      var box = $('lobbyMsgs'), atBottom = box.scrollHeight - box.scrollTop - box.clientHeight < 30, my = myName();
      box.innerHTML = '';
      if (!list || !list.length) { box.innerHTML = '<div class="rmsg empty">还没有人喊话</div>'; return; }
      list.forEach(function (m) {
        var d = document.createElement('div'); d.className = 'rmsg' + (m.n === my ? ' me' : ''); d.style.cssText = 'display:flex;gap:6px;align-items:flex-start';
        d.appendChild(BDAv.badge(m.n, 26));
        var w = document.createElement('span'); w.className = 'rw'; w.textContent = m.n + '：';
        var t = document.createElement('span');
        if (m.sf) { var img = document.createElement('img'); img.src = ctx + '/QQimgs/' + encodeURIComponent(m.sc) + '/' + encodeURIComponent(m.sf); img.alt = m.sf; img.style.cssText = 'max-width:90px;max-height:90px;display:block;margin-top:2px;border-radius:6px'; t.appendChild(img); }
        else t.textContent = m.t;
        var bd = document.createElement('span'); bd.style.cssText = 'min-width:0'; bd.appendChild(w); bd.appendChild(t); d.appendChild(bd); box.appendChild(d);
      });
      if (atBottom) box.scrollTop = box.scrollHeight;
    }
    function loadLobby() { fetch(ctx + '/chat').then(function (r) { return r.json(); }).then(fillLobby).catch(function () {}); }
    function sendLobby() {
      var n = ensureName(); if (!n) { alert('先取个名字才能喊话'); return; }
      var i = $('lobbyInput'), t = (i.value || '').trim(); if (!t) return;
      var b = new URLSearchParams(); b.set('name', n); b.set('text', t);
      var av = ''; try { av = localStorage.getItem('visitorAvatar') || ''; } catch (e) {} if (av) b.set('av', av);
      fetch(ctx + '/chat', { method: 'POST', body: b }).then(function () { i.value = ''; loadLobby(); });
    }
    function sendLobbySticker(cat, file) {
      var n = ensureName(); if (!n) { alert('先取个名字才能发表情'); return; }
      var b = new URLSearchParams(); b.set('name', n); b.set('scat', cat); b.set('sfile', file);
      var av = ''; try { av = localStorage.getItem('visitorAvatar') || ''; } catch (e) {} if (av) b.set('av', av);
      fetch(ctx + '/chat', { method: 'POST', body: b }).then(loadLobby);
    }

    $('btnJoin').onclick = joinRoom;
    $('btnBot').onclick = function () { post({ action: 'addbot' }); };
    $('btnSkip').onclick = function () { post({ action: 'adminskip' }); };
    $('btnLeave').onclick = function () {
      leaveRoom();
      var el = $('roomList'); if (el && el.scrollIntoView) el.scrollIntoView({ behavior: 'smooth' });
    };
    $('roomSend').onclick = function () { if (!room.id) { alert('请先进入房间'); return; } var i = $('roomInput'), t = (i.value || '').trim(); if (!t) return; post({ action: 'chat', text: t }); i.value = ''; };
    $('roomInput').addEventListener('keydown', function (e) { if (e.key === 'Enter') $('roomSend').onclick(); });
    $('wolfSend').onclick = function () { if (!room.id) { alert('请先进入房间'); return; } var i = $('wolfInput'), t = (i.value || '').trim(); if (!t) return; post({ action: 'wchat', text: t }); i.value = ''; };
    $('wolfInput').addEventListener('keydown', function (e) { if (e.key === 'Enter') $('wolfSend').onclick(); });
    $('lobbySend').onclick = sendLobby;
    $('lobbyInput').addEventListener('keydown', function (e) { if (e.key === 'Enter') sendLobby(); });

    StickerPicker.attach({ ctx: ctx, toggle: 'roomSticker', panel: 'roomStickerPanel', tabs: 'roomSpTabs', grid: 'roomSpGrid', send: function (c, f) { if (!room.id) { alert('请先进入房间'); return; } post({ action: 'chat', scat: c, sfile: f }); } });
    StickerPicker.attach({ ctx: ctx, toggle: 'wolfSticker', panel: 'wolfStickerPanel', tabs: 'wolfSpTabs', grid: 'wolfSpGrid', send: function (c, f) { if (!room.id) { alert('请先进入房间'); return; } post({ action: 'wchat', scat: c, sfile: f }); } });
    StickerPicker.attach({ ctx: ctx, toggle: 'lobbySticker', panel: 'lobbyStickerPanel', tabs: 'lobbySpTabs', grid: 'lobbySpGrid', send: sendLobbySticker });

    setInterval(function () {
      var cd = $('cd');
      if (!st || st.phase === 0 || st.phase === 5) { cd.textContent = ''; return; }
      remain -= 1;
      if (remain < 0) remain = Math.max(0, (st.remain || 0) / 1000);
      cd.textContent = '⏳ ' + Math.ceil(remain) + ' 秒';
    }, 1000);

    var rp = /[?&]room=([^&]*)/.exec(location.search); if (rp) { try { $('roomId').value = decodeURIComponent(rp[1]); } catch (e) { } }
    try { if (!$('roomId').value) { var sr = localStorage.getItem('werewolf_room'); if (sr) $('roomId').value = sr; } } catch (e) { }
    if (($('roomId').value || '').trim() && myName()) joinRoom();
    loadRooms(); setInterval(loadRooms, 5000);
    loadLobby(); setInterval(loadLobby, 3000);
    window.addEventListener('beforeunload', function () {
      if (room.id && myName()) { try { var b = new URLSearchParams(); b.set('id', room.id); b.set('name', myName()); b.set('action', 'leave'); fetch(ctx + '/werewolf', { method: 'POST', body: b, keepalive: true }); } catch (e) {} }
    });
  })();
</script>
<script src="${pageContext.request.contextPath}/js/presence.js"></script>
<script src="${pageContext.request.contextPath}/js/music-player.js?v=3"></script>
</body>
</html>