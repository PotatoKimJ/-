# 콩한쪽 — 전체 코드 (복사용)

아래 폴더 구조대로 파일을 만들고, 각 코드 블록을 그대로 붙여넣으면 됩니다.

---

## 배포 전 수정할 것 (요약)

| 수정 항목 | 파일 | 설명 |
|-----------|------|------|
| **GitHub 저장소 이름** | `deploy.sh` | `REPO_NAME="konghanjok"` → 원하는 이름으로 변경 |
| **Git 주소(타 유저/본인)** | `deploy.sh` 방법 C | `YOUR_GITHUB_USERNAME`을 실제 GitHub 아이디로 변경 후 `GITHUB_REPO_URL=...` 로 실행 |
| **메인 대기 현황 카드** | `index.html` | `preview-list` 안 카드 3개 문구 수정 (샘플 → 실제 대기 목록) |
| **매칭 상대 목록** | `match.html` | `<script>` 안 `partnerPool` 배열에 상대 후보 추가·수정 |

자세한 설명은 프로젝트 루트의 **CONFIG.md**를 참고하세요.

---

```
콩한쪽/
├── .gitignore
├── index.html       ← 메인 (타이틀 + 오늘 매칭 대기 현황 + AI 매칭하기)
├── match.html       ← AI 매칭 (폼 → matching.html로 이동)
├── matching.html    ← 매칭 로딩 + 설득 콘텐츠 + 게임 입장
├── destiny.html     ← 운명의 게임 (삼세판 가위바위보)
├── receipt.html     ← 에어팟 수령·결제·공유
├── auto-commit.sh   ← 자동 커밋 스크립트
├── deploy.sh        ← GitHub/Vercel 배포 스크립트
└── assets/
    ├── airpod-left.png
    ├── airpod-right.png
    └── airpods-complete.png
```

**이미지**: `assets/` 폴더에 `airpod-left.png`, `airpod-right.png`, `airpods-complete.png`를 준비하세요. (없어도 레이아웃만 깨질 수 있음)

---

## 1. .gitignore

```
.DS_Store
```

---

## 2. index.html

