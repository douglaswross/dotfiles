# Douglas Ross's .bashrc
# Loaded in every new Codespace automatically

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History settings
HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend

# Check window size after each command
shopt -s checkwinsize

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Colored prompt with git branch
parse_git_branch() {
    git branch 2>/dev/null | grep -E '^\*' | sed 's/* //'
}

# Prompt: directory (git-branch) $
PS1='\[\e[36m\]\w\[\e[33m\]$( [ -n "$(parse_git_branch)" ] && echo " ($(parse_git_branch))")\[\e[0m\] \$ '

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Load aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Load bash completion
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# Add local bin to PATH
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Default editor
export EDITOR=vim
export VISUAL=vim

# Node/npm settings
export NODE_OPTIONS="--max-old-space-size=4096"

# fzf configuration (if installed)
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# Google Cloud SDK (if installed in workspace)
if [ -f "/workspaces/com.fysk/google-cloud-sdk/path.bash.inc" ]; then
    source "/workspaces/com.fysk/google-cloud-sdk/path.bash.inc"
fi

# Welcome message
echo "👋 Welcome back, Douglas!"
