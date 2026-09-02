#!/usr/bin/env bash
# Bootstrap devconfig on macOS, Linux, or WSL2:
#   1. ensure Homebrew is installed
#   2. brew bundle          — install everything in ./Brewfile
#   3. stow the packages    — symlink configs into $HOME
#   4. ensure ~/.zshrc sources the devconfig shell snippets
#
# Safe to re-run. Pass package names to limit stow scope:  ./bootstrap.sh nvim tmux
#
# Native Windows is not covered here — run this inside WSL2. The only thing that
# belongs on the Windows host is WezTerm; see README.md.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info() { printf '\033[36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[33mwarn:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }

is_wsl() {
  [ -n "${WSL_DISTRO_NAME:-}" ] || grep -qiE '(microsoft|wsl)' /proc/version 2>/dev/null
}

# WezTerm is configured on the Windows host under WSL, so skip it there.
if [ "$#" -gt 0 ]; then
  PACKAGES=("$@")
elif is_wsl; then
  PACKAGES=(nvim tmux claude shell)
else
  PACKAGES=(nvim tmux wezterm claude shell)
fi

BREW_PATHS=(
  /opt/homebrew/bin/brew
  /usr/local/bin/brew
  /home/linuxbrew/.linuxbrew/bin/brew
  "$HOME/.linuxbrew/bin/brew"
)

load_brew() {
  command -v brew >/dev/null 2>&1 && return 0
  local p
  for p in "${BREW_PATHS[@]}"; do
    if [ -x "$p" ]; then
      eval "$("$p" shellenv)"
      return 0
    fi
  done
  return 1
}

ensure_brew() {
  load_brew && return
  info "Installing Homebrew"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  load_brew || die "Homebrew installed but 'brew' is not on PATH — open a new shell and re-run"
}

brew_bundle() {
  info "Installing packages from Brewfile"
  brew bundle --file="$REPO_DIR/Brewfile"
}

stow_packages() {
  info "Stowing: ${PACKAGES[*]}"
  stow --dir="$REPO_DIR" --target="$HOME" --restow --verbose "${PACKAGES[@]}"
}

# Ensure ~/.zshrc sources each given (home-relative) snippet, adding a line
# only when it isn't referenced already. Existing setups that source
# ~/.claude-profiles.sh are left untouched.
ensure_zshrc_source() {
  local rc="$HOME/.zshrc" file
  for file in "$@"; do
    if [ -f "$rc" ] && grep -qF "$file" "$rc"; then
      continue
    fi
    info "Adding 'source ~/$file' to ~/.zshrc"
    printf '\n# devconfig\nsource ~/%s\n' "$file" >> "$rc"
  done
}

main() {
  ensure_brew
  brew_bundle
  stow_packages
  ensure_zshrc_source .claude-profiles.sh .config/devconfig/shell-integration.sh

  info "Done. Open a new shell (or 'source ~/.zshrc') to pick up changes."
  command -v nvim >/dev/null 2>&1 &&
    info "Launch 'nvim' once — mason will install the LSP servers and formatters."
  if is_wsl; then
    warn "WSL detected. Install WezTerm on the Windows host and point it at this distro:"
    warn "  winget install wez.wezterm   (then see README.md)"
  fi
}

main