<details>
<summary>클릭하여 펼치기 → 아래 코드 블록 전체 복사</summary>

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>콩한쪽 — 잃어버린 에어팟을 건 운명의 게임</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
  <style>
    :root {
      --bg: #1a0f0f;
      --bg-gradient: radial-gradient(120% 120% at 10% 10%, #2d1515 0%, #1a0f0f 40%, #0d0808 100%);
      --surface: rgba(255, 255, 255, 0.08);
      --surface-strong: rgba(255, 255, 255, 0.12);
      --ink: #f5e6e6;
      --muted: #a08080;
      --brand: #c0392b;
      --brand-strong: #922b21;
      --border: rgba(160, 80, 80, 0.2);
      --shadow: 0 30px 80px rgba(80, 20, 20, 0.35);
      --radius-lg: 32px;
      --radius-md: 20px;
    }

    * { box-sizing: border-box; }

    body {
      margin: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background: var(--bg);
      background-image: var(--bg-gradient);
      color: var(--ink);
      min-height: 100vh;
      padding: 16px;
      position: relative;
      overflow-x: hidden;
    }

    body::before,
    body::after {
      content: "";
      position: fixed;
      width: 280px;
      height: 280px;
      background: linear-gradient(140deg, rgba(192, 57, 43, 0.25), rgba(146, 43, 33, 0.2));
      filter: blur(100px);
      z-index: -2;
      transform: translate(-50%, -50%);
    }
    body::before { top: 16%; left: 10%; }
    body::after { bottom: -8%; right: -6%; }

    .shell {
      max-width: 560px;
      margin: 0 auto;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      justify-content: center;
    }

    .hero-copy {
      text-align: center;
      margin-bottom: 32px;
    }

    .hero-copy h1 {
      font-size: clamp(1.75rem, 5vw, 2.25rem);
      line-height: 1.3;
      letter-spacing: -0.5px;
      margin: 0 0 28px;
      font-weight: 900;
    }

    .hero-copy h1 span { color: var(--brand-strong); }

    .hero-ctas {
      display: flex;
      justify-content: center;
      flex-wrap: wrap;
      gap: 12px;
    }

    .hero-ctas a {
      display: inline-block;
      padding: 18px 32px;
      border-radius: 16px;
      font-size: 1.05rem;
      font-weight: 700;
      text-decoration: none;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }

    .hero-ctas .primary {
      background: linear-gradient(130deg, var(--brand-strong), var(--brand));
      color: #fff;
      box-shadow: 0 16px 35px rgba(91, 95, 251, 0.35);
    }

    .hero-ctas .primary:hover {
      transform: translateY(-2px);
    }

    .hero-panel {
      background: var(--surface-strong);
      border-radius: var(--radius-lg);
      padding: 24px;
      border: 1px solid var(--border);
      box-shadow: var(--shadow);
      color: var(--ink);
    }

    .hero-panel h2 {
      font-size: 1.1rem;
      margin: 0 0 16px;
      font-weight: 700;
    }

    .preview-list { display: grid; gap: 10px; }

    .preview-card {
      padding: 14px 16px;
      border-radius: 14px;
      border: 1px solid var(--border);
      background: rgba(255, 255, 255, 0.08);
      display: flex;
      align-items: center;
      gap: 12px;
      color: var(--ink);
    }

    .preview-card .badge {
      width: 40px;
      height: 40px;
      border-radius: 12px;
      display: grid;
      place-items: center;
      font-weight: 700;
      color: var(--brand-strong);
      background: rgba(91, 95, 251, 0.12);
      font-size: 0.9rem;
    }

    .preview-card p { margin: 0; font-weight: 600; font-size: 0.95rem; }
    .preview-card span { display: block; font-size: 0.8rem; color: var(--muted); margin-top: 2px; }

    @media (min-width: 480px) {
      body { padding: 24px; }
      .shell { max-width: 520px; }
      .hero-panel { padding: 28px; }
    }
  </style>
</head>
<body>
  <div class="shell">
    <main>
      <section class="hero-copy">
        <h1><span>콩한쪽</span><br>잃어버린 에어팟을 건 운명의 게임</h1>
        <div class="hero-ctas">
          <a class="primary" href="match.html">AI 매칭하기</a>
        </div>
      </section>
      <article class="hero-panel">
        <h2>오늘 매칭 대기 현황</h2>
        <div class="preview-list">
          <div class="preview-card">
            <div class="badge">L</div>
            <div>
              <p>AirPods Pro 2 · 좌측 한 쪽</p>
              <span>"노이즈캔슬링 다시 느끼고 싶어요"</span>
            </div>
          </div>
          <div class="preview-card">
            <div class="badge">R</div>
            <div>
              <p>AirPods 3 · 우측 한 쪽</p>
              <span>"반쪽이라 BGM이 울려요 😢"</span>
            </div>
          </div>
          <div class="preview-card">
            <div class="badge">L</div>
            <div>
              <p>AirPods Pro 1 · 좌측 한 쪽</p>
              <span>"운명의 짝을 찾고 싶어요"</span>
            </div>
          </div>
        </div>
      </article>
    </main>
  </div>
</body>
</html>
```

</details>

---

## 3. match.html

<details>
<summary>클릭하여 펼치기 → 아래 코드 블록 전체 복사</summary>

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AI 매칭 | 콩한쪽</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
  <style>
    :root {
      --bg: #1a0f0f;
      --bg-gradient: radial-gradient(120% 120% at 10% 10%, #2d1515 0%, #1a0f0f 40%, #0d0808 100%);
      --surface: rgba(255, 255, 255, 0.08);
      --surface-strong: rgba(255, 255, 255, 0.12);
      --ink: #f5e6e6;
      --muted: #a08080;
      --brand: #c0392b;
      --brand-strong: #922b21;
      --accent: #27ae60;
      --border: rgba(160, 80, 80, 0.2);
      --radius-md: 20px;
      --radius-sm: 14px;
    }

    * { box-sizing: border-box; }

    body {
      margin: 0;
      font-family: 'Noto Sans KR', sans-serif;
      background: var(--bg);
      background-image: var(--bg-gradient);
      color: var(--ink);
      min-height: 100vh;
      padding: 16px;
      overflow-x: hidden;
    }

    .shell {
      max-width: 480px;
      margin: 0 auto;
      padding: 24px 0;
    }

    .back {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      color: var(--muted);
      text-decoration: none;
      font-weight: 600;
      font-size: 0.9rem;
      margin-bottom: 24px;
    }
    .back:hover { color: var(--brand-strong); }

    h1 {
      font-size: 1.5rem;
      margin: 0 0 24px;
      font-weight: 800;
    }

    .card {
      background: var(--surface-strong);
      border-radius: var(--radius-md);
      padding: 24px;
      border: 1px solid var(--border);
      box-shadow: 0 20px 40px rgba(0,0,0,0.3);
      margin-bottom: 20px;
    }

    .input-group label {
      display: block;
      font-weight: 600;
      margin-bottom: 8px;
      font-size: 0.95rem;
    }

    .input-group select,
    .input-group input {
      width: 100%;
      padding: 14px 16px;
      border-radius: var(--radius-sm);
      border: 2px solid rgba(160, 80, 80, 0.35);
      background: rgba(255, 255, 255, 0.95);
      font-size: 1.05rem;
      font-weight: 500;
      color: #1a0f0f;
    }
    .input-group select:focus,
    .input-group input:focus {
      outline: none;
      border-color: var(--brand);
      background: #fff;
    }
    .input-group select option {
      color: #1a0f0f;
      background: #fff;
    }

    .input-group + .input-group { margin-top: 18px; }

    .slider-row { display: flex; align-items: center; gap: 12px; }
    .slider-row input[type="range"] { flex: 1; }
    .slider-value { font-weight: 700; color: var(--brand-strong); min-width: 64px; text-align: right; }

    .btn {
      width: 100%;
      padding: 18px;
      border-radius: var(--radius-sm);
      border: none;
      font-weight: 700;
      font-size: 1.05rem;
      cursor: pointer;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
      margin-top: 24px;
    }

    .btn-primary {
      background: linear-gradient(130deg, var(--brand-strong), var(--brand));
      color: #fff;
      box-shadow: 0 16px 34px rgba(91, 95, 251, 0.28);
    }
    .btn-primary:hover { transform: translateY(-1px); }

    .match-result {
      min-height: 120px;
      display: grid;
      gap: 14px;
      justify-items: center;
      text-align: center;
    }

    .match-result #resultContent {
      display: flex;
      flex-direction: column;
      align-items: center;
      width: 100%;
    }

    .match-result .match-profile {
      text-align: center;
    }

    .result-badge {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 12px;
      border-radius: 999px;
      background: rgba(91, 95, 251, 0.12);
      color: var(--brand-strong);
      font-weight: 600;
      font-size: 0.9rem;
    }

    .match-profile {
      padding: 18px;
      border-radius: var(--radius-sm);
      background: rgba(91, 95, 251, 0.08);
      border: 1px solid var(--border);
    }

    .match-profile h3 { margin: 0 0 8px; font-size: 1.1rem; }
    .match-meta { font-size: 0.9rem; color: var(--muted); display: grid; gap: 4px; }
    .compatibility {
      display: inline-flex;
      align-items: center;
      gap: 8px;
      padding: 12px 16px;
      border-radius: var(--radius-sm);
      background: rgba(39, 174, 96, 0.2);
      color: var(--accent);
      font-weight: 700;
      margin-top: 14px;
    }

    .match-profile h3,
    .match-meta { color: var(--ink); }

    .game-entry-wrap { margin-top: 20px; display: flex; justify-content: center; width: 100%; }
    .game-entry-wrap .btn { margin-top: 0; }

    .hidden { display: none !important; }

    @media (min-width: 480px) {
      body { padding: 24px; }
      .card { padding: 28px; }
    }
  </style>
</head>
<body>
  <div class="shell">
    <a class="back" href="index.html">← 메인으로</a>
    <h1>AI 매칭</h1>

    <form class="card match-form" id="match-form">
      <div class="input-group">
        <label for="model">보유 중인 모델</label>
        <select id="model" name="model" required>
          <option value="AirPods Pro 2">AirPods Pro 2</option>
          <option value="AirPods Pro 1">AirPods Pro 1</option>
          <option value="AirPods 3">AirPods 3</option>
          <option value="AirPods 2">AirPods 2</option>
        </select>
      </div>
      <div class="input-group">
        <label for="side">보유 중인 방향</label>
        <select id="side" name="side" required>
          <option value="left">좌측만 남았어요</option>
          <option value="right">우측만 남았어요</option>
        </select>
      </div>
      <div class="input-group">
        <label for="condition">내 에어팟 컨디션</label>
        <select id="condition" name="condition" required>
          <option value="S">S급 · 거의 새것</option>
          <option value="A">A급 · 생활기스 정도</option>
          <option value="B">B급 · 눈에 띄는 사용감</option>
        </select>
      </div>
      <div class="input-group">
        <label for="usageMonths">사용 기간</label>
        <div class="slider-row">
          <input type="range" id="usageMonths" name="usageMonths" min="0" max="36" step="1" value="8">
          <span class="slider-value" id="usageValue">8개월</span>
        </div>
      </div>
      <button class="btn btn-primary" type="submit">AI 매칭 돌리기</button>
    </form>

    <aside class="card match-result hidden" id="match-result">
      <span class="result-badge" id="resultBadge">🎯 매칭 결과</span>
      <div id="resultContent"></div>
      <div class="game-entry-wrap hidden" id="gameEntryWrap">
        <a class="btn btn-primary" href="destiny.html" id="gameEntryBtn">게임 입장하기</a>
      </div>
    </aside>
  </div>

  <script>
    const usageInput = document.getElementById('usageMonths');
    const usageValue = document.getElementById('usageValue');
    const matchForm = document.getElementById('match-form');
    const matchResult = document.getElementById('match-result');
    const resultContent = document.getElementById('resultContent');
    const gameEntryWrap = document.getElementById('gameEntryWrap');

    const partnerPool = [
      { name: '윤서', model: 'AirPods Pro 2', side: 'right', usageMonths: 9, condition: 'S', distance: '서울 성수동', vibe: '출퇴근 러너', message: '지하철에서 오른쪽 한 쪽을 잃어버렸어요. 좌측만 남았습니다!' },
      { name: '지호', model: 'AirPods Pro 2', side: 'left', usageMonths: 6, condition: 'A', distance: '부산 서면', vibe: '밴드 드러머', message: '공연 끝나고 정신없이 챙기다 한 쪽이 사라졌어요.' },
      { name: '혜림', model: 'AirPods 3', side: 'right', usageMonths: 10, condition: 'A', distance: '대구 동성로', vibe: '콘텐츠 마케터', message: '오른쪽만 남아서 드라마 몰입도가 50%로 줄었어요!' },
      { name: '민후', model: 'AirPods 3', side: 'left', usageMonths: 12, condition: 'B', distance: '서울 연남동', vibe: '카페 투어러', message: '카페에서 충전하다가 누가 가져갔는지 오른쪽이 없어졌어요.' },
      { name: '소연', model: 'AirPods Pro 1', side: 'right', usageMonths: 18, condition: 'B', distance: '인천 송도', vibe: '필라테스 러버', message: '필라테스 장비 사이로 굴러간 것 같아요. 왼쪽만 살았습니다.' },
      { name: '태준', model: 'AirPods Pro 1', side: 'left', usageMonths: 16, condition: 'A', distance: '대전 둔산동', vibe: '게임 스트리머', message: '새벽 방송하다가 왼쪽이 갑자기 침대 밑으로 사라졌어요.' },
      { name: '다은', model: 'AirPods 2', side: 'right', usageMonths: 20, condition: 'B', distance: '경주 황성동', vibe: '여행 크리에이터', message: '여행 중에 떨어뜨려서 오른쪽이 고별인사했어요.' },
      { name: '정우', model: 'AirPods 2', side: 'left', usageMonths: 14, condition: 'A', distance: '서울 광화문', vibe: '도심 포토그래퍼', message: '찍다가 부산하게 움직이다 왼쪽만 살아남았습니다.' }
    ];

    const conditionLabel = { S: 'S급 · 거의 새것', A: 'A급 · 생활기스 정도', B: 'B급 · 눈에 띄는 사용감' };

    usageInput.addEventListener('input', () => {
      usageValue.textContent = usageInput.value + '개월';
    });

    matchForm.addEventListener('submit', (e) => {
      e.preventDefault();
      const formData = new FormData(matchForm);
      const model = formData.get('model');
      const haveSide = formData.get('side');
      const needSide = haveSide === 'left' ? 'right' : 'left';
      const condition = formData.get('condition');
      const usageMonths = Number(formData.get('usageMonths'));

      const candidates = partnerPool
        .filter((p) => p.model === model && p.side === needSide)
        .map((p) => {
          const usageGap = Math.abs(p.usageMonths - usageMonths);
          const conditionGap = Math.abs(p.condition.charCodeAt(0) - condition.charCodeAt(0));
          const score = usageGap * 2 + conditionGap * 5;
          const compatibility = Math.max(48, Math.round(100 - score * 3));
          return { ...p, score, compatibility };
        })
        .sort((a, b) => a.score - b.score);

      if (candidates.length === 0) {
        sessionStorage.setItem('matchPending', JSON.stringify({ noMatch: true }));
        location.href = 'matching.html';
        return;
      }

      const best = candidates[0];
      const payload = {
        mySide: haveSide,
        model: model,
        condition: condition,
        oppModel: best.model,
        oppSide: best.side,
        oppCondition: best.condition
      };
      sessionStorage.setItem('matchPending', JSON.stringify(payload));
      location.href = 'matching.html';
    });
  </script>
</body>
</html>
```

</details>

---

## 4. matching.html

<details>
<summary>클릭하여 펼치기 → 아래 코드 블록 전체 복사</summary>

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AI 매칭 중 | 콩한쪽</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
  <style>
    :root {
      --bg: #1a0f0f;
      --bg-gradient: radial-gradient(120% 120% at 10% 10%, #2d1515 0%, #1a0f0f 40%, #0d0808 100%);
      --ink: #f5e6e6;
      --muted: #a08080;
      --brand: #c0392b;
      --brand-strong: #922b21;
      --accent: #27ae60;
      --surface: rgba(255, 255, 255, 0.08);
      --border: rgba(160, 80, 80, 0.2);
      --radius: 20px;
    }

    * { box-sizing: border-box; }

    html, body {
      margin: 0;
      padding: 0;
      min-height: 100vh;
      font-family: 'Noto Sans KR', sans-serif;
      background: var(--bg);
      background-image: var(--bg-gradient);
      color: var(--ink);
      overflow-x: hidden;
    }

    .page {
      width: 100%;
      max-width: 100%;
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      padding: 56px 16px 24px;
      box-sizing: border-box;
    }

    @media (min-width: 720px) {
      .page {
        flex-direction: row;
        align-items: stretch;
        gap: 0;
        padding: 56px 24px 24px;
      }
    }

    .back {
      position: absolute;
      top: 16px;
      left: 16px;
      color: var(--muted);
      text-decoration: none;
      font-weight: 600;
      font-size: 0.9rem;
      z-index: 10;
    }
    .back:hover { color: var(--brand-strong); }

    .matching-side {
      flex: 0 0 auto;
      width: 100%;
      max-width: 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 220px;
      padding: 24px 16px;
      position: relative;
      box-sizing: border-box;
    }

    @media (min-width: 720px) {
      .matching-side {
        flex: 0 0 42%;
        min-height: 100vh;
        padding: 60px 40px;
      }
    }

    .matching-side.complete .loading-content { display: none; }
    .matching-side.complete .complete-content { display: flex; }
    .loading-content { display: flex; flex-direction: column; align-items: center; gap: 24px; }
    .complete-content { display: none; flex-direction: column; align-items: center; gap: 20px; }

    .loading-spinner {
      width: 64px;
      height: 64px;
      border: 4px solid rgba(255,255,255,0.15);
      border-top-color: var(--brand);
      border-radius: 50%;
      animation: spin 1s linear infinite;
    }

    @keyframes spin {
      to { transform: rotate(360deg); }
    }

    .loading-text {
      font-size: 1.25rem;
      font-weight: 700;
      color: rgba(255,255,255,0.9);
      animation: pulse 1.5s ease-in-out infinite;
    }

    @keyframes pulse {
      0%, 100% { opacity: 1; }
      50% { opacity: 0.6; }
    }

    .loading-sub {
      font-size: 0.9rem;
      color: var(--muted);
    }

    .complete-badge {
      font-size: 1.1rem;
      font-weight: 800;
      color: var(--accent);
      text-shadow: 0 0 20px rgba(39, 174, 96, 0.5);
    }

    .complete-desc {
      font-size: 0.95rem;
      color: rgba(255,255,255,0.8);
      text-align: center;
    }

    .btn-game-entry {
      display: inline-block;
      margin-top: 12px;
      padding: 16px 32px;
      border-radius: 14px;
      border: none;
      background: linear-gradient(130deg, var(--brand-strong), var(--brand));
      color: #fff;
      font-size: 1.05rem;
      font-weight: 700;
      text-decoration: none;
      cursor: pointer;
      box-shadow: 0 8px 24px rgba(192, 57, 43, 0.4);
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .btn-game-entry:hover {
      transform: scale(1.03);
      box-shadow: 0 12px 32px rgba(192, 57, 43, 0.5);
    }

    .copy-side {
      flex: 1;
      width: 100%;
      max-width: 100%;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      padding: 24px 16px 32px;
      overflow-y: auto;
      text-align: center;
      box-sizing: border-box;
    }

    @media (min-width: 720px) {
      .copy-side {
        padding: 60px 48px;
        max-width: 58%;
      }
    }

    .copy-side .hero-img {
      width: auto;
      max-width: min(200px, 50vw);
      height: auto;
      margin: 0 auto 20px;
      display: block;
      filter: drop-shadow(0 12px 32px rgba(0,0,0,0.4));
    }

    .copy-side .hook {
      font-size: clamp(1.25rem, 5vw, 1.8rem);
      font-weight: 900;
      margin: 0 0 12px;
      color: #fff;
      line-height: 1.3;
      letter-spacing: -0.02em;
      max-width: 100%;
    }

    .copy-side .hook span { color: var(--brand-strong); }

    .copy-side .hook-sub {
      font-size: clamp(0.8rem, 2.2vw, 0.9rem);
      color: var(--muted);
      margin: -4px 0 14px;
      line-height: 1.45;
    }

    .copy-side .tag {
      font-size: clamp(0.95rem, 3vw, 1rem);
      font-weight: 600;
      color: var(--accent);
      margin-bottom: 16px;
    }

    .copy-side .one-liner {
      font-size: clamp(0.95rem, 2.8vw, 1.05rem);
      line-height: 1.55;
      color: rgba(255,255,255,0.9);
      margin: 0 0 10px;
      font-weight: 500;
      max-width: 100%;
    }

    .copy-side .punch {
      font-size: clamp(1rem, 3vw, 1.1rem);
      font-weight: 800;
      color: #fff;
      margin-top: 8px;
    }

    .copy-side .eco {
      margin-top: 18px;
      line-height: 1.5;
    }

    .copy-side .eco strong {
      font-size: clamp(1.1rem, 3.5vw, 1.25rem);
      font-weight: 900;
      color: var(--accent);
      display: block;
      margin-bottom: 4px;
    }

    .copy-side .eco-small {
      display: block;
      font-size: clamp(0.75rem, 2vw, 0.85rem);
      color: var(--muted);
    }

    .copy-side .eco-tagline {
      display: block;
      font-size: clamp(0.9rem, 2.5vw, 0.95rem);
      font-weight: 600;
      color: rgba(255,255,255,0.9);
      margin-top: 6px;
    }

    .no-match-msg {
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      text-align: center;
      padding: 24px;
      color: var(--muted);
    }
    .no-match-msg .btn-back {
      display: inline-block;
      margin-top: 16px;
      padding: 14px 28px;
      border-radius: 14px;
      background: var(--surface);
      color: var(--ink);
      text-decoration: none;
      font-weight: 700;
      border: 2px solid var(--border);
    }
    .no-match-msg .btn-back:hover { border-color: var(--brand); color: #fff; }

    .hidden { display: none !important; }
  </style>
</head>
<body>
  <a class="back" href="match.html">← 매칭으로</a>

  <div class="page">
    <section class="matching-side" id="matchingSide">
      <div class="loading-content">
        <div class="loading-spinner" aria-hidden="true"></div>
        <p class="loading-text">매칭 중...</p>
        <p class="loading-sub">나와 꼭 맞는 상대를 찾고 있어요</p>
      </div>
      <div class="complete-content">
        <p class="complete-badge">✓ 매칭 완료!</p>
        <p class="complete-desc" id="completeDesc">상대를 찾았어요.<br>게임에서 이기면 에어팟 완전체를 받을 수 있어요.</p>
        <a href="#" class="btn-game-entry" id="btnGameEntry">게임 입장하기</a>
      </div>
    </section>

    <section class="copy-side">
      <img src="assets/airpods-complete.png" alt="" class="hero-img">
      <p class="tag">분실도 콘텐츠로! 도파민 한판 거래~ 🎧</p>
      <h2 class="hook"><span>85%</span> 절감 · <span>200%</span> 더 재밌게</h2>
      <p class="hook-sub">새로 사면 11만 원, 이기면 1만 원대로 완전체 합체!</p>
      <p class="one-liner">이기면 완전체 가져가고, 수수료만 기분 좋게 내면 끝~ 💸</p>
      <p class="punch">한쪽만 있어도 괜찮아. 게임 한 판 이기면 완전체 내 거! 기분 좋게 한판 해볼까요? 😊</p>
      <p class="eco"><strong>ECO!</strong><span class="eco-small">전자 폐기물 최소화</span><span class="eco-tagline">세상의 모든 콩이 다시 짝을 찾는 그날까지!</span></p>
    </section>
  </div>

  <div class="no-match-msg hidden" id="noMatchMsg">
    <p>아직 준비된 파트너가 없어요.<br>잠시 후 다시 시도해 주세요!</p>
    <a href="match.html" class="btn-back">매칭 화면으로 돌아가기</a>
  </div>

  <script>
    (function () {
      const MATCH_DURATION_MS = 4000;
      const key = 'matchPending';
      const data = sessionStorage.getItem(key);

      const matchingSide = document.getElementById('matchingSide');
      const completeDesc = document.getElementById('completeDesc');
      const btnGameEntry = document.getElementById('btnGameEntry');
      const noMatchMsg = document.getElementById('noMatchMsg');

      if (!data) {
        document.querySelector('.page').classList.add('hidden');
        noMatchMsg.classList.remove('hidden');
        return;
      }

      let payload;
      try {
        payload = JSON.parse(data);
      } catch (e) {
        noMatchMsg.classList.remove('hidden');
        document.querySelector('.page').style.display = 'none';
        return;
      }

      if (payload.noMatch) {
        matchingSide.querySelector('.loading-content').innerHTML = '<p class="loading-text">매칭 결과 없음</p>';
        setTimeout(() => {
          sessionStorage.removeItem(key);
          noMatchMsg.classList.remove('hidden');
          document.querySelector('.page').classList.add('hidden');
        }, 1500);
        return;
      }

      const params = new URLSearchParams({
        mySide: payload.mySide,
        model: payload.model,
        condition: payload.condition,
        oppModel: payload.oppModel,
        oppSide: payload.oppSide,
        oppCondition: payload.oppCondition
      });
      btnGameEntry.href = 'destiny.html?' + params.toString();

      setTimeout(() => {
        matchingSide.classList.add('complete');
      }, MATCH_DURATION_MS);
    })();
  </script>
</body>
</html>
```

</details>

---

## 5. destiny.html

**destiny.html**은 길어서, 프로젝트 폴더에서 **destiny.html**을 열고 **Cmd+A** → **Cmd+C** → 새 `destiny.html`에 **Cmd+V**로 복사하는 것을 권장합니다.  
동일한 폴더에 이미 있다면 그대로 두면 됩니다.

---

## 6. receipt.html

<details>
<summary>클릭하여 펼치기 → 아래 코드 블록 전체 복사</summary>

```html
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>에어팟 수령 · 결제 | 콩한쪽</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700;900&display=swap" rel="stylesheet">
  <style>
    :root {
      --ink: #1a2e1a;
      --muted: #4a6b4a;
      --brand: #2d8a3e;
      --brand-strong: #1e6b2c;
      --accent: #f0c14b;
      --bg: #f0f9f0;
      --surface: rgba(255, 255, 255, 0.9);
      --radius: 20px;
    }

    * { box-sizing: border-box; }

    html, body {
      margin: 0;
      padding: 0;
      min-height: 100vh;
      font-family: 'Noto Sans KR', sans-serif;
      background: var(--bg);
      color: var(--ink);
      overflow-x: hidden;
    }

    body::before {
      content: "";
      position: fixed;
      inset: 0;
      background: radial-gradient(80% 80% at 50% 0%, rgba(45, 138, 62, 0.12) 0%, transparent 50%),
                  radial-gradient(60% 60% at 80% 80%, rgba(240, 193, 75, 0.15) 0%, transparent 50%);
      pointer-events: none;
      z-index: 0;
    }

    .page {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      padding: 24px;
      position: relative;
      z-index: 1;
    }

    .back-link {
      position: absolute;
      top: 16px;
      left: 16px;
      color: var(--muted);
      text-decoration: none;
      font-weight: 600;
      font-size: 0.9rem;
    }
    .back-link:hover { color: var(--brand-strong); }

    .congrats {
      text-align: center;
      margin-bottom: 20px;
    }

    .congrats .emoji {
      font-size: 2.5rem;
      display: block;
      margin-bottom: 8px;
    }

    .congrats h1 {
      font-size: clamp(1.3rem, 4vw, 1.6rem);
      font-weight: 800;
      margin: 0 0 8px;
      color: var(--brand-strong);
    }

    .congrats .sub {
      font-size: 0.95rem;
      color: var(--muted);
      line-height: 1.5;
    }

    .receipt-card {
      width: 100%;
      max-width: 360px;
      background: var(--surface);
      border-radius: var(--radius);
      border: 2px solid rgba(45, 138, 62, 0.25);
      padding: 24px;
      margin-bottom: 16px;
      box-shadow: 0 8px 32px rgba(45, 138, 62, 0.12);
    }

    .receipt-card h2 {
      font-size: 1rem;
      font-weight: 700;
      margin: 0 0 16px;
      color: var(--ink);
      border-bottom: 2px solid rgba(45, 138, 62, 0.2);
      padding-bottom: 10px;
    }

    .receipt-row {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      padding: 10px 0;
      font-size: 0.95rem;
      color: var(--ink);
    }

    .receipt-row .label-wrap {
      flex: 1;
      min-width: 0;
    }

    .receipt-row .label-detail {
      font-size: 0.8rem;
      color: var(--muted);
      margin-top: 2px;
    }

    .receipt-row.total {
      margin-top: 12px;
      padding-top: 16px;
      border-top: 2px solid rgba(45, 138, 62, 0.3);
      font-size: 1.1rem;
      font-weight: 800;
      color: var(--brand-strong);
    }

    .receipt-row .amount {
      font-weight: 700;
      color: var(--brand-strong);
    }

    .receipt-row.total .amount {
      font-size: 1.25rem;
      color: var(--brand-strong);
    }

    .shipping-note {
      width: 100%;
      max-width: 360px;
      font-size: 0.9rem;
      color: var(--muted);
      text-align: center;
      margin-bottom: 24px;
      line-height: 1.5;
    }

    .btn-pay {
      display: block;
      width: 100%;
      max-width: 360px;
      padding: 18px 24px;
      border-radius: var(--radius);
      border: none;
      background: linear-gradient(130deg, var(--brand-strong), var(--brand));
      color: #fff;
      font-size: 1.1rem;
      font-weight: 700;
      cursor: pointer;
      box-shadow: 0 8px 24px rgba(45, 138, 62, 0.35);
      transition: transform 0.2s ease, box-shadow 0.2s ease;
      margin-bottom: 20px;
    }

    .btn-pay:hover {
      transform: scale(1.02);
      box-shadow: 0 12px 32px rgba(45, 138, 62, 0.45);
    }

    .share-section {
      width: 100%;
      max-width: 360px;
      text-align: center;
    }

    .share-section .share-title {
      font-size: 0.95rem;
      font-weight: 700;
      color: var(--ink);
      margin-bottom: 12px;
    }

    .share-btns {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      justify-content: center;
    }

    .share-btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      gap: 6px;
      padding: 12px 16px;
      border-radius: 12px;
      border: 2px solid rgba(45, 138, 62, 0.3);
      background: var(--surface);
      color: var(--ink);
      font-size: 0.9rem;
      font-weight: 600;
      cursor: pointer;
      text-decoration: none;
      transition: all 0.2s ease;
    }

    .share-btn:hover {
      border-color: var(--brand);
      background: rgba(45, 138, 62, 0.08);
    }

    .share-btn.kakao { border-color: #fee500; background: #fee500; color: #191919; }
    .share-btn.kakao:hover { filter: brightness(1.05); }
    .share-btn.instagram { border-color: #e4405f; background: linear-gradient(45deg, #f09433, #e4405f); color: #fff; }
    .share-btn.instagram:hover { filter: brightness(1.1); }
    .share-btn.facebook { border-color: #1877f2; background: #1877f2; color: #fff; }
    .share-btn.facebook:hover { filter: brightness(1.1); }
  </style>
</head>
<body>
  <div class="page">
    <a class="back-link" href="index.html">← 메인으로</a>

    <div class="congrats">
      <span class="emoji">🎉</span>
      <h1>축하해요! 이제 완전체로 들을 수 있어요</h1>
      <p class="sub">에어팟 한 쌍을 되찾았어요. 결제만 하시면 됩니다.</p>
    </div>

    <div class="receipt-card">
      <h2>영수증</h2>
      <div class="receipt-row">
        <span>상대 참가자 배송비</span>
        <span class="amount">3,500원</span>
      </div>
      <div class="receipt-row">
        <div class="label-wrap">
          <span>본인 배송비</span>
          <div class="label-detail">처음 보낼 때 3,500원 + 에어팟 완전체 수령 배송비 3,500원</div>
        </div>
        <span class="amount">7,000원</span>
      </div>
      <div class="receipt-row">
        <span>참가비</span>
        <span class="amount">10,000원</span>
      </div>
      <div class="receipt-row total">
        <span>총 결제 금액</span>
        <span class="amount">20,500원</span>
      </div>
    </div>

    <p class="shipping-note">회수했던 주소로 다시 보내드립니다.</p>

    <button type="button" class="btn-pay" id="btnPay">결제하기</button>

    <div class="share-section">
      <p class="share-title">🎧 친구에게 콩한쪽 알려주기</p>
      <div class="share-btns">
        <a href="#" class="share-btn kakao" id="shareKakao" title="카카오톡">카톡</a>
        <a href="#" class="share-btn instagram" id="shareInstagram" title="인스타그램">인스타</a>
        <a href="#" class="share-btn facebook" id="shareFacebook" title="페이스북">페이스북</a>
        <button type="button" class="share-btn" id="shareCopy" title="URL 복사">URL 복사</button>
        <a href="#" class="share-btn" id="shareSms" title="문자">문자</a>
      </div>
    </div>
  </div>

  <script>
    document.getElementById('btnPay').addEventListener('click', () => {
      alert('결제 기능은 준비 중입니다.');
    });

    var shareUrl = (function() {
      var origin = window.location.origin;
      var path = window.location.pathname.replace(/\/receipt\.html$/, '') || '';
      return origin + path + (path.endsWith('/') ? '' : '/') + 'index.html';
    })();
    var shareText = '콩한쪽 — 잃어버린 에어팟을 건 운명의 게임 🎧';

    document.getElementById('shareKakao').addEventListener('click', function(e) {
      e.preventDefault();
      if (typeof Kakao !== 'undefined' && Kakao.isInitialized()) {
        Kakao.Share.sendDefault({ objectType: 'feed', content: { title: '콩한쪽', description: shareText, link: { webUrl: shareUrl } } });
      } else {
        window.open('https://story.kakao.com/share?url=' + encodeURIComponent(shareUrl), '_blank', 'width=500,height=600');
      }
    });

    document.getElementById('shareInstagram').addEventListener('click', function(e) {
      e.preventDefault();
      navigator.clipboard.writeText(shareUrl).then(function() { alert('링크가 복사되었어요. 인스타에 붙여넣기 하세요!'); }).catch(function() { prompt('아래 URL을 복사하세요', shareUrl); });
    });

    document.getElementById('shareFacebook').setAttribute('href', 'https://www.facebook.com/sharer/sharer.php?u=' + encodeURIComponent(shareUrl));
    document.getElementById('shareFacebook').setAttribute('target', '_blank');

    document.getElementById('shareCopy').addEventListener('click', function() {
      navigator.clipboard.writeText(shareUrl).then(function() { alert('URL이 복사되었어요!'); }).catch(function() { prompt('아래 URL을 복사하세요', shareUrl); });
    });

    document.getElementById('shareSms').setAttribute('href', 'sms:?body=' + encodeURIComponent(shareText + ' ' + shareUrl));
    document.getElementById('shareSms').setAttribute('target', '_blank');
  </script>
</body>
</html>
```

</details>

---

## 7. auto-commit.sh

<details>
<summary>클릭하여 펼치기</summary>

```bash
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
```

</details>

---

## 8. deploy.sh

<details>
<summary>클릭하여 펼치기</summary>

```bash
#!/bin/bash
set -e
cd "$(dirname "$0")"

REPO_NAME="konghanjok"

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
echo "  GITHUB_REPO_URL=https://github.com/사용자명/$REPO_NAME.git ./deploy.sh"
echo ""
exit 1
```

</details>

---

## 한 번에 복사하는 방법 요약

| 파일 | 방법 |
|------|------|
| **.gitignore** | 위 "1. .gitignore" 블록 내용 복사 |
| **index.html** | "2. index.html" `<details>` 펼친 뒤 코드 블록 전체 복사 |
| **match.html** | "3. match.html" `<details>` 펼친 뒤 코드 블록 전체 복사 |
| **matching.html** | "4. matching.html" `<details>` 펼친 뒤 코드 블록 전체 복사 |
| **destiny.html** | 프로젝트의 `destiny.html` 열기 → Cmd+A → Cmd+C → 새 파일에 Cmd+V |
| **receipt.html** | "6. receipt.html" `<details>` 펼친 뒤 코드 블록 전체 복사 |
| **auto-commit.sh** | "7. auto-commit.sh" 블록 복사 후 `chmod +x auto-commit.sh` |
| **deploy.sh** | "8. deploy.sh" 블록 복사 후 `chmod +x deploy.sh` |

같은 폴더에 HTML들을 두고 `assets/`에 이미지 세 개를 넣은 뒤 브라우저에서 **index.html**을 열면 동작합니다.
