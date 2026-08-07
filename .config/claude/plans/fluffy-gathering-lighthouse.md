# News Curator — パーソナライズドRSSフィード

## Context

複数のニュースサイト（技術系・ビジネス/スタートアップ・個人ブログ）からRSSを集約し、自分用のニュースフィードを作りたい。要件は以下：

- Webで読める（ブラウザUI）
- メールで定期的にダイジェストを受け取る
- 記事を評価（いいね/興味なし）でき、その評価をもとに関心の高いニュースが上位に来るよう学習する
- **完全無料の範囲でデプロイしたい**（API含む）

以前 `/Users/sencha/dev/news-curator` にPython(FastAPI)版を作りかけていたが、未デプロイ・評価機能なし・Railway/Claude API（有料）前提だったため、TypeScript/Next.jsで作り直す（既存ディレクトリは削除済み、Next.js雛形を生成済み）。

## スタック（すべて無料枠）

| 役割 | サービス | 無料枠 |
|---|---|---|
| フロント + API | Next.js (App Router) → **Vercel** | 個人利用に十分 |
| DB | **Neon** (PostgreSQL) | 0.5GB |
| RSS取得 cron | **GitHub Actions** (cron) | 月2000分 |
| AI要約/キュレーション | **Gemini API** (google-generativeai) | 無料枠あり。将来オプション |
| メール通知 | **Gmail SMTP** (nodemailer + アプリパスワード) | 無料 |

Vercelはサーバーレスで常駐プロセスが持てないため、cronはGitHub Actionsから API Routeを叩く方式にする（Vercel Cronは無料枠で1日1回制限のため回避）。

## データモデル (Neon / Prisma)

- `Feed`: id, url, category, title, createdAt
- `Article`: id, feedId, title, url(unique), source, category, contentSnippet, summary(nullable), publishedAt, fetchedAt, score(Float, default 0)
- `Rating`: id, articleId, value(Int: +1 like / -1 skip), createdAt
- `KeywordScore`: id, keyword(unique), score(Float) — 評価から積算する嗜好スコア

## パーソナライズ方式（Claude/Gemini API不要で動く）

1. 記事タイトル+スニペットから簡易キーワード抽出（日本語は分かち書き簡易版 or n-gram、英語は単語分割 + ストップワード除去）
2. 記事を「いいね」→ その記事のキーワードの `KeywordScore` を +1、「興味なし」→ -1
3. 新着記事の `score` = 含まれるキーワードの `KeywordScore` 合計
4. フィード一覧は `score` 降順 → `publishedAt` 降順でソート

Gemini APIは「要約生成」のオプション機能として後付け（無料枠内、環境変数がある時だけ有効化）。

## 実装ステップ

### 1. 依存追加
`news-curator/package.json` に: `@prisma/client`, `prisma`(dev), `nodemailer`, `rss-parser`, `@types/nodemailer`(dev)

### 2. Prismaセットアップ
- `prisma/schema.prisma` に上記モデル定義（provider = postgresql, `DATABASE_URL`）
- `lib/prisma.ts` — PrismaClientシングルトン（Vercelのホットリロード対策）

### 3. コアロジック (`lib/`)
- `lib/fetcher.ts` — `rss-parser`で全Feed取得、URL重複スキップしてArticle upsert。（旧Python `fetcher.py` のロジックを移植）
- `lib/keywords.ts` — キーワード抽出 + KeywordScore更新 + 記事スコア計算
- `lib/mailer.ts` — nodemailer + Gmail SMTPでHTMLダイジェスト送信（旧 `mailer.py` のHTMLテンプレを流用）
- `lib/feeds.ts` — 初期RSSフィード定義（Hacker News, Zenn, Publickey, TechCrunch, 個人ブログ等）とシード

### 4. API Routes (`app/api/`)
- `POST /api/cron` — 認証(`CRON_SECRET`ヘッダ)→ fetch → スコア再計算 → （朝の時間帯なら）メール送信。GitHub Actionsから叩く
- `POST /api/rate` — `{articleId, value}` を受けて Rating作成 + KeywordScore更新
- `GET /api/articles` — score順の記事一覧（ページネーション）

### 5. UI (`app/`)
- `app/page.tsx` — フィード一覧。カード表示、各記事に「👍いいね / 🙅興味なし」ボタン（`/api/rate`をfetch、楽観的更新）
- `app/feeds/page.tsx` — 購読フィードの追加/削除（後回し可、まずは`lib/feeds.ts`のシードで開始）
- Tailwindでスタイル（雛形に導入済み）

### 6. cron (`.github/workflows/cron.yml`)
- 30分ごと + 毎朝7時(JST)に `curl -X POST $DEPLOY_URL/api/cron -H "x-cron-secret: $CRON_SECRET"`
- Secrets: `DEPLOY_URL`, `CRON_SECRET`

### 7. デプロイ手順（ドキュメント化）
- `README.md` に手順記載：Neon作成→`DATABASE_URL`取得→`prisma db push`→Vercelデプロイ→環境変数設定→GitHubリポジトリ作成→Actions secrets設定→Gmailアプリパスワード発行

### 環境変数 (`.env.example`)
`DATABASE_URL`, `CRON_SECRET`, `GMAIL_ADDRESS`, `GMAIL_APP_PASSWORD`, `RECIPIENT_EMAIL`, `GEMINI_API_KEY`(任意), `SCHEDULE_TIMEZONE`

## 検証方法

1. ローカル: Neon無料DB作成 → `.env`設定 → `npx prisma db push` → `npm run dev`
2. `curl -X POST localhost:3000/api/cron -H "x-cron-secret: ..."` でRSS取得を実行、DBに記事が入るか確認
3. ブラウザ `localhost:3000` で記事一覧表示、いいね/興味なしボタンを押す
4. 再度 `/api/cron` or ページ再読込で、評価が反映されてスコア順が変わることを確認
5. メール送信: cronのメール送信分岐を手動トリガーし、Gmailに届くか確認
6. デプロイ後: GitHub Actionsを手動実行(workflow_dispatch)して本番cronが通るか確認

## 未確定・後回し

- Gemini APIキーは未取得（要約機能は環境変数がある時のみ有効化するので、無くても動く）
- フィード追加UI（`app/feeds`）は初期はシードのみで開始し、後から追加可能
