@echo off
chcp 65001 >nul
REM  一键同步云端表情包到本地 QQimgs（全部分类、只下新增）
REM  想换地址就改下面 Base 后面那串；想只同步某个分类，就在末尾加  -Cat 基米斗
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync-stickers.ps1" -Base "https://overkold.dpdns.org"
echo.
pause