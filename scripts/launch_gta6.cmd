@echo off
setlocal
echo ========================================================
echo        Luacias - Scarlett Compatibility Layer
echo        Discord: https://discord.gg/6r4ngXfsab
echo ========================================================
echo.

set VICTORY_PIPELINE_JOURNAL=1
set VICTORY_SHADER_LOOP_LIMIT=4096

if "%~1"=="" (
    echo Usage: launch_gta6.cmd "path\to\game_scarlett_master.exe"
    echo Or edit this script to set your default game path.
    echo.
    set /p GAME_PATH="Enter full path to game_scarlett_master.exe: "
) else (
    set "GAME_PATH=%~1"
)

if not exist "%GAME_PATH%" (
    echo [ERROR] Game executable not found at: "%GAME_PATH%"
    pause
    exit /b 1
)

echo [Luacias] Starting GTA VI (game_scarlett_master.exe)...
if exist "victory.exe" (
    victory.exe run "%GAME_PATH%" --execute
) else if exist "target\release\victory.exe" (
    target\release\victory.exe run "%GAME_PATH%" --execute
) else (
    echo [ERROR] victory.exe not found. Build via 'cargo build --release' or download from Releases!
    pause
    exit /b 1
)

pause
