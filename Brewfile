# Brewfile — system dependencies for devconfig
#
#   brew bundle           install / update everything listed here
#   brew bundle check     report what's missing
#   brew bundle cleanup   list installed formulae not in this file
#
# Works on macOS and on Linux / WSL2 via Homebrew on Linux (https://brew.sh).
# `./bootstrap.sh` runs this for you.
#
# Editor tooling (LSP servers, formatters, linters) is deliberately NOT here —
# Neovim's mason manages that cross-platform, including native Windows. See
# nvim/.config/nvim/lua/plugins/lsp.lua.

# ── Dotfiles ──────────────────────────────────────────────────────────────────
brew "stow"

# ── Core CLI ──────────────────────────────────────────────────────────────────
brew "git"
brew "gh"
brew "neovim"
brew "tmux"
brew "ripgrep"          # telescope live_grep (required), general use
brew "fd"               # telescope find_files (faster, respects .gitignore)
brew "fzf"              # fuzzy finder — shell keybindings and nvim helpers
brew "tree-sitter-cli"  # nvim-treesitter (main branch) compiles parsers with it

# ── Language runtimes ─────────────────────────────────────────────────────────
# Also the backends mason shells out to when it builds a server from source.
brew "node"             # bash-language-server and other npm-based LSP servers
brew "go"               # shfmt, gopls, … via `go install`
brew "uv"               # Python tooling, pyright virtualenvs

# ── Linux-only: clipboard providers ───────────────────────────────────────────
# nvim's `unnamedplus` (options.lua) needs one of these on PATH to reach the
# system clipboard. macOS gets this for free via pbcopy/pbpaste; install both
# here since which one works depends on the session (X11 vs Wayland).
unless OS.mac?
  brew "xclip"        # X11
  brew "wl-clipboard"  # Wayland (wl-copy/wl-paste)
end

# ── macOS-only GUI apps & fonts ───────────────────────────────────────────────
# Casks don't exist on Linux / WSL. There, install WezTerm via its own apt
# repo (native Linux desktop) or on the Windows host (WSL) — see README.md —
# and fonts through the distro package manager.
if OS.mac?
  cask "wezterm"
  cask "claude-code"
  cask "font-jetbrains-mono"
end
