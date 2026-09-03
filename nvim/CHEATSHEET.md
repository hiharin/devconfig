# Neovim Cheat Sheet (custom mappings)

Leader: **`Space`**

## General

| Keys          | Action                     |
|---------------|------------------------------|
| `<leader>w`   | Save file                    |
| `<leader>q`   | Quit window                  |
| `<leader>bd`  | Delete buffer                |
| `Esc`         | Clear search highlight        |

## Window navigation

| Keys     | Action              |
|----------|----------------------|
| `Ctrl+h` | Go to left window   |
| `Ctrl+j` | Go to lower window  |
| `Ctrl+k` | Go to upper window  |
| `Ctrl+l` | Go to right window  |

## Editing

| Keys (visual mode) | Action                  |
|---------------------|--------------------------|
| `J`                 | Move selection down, reindent |
| `K`                 | Move selection up, reindent   |

## Scrolling / search (centered)

| Keys     | Action                              |
|----------|---------------------------------------|
| `Ctrl+d` | Half-page down, center cursor        |
| `Ctrl+u` | Half-page up, center cursor          |
| `n`      | Next search match, centered           |
| `N`      | Previous search match, centered       |

## Diagnostics

| Keys        | Action                |
|-------------|-------------------------|
| `<leader>cd`| Show line diagnostics  |
| `]d`        | Next diagnostic        |
| `[d`        | Previous diagnostic    |

## LSP (buffer-local, on attach)

| Keys         | Action                    |
|--------------|-----------------------------|
| `grd`        | Go to definition            |
| `grD`        | Go to declaration           |
| `<leader>cf` | Format buffer (LSP)         |
| `grr`        | References *(Neovim 0.11+ default)* |
| `gra`        | Code action *(default)*     |
| `gri`        | Go to implementation *(default)* |
| `grn`        | Rename *(default)*          |
| `K`          | Hover docs *(default)*      |

## Formatting

| Keys         | Action                        |
|--------------|----------------------------------|
| `<leader>cF` | Format file via conform.nvim (also runs automatically on save) |

## Git (gitsigns, buffer-local)

| Keys        | Action           |
|-------------|-------------------|
| `]c`        | Next git hunk     |
| `[c`        | Previous git hunk |
| `<leader>gs`| Stage hunk        |
| `<leader>gr`| Reset hunk        |
| `<leader>gp`| Preview hunk      |
| `<leader>gb`| Blame line        |

## Telescope (fuzzy finder)

| Keys              | Action              |
|-------------------|-----------------------|
| `<leader><leader>`| Find files           |
| `<leader>ff`      | Find files           |
| `<leader>fg`      | Live grep            |
| `<leader>fb`      | List buffers         |
| `<leader>fh`      | Help tags            |
| `<leader>fd`      | Diagnostics          |
| `<leader>fr`      | Resume last picker   |

## Completion (blink.cmp, insert mode, "default" preset)

| Keys           | Action           |
|----------------|--------------------|
| `Ctrl+Space`   | Open completion menu |
| `Ctrl+n`/`Ctrl+p`| Select next/previous item |
| `Ctrl+y`       | Accept selected item |
