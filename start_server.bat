@echo off
chcp 65001 >nul
setlocal
title CS 1.6 Dedicated Server

set "ROOT=%~dp0"
set "SERVER_DIR=%ROOT%hlds"
set "LOG_DIR=%ROOT%logs"
set "HLDS=%SERVER_DIR%\hlds.exe"

set "PORT=27015"
set "MAXPLAYERS=20"
set "MAP=de_dust2"

:: --- Проверки ---
if not exist "%HLDS%" (
    echo [ERROR] hlds.exe не найден: %HLDS%
    echo Запусти сначала update_hlds.bat
    pause & exit /b 1
)
if not exist "%LOG_DIR%" mkdir "%LOG_DIR%"

:: --- Бэкап лога ---
set "STAMP=%DATE:~-4%%DATE:~3,2%%DATE:~0,2%_%TIME:~0,2%%TIME:~3,2%"
set "STAMP=%STAMP: =0%"

echo ============================================
echo  CS 1.6 Server
echo  Port: %PORT%   MaxPlayers: %MAXPLAYERS%   Map: %MAP%
echo  Log:  %LOG_DIR%\server_%STAMP%.log
echo ============================================
echo.

cd /d "%SERVER_DIR%"

:: --- Запуск HLDS ---
"%HLDS%" -console -game cstrike -insecure -nomaster ^
    +ip 0.0.0.0 +port %PORT% +maxplayers %MAXPLAYERS% +map %MAP% ^
    +exec server.cfg +sv_lan 0 +sys_ticrate 1000 -nojoy -nomsg ^
    > "%LOG_DIR%\server_%STAMP%.log" 2>&1

echo.
echo [*] Сервер остановлен. Лог: %LOG_DIR%\server_%STAMP%.log
pause