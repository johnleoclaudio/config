# Guide: https://www.youtube.com/watch?v=ud7YxC33Z3w
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# zinit package manager
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# zsh plugins
#
# syntax highlighting
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions

# Load completions
autoload -U compinit && compinit

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Source shared environment and aliases
[[ -f ~/.shell_env ]] && source ~/.shell_env
[[ -f ~/.shell_aliases ]] && source ~/.shell_aliases

# Zsh-specific configurations
# emacs mode for navigation
# ctrl + f to accept autosuggestion
# ctrl + b/ f forward
# ctrl + a/ e first and last
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# macOS-specific configurations
if [[ "$OSTYPE" == "darwin"* ]]; then
    # brew
    eval "$(/opt/homebrew/bin/brew shellenv)"
    alias brew=/opt/homebrew/bin/brew
    
    ### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
    export PATH="/Users/leo/.rd/bin:$PATH"
    ### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
fi
