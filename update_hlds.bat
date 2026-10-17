@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion
title CS 1.6 - Update HLDS

set "ROOT=%~dp0"
set "STEAMCMD_DIR=%ROOT%steamcmd"
set "SERVER_DIR=%ROOT%hlds"

echo ============================================
echo  Обновление HLDS через SteamCMD
echo ============================================

if not exist "%STEAMCMD_DIR%" mkdir "%STEAMCMD_DIR%"
if not exist "%SERVER_DIR%"  mkdir "%SERVER_DIR%"

:: --- Скачиваем SteamCMD, если его нет ---
if not exist "%STEAMCMD_DIR%\steamcmd.exe" (
    echo [*] Скачиваю SteamCMD...
    powershell -NoProfile -Command ^
        "Invoke-WebRequest -Uri 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip' -OutFile '%STEAMCMD_DIR%\steamcmd.zip' -UseBasicParsing"
    if errorlevel 1 (
        echo [ERROR] Не удалось скачать SteamCMD. Проверь интернет.
        pause & exit /b 1
    )
    echo [*] Распаковываю...
    powershell -NoProfile -Command ^
        "Expand-Archive -Path '%STEAMCMD_DIR%\steamcmd.zip' -DestinationPath '%STEAMCMD_DIR%' -Force"
    del /q "%STEAMCMD_DIR%\steamcmd.zip"
)

:: --- Первый запуск SteamCMD (самообновление) ---
if not exist "%STEAMCMD_DIR%\public" (
    echo [*] Первичная инициализация SteamCMD...
    "%STEAMCMD_DIR%\steamcmd.exe" +quit
)

:: --- Установка/обновление HLDS (app 90) ---
echo [*] Устанавливаю/обновляю HLDS (app 90)...
"%STEAMCMD_DIR%\steamcmd.exe" ^
    +force_install_dir "%SERVER_DIR%" ^
    +login anonymous ^
    +app_update 90 validate ^
    +quit

if not exist "%SERVER_DIR%\hlds.exe" (
    echo.
    echo [ERROR] hlds.exe не найден после установки.
    echo Попробуй запустить повторно: SteamCDN иногда отдаёт пустой ответ.
    echo Если проблема остаётся - залогинься в SteamCMD своим Steam-аккаунтом:
    echo    "%STEAMCMD_DIR%\steamcmd.exe" +login ТВОЙ_ЛОГИН
    pause & exit /b 1
)

echo.
echo [OK] HLDS готов: %SERVER_DIR%\hlds.exe
pause