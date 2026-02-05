@echo off
REM 자동 커밋 & 푸시 (30초마다 변경사항 확인 → origin main으로 푸시)
REM 종료: Ctrl+C
cd /d "%~dp0"
where bash >nul 2>&1
if %errorlevel% neq 0 (
  echo Git Bash가 필요합니다. Git 설치 후 다시 실행하세요.
  pause
  exit /b 1
)
bash "%~dp0auto-commit.sh"
