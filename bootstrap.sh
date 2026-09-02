#!/usr/bin/env bash
# Bootstrap devconfig on a fresh machine:
#   1. ensure GNU Stow is installed
#   2. symlink every package into $HOME
#   3. make sure ~/.zshrc sources ~/.claude-profiles.sh
#
# Safe to re-run. Pass package names to limit scope: ./bootstrap.sh nvim tmux
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$#" -gt 0 ]; then
  PACKAGES=("$@")
else
  PACKAGES=(nvim tmux wezterm claude)
fi

info() { printf '\033[36m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[33mwarn:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[31merror:\033[0m %s\n' "$*" >&2; exit 1; }

ensure_stow() {
  command -v stow >/dev/null 2>&1 && return
  info "Installing GNU Stow"
  if command -v brew >/dev/null 2>&1; then
    brew install stow
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y stow
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y stow
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm stow
  else
    die "no supported package manager found — install GNU Stow manually, then re-run"
  fi
}

stow_packages() {
  info "Stowing: ${PACKAGES[*]}"
  stow --dir="$REPO_DIR" --target="$HOME" --restow --verbose "${PACKAGES[@]}"
}

ensure_zshrc_source() {
  local line='source ~/.claude-profiles.sh'
  local rc="$HOME/.zshrc"
  if [ -f "$rc" ] && grep -qF 'claude-profiles.sh' "$rc"; then
    return
  fi
  info "Adding '$line' to ~/.zshrc"
  printf '\n# devconfig: Claude Code account profiles\n%s\n' "$line" >> "$rc"
}

ensure_stow
stow_packages
ensure_zshrc_source

info "Done. Open a new shell (or 'source ~/.zshrc') to pick up changes."
command -v wezterm >/dev/null 2>&1 || warn "wezterm not on PATH — install it to use ~/.wezterm.lua"
