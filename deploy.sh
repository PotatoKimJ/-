#!/bin/bash
# GitHub 저장소 생성 및 푸시 (Vercel 배포 전 사용)
# 수정: 아래 REPO_NAME을 원하는 저장소 이름으로 바꾸세요.
set -e
cd "$(dirname "$0")"

# === 여기를 수정하세요: GitHub 저장소 이름 ===
REPO_NAME="konghanjok"
# 예: REPO_NAME="my-konghanjok"

# 1) GitHub CLI 사용
if command -v gh &>/dev/null; then
  echo "→ GitHub CLI(gh)로 저장소 생성 및 푸시..."
  gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
  echo "✓ GitHub 푸시 완료: https://github.com/$(gh api user -q .login)/$REPO_NAME"
  echo ""
  echo "▼ Vercel 배포: https://vercel.com/new 에서 위 저장소 Import 후 Deploy"
  exit 0
fi

# 2) GITHUB_TOKEN으로 API 사용
if [ -n "$GITHUB_TOKEN" ]; then
  echo "→ GitHub API로 저장소 생성 중..."
  USER=$(curl -s -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user | grep '"login"' | head -1 | sed 's/.*"login": "\(.*\)".*/\1/')
  [ -z "$USER" ] && { echo "GITHUB_TOKEN 인증 실패"; exit 1; }
  curl -s -X POST -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/json" \
    -d "{\"name\":\"$REPO_NAME\",\"private\":false}" https://api.github.com/user/repos >/dev/null
  git remote add origin "https://${GITHUB_TOKEN}@github.com/${USER}/${REPO_NAME}.git" 2>/dev/null || git remote set-url origin "https://${GITHUB_TOKEN}@github.com/${USER}/${REPO_NAME}.git"
  git push -u origin main
  echo "✓ GitHub 푸시 완료: https://github.com/${USER}/${REPO_NAME}"
  echo ""
  echo "▼ Vercel: https://vercel.com/new → Import ${USER}/${REPO_NAME} → Deploy"
  exit 0
fi

# 3) 저장소 URL 직접 지정
if [ -n "$GITHUB_REPO_URL" ]; then
  echo "→ 원격 추가 후 푸시..."
  git remote add origin "$GITHUB_REPO_URL" 2>/dev/null || git remote set-url origin "$GITHUB_REPO_URL"
  git push -u origin main
  echo "✓ 푸시 완료."
  echo ""
  echo "▼ Vercel: https://vercel.com/new 에서 이 저장소 Import 후 Deploy"
  exit 0
fi

# 4) 안내
echo "GitHub에 올리려면 아래 중 하나를 해주세요."
echo ""
echo "방법 A) GitHub CLI 설치 후 한 번만 로그인:"
echo "  brew install gh && gh auth login"
echo "  ./deploy.sh"
echo ""
echo "방법 B) GitHub Personal Access Token 사용:"
echo "  GITHUB_TOKEN=ghp_xxxx ./deploy.sh"
echo ""
echo "방법 C) 이미 만든 저장소 URL 사용:"
echo "  GITHUB_REPO_URL=https://github.com/YOUR_GITHUB_USERNAME/$REPO_NAME.git ./deploy.sh"
echo ""
exit 1
