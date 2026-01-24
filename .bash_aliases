# Douglas Ross's Aliases
# Loaded from .bashrc

# ===== Navigation =====
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# ===== Listing =====
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -ltr'  # Sort by date, newest last

# ===== Git shortcuts =====
alias gs='git status'
alias ga='git add'
alias gaa='git add -A'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log --oneline -20'
alias glog='git log --graph --oneline --decorate -20'
alias grh='git reset --hard'
alias grs='git reset --soft HEAD~1'

# ===== npm shortcuts =====
alias ni='npm install'
alias nid='npm install --save-dev'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrs='npm start'

# ===== Development =====
alias dev='npm run dev'
alias build='npm run build'
alias test='npm test'
alias lint='npm run lint'

# ===== Docker =====
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'
alias dpsa='docker ps -a'

# ===== Utility =====
alias c='clear'
alias h='history'
alias ports='lsof -i -P -n | grep LISTEN'
alias myip='curl -s ifconfig.me'
alias reload='source ~/.bashrc'
alias path='echo $PATH | tr ":" "\n"'

# ===== Safety nets =====
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# ===== Quick edits =====
alias bashrc='code ~/.bashrc'
alias aliases='code ~/.bash_aliases'

# ===== Codespaces specific =====
alias cs='gh codespace'
alias csl='gh codespace list'

# ===== Functions =====

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find file by name
ff() {
    find . -name "*$1*" 2>/dev/null
}

# Search in files
search() {
    grep -rn "$1" . --include="*.$2" 2>/dev/null
}

# Quick git commit with message
gcam() {
    git add -A && git commit -m "$1"
}

# Kill process on port
killport() {
    lsof -ti:$1 | xargs kill -9 2>/dev/null || echo "No process on port $1"
}

# Extract any archive
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
