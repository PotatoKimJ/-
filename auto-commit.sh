#!/bin/bash
# 파일 변경 시 자동 커밋 (백그라운드에서 실행)
cd "$(dirname "$0")"

echo "자동 커밋 시작 (종료: Ctrl+C)"
while true; do
  if [ -n "$(git status --porcelain)" ]; then
    git add -A
    git commit -m "auto: $(date '+%Y-%m-%d %H:%M')"
    echo "[$(date '+%H:%M:%S')] 커밋됨"
    if git remote get-url origin &>/dev/null; then
      git push origin main 2>/dev/null && echo "[$(date '+%H:%M:%S')] 푸시됨" || echo "[$(date '+%H:%M:%S')] 푸시 실패 (원격 확인)"
    fi
  fi
  sleep 30
done
