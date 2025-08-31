#!/bin/bash
# ~/.bashrc: executed by bash(1) for non-login shells.
# Cross-platform dotfiles bashrc - combines Ubuntu defaults with custom enhancements

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Source shared environment variables and aliases first
[[ -f ~/.shell_env ]] && source ~/.shell_env
[[ -f ~/.shell_aliases ]] && source ~/.shell_aliases

# History configuration (enhanced from defaults)
HISTCONTROL=ignoreboth:erasedups
HISTIGNORE="ls:ll:la:cd:pwd:exit:date:* --help:history"
HISTSIZE=5000
HISTFILESIZE=10000
HISTTIMEFORMAT="%F %T "

# Bash options
shopt -s histappend
shopt -s checkwinsize
shopt -s cmdhist
shopt -s globstar 2> /dev/null
shopt -s expand_aliases

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Set variable identifying the chroot (for Ubuntu/Debian)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Enhanced prompt with git branch support
if command -v git &> /dev/null; then
    # Function to get git branch
    git_branch() {
        git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
    }
    
    # Colored prompt with git branch
    if [ "$EUID" -eq 0 ]; then
        # Root prompt (red)
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(git_branch)\[\033[00m\]\# '
    else
        # Regular user prompt (green) 
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[33m\]$(git_branch)\[\033[00m\]\$ '
    fi
else
    # Fallback without git
    if [ "$EUID" -eq 0 ]; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\# '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    fi
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Enable color support for ls and grep
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Ubuntu default ls aliases (will be overridden by eza if available from shared config)
if ! command -v eza &> /dev/null; then
    alias ll='ls -alF'
    alias la='ls -A' 
    alias l='ls -CF'
fi

# Server-specific aliases and functions
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias search='apt search'
alias autoremove='sudo apt autoremove'
alias autoclean='sudo apt autoclean'

# System monitoring
alias logs='sudo journalctl -f'
alias syslog='sudo tail -f /var/log/syslog'
alias ports='sudo netstat -tuln'
alias listen='sudo lsof -i -P -n | grep LISTEN'
alias services='sudo systemctl --type=service'
alias processes='ps aux --sort=-%cpu | head'
alias meminfo='free -h'
alias diskspace='df -h'

# Docker management (enhanced from shared config)
alias dcleanup='docker system prune -af'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'
alias dlogs='docker logs -f'
alias dexec='docker exec -it'
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'

# Kubernetes (from your VPS config)
alias k='kubectl'
alias kgp='kubectl get pods'
alias kgs='kubectl get services'
alias kgd='kubectl get deployments'
alias kdp='kubectl describe pod'
alias kl='kubectl logs'
alias kexec='kubectl exec -it'

# Navigation shortcuts for common server directories
alias www='cd /var/www'
alias log='cd /var/log'
alias etc='cd /etc'
alias nginx='cd /etc/nginx'
alias apache='cd /etc/apache2'

# Network utilities
alias myip='curl -s ifconfig.me'
alias localip='ip route get 1.1.1.1 | awk "{print \$7}"'
alias openports='sudo ss -tuln'

# Add an "alert" alias for long running commands
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Load bash aliases if they exist (Ubuntu standard)
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Load local customizations if they exist
[[ -f ~/.bashrc.local ]] && source ~/.bashrc.local