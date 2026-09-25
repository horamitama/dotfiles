> **⚠️ 2026-09-24: このプランは着手せず保留。** 週4hに対してスコープが大きすぎ、
> 唯一の未検証仮説（プリント抽出の精度）が M5 と最後尾に置かれていた。
> 現行プランは `famcal-v0.md`。**M1〜M6 には v0 の結果が出るまで着手しない。**
> ただし以下は生きている: RFC 5545 準拠のデータモデル、繰り返し編集の3分岐、Go 採用、
> 「作らなくていいものを作らない」という主眼。v1 に進む時はここから再開する。

# famcal — 家族カレンダーアプリ v1

## Context

妻は家族の予定を TimeTree で管理しており、本人は Google カレンダーを使いたい。両者の同期は調査の結果**公式手段が全て塞がっている**（API は 2023-12-22 終了、エクスポート機能なし、外部カレンダー連携は Google→TimeTree の一方向のみ）。そのため同期ではなく**置き換え**を狙う。

差別化は UI の洗練でも情報量の削減でもなく、**予定の入力コスト**に置く。学校・保育園のプリントや連絡帳を人間が読んで手で予定に起こしている作業を、撮影 → AI 抽出 → 確認 → 保存に置き換える。ここは TimeTree も Google も手つかずで、AI が飾りではなく本物の差になる。

通常この手のアプリは「家族全員が移行しないと価値がゼロ」という壁で死ぬが、本件は**妻が最初のユーザーとして確保済み**で既存予定の移行も不要。

副業枠は**週4時間**（月水木金 9:00–10:00）。カレンダーは「当たり前品質」の要求が異常に高く個人開発の墓場でもあるため、**作らなくていいものを徹底的に作らない**のが設計の主眼。

## v1 の定義

妻が「TimeTree やめてこっち使う」と言う最小セット。**これ以上増やさない。**

- 月表示（タップで日別リスト）
- 予定の作成・編集・削除（繰り返しの3分岐を含む）
- プリント撮影 → 抽出 → 確認 → 保存
- 予定前のローカル通知

コメント・メモ・ラベル・設定画面は**入れない**。TimeTree の機能を追いかけた瞬間に沈む。

## 技術選定の前提

**保守できるかどうかを唯一の基準にする。**「過去にデプロイした実績がある」は採用理由にならない（news-curator の Next.js はバイブコーディングで通っただけで、知識の範囲外＝保守不能）。

そこで構成を見直した結果、**v1 ではサーバ側に繰り返し展開が要らない**ことが分かった。月表示はクライアントが展開し、通知もクライアントが貼る。サーバはマスターと override を保存するだけ。したがって:

- 展開ロジックはモバイル側に閉じる
- **API は4テーブルの CRUD + 認証 + Claude 呼び出しだけの薄い層**
- 前後で言語を揃える必要がない → 得意な Go を使える

## アーキテクチャ

置き場所は `/Users/sencha/dev/famcal`。**monorepo ツールは使わない**（共有コードが無いので pnpm workspace も turbo も不要）。1リポジトリ・2ディレクトリ。

```
famcal/
  api/         Go
  mobile/      Expo (TypeScript)
```

### api/ — Go

ローカルに `go1.25.4` / `sqlc` / `goose` / `docker` が既に入っているため、そこに合わせる。**フレームワークはゼロ。**

| 用途 | 選定 | 備考 |
|---|---|---|
| HTTP | 標準 `net/http` | Go 1.22 以降の `ServeMux` はメソッド＋ワイルドカードのルーティングに対応。chi も要らない |
| DB アクセス | `pgx` + `sqlc` | ORM を使わない。SQL を書いて型付き Go を生成する |
| マイグレーション | `goose` | 導入済み |
| Claude | `anthropic-sdk-go` | 公式 SDK |

### mobile/ — Expo

| 用途 | 選定 |
|---|---|
| アプリ | Expo (React Native / TypeScript) |
| 繰り返し展開 | `rrule` (rrule.js) |
| カメラ | `expo-image-picker` |
| 通知 | `expo-notifications`（v1 はローカル通知のみ） |
| トークン保管 | `expo-secure-store` |

