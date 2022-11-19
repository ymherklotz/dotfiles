set -x _JAVA_AWT_WM_NONREPARENTING 1
set -x DOTNET_CLI_TELEMETRY_OPTOUT 1
set -x EDITOR 'emacsclient -nw'
set -x VISUAL 'emacsclient -c'
set -x CLICOLOR 1
set -x LEDGER_FILE "$HOME/Dropbox/ledger/main.ledger"
set -x VAGRANT_HOME /mnt/orca/vagrant
set -x QMK_HOME "$HOME/projects/qmk_firmware"
set -x NIX_IGNORE_SYMLINK_STORE 1

set -x CDS_LIC_FILE 5280@ee-llic01.ee.ic.ac.uk
set -x SNPS_LICENSE_FILE 7182@ee-llic01.ee.ic.ac.uk
set -x MGLS_LICENSE_FILE 1717@ee-llic01.ee.ic.ac.uk
set -x LM_LICENSE_FILE 2100@ee-llic01.ee.ic.ac.uk:7193@ee-llic01.ee.ic.ac.uk:5280@ee-llic01.ee.ic.ac.uk:7182@ee-llic01.ee.ic.ac.uk:1717@ee-llic01.ee.ic.ac.uk

# nix section
set -x NIX_LINK $HOME/.nix-profile
set -x NIX_SSL_CERT_FILE /etc/ssl/certs/ca-certificates.crt
set -x MANPATH "$NIX_LINK/share/man:$MANPATH"
set -x PATH "$NIX_LINK/bin:$PATH"
set -e NIX_LINK

function latestqr -d "Return the string corresponding to the latest QR code."
  ls -aS $HOME/Desktop | tail -n1 | tr \\n \\0 | xargs -0 -I% zbarimg --raw -q $HOME/Desktop/%
end

function open; xdg-open $argv; end
function ls; exa $argv; end
function ll; ls -lah $argv; end
function vim; nvim $argv; end

if status is-interactive
    # Commands to run in interactive sessions can go here
end

direnv hook fish | source
