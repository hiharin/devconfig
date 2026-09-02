# devconfig

Personal config for nvim, tmux, wezterm, and Claude Code account profiles,
managed with [GNU Stow](https://www.gnu.org/software/stow/).

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
4. adds `source ~/.claude-profiles.sh` to `~/.zshrc` if not already there.

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
| Compiler for treesitter parsers | OS | `xcode-select --install` / `build-essential` |

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

The quick start works as-is via [Homebrew on Linux](https://docs.brew.sh/Homebrew-on-Linux).
Fonts aren't handled by `brew` there — install a Nerd Font (the wezterm config
expects JetBrains Mono) through your distro's package manager. This path is less
exercised than macOS; file issues if something drifts.

## Claude Code account profiles

`claude/.claude-profiles.sh` defines a `claude-personal` shell alias that runs
Claude Code with `CLAUDE_CONFIG_DIR` pointed at `~/.claude-personal`, keeping that
account's credentials, settings, and MCP config fully isolated from the default
(work) `~/.claude` profile. Plain `claude` keeps using the default; run
`claude-personal` for the personal account (first run prompts `/login`).
Switching requires a new `claude` process — there's no live in-session switch.

## Adding a new tool

1. Create a top-level directory named after the tool (e.g. `git/`).
2. Inside it, recreate the path relative to `$HOME` (e.g. `git/.gitconfig`).
3. Add it to `PACKAGES` in the `Makefile` and `bootstrap.sh` if it should be
   stowed by default.
4. `make PKG=git install`.

## Removing links

```sh
make uninstall          # or: stow -D -t ~ nvim tmux wezterm claude
```
