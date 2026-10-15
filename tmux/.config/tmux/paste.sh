#!/bin/sh
# Read the system clipboard before touching tmux's buffers. A failed read must
# never paste an older buffer. Target the clicked pane and its tmux server.
set -eu

pane=$1
socket=$2
[ -n "$pane" ] || exit 0
clipboard=$(mktemp)
# Give each asynchronous click its own buffer so concurrent pastes cannot
# overwrite each other's contents. Delete it on exit in case paste-buffer -d
# never ran (e.g. the pane closed mid-click); named buffers ignore buffer-limit.
buffer="devconfig-${clipboard##*/}"
trap 'rm -f "$clipboard"; tmux -S "$socket" delete-buffer -b "$buffer" 2>/dev/null || true' EXIT
trap 'exit 1' HUP INT TERM

if [ "$(uname -s)" = Darwin ]; then
  pbpaste > "$clipboard"
elif [ -n "${WAYLAND_DISPLAY:-}" ] && command -v wl-paste >/dev/null 2>&1; then
  wl-paste --no-newline --type text > "$clipboard"
else
  # Also covers XWayland: WAYLAND_DISPLAY may be set without wl-clipboard
  # installed, so fall back to xclip (which works through XWayland too).
  xclip -selection clipboard -o > "$clipboard"
fi

# Load from a file to preserve trailing newlines. -p brackets the paste when
# the app asks for it, so a multi-line paste is not run line by line.
tmux -S "$socket" load-buffer -b "$buffer" "$clipboard"
tmux -S "$socket" paste-buffer -p -d -b "$buffer" -t "$pane"
