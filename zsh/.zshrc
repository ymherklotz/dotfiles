# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=1000000
setopt appendhistory notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 10
zstyle ':completion:*' prompt ' '
zstyle :compinstall filename '/home/yannherklotz/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Sourcing everything
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
source $HOME/.zsh/export.zsh
source $HOME/.zsh/minimal.zsh
source $HOME/.zsh/function.zsh
source $HOME/.zsh/startup.zsh
