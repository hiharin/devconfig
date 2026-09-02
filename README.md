# devconfig

Personal config files for nvim, tmux, wezterm, and Claude Code account profiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package whose internal path mirrors where it belongs relative to `$HOME`.

## macOS

```sh
brew install stow
git clone <this-repo> ~/projects/devconfig
cd ~/projects/devconfig
stow -t ~ nvim tmux wezterm claude
```

This symlinks:

- `nvim/.config/nvim` -> `~/.config/nvim`
- `tmux/.tmux.conf` -> `~/.tmux.conf`
- `wezterm/.wezterm.lua` -> `~/.wezterm.lua`
- `claude/.claude-profiles.sh` -> `~/.claude-profiles.sh`

Then add `source ~/.claude-profiles.sh` to `~/.zshrc` (this line itself isn't stow-managed, since `~/.zshrc` isn't tracked in this repo).

### Claude Code account profiles

`claude/.claude-profiles.sh` defines a `claude-personal` shell alias that runs Claude Code with `CLAUDE_CONFIG_DIR` pointed at `~/.claude-personal`, keeping that account's credentials, settings, and MCP config fully isolated from your default (work) `~/.claude` profile. Plain `claude` keeps using the default profile; run `claude-personal` to use the personal account instead (first run prompts `/login`). Switching requires starting a new `claude` process — there's no live in-session switch.

## Windows

tmux doesn't run natively on Windows, so configs are split across two environments:

**wezterm and nvim run natively on Windows.** Clone the repo, then create the symlinks manually (native `nvim`/`wezterm` builds don't read `~/.config` on Windows):

```powershell
git clone <this-repo> $HOME\projects\devconfig
cd $HOME\projects\devconfig

New-Item -ItemType SymbolicLink -Path "$env:LOCALAPPDATA\nvim" -Target "$HOME\projects\devconfig\nvim\.config\nvim"
New-Item -ItemType SymbolicLink -Path "$HOME\.wezterm.lua" -Target "$HOME\projects\devconfig\wezterm\.wezterm.lua"
```

`New-Item -ItemType SymbolicLink` requires either an elevated (Administrator) PowerShell prompt, or Developer Mode enabled (Settings -> Update & Security -> For developers).

**tmux requires WSL.** Inside your WSL distro, clone the repo again into the Linux filesystem and follow the [macOS](#macos) instructions above (`apt install stow` instead of `brew install stow`) to stow the `tmux` package.

## Adding a new tool

1. Create a new top-level directory named after the tool (e.g. `git/`).
2. Inside it, recreate the path relative to `$HOME` (e.g. `git/.gitconfig`).
3. Run `stow -t ~ <tool>` from the repo root.

## Removing links

```sh
stow -D -t ~ nvim tmux wezterm claude
```
