# devconfig shell integration — sourced from your shell rc (see bootstrap.sh).
#
# Report the working directory to the terminal via an OSC 7 escape sequence
# on every directory change. tmux only re-derives #{pane_current_path} on
# pane-focus changes, so without this the status bar shows a stale directory
# after a bare `cd` until you switch panes and back. WezTerm also uses OSC 7
# to track the cwd for "new tab / split here".
#
# Supports zsh (via add-zsh-hook) and bash (via PROMPT_COMMAND) — bash is the
# default shell on most Linux distros, zsh on macOS since Catalina.

_devconfig_osc7_cwd() {
  # $HOST is zsh's, $HOSTNAME is bash's — cheaper than shelling out to hostname(1).
  printf '\033]7;file://%s%s\033\\' "${HOST:-${HOSTNAME:-}}" "${PWD}"
}

if [ -n "${ZSH_VERSION:-}" ]; then
  autoload -Uz add-zsh-hook
  add-zsh-hook chpwd _devconfig_osc7_cwd
  _devconfig_osc7_cwd   # fire once for the shell's starting directory
elif [ -n "${BASH_VERSION:-}" ]; then
  case ";${PROMPT_COMMAND:-};" in
    *";_devconfig_osc7_cwd;"*) ;; # already hooked (e.g. rc file re-sourced)
    *) PROMPT_COMMAND="_devconfig_osc7_cwd${PROMPT_COMMAND:+;${PROMPT_COMMAND}}" ;;
  esac
  _devconfig_osc7_cwd
fi

alias nv='nvim'
