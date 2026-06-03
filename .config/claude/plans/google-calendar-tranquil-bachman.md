# Google Calendar ↔ TimeTree 双方向同期スクリプト

## Context

Google CalendarとTimeTreeのイベントを15分ごとに自動双方向同期する。GitHub Actionsのcronで定期実行し、永続状態はリポジトリにコミットされた`sync-state.json`で管理する。

**注意**: TimeTree APIは2023年12月に新規申請が終了しているが、既存のPersonal Access Tokenは引き続き機能する前提で実装する。動作確認は初回セットアップ時に要実施。

---

## ディレクトリ構成

```
calendar-sync/
├── src/
│   ├── index.ts       # エントリーポイント・オーケストレーション
│   ├── google.ts      # Google Calendar APIクライアント
│   ├── timetree.ts    # TimeTree APIクライアント
│   ├── sync.ts        # 双方向同期ロジック
│   ├── state.ts       # sync-state.json の読み書き
│   ├── types.ts       # 共有型定義
│   └── auth.ts        # 初回OAuth認証ヘルパー（ローカル実行用）
├── .github/
│   └── workflows/
│       └── sync.yml
├── sync-state.json    # 同期状態（リポジトリにコミット）
├── .env.example
├── package.json
├── tsconfig.json
└── README.md
```

---

## 依存パッケージ

```json
{
  "dependencies": {
    "googleapis": "^144.0.0",
    "dotenv": "^16.0.0"
  },
  "devDependencies": {
    "typescript": "^5.0.0",
    "tsx": "^4.0.0",
    "@types/node": "^20.0.0"
  }
}
```

実行コマンド: `tsx src/index.ts`（ビルドステップ不要）

---

## 状態ファイル (`sync-state.json`)

```json
{
  "lastSyncTime": "2024-01-01T00:00:00.000Z",
  "gcToTt": { "<gcEventId>": "<ttEventId>" },
  "ttToGc": { "<ttEventId>": "<gcEventId>" }
}
```

- 初回実行時は`lastSyncTime`を24時間前に設定して作成
- ワークフローが同期後に`[skip ci]`コミットでpush

---

## 重複防止メカニズム

| 方向 | マーカー | 場所 |
|------|----------|------|
| TT → GC で作成したGCイベント | `extendedProperties.private.timetreeSource = "true"`, `timetreeId = TT_ID` | GCのextendedProperties |
| GC → TT で作成したTTイベント | `\n---\n[sync-source:google-calendar:GC_ID]` | TTのdescription末尾 |

**同期スキップ条件**:
- GC → TT: `extendedProperties.private.timetreeSource === "true"` のイベントはスキップ
- TT → GC: descriptionに `[sync-source:google-calendar:]` が含まれるイベントはスキップ

---

## 同期ロジック (sync.ts)

### GC → TT

1. `calendar.events.list({ updatedMin: lastSyncTime, singleEvents: true })` で差分取得
2. 各イベントに対して:
   - `timetreeSource === "true"` → スキップ
   - `status === "cancelled"` → `state.gcToTt`にあればTTから削除、マッピング削除
   - `state.gcToTt`にある → TTでPUT更新
   - ない → TTにPOST作成、`state.gcToTt`に追加

### TT → GC

1. `GET /calendars/{id}/upcoming_events?days=365` で取得し、`updated_at > lastSyncTime` でフィルタ
2. 各イベントに対して:
   - descriptionに `[sync-source:google-calendar:]` → スキップ
   - `state.ttToGc`にある → GCでPATCH更新
   - ない → GCにPOST作成、`state.ttToGc`に追加

**制限**: TTは削除イベントを通知しないため、TT → GCの削除同期はv1対象外。

---

## フィールドマッピング

| Google Calendar | TimeTree |
|----------------|----------|
| `summary` | `title` |
| `start.dateTime` / `start.date` | `start_at` |
| `end.dateTime` / `end.date` | `end_at` |
| `start.date != null` (終日) | `all_day: true` |
| `start.timeZone` | `start_timezone` |
| `end.timeZone` | `end_timezone` |
| `description` (マーカー除外) | `description` (マーカー付与) |

---

## 主要ファイル実装要点

### `src/google.ts`
- `googleapis`の`OAuth2Client`を使用
- `refresh_token`からアクセストークンを自動更新
- `calendar.events.list`で`updatedMin` + `singleEvents: true`
- `calendar.events.insert` / `update` / `delete`

### `src/timetree.ts`
- Node.js native `fetch`（Node 20+）でHTTPリクエスト
- ヘッダー: `Authorization: Bearer TOKEN`, `Accept: application/vnd.timetree.v1+json`
- レート制限: 600req/10min → `X-RateLimit-Remaining`ヘッダーを監視
- リトライ: 3回、指数バックオフ（429/5xx時）

### `src/auth.ts`
- ローカルで一度だけ実行するOAuth認証フロー
- `http://localhost:3000/callback`にリダイレクトして認可コードを受け取る
- `refresh_token`をコンソール出力 → GitHub Secretsに保存

### `.github/workflows/sync.yml`
```yaml
on:
  schedule:
    - cron: '*/15 * * * *'
  workflow_dispatch:

jobs:
  sync:
    runs-on: ubuntu-latest
    permissions:
      contents: write
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '20'
      - run: npm ci
      - run: npm run sync
        env:
          GOOGLE_CLIENT_ID: ${{ secrets.GOOGLE_CLIENT_ID }}
          GOOGLE_CLIENT_SECRET: ${{ secrets.GOOGLE_CLIENT_SECRET }}
          GOOGLE_REFRESH_TOKEN: ${{ secrets.GOOGLE_REFRESH_TOKEN }}
          GOOGLE_CALENDAR_ID: ${{ secrets.GOOGLE_CALENDAR_ID }}
          TIMETREE_ACCESS_TOKEN: ${{ secrets.TIMETREE_ACCESS_TOKEN }}
          TIMETREE_CALENDAR_ID: ${{ secrets.TIMETREE_CALENDAR_ID }}
      - name: Commit sync state
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add sync-state.json
          git diff --staged --quiet || git commit -m "chore: update sync state [skip ci]"
          git push
```

---

## エラーハンドリング

- APIエラーはログ出力してスキップ（1イベントの失敗が全体を止めない）
- 未処理例外は`process.exit(1)`でActions失敗扱い
- `lastSyncTime`は全処理完了後にのみ更新

---

## 検証手順

1. `src/auth.ts`をローカル実行 → `GOOGLE_REFRESH_TOKEN`取得
2. `.env`ファイルに全環境変数設定
3. `npm run sync`をローカル実行 → 初回同期確認
4. `sync-state.json`にマッピングが記録されていること確認
5. GC/TTどちらかにテストイベント作成 → 再度`npm run sync` → 反対側に反映確認
6. 同じイベントが無限ループしないこと確認（3回連続実行）
7. リポジトリにpushしてGitHub Actionsのworkflow_dispatchで手動実行確認
