echo "シンボリックリンクを作成します..."

for item_path in $HOME/.dotfiles/*; do
  item_name=$(basename "$item_path")

  # 隠しファイルをスキップ
  if [[ "$item_name" =~ ^\. ]]; then
    continue
  fi

  target_link="$HOME/.config/$item_name"
  source_path="$item_path"

  # リンク先が既に存在するかチェック
  if [ -e "$target_link" ] || [ -L "$target_link" ]; then
    echo "警告: $target_link は既に存在します。スキップしました。"
  else
    # シンボリックリンクを作成
    ln -s "$source_path" "$target_link"
    echo "作成: $target_link"
  fi
done

echo "完了しました。"