iOS PWA ではなく Expo にするのは push の確実性のため。「通知が来なかった」は家族カレンダーで唯一の致命傷で、iOS の Web Push はホーム画面追加が必須・バックグラウンド同期なし・配信が不安定。

## ホスティング

**決定要因は DB。** マネージド Postgres はどちらのクラウドも家族規模には高すぎる:

| | 最小コスト | ゼロスケール |
|---|---|---|
| Cloud SQL | 月 $10〜 | なし |
| Aurora Serverless v2 | 月 $40 超（最小 0.5 ACU） | 実質なし |
| **Neon** | **無料枠** | あり |

→ **DB は Neon**。news-curator で既にアカウントがある。

コンピュートは **Cloud Run**:
- ゼロスケール、無料枠（月200万リクエスト）で家族利用は実質 $0
- **素の HTTP サーバをそのまま動かせる。** Lambda のようにプログラミングモデルを寄せる必要がない
- コンテナなので後から Fly.io でも ECS でも移せる

AWS 側の対抗は Lambda + API Gateway（ゼロスケールするが `net/http` をそのまま動かせない）と App Runner（ゼロスケールせず月$5〜）。今回は Cloud Run が素直。

> PDE 試験との相乗効果は**薄い**（Cloud Run は出題範囲ではない）ので、その理由では選ばない。

## データモデル

**独自モデルを発明せず、RFC 5545（iCalendar）をそのまま踏襲する。** 30年分の設計の答えが既にあり、ics 入出力がほぼタダで付き（TimeTree にできないことが増える）、将来 Google 連携を足す際に変換層が要らない。依存はしないが、モデルは借りる。

`api/db/migrations/00001_init.sql`（goose）:

```sql
-- +goose Up
create table household (
  id         uuid primary key default gen_random_uuid(),
  name       text not null,
  join_code  text not null unique,
  timezone   text not null default 'Asia/Tokyo',
  created_at timestamptz not null default now()
);

create table member (
  id           uuid primary key default gen_random_uuid(),
  household_id uuid not null references household(id) on delete cascade,
  display_name text not null,
  created_at   timestamptz not null default now()
);

create table device (
  id           uuid primary key default gen_random_uuid(),
  member_id    uuid not null references member(id) on delete cascade,
  token_hash   bytea not null unique,        -- 平文トークンは保存しない
  platform     text not null,                -- 'ios' | 'android'
  push_token   text,                         -- 将来の APNs 用。v1 未使用
  last_seen_at timestamptz not null default now()
);

create table event (                          -- 繰り返しのマスター、または単発
  id           uuid primary key default gen_random_uuid(),
  household_id uuid not null references household(id) on delete cascade,
  uid          text not null unique,          -- iCalendar UID。ics 入出力用

  summary      text not null,
  description  text,
  location     text,

  dt_start     timestamptz not null,
  dt_end       timestamptz not null,          -- 終日予定では「排他的」= 終了日の翌日0時
  is_all_day   boolean not null default false,
  timezone     text not null default 'Asia/Tokyo',

  rrule        text,                          -- 'FREQ=WEEKLY;BYDAY=MO,TH;UNTIL=...'
  ex_dates     timestamptz[] not null default '{}',   -- 除外日。単発削除もここ

  created_by   uuid not null references member(id),
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now(),
  version      integer not null default 1,    -- 楽観ロック
  deleted_at   timestamptz                    -- ソフト削除
);
create index on event (household_id, dt_start);
create index on event (household_id, updated_at);   -- 差分同期用

create table event_override (                 -- RECURRENCE-ID: 1インスタンスだけ内容変更
  id            uuid primary key default gen_random_uuid(),
  event_id      uuid not null references event(id) on delete cascade,
  recurrence_id timestamptz not null,         -- 元インスタンスの開始時刻
  summary       text,                         -- null = マスターから継承
  description   text,
  location      text,
  dt_start      timestamptz,
  dt_end        timestamptz,
  updated_at    timestamptz not null default now(),
  version       integer not null default 1,
  unique (event_id, recurrence_id)
);
```

