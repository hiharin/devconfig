# tmux Cheat Sheet (custom mappings)

Prefix: **`Ctrl+a`** (not the default `Ctrl+b`). Press `Ctrl+a` then the key below.
To send a literal `Ctrl+a` to the terminal, press `Ctrl+a` twice.

## Panes

| Keys              | Action                                   |
|-------------------|-------------------------------------------|
| `Ctrl+a` `\|`      | Split pane vertically (side-by-side), inherits cwd |
| `Ctrl+a` `-`      | Split pane horizontally (stacked), inherits cwd |
| `Ctrl+a` `↑`      | Resize pane up (repeatable, hold arrow)   |
| `Ctrl+a` `↓`      | Resize pane down (repeatable)             |
| `Ctrl+a` `←`      | Resize pane left (repeatable)             |
| `Ctrl+a` `→`      | Resize pane right (repeatable)            |

> Note: default `"` and `%` split bindings are **unbound** — use `\|` / `-` instead.

## Windows

| Keys         | Action                                  |
|--------------|-------------------------------------------|
| `Ctrl+a` `c` | New window, inherits current pane's cwd  |

## Copy mode (vi-style)

| Keys              | Action                          |
|-------------------|----------------------------------|
| `Ctrl+a` `Enter`  | Enter copy mode                  |
| `v`               | Begin selection (in copy mode)   |
| `y`               | Copy selection and exit copy mode |
| `Esc`             | Cancel copy mode                 |

## Misc

| Keys         | Action                                  |
|--------------|-------------------------------------------|
| `Ctrl+a` `r` | Reload `~/.tmux.conf`                    |
| Mouse        | Drag borders to resize, click to select panes |

## Unchanged defaults worth knowing

- `Ctrl+a` `o` — cycle to next pane
- `Ctrl+a` `x` — kill current pane
- `Ctrl+a` `z` — zoom/unzoom current pane
- `Ctrl+a` `d` — detach session
- `Ctrl+a` `n` / `p` — next/previous window
- `Ctrl+a` `0`-`9` — jump to window by number
