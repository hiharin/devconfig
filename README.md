# devconfig

Personal config files for nvim, tmux, and wezterm, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package whose internal path mirrors where it belongs relative to `$HOME`.

## Setup on a new machine

```sh
brew install stow
git clone <this-repo> ~/projects/devconfig
cd ~/projects/devconfig
stow -t ~ nvim tmux wezterm
```

This symlinks:

- `nvim/.config/nvim` -> `~/.config/nvim`
- `tmux/.tmux.conf` -> `~/.tmux.conf`
- `wezterm/.wezterm.lua` -> `~/.wezterm.lua`

## Adding a new tool

1. Create a new top-level directory named after the tool (e.g. `git/`).
2. Inside it, recreate the path relative to `$HOME` (e.g. `git/.gitconfig`).
3. Run `stow -t ~ <tool>` from the repo root.

## Removing links

```sh
stow -D -t ~ nvim tmux wezterm
```
