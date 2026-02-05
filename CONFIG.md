# 배포 전 수정·보완 가이드

**현재 원격 저장소:** `https://github.com/PotatoKimJ/-.git` (이 폴더에서 `git push origin main` 시 위 주소로 푸시됩니다.)

이 프로젝트를 **내 저장소**로 올리거나 **타 유저 Git 주소**로 배포할 때 수정하면 좋은 항목입니다.

---

## 1. GitHub 저장소 (deploy.sh)

| 항목 | 위치 | 설명 |
|------|------|------|
| **저장소 이름** | `deploy.sh` 상단 `REPO_NAME="konghanjok"` | 원하는 이름으로 변경 (예: `my-konghanjok`) |
| **내 GitHub 주소** | 방법 C 사용 시 | `YOUR_GITHUB_USERNAME`을 본인 GitHub 아이디로 변경 |

**예시 (이미 만든 저장소로 푸시):**
```bash
GITHUB_REPO_URL=https://github.com/내아이디/저장소이름.git ./deploy.sh
```

---

## 2. 메인 페이지 대기 현황 (index.html)

**위치:** `index.html` → `<article class="hero-panel">` 안의 `preview-list`

- **오늘 매칭 대기 현황**에 보이는 카드 3개는 **샘플 데이터**입니다.
- 실제 대기 목록으로 바꾸려면 각 `preview-card` 안의 문구를 수정하세요.
  - `badge`: L / R (좌측/우측)
  - `p`: 모델명 · 방향
  - `span`: 한 줄 메시지(따옴표 안)

---

## 3. AI 매칭 상대 풀 (match.html)

**위치:** `match.html` → `<script>` 안의 `partnerPool` 배열

- 매칭에 사용되는 **상대 후보 목록**입니다. 이름, 모델, 방향, 지역, 메시지 등을 자유롭게 추가·수정하세요.
- 필드: `name`, `model`, `side`(left/right), `usageMonths`, `condition`(S/A/B), `distance`, `vibe`, `message`

---

## 4. 공유 URL (receipt.html 등)

- 공유하기 버튼의 링크는 **현재 접속한 도메인**을 자동으로 사용합니다.
- Vercel 등으로 배포하면 `https://내프로젝트.vercel.app/index.html` 형태로 공유됩니다. **별도 수정 불필요.**

---

## 5. 이미지 (assets/)

- `assets/` 폴더: `airpod-left.png`, `airpod-right.png`, `airpods-complete.png` 등 필요 이미지를 넣어두세요.
- 경로를 바꾸려면 각 HTML에서 `assets/...` 를 검색해 수정하면 됩니다.

---

## 6. 기타

- **결제·접수:** `receipt.html` 결제, `submit.html` 접수는 현재 데모 수준입니다. 실제 서비스 시 백엔드/결제 API 연동이 필요합니다.
- **브랜치:** 스크립트는 `main` 기준입니다. 다른 기본 브랜치를 쓰면 `deploy.sh`, `auto-commit.sh`에서 `main`을 해당 브랜치명으로 바꾸세요.

수정 후 `./deploy.sh` 또는 `GITHUB_REPO_URL=... ./deploy.sh` 로 푸시하고, Vercel에서 해당 저장소를 Import 해 배포하면 됩니다.
