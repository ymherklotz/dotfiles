os=$(uname -s)

. $HOME/.nix-profile/etc/profile.d/nix.sh

[ -n "$SSH_CLIENT" ] && export MINIMAL_USER_CHAR="$(hostname)"

export GITHUB_HOME=$HOME/Projects
export FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore'
export ALTERNATE_EDITOR="emacs -nw -Q"
export EDITOR='emacsclient -nw'
export VISUAL='emacsclient -c'
export TERM='xterm-256color'
export CLICOLOR=1

prepend_path() {
    [ -d "$1" ] && PATH="$1:$PATH"
}

append_path() {
    [ -d "$1" ] && PATH="$PATH:$1"
}

if [ $os = "Darwin" ]; then
    prepend_path "/Library/TeX/texbin"
    prepend_path "/usr/local/opt/bison/bin"

    append_path "${HOME}/Library/Python/3.8/bin"
fi

prepend_path "/usr/local/bin"
prepend_path "${HOME}/.gem/ruby/2.7.0/bin"
prepend_path "${HOME}/.yarn/bin"
prepend_path "${HOME}/.cargo/bin"
prepend_path "${HOME}/.cabal/bin"
prepend_path "${HOME}/.local/bin"

append_path "/opt/Xilinx/Vivado/2019.1/bin"
append_path "/opt/intelFPGA_lite/18.1/quartus/bin"

export PATH

if [[ -n $SSH_CLIENT ]]; then
    export MINIMAL_USER_CHAR="$(hostname)"
fi

# Stop dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Fix java windows for tiling window managers
[ $os = "Linux" ] && export _JAVA_AWT_WM_NONREPARENTING=1

# Direnv hook setup
command -v direnv >/dev/null 2>&1
[ "$?" -eq 0 ] && eval "$(direnv hook zsh)"

# Opam hook setup and initialising it
command -v opam >/dev/null 2>&1
if [ "$?" -eq 0 ]; then
    test -r /home/yannherklotz/.opam/opam-init/init.zsh && . /home/yannherklotz/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
    eval "$(opam env)";
fi

# Load rust environment
[ -r "$HOME/.cargo/env" ] && source $HOME/.cargo/env

# Travis
[ -r "$HOME/.travis/travis.sh" ] && source "$HOME/.travis/travis.sh"
