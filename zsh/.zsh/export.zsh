os=$(uname -s)

[ -n "$SSH_CLIENT" ] && export MINIMAL_USER_CHAR="$(hostname)"

. $HOME/.nix-profile/etc/profile.d/nix.sh
export NIX_IGNORE_SYMLINK_STORE=1

export GITHUB_HOME=$HOME/Projects
export FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore'
export ALTERNATE_EDITOR="emacs -nw -Q"
export EDITOR='emacsclient -nw'
export VISUAL='emacsclient -c'
export TERM='xterm-256color'
export CLICOLOR=1

#export LFSCSIGS="$HOME/.opam/default/.opam-switch/sources/coq-smtcoq.dev+8.13/src/lfsc/tests/signatures"

prepend_path() {
    [ -d "$1" ] && PATH="$1:$PATH"
}

append_path() {
    [ -d "$1" ] && PATH="$PATH:$1"
}

if [ $os = "Darwin" ]; then
    prepend_path "/Library/TeX/texbin"
    prepend_path "/usr/local/opt/bison/bin"

    append_path "${HOME}/Library/Python/3.9/bin"
fi

prepend_path "/usr/local/bin"
prepend_path "/usr/local/sbin"
prepend_path "${HOME}/.gem/ruby/2.7.0/bin"
prepend_path "${HOME}/.yarn/bin"
prepend_path "${HOME}/.cargo/bin"
prepend_path "${HOME}/.cabal/bin"
prepend_path "${HOME}/.local/bin"
# prepend_path "/usr/local/opt/llvm/bin"

prepend_path "/mnt/data/tools/panda/bambu-9.7-dev/bin"

append_path "/opt/Xilinx/Vivado/2019.1/bin"
append_path "/opt/intelFPGA_lite/18.1/quartus/bin"
append_path "$HOME/projects/vericert/bin"
append_path "/opt/bin"
append_path "$HOME/go/bin"

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
# command -v opam >/dev/null 2>&1
# if [ "$?" -eq 0 ]; then
#     test -r /home/yannherklotz/.opam/opam-init/init.zsh && . /home/yannherklotz/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
#     eval "$(opam env)";
# fi

# Load rust environment
[ -r "$HOME/.cargo/env" ] && source $HOME/.cargo/env

# Travis
[ -r "$HOME/.travis/travis.sh" ] && source "$HOME/.travis/travis.sh"

export CDS_LIC_FILE=5280@ee-llic01.ee.ic.ac.uk
export SNPS_LICENSE_FILE=7182@ee-llic01.ee.ic.ac.uk
export MGLS_LICENSE_FILE=1717@ee-llic01.ee.ic.ac.uk
export LM_LICENSE_FILE=2100@ee-llic01.ee.ic.ac.uk:7193@ee-llic01.ee.ic.ac.uk:5280@ee-llic01.ee.ic.ac.uk:7182@ee-llic01.ee.ic.ac.uk:1717@ee-llic01.ee.ic.ac.uk

export QMK_HOME=$HOME/projects/qmk_firmware

0file() { curl -F"file=@$1" https://envs.sh ; }
0pb() { curl -F"file=@-;" https://envs.sh ; }
0url() { curl -F"url=$1" https://envs.sh ; }
0short() { curl -F"shorten=$1" https://envs.sh ; }
