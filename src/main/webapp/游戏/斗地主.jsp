<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>熊喵喵斗地主 · 联机房间</title>
  <link rel="icon" type="image/x-icon" href="${pageContext.request.contextPath}/Titleico/Bangdream.png">
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { min-height: 100vh; font-family: "Segoe UI", "Microsoft YaHei", sans-serif;
      background: linear-gradient(-45deg,#3a3d52,#4a4458,#3f4a5c,#453f52,#3a3d52); background-size: 400% 400%;
      animation: gf 22s ease infinite; color: #eceaf4; padding: 16px; overflow-x: hidden; }
    @keyframes gf { 0%,100%{background-position:0% 50%} 50%{background-position:100% 50%} }
    h1 { text-align: center; font-size: 30px; letter-spacing: 3px; margin-bottom: 6px;
      background: linear-gradient(90deg,#8fc0e0,#f0c674,#8f7bd0); -webkit-background-clip: text; background-clip: text; color: transparent; }
    .tip { text-align: center; color: #b7b4c6; font-size: 14px; min-height: 22px; margin-bottom: 12px; }
    .tip b { color: #f0c674; }
    /* 大厅 */
    .lobby { max-width: 1040px; margin: 0 auto 14px; background: rgba(255,255,255,.06); border: 1px solid rgba(255,255,255,.10); border-radius: 14px; padding: 12px 14px; backdrop-filter: blur(10px); }
    .lobby-bar { display: flex; align-items: center; gap: 10px; flex-wrap: wrap; }
    .lobby-bar input { flex: 1; min-width: 140px; padding: 9px 12px; font-size: 14px; color: #fff; border: 2px solid rgba(255,255,255,.15); border-radius: 10px; background: rgba(255,255,255,.08); outline: none; }
    .lobby-bar input:focus { border-color: #6ba3c7; }
    .lobby-bar button { padding: 9px 16px; font-size: 14px; font-weight: 600; color: #fff; cursor: pointer; border: none; border-radius: 10px; background: rgba(255,255,255,.14); }
    .lobby-bar button.gold { background: linear-gradient(135deg,#c9a24b,#f0c674); color: #3a2f12; }
    .room-state { font-size: 13px; color: #b7b4c6; }
    .lobby-body { display: none; gap: 12px; margin-top: 12px; }
    .members { width: 170px; flex: 0 0 auto; }
    .mh { font-size: 12px; color: #b7b4c6; margin-bottom: 6px; }
    .members ul { list-style: none; max-height: 150px; overflow: auto; }
    .members li { font-size: 14px; padding: 5px 8px; border-radius: 8px; background: rgba(255,255,255,.05); margin-bottom: 4px; }
    .chat { flex: 1; display: flex; flex-direction: column; }
    .msgs { height: 150px; overflow: auto; background: rgba(0,0,0,.18); border-radius: 10px; padding: 8px 10px; }
    .rmsg { font-size: 14px; line-height: 1.5; word-break: break-word; }
    .rmsg .rw { color: #8fc0e0; font-weight: 600; } .rmsg.me .rw { color: #f0c674; } .rmsg.empty { color: #b7b4c6; text-align: center; }
    .chatrow { display: flex; gap: 8px; margin-top: 8px; }
    .chatrow input { flex: 1; padding: 9px 12px; font-size: 14px; color: #fff; border: 2px solid rgba(255,255,255,.15); border-radius: 10px; background: rgba(255,255,255,.08); outline: none; }
    .chatrow input:focus { border-color: #6ba3c7; }
    .chatrow button { padding: 0 16px; font-size: 14px; font-weight: 600; color: #fff; cursor: pointer; border: none; border-radius: 10px; background: linear-gradient(135deg,#6ba3c7,#8f7bd0); }
    .roomlist { list-style: none; max-height: 210px; overflow: auto; margin-top: 6px; }
    .rl-item { display: flex; align-items: center; justify-content: space-between; gap: 10px; padding: 7px 10px; border-radius: 9px; background: rgba(255,255,255,.05); margin-bottom: 5px; }
    .rl-info { font-size: 14px; } .rl-info b { color: #f0c674; }
    .rl-meta { color: #b7b4c6; font-size: 12px; margin-left: 6px; }
    .rl-join { padding: 5px 14px; font-size: 13px; font-weight: 600; color: #fff; cursor: pointer; border: none; border-radius: 8px; background: linear-gradient(135deg,#6ba3c7,#8f7bd0); }
    .rl-join:disabled { opacity: .5; cursor: not-allowed; background: rgba(255,255,255,.14); }
    .rl-empty { color: #b7b4c6; font-size: 13px; text-align: center; padding: 8px; }
    /* 牌桌 */
    #board { max-width: 1040px; margin: 0 auto; display: flex; flex-direction: column; gap: 14px; }
    .top { display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; }
    .seat { flex: 1; text-align: center; }
    .who2 { font-size: 15px; font-weight: 600; margin-bottom: 6px; color: #8fc0e0; }
    .who2.landlord { color: #f0c674; }
    .backs { display: flex; justify-content: center; align-items: center; min-height: 44px; }
    .backcard { width: 30px; height: 44px; border-radius: 5px; border: 2px solid rgba(255,255,255,.7);
      background: repeating-linear-gradient(45deg,#5a4a7a,#5a4a7a 6px,#6b5a8a 6px,#6b5a8a 12px); margin-left: -14px; }
    .backcard:first-child { margin-left: 0; }
    .cnt { font-size: 13px; color: #b7b4c6; margin-left: 8px; }
    .played { min-height: 80px; display: flex; flex-wrap: wrap; gap: 6px; justify-content: center; align-items: center; margin-top: 6px; }
    .passed { color: #b7b4c6; font-style: italic; }
    .bottom { display: flex; flex-direction: column; align-items: center; gap: 6px; }
    .bottom .lbl { font-size: 12px; color: #b7b4c6; }
    .bottom .cards { display: flex; gap: 8px; min-height: 66px; }
    .you { text-align: center; }
    .hand { display: flex; flex-wrap: wrap; justify-content: center; gap: 10px; min-height: 112px; padding-top: 22px; }
    .card { width: 74px; height: 102px; border-radius: 9px; position: relative; overflow: hidden;
      background-size: cover; background-position: center; background-color: #2f2b3d; border: 2px solid #fff;
      box-shadow: 0 2px 8px rgba(0,0,0,.45); flex: 0 0 auto; transition: transform .12s; }
    .card::after { content: ''; position: absolute; inset: 0; background: linear-gradient(180deg, rgba(0,0,0,.12), rgba(0,0,0,.55)); }
    .card .lab { position: absolute; top: 4px; left: 6px; z-index: 1; font-weight: 800; font-size: 19px; color: #fff; text-shadow: 0 1px 3px #000,0 0 4px #000; }
    .card .suit { position: absolute; bottom: 4px; right: 6px; z-index: 1; font-size: 20px; color: #fff; text-shadow: 0 1px 3px #000; }
    .card.red .lab,.card.red .suit { color: #ff6b6b; }
    .card.joker .lab { font-size: 13px; writing-mode: vertical-rl; top: 5px; left: 5px; letter-spacing: 1px; }
    .card.click { cursor: pointer; }
    .card.click:hover { transform: translateY(-8px); }
    .card.sel { transform: translateY(-18px); box-shadow: 0 0 0 3px #f0c674, 0 8px 16px rgba(0,0,0,.5); }
    .card.mini { width: 50px; height: 70px; } .card.mini .lab { font-size: 14px; } .card.mini .suit { font-size: 15px; } .card.mini.joker .lab { font-size: 10px; }
    .controls { display: flex; justify-content: center; gap: 12px; margin-top: 8px; flex-wrap: wrap; }
    .controls button { padding: 10px 22px; font-size: 15px; font-weight: 600; color: #fff; cursor: pointer; border: none; border-radius: 10px; background: linear-gradient(135deg,#6ba3c7,#8f7bd0); box-shadow: 0 4px 14px rgba(0,0,0,.3); }
    .controls button.ghost { background: rgba(255,255,255,.14); } .controls button.gold { background: linear-gradient(135deg,#c9a24b,#f0c674); color: #3a2f12; }
    .home { text-align: center; margin-top: 16px; } .home a { color: #8fc0e0; text-decoration: none; font-size: 14px; }
    .result { text-align: center; font-size: 22px; font-weight: 700; min-height: 26px; margin-top: 6px; }
    .turn-center { text-align: center; font-size: 22px; font-weight: 800; letter-spacing: 1px; min-height: 30px; margin: 4px 0; color: #f0c674; text-shadow: 0 2px 8px rgba(0,0,0,.4); }
    .turn-center b { color: #8fc0e0; } .turn-center .none { display: block; font-size: 15px; font-weight: 600; color: #ff8f8f; margin-top: 2px; }
    @media (max-width: 640px) { .card{width:56px;height:80px} .card.mini{width:40px;height:58px} .hand{gap:6px} h1{font-size:22px} .lobby-body{flex-direction:column} .members{width:auto} }
  </style>
</head>
<body>
<h1>🐼 熊喵喵斗地主 · 联机房间</h1>
<div class="tip" id="tip">输入房间号进入，可单人（自动补电脑）或和好友同房间对战</div>

<div class="lobby">
  <div class="mh">🔥 进行中的房间（点「进入」直接加入）</div>
  <ul class="roomlist" id="roomList"><li class="rl-empty">暂无房间，输入房间号即可开一个</li></ul>
</div>

<div class="lobby">
  <div class="mh">📣 大厅喊话 · 找人一起玩（全服可见，和乐队主页聊天互通）</div>
  <div class="msgs" id="lobbyMsgs"><div class="rmsg empty">还没有人喊话</div></div>
  <div class="chatrow"><input id="lobbyInput" type="text" maxlength="200" placeholder="喊话：来个斗地主的，房间号 xxx…" autocomplete="off"><button id="lobbySend">发送</button></div>
</div>

<div class="lobby">
  <div class="lobby-bar">
    <input id="roomId" type="text" maxlength="24" placeholder="输入房间号，例如 panda123" autocomplete="off">
    <button id="btnJoin" class="gold">进入房间</button>
    <button id="btnLeave" style="display:none">离开</button>
    <span class="room-state" id="roomState">未加入房间</span>
  </div>
  <div class="lobby-body" id="lobbyBody">
    <div class="members"><div class="mh">房间成员</div><ul id="memberList"></ul></div>
    <div class="chat">
      <div class="msgs" id="roomMsgs"><div class="rmsg empty">还没有聊天</div></div>
      <div class="chatrow"><input id="roomInput" type="text" maxlength="200" placeholder="和房间队友聊天…" autocomplete="off"><button id="roomSend">发送</button></div>
    </div>
  </div>

<div id="board">
  <div class="top">
    <div class="seat"><div class="who2" id="sLeftName">—</div><div class="backs" id="sLeftBacks"></div><div class="played" id="sLeftPlayed"></div></div>
    <div class="bottom"><div class="lbl">底牌</div><div class="cards" id="bottomCards"></div></div>
    <div class="seat"><div class="who2" id="sRightName">—</div><div class="backs" id="sRightBacks"></div><div class="played" id="sRightPlayed"></div></div>
  </div>
  <div class="turn-center" id="turnCenter"></div>
  <div class="you"><div class="played" id="sYouPlayed"></div><div class="hand" id="yourHand"></div></div>
</div>

<div class="controls" id="controls">
  <button id="btnStart" class="gold">开始游戏</button>
  <button id="btnCall" style="display:none" class="gold">叫地主</button>
  <button id="btnSkip" style="display:none" class="ghost">不叫</button>
  <button id="btnPlay" style="display:none">出牌</button>
  <button id="btnHint" style="display:none" class="ghost">提示</button>
  <button id="btnPass" style="display:none" class="ghost">不要</button>
  <button id="btnRestart" style="display:none" class="gold">再来一局</button>
</div>
<div class="result" id="result"></div>
<div class="home"><a href="${pageContext.request.contextPath}/乐队主页.jsp">← 返回乐队主页</a></div>

<script>
  (function () {
    var ctx = '${pageContext.request.contextPath}';
    var pandaList = [];
    var pandaBg = [];
    var room = { id: null, timer: null };
    var selected = new Set();
    var lastState = null;
    function $(id) { return document.getElementById(id); }
    function myName() { return (sessionStorage.getItem('visitorName') || '').trim(); }
    function setTip(h) { $('tip').innerHTML = h; }

    // ---------- 大厅 ----------
    function ensureName() { var n = myName(); if (!n) { n = (prompt('请输入你的名字（用于房间与在线）：') || '').trim(); if (n) sessionStorage.setItem('visitorName', n); } return n; }
    function joinRoom() {
      var name = ensureName(); if (!name) { alert('需要名字才能进房间'); return; }
      var id = ($('roomId').value || '').trim(); if (!id) { alert('请输入房间号'); return; }
      room.id = id;
      $('lobbyBody').style.display = 'flex'; $('btnLeave').style.display = '';
      $('roomState').textContent = '已进入房间 ' + id + '（' + name + '）';
      poll(); if (room.timer) clearInterval(room.timer); room.timer = setInterval(poll, 2000);
    }
    function leaveRoom() {
      if (!room.id) return;
      var name = myName(); if (name) act({ action: 'leave' });
      if (room.timer) clearInterval(room.timer); room.timer = null; room.id = null;
      $('lobbyBody').style.display = 'none'; $('btnLeave').style.display = 'none'; $('roomState').textContent = '未加入房间'; lastState = null; render(null);
    }
    function poll() {
      if (!room.id) return;
      fetch(ctx + '/room?id=' + encodeURIComponent(room.id) + '&name=' + encodeURIComponent(myName())).then(function (r) { return r.json(); }).then(function (d) { if (d && !d.error) render(d); }).catch(function () {});
    }
    function act(obj) {
      if (!room.id) { alert('请先进入房间'); return Promise.resolve(); }
      var b = new URLSearchParams(); b.set('id', room.id); b.set('name', myName());
      Object.keys(obj).forEach(function (k) { b.set(k, obj[k]); });
      return fetch(ctx + '/room', { method: 'POST', body: b }).then(function (r) { return r.json(); }).then(function (j) { if (j && j.ok === false) setTip('⚠ ' + (j.error || '操作失败')); poll(); }).catch(function () {});
    }
    function sendChat() {
      if (!room.id) { alert('请先进入房间'); return; }
      var inp = $('roomInput'); var text = (inp.value || '').trim(); if (!text) return;
      act({ action: 'chat', text: text }); inp.value = '';
    }

    // ---------- 渲染 ----------
    function isRed(c) { return c.suit === '♥' || c.suit === '♦'; }
    function pandaUrl(c) {
      if (pandaBg.length) { var u = pandaBg[c.id % pandaBg.length]; if (u) return u; }
      if (!pandaList.length) return '';
      return ctx + '/QQimgs/熊喵喵/' + encodeURIComponent(pandaList[c.id % pandaList.length]);
    }
    // 把每张图（含动图）只画第一帧、缩放到卡牌尺寸，烘焙成静态 dataURL，避免动图卡顿又能用满整池
    function buildCardBgs(files) {
      if (!files || !files.length) return;
      pandaBg = new Array(files.length);
      var pending = files.length;
      var done = function () { if (--pending === 0 && room.id) poll(); };
      files.forEach(function (f, i) {
        var url = ctx + '/QQimgs/熊喵喵/' + encodeURIComponent(f);
        var im = new Image();
        im.onload = function () {
          try {
            var w = 90, h = 124, dpr = window.devicePixelRatio || 1;
            var cv = document.createElement('canvas');
            cv.width = Math.round(w * dpr); cv.height = Math.round(h * dpr);
            var g = cv.getContext('2d');
            var scale = Math.max(cv.width / im.width, cv.height / im.height);
            var dw = im.width * scale, dh = im.height * scale;
            g.drawImage(im, (cv.width - dw) / 2, (cv.height - dh) / 2, dw, dh);
            pandaBg[i] = cv.toDataURL('image/jpeg', 0.82);
          } catch (e) { pandaBg[i] = url; }
          done();
        };
        im.onerror = function () { pandaBg[i] = url; done(); };
        im.src = url;
      });
    }
    function cardEl(c, mini, clickable, sel) {
      var d = document.createElement('div');
      d.className = 'card' + (isRed(c) ? ' red' : '') + (c.joker ? ' joker' : '') + (mini ? ' mini' : '') + (clickable ? ' click' : '') + (sel ? ' sel' : '');
      var u = pandaUrl(c); if (u) d.style.backgroundImage = 'url("' + u + '")';
      var lab = document.createElement('span'); lab.className = 'lab'; lab.textContent = c.label; d.appendChild(lab);
      if (c.suit) { var s = document.createElement('span'); s.className = 'suit'; s.textContent = c.suit; d.appendChild(s); }
      return d;
    }
    function renderBacks(el, n) { el.innerHTML = ''; var show = Math.min(n, 12); for (var i = 0; i < show; i++) { var b = document.createElement('div'); b.className = 'backcard'; el.appendChild(b); } var c = document.createElement('span'); c.className = 'cnt'; c.textContent = '×' + n; el.appendChild(c); }
    function renderPlayed(el, sp) { el.innerHTML = ''; if (!sp) return; if (sp.pass) { el.innerHTML = '<span class="passed">不要</span>'; return; } if (sp.cards) sp.cards.forEach(function (c) { el.appendChild(cardEl(c, true)); }); }
    function render(st) {
      lastState = st;
      if (!st) { ['sLeftBacks','sRightBacks','sLeftPlayed','sRightPlayed','sYouPlayed','bottomCards','yourHand','memberList'].forEach(function (id) { $(id).innerHTML = ''; }); $('sLeftName').textContent = '—'; $('sRightName').textContent = '—'; return; }
      var name = myName();
      var ul = $('memberList'); ul.innerHTML = '';
      (st.members || []).forEach(function (m) { var li = document.createElement('li'); li.textContent = m + (m === name ? '（你）' : ''); ul.appendChild(li); });
      renderMsgs(st.msg || [], name);

      var me = st.mySeat, leftSeat, rightSeat;
      if (me >= 0) { leftSeat = (me + 1) % 3; rightSeat = (me + 2) % 3; } else { me = 0; leftSeat = 1; rightSeat = 2; }
      setSeat('sLeftName', st.seats[leftSeat], st.landlord === leftSeat);
      setSeat('sRightName', st.seats[rightSeat], st.landlord === rightSeat);
      renderBacks($('sLeftBacks'), st.seats[leftSeat].count);
      renderBacks($('sRightBacks'), st.seats[rightSeat].count);
      renderPlayed($('sLeftPlayed'), st.seatPlay[leftSeat]);
      renderPlayed($('sRightPlayed'), st.seatPlay[rightSeat]);
      renderPlayed($('sYouPlayed'), st.mySeat >= 0 ? st.seatPlay[st.mySeat] : null);

      var bc = $('bottomCards'); bc.innerHTML = ''; (st.bottom || []).forEach(function (c) { bc.appendChild(cardEl(c, true)); });

      var hand = $('yourHand'); hand.innerHTML = '';
      if (st.mySeat >= 0) {
        st.hand.forEach(function (c) {
          var clickable = (st.phase === 'play' && st.turn === st.mySeat);
          var d = cardEl(c, false, clickable, selected.has(c.id));
          d.onclick = function () { if (!(st.phase === 'play' && st.turn === st.mySeat)) return; if (selected.has(c.id)) selected.delete(c.id); else selected.add(c.id); d.classList.toggle('sel'); };
          hand.appendChild(d);
        });
      } else { hand.innerHTML = '<span class="passed">观战中（房间已满 3 人）</span>'; }

      updateTip(st); showControls(st); updateResult(st); setCenter(st);
    }
    function setSeat(id, seat, isLandlord) { var el = $(id); el.textContent = (seat.name || '空位') + (isLandlord ? ' 🃏' : ''); el.className = 'who2' + (isLandlord ? ' landlord' : ''); }
    function updateTip(st) {
      var nm = function (i) { return st.seats[i] && st.seats[i].name ? st.seats[i].name : '空位'; };
      if (st.phase === 'lobby') setTip('已就位：' + st.members.length + ' 人。点“开始游戏”（不足 3 人自动补电脑）');
      else if (st.phase === 'bid') {
        var who = (st.bidTurn === st.mySeat) ? '你' : nm(st.bidTurn);
        if (st.bidStage === 1) setTip('抢地主中… 轮到 <b>' + who + '</b>　' + (st.robHolder >= 0 ? ('当前地主：' + nm(st.robHolder) + (st.robCount > 0 ? '（已抢 ' + st.robCount + ' 次）' : '')) : ''));
        else setTip('叫地主中… 轮到 <b>' + who + '</b>');
      }
      else if (st.phase === 'play') {
        if (st.turn === st.mySeat) {
          if (st.lastSeat !== null && st.lastSeat !== st.mySeat && st.canFollow === false) setTip('轮到你 · 你没有能打的牌，请点「不要」');
          else setTip('轮到你出牌');
        } else setTip('轮到 <b>' + nm(st.turn) + '</b> 出牌　' + (st.landlord >= 0 ? '地主：' + nm(st.landlord) : ''));
      }
      else if (st.phase === 'over') setTip('本局结束');
    }
    function setCenter(st) {
      var el = $('turnCenter'); if (!el) return;
      if (!st) { el.innerHTML = ''; return; }
      var nm = function (i) { return st.seats[i] && st.seats[i].name ? st.seats[i].name : '空位'; };
      if (st.phase === 'lobby') { el.innerHTML = '等待开始…'; return; }
      if (st.phase === 'over') { el.innerHTML = ''; return; }
      if (st.phase === 'bid') {
        var who = (st.bidTurn === st.mySeat) ? '你' : nm(st.bidTurn);
        var label = st.bidStage === 1 ? '抢地主' : '叫地主';
        el.innerHTML = '🫵 轮到 <b>' + who + '</b> ' + label;
        return;
      }
      var t = (st.turn === st.mySeat) ? '你' : nm(st.turn);
      var html = '🫵 轮到 <b>' + t + '</b> 出牌';
      if (st.turn === st.mySeat && st.lastSeat !== null && st.lastSeat !== st.mySeat && st.canFollow === false)
        html += '<span class="none">你没有能打的牌，只能「不要」</span>';
      el.innerHTML = html;
    }
    function doHint() {
      if (!room.id || !lastState || lastState.turn !== lastState.mySeat) return;
      var b = new URLSearchParams(); b.set('id', room.id); b.set('name', myName()); b.set('action', 'hint');
      fetch(ctx + '/room', { method: 'POST', body: b }).then(function (r) { return r.json(); }).then(function (j) {
        if (!j || !j.ok) { if (j && j.error) setTip('⚠ ' + j.error); return; }
        if (j.none) { setTip('你没有能打的牌'); return; }
        selected.clear(); (j.ids || []).forEach(function (id) { selected.add(id); });
        if (lastState) render(lastState);
      }).catch(function () {});
    }
    function updateResult(st) {

    }
    function renderMsgs(list, myN) {
      var box = $('roomMsgs'); var atBottom = box.scrollHeight - box.scrollTop - box.clientHeight < 30; box.innerHTML = '';
      if (!list.length) { box.innerHTML = '<div class="rmsg empty">还没有聊天</div>'; return; }
      list.forEach(function (m) { var d = document.createElement('div'); d.className = 'rmsg' + (m.n === myN ? ' me' : ''); var w = document.createElement('span'); w.className = 'rw'; w.textContent = m.n + '：'; var t = document.createElement('span'); t.textContent = m.t; d.appendChild(w); d.appendChild(t); box.appendChild(d); });
      if (atBottom) box.scrollTop = box.scrollHeight;
    }
    function showControls(st) {
      var m = { btnStart: 0, btnCall: 0, btnSkip: 0, btnPlay: 0, btnHint: 0, btnPass: 0, btnRestart: 0 };
      var seated = st.mySeat >= 0;
      if (st.phase === 'lobby') { if (seated) m.btnStart = 1; }
      else if (st.phase === 'bid') {
        if (st.bidStage === 1) { $('btnCall').textContent = '抢地主'; $('btnSkip').textContent = '不抢'; }
        else { $('btnCall').textContent = '叫地主'; $('btnSkip').textContent = '不叫'; }
        if (st.bidTurn >= 0 && st.bidTurn === st.mySeat) { m.btnCall = 1; m.btnSkip = 1; }
      }
      else if (st.phase === 'play') { if (st.turn === st.mySeat) { m.btnPlay = 1; m.btnHint = 1; m.btnPass = 1; } }
      else if (st.phase === 'over') { if (seated) m.btnRestart = 1; }
      Object.keys(m).forEach(function (id) { $(id).style.display = m[id] ? '' : 'none'; });
    }

    // ---------- 操作 ----------
    function doPlay() {
      if (!lastState || lastState.turn !== lastState.mySeat) return;
      if (!selected.size) { setTip('请先选牌'); return; }
      var ids = Array.from(selected).join(',');
      selected.clear(); act({ action: 'play', ids: ids });
    }

    function escapeHtml(s) { return String(s == null ? '' : s).replace(/[&<>"']/g, function (m) { return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[m]; }); }
    function loadRooms() {
      fetch(ctx + '/room?list=1').then(function (r) { return r.json(); }).then(function (list) {
        var ul = $('roomList'); if (!ul) return; ul.innerHTML = '';
        if (!list || !list.length) { ul.innerHTML = '<li class="rl-empty">暂无房间，输入房间号即可开一个</li>'; return; }
        list.forEach(function (rm) {
          var li = document.createElement('li'); li.className = 'rl-item';
          var phaseText = rm.phase === 'lobby' ? '等待开始' : rm.phase === 'bid' ? '叫地主中' : rm.phase === 'play' ? '对局中' : '结算中';
          var who = (rm.players && rm.players.length) ? rm.players.join('、') : (rm.members + ' 人');
          var info = document.createElement('span'); info.className = 'rl-info';
          var b = document.createElement('b'); b.textContent = rm.id;
          var meta = document.createElement('span'); meta.className = 'rl-meta'; meta.textContent = ' ' + phaseText + ' · ' + who;
          info.appendChild(b); info.appendChild(meta);
          li.appendChild(info);
          var btn = document.createElement('button'); btn.className = 'rl-join';
          if (rm.canJoin) { btn.textContent = '进入'; btn.onclick = function () { $('roomId').value = rm.id; joinRoom(); }; }
          else { btn.textContent = '满/进行中'; btn.disabled = true; }
          li.appendChild(btn);
          ul.appendChild(li);
        });
      }).catch(function () {});
    }

    // ---------- 大厅喊话（全局聊天，复用 /chat） ----------
    function renderLobbyChat(list) {
      var box = $('lobbyMsgs'); if (!box) return;
      var atBottom = box.scrollHeight - box.scrollTop - box.clientHeight < 30;
      var myN = myName();
      box.innerHTML = '';
      if (!list || !list.length) { box.innerHTML = '<div class="rmsg empty">还没有人喊话</div>'; return; }
      list.forEach(function (m) {
        var d = document.createElement('div'); d.className = 'rmsg' + (m.n === myN ? ' me' : '');
        var w = document.createElement('span'); w.className = 'rw'; w.textContent = m.n + '：';
        var t = document.createElement('span');
        if (m.sf) { var img = document.createElement('img'); img.src = ctx + '/QQimgs/' + encodeURIComponent(m.sc) + '/' + encodeURIComponent(m.sf); img.alt = m.sf; img.style.cssText = 'max-width:90px;max-height:90px;vertical-align:middle;border-radius:6px'; t.appendChild(img); }
        else t.textContent = m.t;
        d.appendChild(w); d.appendChild(t); box.appendChild(d);
      });
      if (atBottom) box.scrollTop = box.scrollHeight;
    }
    function loadLobbyChat() { fetch(ctx + '/chat').then(function (r) { return r.json(); }).then(renderLobbyChat).catch(function () {}); }
    function sendLobbyChat() {
      var name = ensureName(); if (!name) { alert('先取个名字才能喊话'); return; }
      var inp = $('lobbyInput'); var text = (inp.value || '').trim(); if (!text) return;
      var b = new URLSearchParams(); b.set('name', name); b.set('text', text);
      fetch(ctx + '/chat', { method: 'POST', body: b }).then(function () { inp.value = ''; loadLobbyChat(); }).catch(function () {});
    }

    $('btnJoin').onclick = joinRoom;
    $('btnLeave').onclick = leaveRoom;
    $('roomSend').onclick = sendChat;
    $('roomInput').addEventListener('keydown', function (e) { if (e.key === 'Enter') sendChat(); });
    $('lobbySend').onclick = sendLobbyChat;
    $('lobbyInput').addEventListener('keydown', function (e) { if (e.key === 'Enter') sendLobbyChat(); });
    $('btnStart').onclick = function () { selected.clear(); act({ action: 'start' }); };
    $('btnRestart').onclick = function () { selected.clear(); act({ action: 'start' }); };
    $('btnCall').onclick = function () { act({ action: 'bid', call: '1' }); };
    $('btnSkip').onclick = function () { act({ action: 'bid', call: '0' }); };
    $('btnPlay').onclick = doPlay;
    $('btnPass').onclick = function () { selected.clear(); act({ action: 'pass' }); };
    $('btnHint').onclick = doHint;

    window.addEventListener('beforeunload', function () { if (room.id && myName()) { try { var b = new URLSearchParams(); b.set('id', room.id); b.set('name', myName()); b.set('action', 'leave'); fetch(ctx + '/room', { method: 'POST', body: b, keepalive: true }); } catch (e) {} } });

    var rp = /[?&]room=([^&]*)/.exec(location.search); if (rp) { try { $('roomId').value = decodeURIComponent(rp[1]); } catch (e) {} }
    showControls({ mySeat: -1, phase: 'lobby' });
    loadRooms(); setInterval(loadRooms, 5000);
    loadLobbyChat(); setInterval(loadLobbyChat, 3000);
    fetch(ctx + '/chat?stickers=1').then(function (r) { return r.json(); }).then(function (d) { var arr = (d && d['熊喵喵']) || []; pandaList = arr.map(function (x) { return x.n; }); buildCardBgs(pandaList); }).catch(function () {});

  })();
</script>
<script src="${pageContext.request.contextPath}/js/presence.js"></script>
<script src="${pageContext.request.contextPath}/js/music-player.js"></script>

</body>
</html>