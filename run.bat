@echo off
setlocal
cd /d "%~dp0"

set "PYEXE=%~dp0python\python.exe"
if not exist "%PYEXE%" set "PYEXE=python"
if not defined WH_CANVAS_PORT set "WH_CANVAS_PORT=3001"

"%PYEXE%" -c "import fastapi,uvicorn,requests,pydantic,multipart,httpx,PIL,websockets" >nul 2>&1
if errorlevel 1 (
    echo Dependencies are missing. Run the dependency installer first.
    pause
    exit /b 1
)

echo Starting WH Infinite Canvas...
echo Visit: http://127.0.0.1:%WH_CANVAS_PORT%/
echo Press Ctrl+C to stop.
echo.

start /b cmd /c "timeout /t 3 /nobreak >nul && start http://127.0.0.1:%WH_CANVAS_PORT%/"
"%PYEXE%" main.py

echo.
echo Server stopped.
pause
