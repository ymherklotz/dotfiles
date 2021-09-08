[[ $TERM == "dumb" ]] && unsetopt zle && PS1=$  && return

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=1000000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 10
zstyle ':completion:*' prompt ' '
zstyle :compinstall filename '/home/yannherklotz/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS

#if [ -d ~/.cache/wal ]; then (cat ~/.cache/wal/sequences &) fi

export MINIMAL_MAGIC_ENTER=no

# Sourcing everything
#if [ -e /usr/share/fzf/key-bindings.zsh ]; then source /usr/share/fzf/key-bindings.zsh; fi
#if [ -e /usr/share/fzf/completion.zsh ]; then source /usr/share/fzf/completion.zsh; fi
if [ -e $HOME/.zsh/export.zsh ]; then source $HOME/.zsh/export.zsh; fi
if [ -e $HOME/.zsh/minimal.zsh ]; then source $HOME/.zsh/minimal.zsh; fi
if [ -e $HOME/.zsh/function.zsh ]; then source $HOME/.zsh/function.zsh; fi
if [ -e $HOME/.zsh/startup.zsh ]; then source $HOME/.zsh/startup.zsh; fi
if [ -e $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh ]; then source $HOME/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh; fi
if [ -e $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then source $HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh; fi
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs ^N history-substring-search-down