**設計上の要点:**

- **`event_override` を最初から持つ。**「この1件だけ編集」は後から足すと破綻する。最大の沼なので初日に入れる
- **削除と変更で機構を分ける。** 単発削除は `ex_dates` に追加（RFC の正道、ics 出力もそのまま）、内容変更は `event_override`。1つの目的に2つの機構を持たせない
- **終日予定の `dt_end` は排他的。** 全実装者が一度バグらせる箇所
- **`version` で楽観ロック。** 夫婦が同じ予定を同時に触る前提
- **`deleted_at` でソフト削除。** ハード削除だとクライアントに削除を伝えられない
- **`token_hash` に保存。** 平文トークンは DB に置かない。リクエストのトークンをハッシュして引く
- `updated_at` はトリガを使わず UPDATE 文で明示的にセットする（sqlc なので SQL が見える方が追いやすい）

## 繰り返しの編集 — 3分岐

| 操作 | 実装 |
|---|---|
| この1件だけ変更 | `event_override` を upsert |
| この1件だけ削除 | `ex_dates` に追加 |
| これ以降すべて | マスターの `rrule` に `UNTIL` を付けて切り、新 `uid` で新しい `event` を作成（**削除ではなく分割**） |
| すべて | マスターを直接更新、`version + 1` |

「これ以降すべて」は 2026-09-17 に Google カレンダー上で実際に行った操作と同じ形。

## 展開ロジック（mobile 側）

`mobile/src/recurrence/` に純 TypeScript として置く。**Expo に依存させない**ので、Expo の設定が終わる前に単体で書いてテストできる。

```
expandEvents(events, overrides, rangeStart, rangeEnd): Occurrence[]
  1. rrule があれば RRule.between() で展開、無ければ単発として1件
  2. ex_dates に一致する occurrence を除外
  3. overrides を recurrence_id でマッチして差し替え（null 項目はマスターから継承）
  4. deleted_at != null の event は除外
  5. 開始時刻でソート
```

**`rrule` の既知の癖**: floating time 前提で DST 周りに難がある。日本国内のみなら実害はないので v1 では許容し、その旨をコードにコメントで残す。海外対応が必要になった時点で `ical.js` への差し替えを検討する（`rrule` は 2023-11 で更新停止しているが、RFC 5545 の再帰仕様自体が凍結されているため陳腐化のリスクは低い）。

## API

全エンドポイントを `Authorization: Bearer <deviceToken>` で保護する。

| メソッド | パス | 用途 |
|---|---|---|
| POST | `/api/households` | 世帯作成 → `join_code` を返す |
| POST | `/api/devices` | `join_code` + 表示名 → 端末トークン発行 |
| GET | `/api/events?since=<RFC3339>` | 差分取得。overrides と削除済みも含む |
| POST | `/api/events` | 作成 |
| PATCH | `/api/events/{id}` | 更新（`scope`: `single`/`following`/`all` + `version`） |
| DELETE | `/api/events/{id}` | 削除（`scope` 同上） |
| POST | `/api/extract` | 画像 → 候補イベント。**保存はしない** |

**同期は作り込まない。** 2人・少数の予定なので、フォーカス時に `since` 付きで取得して端末にキャッシュするだけ。同期エンジンは書かない。

## 認証 — 招待コード方式

パスワードもメールも Google アカウントも要らない。

1. 夫が世帯を作る → `join_code` が出る
2. 妻が端末でコードを入力 → `device` が作られ長期トークンが返る
3. トークンは `expo-secure-store` に保存し、以後のリクエストに付与。サーバはハッシュで引く

**妻側の摩擦が最小**で、後々の OAuth 審査の天井にも当たらない。

## 抽出パイプライン

```
[カメラ/ライブラリ] → 画像
      ↓ POST /api/extract
[Claude claude-opus-5 + vision]  ← anthropic-sdk-go、構造化出力で受ける
      ↓
[候補イベント配列]  ← 保存しない
      ↓ 確認画面でユーザーが編集
POST /api/events
```

