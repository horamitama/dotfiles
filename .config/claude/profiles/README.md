# profiles

マシンごとに Claude Code に読ませるコンテキスト。共通の `~/.claude/CLAUDE.md` が
`~/.claude/CLAUDE.local.md`（gitignore対象）を読み込むので、各マシンで一度だけリンクを張る。

```sh
# 個人マシン
ln -s profiles/personal/CLAUDE.md ~/.claude/CLAUDE.local.md
# 仕事マシン
ln -s profiles/work/CLAUDE.md ~/.claude/CLAUDE.local.md
```
