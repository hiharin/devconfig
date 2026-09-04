# devconfig

Personal config for nvim, tmux, wezterm, shell integration, and Claude Code
account profiles, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package whose internal path mirrors where it
belongs relative to `$HOME`.

## Quick start (macOS, Linux, WSL2)

```sh
git clone <this-repo> ~/projects/devconfig
cd ~/projects/devconfig
./bootstrap.sh
```

`bootstrap.sh` is idempotent and:

1. installs Homebrew if it's missing,
2. runs `brew bundle` to install everything in [`Brewfile`](Brewfile),
3. stows the packages (symlinks configs into `$HOME`),
4. adds `source` lines to your shell rc (`~/.zshrc` on macOS, `~/.bashrc` on
   most Linux distros — picked from `$SHELL`) for `~/.claude-profiles.sh` and
   `~/.config/devconfig/shell-integration.sh` if not already there.

Then launch `nvim` once so [mason](https://github.com/mason-org/mason.nvim)
can install the language servers and formatters.

Pass package names to limit scope: `./bootstrap.sh nvim tmux`.

### Day-to-day (`make`)

```
make deps        install / update system packages from Brewfile
make install     stow all packages
make restow      re-sync links after adding/removing files in a package
make uninstall   remove the symlinks
make check       report what's installed and whether the Brewfile is satisfied
```

## How dependencies are managed

Three layers, each with one owner:

| Layer | Owner | Where |
|---|---|---|
| System CLI, language runtimes, GUI apps, fonts | Homebrew | [`Brewfile`](Brewfile) |
| Editor tools — LSP servers, formatters, linters | mason | `nvim/.config/nvim/lua/plugins/lsp.lua` (`mason-tool-installer` `ensure_installed`) |
| treesitter parsers | nvim-treesitter (`main`) | needs `tree-sitter-cli` (Brewfile) + a C compiler: `xcode-select --install` / `build-essential` |

The split keeps per-OS package lists small: mason works identically on macOS,
Linux, WSL, and native Windows, so only runtimes (`node`, `go`) and core CLI
tools (`ripgrep`, `fd`) need to come from Homebrew. Don't install the same tool
from both — shell tools via Homebrew, editor-only servers via mason.

## Windows

Run everything inside **WSL2** — follow the quick start above in your WSL distro.
tmux, zsh, and Homebrew all work there; `bootstrap.sh` detects WSL and skips the
`wezterm` package.

The one thing that belongs on the Windows host is the terminal itself:

```powershell
winget install wez.wezterm
```

Point it at WSL by symlinking the config (Developer Mode on, or an elevated
prompt):

```powershell
New-Item -ItemType SymbolicLink -Path "$HOME\.wezterm.lua" `
  -Target "\\wsl$\<distro>\home\<user>\projects\devconfig\wezterm\.wezterm.lua"
```

Native-Windows nvim (outside WSL) is not a supported target here; if you want it,
symlink `nvim/.config/nvim` to `$env:LOCALAPPDATA\nvim` and note that `tmux` and
the `claude` profile script are WSL/Unix-only.

## Linux

The quick start works as-is via [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux),
on both bash and zsh — `bootstrap.sh` picks the right rc file from `$SHELL`.
Two things Homebrew can't hand you on Linux:

- **Fonts.** Install a Nerd Font (the wezterm config expects JetBrains Mono)
  through your distro's package manager.
- **WezTerm.** Homebrew only ships a macOS cask for it — there's no Linux
  formula. On a native Linux desktop (not WSL), `bootstrap.sh` installs it
  itself from WezTerm's own apt repo (requires `apt-get`; you'll get a sudo
  prompt the first time). It installs `wezterm-nightly`, not the `wezterm`
  stable package — stable is frozen at a Feb 2024 build with a GNOME/Wayland
  bug where CSD move/resize hit-testing is unreliable; nightly has the fix
  (see `wezterm/.wezterm.lua`'s `enable_wayland` comment). To install by hand
  instead:

  ```sh
  curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
  echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
  sudo apt update && sudo apt install wezterm-nightly
  ```

Everything else — `stow`, clipboard support for nvim (`xclip` + `wl-clipboard`,
covering both X11 and Wayland sessions), editor tooling via mason — comes from
the Brewfile like on macOS. This path is less exercised than macOS; file
issues if something drifts.

## Claude Code account profiles

`claude/.claude-profiles.sh` defines a `claude-personal` shell alias that runs
Claude Code with `CLAUDE_CONFIG_DIR` pointed at `~/.claude-personal`, keeping that
account's credentials, settings, and MCP config fully isolated from the default
(work) `~/.claude` profile. Plain `claude` keeps using the default; run
`claude-personal` for the personal account (first run prompts `/login`).
Switching requires a new `claude` process — there's no live in-session switch.

## Shell integration

`shell/.config/devconfig/shell-integration.sh` is sourced from `~/.zshrc` and
emits an OSC 7 sequence on every `cd`. This tells tmux the pane's working
directory changed — otherwise `#{pane_current_path}` in the status bar only
refreshes when pane focus changes, so a bare `cd` shows a stale directory until
you switch panes and back. WezTerm consumes the same sequence for "new tab /
split here".

## Adding a new tool

1. Create a top-level directory named after the tool (e.g. `git/`).
2. Inside it, recreate the path relative to `$HOME` (e.g. `git/.gitconfig`).
3. Add it to `PACKAGES` in the `Makefile` and `bootstrap.sh` if it should be
   stowed by default.
4. `make PKG=git install`.

## Removing links

```sh
make uninstall          # or: stow -D -t ~ nvim tmux wezterm claude shell
```
