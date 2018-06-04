#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

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

echo "Installing emacs config..."
cp ${current_dir}/emacs/init.el ~/.emacs.d/init.el
ln_configs emacs/loader.org ~/.emacs.d/loader.org

echo "Installing X config..."
ln_configs X/.Xmodmap ~/.Xmodmap
ln_configs X/.Xresources ~/.Xresources 
ln_configs X/.xinitrc ~/.xinitrc

echo "Installing tmux config..."
ln_configs tmux/.tmux.conf ~/.tmux.conf

echo "Installing i3 config..."
ln_configs i3/config ~/.config/i3/config

echo "Installing zsh config..."
ln_configs zsh/.zshrc ~/.zshrc
ln_configs zsh/.zsh ~/.zsh

echo "Installing isync config..."
ln_configs isync/.mbsyncrc ~/.mbsyncrc
