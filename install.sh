#!/usr/bin/env bash

current_dir=$(pwd)

extra_opts=" -s "

for i in "$@"; do
  case $i in

    -f | --force)
      extra_opts+=" -f "
      ;;

  esac
done

function ln_configs {
  ln $extra_opts ${current_dir}/${1} $2
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