抽出結果は `summary` / `date` / `start_time?` / `end_time?` / `location?` / `items?`（持ち物）/ `confidence`。日本語のプリントが対象なのでプロンプトも日本語で書く。

**勝負どころは精度と手数。** 撮影から保存まで15秒で終われば勝ち。ここだけ異常に磨く。

コストは Opus 5（$5/$25 per 1M）で1枚あたり $0.02 程度。週数枚なら月100円未満。

## 通知 — v1 はローカルのみ

| 種類 | 実装 | v1 |
|---|---|---|
| 予定前のリマインダー | `expo-notifications` のローカル通知 | **入れる** |
| 「妻が予定を追加した」 | サーバ push（APNs） | 後回し |

同期のたびに今後7日分の occurrence を展開してローカル通知を貼り直す。**サーバ push・デバイストークン管理・APNs 証明書が v1 から丸ごと消える。**

## マイルストーン

週4時間・2週間スプリント前提。

| | 内容 | 目安 |
|---|---|---|
| **M1** | `api/` — goose スキーマ、sqlc、世帯/端末/イベントの CRUD と差分取得、Cloud Run + Neon にデプロイ | 2スプリント |
| **M2** | 展開ロジック（純 TS、vitest。Expo 不要） | 1スプリント |
| **M3** | Expo 雛形、招待コード参加、月表示 | 2スプリント |
| **M4** | 予定の作成・編集・削除（3分岐） | 2スプリント |
| **M5** | カメラ → 抽出 → 確認 | 1〜2スプリント |
| **M6** | ローカル通知、TestFlight で妻に配布 | 1スプリント |

**合計 9〜10スプリント ≒ 4〜5ヶ月。** ただし PDE 合格後（10月下旬想定）は副業枠が週11時間に増えるため、実際にはこれより短縮できる見込み。

## M1 の作業（次にやること）

1. `/dev/famcal` を作り `git init`、`api/` と `mobile/` を切る
2. `api/` を `go mod init`、`docker-compose.yaml` でローカル Postgres を立てる
3. `goose` で上記スキーマのマイグレーションを書く
4. `sqlc.yaml` を置き、クエリを書いて型付き Go を生成
5. `net/http` でルーティング、トークン認証のミドルウェア
6. CRUD と差分取得を実装
7. Neon にプロジェクト作成、`gcloud` を入れて Cloud Run にデプロイ

## 検証

**`api/` は Go のテーブルドリブンテストで、DB は docker-compose のローカル Postgres を使う。** モックしない。

**展開ロジック（M2）は vitest でテストを先に書く。** 2026-09-17 に Google カレンダー上で実際に踏んだケースをそのままテストにする:

- `UNTIL` は UTC・`DTSTART` は TZID 付き、の混在
- 終日予定の `DTEND` が排他的であること
- `EXDATE` で3連休（2026-09-21〜23）を除外
- 「これ以降すべて変更」が削除ではなく分割になること
- `RECURRENCE-ID` で1件だけ差し替わり、未指定項目がマスターから継承されること
- 同一予定への同時更新が `version` で弾かれること

API は `curl` で叩いて確認する。M3 以降は Expo Go で実機確認し、最終的に TestFlight 経由で妻の iPhone に入れて日常使用で検証する。

## 既知のリスクと未決事項

- **Expo は初めて。** 既存プロジェクトに React Native の痕跡がゼロなので、M3 は見積もりより伸びる可能性が高い。**ここが唯一「保守できる技術か」の基準を満たしていない部分**で、通知の確実性と引き換えに受け入れている
- **抽出精度は実物で試すまで不明。** M5 の着手時ではなく、**M1 と並行して実際のプリント数枚で先に叩いておく**べき。ここが使い物にならないなら v1 の前提が崩れる
- **Apple Developer Program 年 $99** が M6 で必要
- **課金対象は「夫がエンジニアではない家庭」。** その検証方法は未着手。まず自分の家庭で3ヶ月使い倒して手放せないかを確かめるのが先
- **9/27 のスプリントレビューで Sprint 2 の予定を作る必要がある。** 現在カレンダーの 9/28 以降は意図的に空
