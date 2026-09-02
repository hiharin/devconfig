# devconfig shell integration — sourced from ~/.zshrc (see bootstrap.sh).
#
# Report the working directory to the terminal via an OSC 7 escape sequence
# on every directory change. tmux only re-derives #{pane_current_path} on
# pane-focus changes, so without this the status bar shows a stale directory
# after a bare `cd` until you switch panes and back. WezTerm also uses OSC 7
# to track the cwd for "new tab / split here".

if [ -n "${ZSH_VERSION:-}" ]; then
  _devconfig_osc7_cwd() {
    printf '\033]7;file://%s%s\033\\' "${HOST}" "${PWD}"
  }
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd _devconfig_osc7_cwd
  _devconfig_osc7_cwd   # fire once for the shell's starting directory
fi
