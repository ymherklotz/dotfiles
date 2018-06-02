#!/usr/bin/env bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

EXTRA_OPTS=" -s "

for i in "$@"; do
  case $i in

    -f | --force)
      EXTRA_OPTS+=" -f "
      ;;

  esac
done

function ln_configs {
  ln $EXTRA_OPTS ${SCRIPT_DIR}/${1} $2
}

echo "installing emacs config..."
cp ${current_dir}/emacs/init.el ~/.emacs.d/init.el
ln_configs emacs/loader.org ~/.emacs.d/loader.org

echo "installing X config"
ln_configs X/.Xmodmap ~/.Xmodmap
ln_configs X/.Xresources ~/.Xresources 
ln_configs X/.xinitrc ~/.xinitrc

echo "installing tmux config"
ln_configs tmux/.tmux.conf ~/.tmux.conf

echo "installing i3 config"
ln_configs i3/config ~/.config/i3/config

echo "installing zsh config"
ln_configs zsh/.zshrc ~/.zshrc
ln_configs zsh/.zsh ~/.zsh

echo "installing isync config"
ln_configs isync/.mbsyncrc ~/.mbsyncrc
