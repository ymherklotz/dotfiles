export _JAVA_AWT_WM_NONREPARENTING=1
export DOTNET_CLI_TELEMETRY_OPTOUT=1

export EDITOR=nvim
export VISUAL=emacs
export CLICOLOR=1

export LEDGER_FILE=$HOME/Dropbox/ledger/main.ledger
# export VAGRANT_HOME=/mnt/orca/vagrant

export QMK_HOME=$HOME/projects/qmk_firmware
export HOMEBREW_NO_ENV_HINTS=1

export CDS_LIC_FILE=5280@ee-llic01.ee.ic.ac.uk
export SNPS_LICENSE_FILE=7182@ee-llic01.ee.ic.ac.uk
export MGLS_LICENSE_FILE=1717@ee-llic01.ee.ic.ac.uk
export LM_LICENSE_FILE=2100@ee-llic01.ee.ic.ac.uk:7193@ee-llic01.ee.ic.ac.uk:5280@ee-llic01.ee.ic.ac.uk:7182@ee-llic01.ee.ic.ac.uk:1717@ee-llic01.ee.ic.ac.uk

export QSYS_ROOTDIR="/mnt/data/tools/intel/QuartusLite/18.1/quartus/sopc_builder/bin"
export INTELFPGAOCLSDKROOT="/mnt/data/tools/intel/QuartusStandard/19.1/hld"

[ -f /usr/local/bin/brew ] && eval "$(/usr/local/bin/brew shellenv)"
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env
[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ] \
    && source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
[ -f $HOME/.opam/opam-init/init.zsh ] && source $HOME/.opam/opam-init/init.zsh
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

PATH=$HOME/.nix-profile/bin:$PATH
PATH=/Library/TeX/texbin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=$HOME/.cargo/bin:$PATH
PATH=$HOME/.local/bin:$PATH
PATH=$HOME/Library/ConTeXt/tex/texmf-osx-64/bin:$PATH

export PATH

export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
