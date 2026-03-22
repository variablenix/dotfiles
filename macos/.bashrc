# =============================================================================
# ~/.bashrc — macOS
# Requires: bash 5+ (brew install bash), GNU coreutils (brew install coreutils)
# Note: macOS defaults to zsh — to use bash, set in System Settings > Users
#       or run: chsh -s /opt/homebrew/bin/bash
# =============================================================================

# if not running interactively, do nothing
case $- in
    *i*) ;;
      *) return;;
esac

# =============================================================================
# homebrew (must be first — sets PATH, MANPATH, INFOPATH)
# =============================================================================

# Apple Silicon
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
# Intel
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# =============================================================================
# history
# =============================================================================

HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S  "
shopt -s histappend
shopt -s cmdhist

PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# =============================================================================
# shell options
# =============================================================================

shopt -s checkwinsize
shopt -s globstar
shopt -s nocaseglob
shopt -s cdspell
shopt -s autocd

# =============================================================================
# path
# =============================================================================

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# =============================================================================
# environment
# =============================================================================

export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-FXR'
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# colored man pages (using less)
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'

# disable Ctrl-S flow control
stty -ixon 2>/dev/null

# =============================================================================
# dir_colors (requires GNU coreutils: brew install coreutils)
# =============================================================================

if command -v gdircolors &>/dev/null; then
  [[ -f ~/.dir_colors ]] && eval "$(gdircolors ~/.dir_colors)"
fi

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

PS1="${_GREEN}${_BOLD}\u${_RESET} ${_WHITE}@${_RESET} ${_CYAN}\h${_RESET}  ${_BLUE}\w${_RESET}${_YELLOW}\$(_git_branch)${_RESET}${_WHITE}\$(_venv)${_RESET}\n${_CYAN}»${_RESET} "

# =============================================================================
# bash completion (via homebrew bash-completion@2)
# =============================================================================

if [[ -r "$(brew --prefix 2>/dev/null)/etc/profile.d/bash_completion.sh" ]]; then
  source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
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

# nvm (lazy load)
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
