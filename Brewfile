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

# ── Language runtimes ─────────────────────────────────────────────────────────
# Also the backends mason shells out to when it builds a server from source.
brew "node"             # bash-language-server and other npm-based LSP servers
brew "go"               # shfmt, gopls, … via `go install`
brew "uv"               # Python tooling, pyright virtualenvs

# ── macOS-only GUI apps & fonts ───────────────────────────────────────────────
# Casks don't exist on Linux / WSL. There, install WezTerm on the Windows host
# (`winget install wez.wezterm`) and fonts through the distro package manager.
if OS.mac?
  cask "wezterm"
  cask "claude-code"
  cask "font-jetbrains-mono"
end
