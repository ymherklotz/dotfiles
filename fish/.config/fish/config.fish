set -x _JAVA_AWT_WM_NONREPARENTING 1
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -x EDITOR 'emacsclient -nw'
set -x VISUAL 'emacsclient -c'
set -x CLICOLOR 1
set -x LEDGER_FILE "$HOME/Dropbox/ledger/main.ledger"
set -x VAGRANT_HOME /mnt/orca/vagrant
set -x QMK_HOME "$HOME/projects/qmk_firmware"
set -x HOMEBREW_NO_ENV_HINTS 1

set -x CDS_LIC_FILE 5280@ee-llic01.ee.ic.ac.uk
set -x SNPS_LICENSE_FILE 7182@ee-llic01.ee.ic.ac.uk
set -x MGLS_LICENSE_FILE 1717@ee-llic01.ee.ic.ac.uk
set -x LM_LICENSE_FILE 2100@ee-llic01.ee.ic.ac.uk:7193@ee-llic01.ee.ic.ac.uk:5280@ee-llic01.ee.ic.ac.uk:7182@ee-llic01.ee.ic.ac.uk:1717@ee-llic01.ee.ic.ac.uk

# nix section
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish

fish_add_path /Library/TeX/texbin
fish_add_path /usr/local/bin
fish_add_path $HOME/.nix-profile/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path $HOME/Library/ConTeXt/tex/texmf-osx-64/bin

function latestqr -d "Return the string corresponding to the latest QR code."
  ls -aS $HOME/Desktop | tail -n1 | tr \\n \\0 | xargs -0 -I% zbarimg --raw -q $HOME/Desktop/%
end

function ll; ls -lah $argv; end
function vim; nvim $argv; end

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -x GPG_TTY (tty)
    set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
end

direnv hook fish | source

# opam configuration
source $HOME/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
