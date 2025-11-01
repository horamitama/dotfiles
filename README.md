# dotfiles

hora-mitama's dotfiles

```bash
git clone git@github.com:horamitama/dotfiles.git
```

# ホームディレクトリに移動 (念のため)

cd ~

# ~/.dotfiles を指す .config というリンクを作成

```bash
ln -s dotfiles .
```

## nord on iTerm2

```bash
https://www.nordtheme.com/ports/iterm2
```

## Nerd font

## Symbolic LINK

```bash
ln -s ~/dotfiles/.config/nvim .config/nvim
ln -s ~/dotfiles/.config/fish .config/fish
ln -s ~/dotfiles/.config/README.md .config/README.md
```

## npm

```bash
brew install npm
```

##

```bash
npm install tree-sitter-cli
```

## Tmux

tmuxのセッションに入ってCtl+g, Shift+iをするとプラグインのインストールが始まる。
テーマの適用は以下の通り。
![Nord Tmux](https://www.nordtheme.com/docs/ports/tmux/installation)

## Github CLI

```bash
brew install gh
gh auth login
```
