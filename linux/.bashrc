# =============================================================================
# ~/.bashrc — Linux (Debian / Ubuntu)
# Raspberry Pi OS, Ubuntu 22.04/24.04, Debian 12
# =============================================================================

# if not running interactively, do nothing
case $- in
    *i*) ;;
      *) return;;
esac

# =============================================================================
# history
# =============================================================================

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth              # ignore duplicates and lines starting with space
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
shopt -s histappend                 # append to history, don't overwrite
shopt -s cmdhist                    # save multi-line commands as one entry

# write history immediately (syncs across open terminals)
PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# =============================================================================
# shell options
# =============================================================================

shopt -s checkwinsize               # update LINES/COLUMNS after each command
shopt -s globstar                   # enable ** glob
shopt -s nocaseglob                 # case-insensitive globbing
shopt -s cdspell                    # correct minor spelling errors in cd
shopt -s autocd                     # type a dir name to cd into it

# =============================================================================
# path
# =============================================================================

export PATH="$HOME/.local/bin:$PATH"

# =============================================================================
# environment
# =============================================================================

export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-FXR'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# colored man pages
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'

# disable Ctrl-S flow control (frees it for vim save)
stty -ixon 2>/dev/null

# =============================================================================
# dir_colors
# =============================================================================

[[ -f ~/.dir_colors ]] && eval "$(dircolors ~/.dir_colors)"

# =============================================================================
# prompt (PS1)
# =============================================================================

_RESET='\[\e[0m\]'
_BOLD='\[\e[1m\]'
_RED='\[\e[31m\]'
_GREEN='\[\e[32m\]'
_YELLOW='\[\e[33m\]'
_BLUE='\[\e[34m\]'
_CYAN='\[\e[36m\]'
_WHITE='\[\e[97m\]'

_git_branch() {
  local branch
  branch=$(git symbolic-ref --short HEAD 2>/dev/null) || \
  branch=$(git rev-parse --short HEAD 2>/dev/null)
  [[ -n "$branch" ]] && echo " (${branch})"
}

_venv() {
  [[ -n "$VIRTUAL_ENV" ]] && echo " ($(basename "$VIRTUAL_ENV"))"
}

if [[ $EUID -eq 0 ]]; then
  _USER_COLOR="$_RED"
else
  _USER_COLOR="$_GREEN"
fi

# two-line prompt:
# line 1: user @ host  ~/path  (git-branch)  (venv)
# line 2: »
PS1="${_USER_COLOR}${_BOLD}\u${_RESET} ${_WHITE}@${_RESET} ${_CYAN}\h${_RESET}  ${_BLUE}\w${_RESET}${_YELLOW}\$(_git_branch)${_RESET}${_WHITE}\$(_venv)${_RESET}\n${_CYAN}»${_RESET} "

# =============================================================================
# bash completion
# =============================================================================

if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  fi
fi

# =============================================================================
# source aliases
# =============================================================================

[[ -f ~/.aliases ]] && source ~/.aliases

# =============================================================================
# source local overrides (machine-specific, not committed)
# =============================================================================

[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local

# =============================================================================
# tool integrations
# =============================================================================

# fzf
[[ -f ~/.fzf.bash ]] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
if command -v fd &>/dev/null; then
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# pyenv
if command -v pyenv &>/dev/null; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
fi

# nvm (lazy load — avoids ~300ms startup penalty)
if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  nvm() {
    unset -f nvm node npm npx
    [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
    nvm "$@"
  }
fi

# direnv
if command -v direnv &>/dev/null; then
  eval "$(direnv hook bash)"
fi
