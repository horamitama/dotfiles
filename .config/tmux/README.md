# tmux

## セットアップ

- tmuxコマンド本体: Homebrewで `brew install tmux`
- プラグインマネージャ TPM: `~/.config/tmux/plugins/tpm` (git clone https://github.com/tmux-plugins/tpm)
- TPM管理下のプラグインは `~/.config/tmux/plugins/tpm/scripts/install_plugins.sh` で一括インストール
  - 空ディレクトリが残っているとTPMが「インストール済み」と誤認してスキップするため、その場合は先に `rmdir` してから実行する
- `nord-tmux` はTPM管理外(`run-shell`で直接読み込み)のため、手動で `git clone https://github.com/nordtheme/tmux ~/.config/tmux/plugins/nord-tmux` が必要

## この設定の中身 (`tmux.conf`)

| 項目 | 内容 |
|---|---|
| デフォルトシェル | fish (`/opt/homebrew/bin/fish`)。macOSのログインシェルはzshのままだが、tmux起動時のシェルはこの設定で上書き |
| prefixキー | `C-b` ではなく **`C-t`**(独自変更) |
| 設定リロード | `prefix + r` |
| 縦分割 | `prefix + \|` |
| 横分割 | `prefix + -` |
| ペインリサイズ | `prefix + h/j/k/l` (5行/列ずつ) |
| マウス操作 | 有効 |
| テーマ | Nord |
| プラグイン | vim-tmux-navigator(vimとのペイン移動統合)、tmux-resurrect/tmux-continuum(セッションの自動保存・復元) |

## 基本操作

tmuxは「**prefixキーを押してから次のキー**」という操作が基本。この設定でのprefixは **`Ctrl+t`**(デフォルトの `Ctrl+b` ではない)。

### セッション(ウィンドウ全体の単位)

```
tmux new -s work        # "work"という名前で新規セッション作成
tmux ls                 # セッション一覧
tmux attach -t work     # セッションに再接続
prefix + d              # セッションからデタッチ(裏では起動したまま切り離す)
```

### ウィンドウ(タブに相当)

```
prefix + c              # 新規ウィンドウ
prefix + n / p          # 次/前のウィンドウ
prefix + 0-9            # 番号でウィンドウ切り替え
prefix + ,              # ウィンドウ名を変更
```

### ペイン(このconfig独自のキー)

```
prefix + |              # 縦に分割
prefix + -              # 横に分割
prefix + 矢印キー        # ペイン間移動(vim-tmux-navigatorがあればCtrl+h/j/k/lでも可)
prefix + h/j/k/l        # ペインをリサイズ
```

## 練習の流れ

```
tmux new -s test
```

1. `Ctrl+t` → `|` で分割
2. `Ctrl+t` → `d` でデタッチ
3. `tmux attach -t test` で復帰
