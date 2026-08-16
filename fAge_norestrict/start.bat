@echo off
cd /d "%~dp0"

set "BATCH_LAUNCHER=%~f0"
set "BATCH_NAME=%~nx0"
set "BATCH_DIR=%~dp0"

:: ============================================================
:: Request Administrator Privileges
:: ============================================================
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)


:: =========================
:: Install Requirements
:: =========================
echo Checking and installing required modules...

python -m pip install --upgrade pip
python -m pip install -r requirements.txt


:: ============================================================
:: CHECK UPDATE ครั้งแรก
:: ============================================================
python -OO -B start.py
set exitcode=%ERRORLEVEL%

:: ============================================================
:: ถ้า exit code = 9 → มีอัปเดต
:: ============================================================
if %exitcode%==9 (
    powershell -command "Expand-Archive -Force 'update.zip' '.'; Remove-Item 'update.zip' -Force"
)

:: ============================================================
:: เรียก start.py อีกครั้งหลังอัปเดต (หรือไม่มีอัปเดต)
:: ============================================================
start "" pythonw.exe -OO -B start.py





