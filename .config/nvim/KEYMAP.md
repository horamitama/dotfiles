# Neovim Keymap Reference

Leader key: `<Space>`

## General

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>w` | Normal | Save file |
| `<leader>q` | Normal | Quit |
| `<Esc><Esc>` | Normal | Clear search highlight |
| `H` | Normal | Go to start of line |
| `L` | Normal | Go to end of line |
| `p` | Visual | Paste without overwriting register |

## Line Movement

| Key | Mode | Description |
|-----|------|-------------|
| `<Alt-j>` | Normal/Insert/Visual | Move line down |
| `<Alt-k>` | Normal/Insert/Visual | Move line up |

## Window Navigation

| Key | Mode | Description |
|-----|------|-------------|
| `<C-h>` | Normal | Go to left window |
| `<C-l>` | Normal | Go to right window |
| `<C-j>` | Normal | Go to lower window |
| `<C-k>` | Normal | Go to upper window |

## Neo-tree (File Explorer)

### Global

| Key | Description |
|-----|-------------|
| `<leader>e` | Toggle file tree |
| `<leader>ge` | Open git status |
| `<leader>be` | Open buffer list |

### Inside Neo-tree

| Key | Description |
|-----|-------------|
| `l` / `<CR>` | Open file/folder |
| `h` | Close folder |
| `s` | Open in horizontal split |
| `v` | Open in vertical split |
| `t` | Open in new tab |
| `a` | Add new file/folder |
| `d` | Delete |
| `r` | Rename |
| `c` | Copy |
| `m` | Move |
| `y` | Copy to clipboard |
| `x` | Cut to clipboard |
| `p` | Paste from clipboard |
| `R` | Refresh |
| `<` / `>` | Switch source (files/buffers/git) |
| `?` | Show help |
| `q` | Close Neo-tree |

## Fuzzy Finder (fzf-lua)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>ff` | Normal | Find files |
| `<leader>fr` | Normal | Recent files |
| `<leader>fg` | Normal | Live grep (search text) |
| `<leader>fb` | Normal | Buffers |
| `<leader>fh` | Normal | Help tags |
| `<leader>/` | Normal | Search in current buffer |

## Buffer (Bufferline)

| Key | Mode | Description |
|-----|------|-------------|
| `<S-h>` | Normal | Previous buffer |
| `<S-l>` | Normal | Next buffer |
| `<leader>bp` | Normal | Pin buffer |
| `<leader>bc` | Normal | Pick and close buffer |

## Terminal (ToggleTerm)

| Key | Mode | Description |
|-----|------|-------------|
| `<C-/>` | Normal/Terminal | Toggle floating terminal |
| `<leader>tv` | Normal | Open vertical terminal (right) |

