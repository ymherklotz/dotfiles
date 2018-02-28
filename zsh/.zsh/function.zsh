alias fdisk='fdisk --color=always'
alias grep='grep --color=always'
alias ls='ls --color=always'
alias l='ls -la --color=always'
alias vim='nvim'
# alias lspasscp='lpass show -c --password $(lpass ls  | fzf | awk '{print $(NF)}' | sed 's/\\]//g')'

# fd - cd to selected directory
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
