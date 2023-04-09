function latestqr -d "Return the string corresponding to the latest QR code."
  ls -aS $HOME/Desktop | tail -n1 | tr \\n \\0 | xargs -0 -I% zbarimg --raw -q $HOME/Desktop/%
end

function ll; ls -lah $argv; end
function vim; nvim $argv; end

if status is-interactive
    set -x GPG_TTY (tty)
    gpgconf --launch gpg-agent
    direnv hook fish | source
end
