alias emc='emacsclient -c -a ""'
alias em='emacsclient -nw -a ""'
alias ls='exa'
alias ff='firefox'
alias vim=nvim
# alias lspasscp='lpass show -c --password $(lpass ls  | fzf | awk '{print $(NF)}' | sed 's/\\]//g')'

# fixing pdflatex
#alias pdflatex='/usr/bin/pdflatex'
#alias pdftex='/usr/bin/pdftex'

# fd - cd to selected directory
fdd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

wal-tile() {
    wal -n -i "$@"
    feh --bg-fill "$(< "${HOME}/.cache/wal/wal")"
    $HOME/.local/bin/betterlock -u "$(< "${HOME}/.cache/wal/wal")"
}

wal-tile-l() {
    wal -l -n -i "$@"
    feh --bg-fill "$(< "${HOME}/.cache/wal/wal")"
    $HOME/.local/bin/betterlock -u "$(< "${HOME}/.cache/wal/wal")"
}

latestqr() {
  ls -aS $HOME/Desktop | tail -n1 | tr \\n \\0 | xargs -0 -I% zbarimg --raw -q $HOME/Desktop/%
}
