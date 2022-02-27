#!/usr/bin/env bash

SCRIPT_DIR=$(pwd)

function print_help {
  echo "Install configuration options to the correct paths."
  echo ""
  echo "  USAGE:"
  echo "    install.sh [OPTIONS] [PROG [PROG ...]]"
  echo ""
  echo "  OPTIONS:"
  echo "    -f, --force    Force and overwrite current"
  echo "                   configurations."
  echo "    -h, --help     Print this help message."
  echo "    PROG           The program for which the config should"
  echo "                   be installed. If this is left empty it will"
  echo "                   install all the configurations. More that"
  echo "                   one can be specified."
  echo ""
  echo "  EXAMPLE:"
  echo "    install.sh -f emacs X tmux i3"
}

function ln_configs {
  if [[ $FORCE -eq 1 ]]; then
    rm -f $2
  fi
  ln $EXTRA_OPTS ${SCRIPT_DIR}/$1 $2
}

function mk {
  mkdir -p "$1"
}

EXTRA_OPTS=" -s "
for i in "$@"; do
  case $i in

    -f | --force)
      EXTRA_OPTS+=" -f "
      FORCE=1
      ;;

    -h | --help)
      print_help
      exit 0
      ;;

    X)        X=1;         NOT_ALL=1;;
    afew)     AFEW=1;      NOT_ALL=1;;
    bspwm)    BSPWM=1;     NOT_ALL=1;;
    compton)  COMPTON=1;   NOT_ALL=1;;
    doom)     DOOM=1;      NOT_ALL=1;;
    emacs)    EMACS=1;     NOT_ALL=1;;
    firefox)  FIREFOX=1;   NOT_ALL=1;;
    i3)       I3=1;        NOT_ALL=1;;
    isync)    ISYNC=1;     NOT_ALL=1;;
    mpd)      MPD=1;       NOT_ALL=1;;
    msmtp)    MSMTP=1;     NOT_ALL=1;;
    ncmpcpp)  NCMPCPP=1;   NOT_ALL=1;;
    notmuch)  NOTMUCH=1;   NOT_ALL=1;;
    polybar)  POLYBAR=1;   NOT_ALL=1;;
    scripts)  SCRIPTS=1;   NOT_ALL=1;;
    services) SERVICES=1;  NOT_ALL=1;;
    sxhkd)    SXHKD=1;     NOT_ALL=1;;
    rofi)     ROFI=1;      NOT_ALL=1;;
    termite)  TERMITE=1;   NOT_ALL=1;;
    tmux)     TMUX_INST=1; NOT_ALL=1;;
    zathura)  ZATHURA=1;   NOT_ALL=1;;
    zsh)      ZSH=1;       NOT_ALL=1;;
    git)      GIT=1;       NOT_ALL=1;;

    *)
      print_help
      exit 1

  esac
done

if [[ ! -z $GIT ]] || [[ -z $NOT_ALL ]]; then
    echo "Installing git config..."
    ln_configs git/.gitconfig ~/.gitconfig
fi

if [[ ! -z $EMACS ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing emacs config..."
  mk ~/.emacs.d
  cp ${SCRIPT_DIR}/emacs/init.el ~/.emacs.d/init.el
  ln_configs emacs/loader.org ~/.emacs.d/loader.org
fi

if [[ ! -z $SXHKD ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing sxhkd config..."
  mk ~/.config/sxhkd
  ln_configs sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
fi

if [[ ! -z $DOOM ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing doom config..."
  mk ~/.config/doom
  ln_configs doom/config.el ~/.config/doom/config.el
  ln_configs doom/init.el ~/.config/doom/init.el
  ln_configs doom/packages.el ~/.config/doom/packages.el
fi

if [[ ! -z $MSMTP ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing msmtp config..."
  mk ~/.config/msmtp
  ln_configs msmtp/config ~/.config/msmtp/config
fi

if [[ ! -z $ZATHURA ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing zathura config..."
  mk ~/.config/zathura
  ln_configs zathura/zathurarc ~/.config/zathura/zathurarc
fi

if [[ ! -z $AFEW ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing afew config..."
  mk ~/.config/afew
  ln_configs afew/config ~/.config/afew/config
fi

if [[ ! -z $NOTMUCH ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing notmuch config..."
  ln_configs notmuch/.notmuch-config ~/.notmuch-config
fi

if [[ ! -z $X ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing X config..."
  ln_configs X/.Xmodmap ~/.Xmodmap
  ln_configs X/.Xresources ~/.Xresources 
  ln_configs X/.xinitrc ~/.xinitrc
fi

if [[ ! -z $TMUX_INST ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing tmux config..."
  ln_configs tmux/.tmux.conf ~/.tmux.conf
fi

if [[ ! -z $I3 ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing i3 config..."
  mk ~/.config/i3
  ln_configs i3/config ~/.config/i3/config
fi

if [[ ! -z $ZSH ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing zsh config..."
  ln_configs zsh/.zshrc ~/.zshrc
  ln_configs zsh/.zsh ~/.zsh
fi

if [[ ! -z $ISYNC ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing isync config..."
  ln_configs isync/.mbsyncrc ~/.mbsyncrc
fi

if [[ ! -z $POLYBAR ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing polybar config..."
  mk ~/.config/polybar
  ln_configs polybar/config ~/.config/polybar/config
  ln_configs polybar/launch.sh ~/.config/polybar/launch.sh
fi

if [[ ! -z $COMPTON ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing compton config..."
  mk ~/.config
  ln_configs compton/compton.conf ~/.config/compton.conf
fi

if [[ ! -z $FIREFOX ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing firefox config..."
  #ln_configs firefox/userChrome.css ~/.mozilla/firefox/1ye8etqv.default/chrome/userChrome.css
fi

if [[ ! -z $NCMPCPP ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing ncmpcpp config..."
  mk ~/.ncmpcpp
  ln_configs ncmpcpp/bindings ~/.ncmpcpp/bindings
  ln_configs ncmpcpp/config ~/.ncmpcpp/config
fi

if [[ ! -z $MPD ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing mpd config..."
  mk ~/.config/mpd
  ln_configs mpd/mpd.conf ~/.config/mpd/mpd.conf
fi

if [[ ! -z $BSPWM ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing bspwm config..."
  mk ~/.config/bspwm
  ln_configs bspwm/bspwmrc ~/.config/bspwm/bspwmrc
  mk ~/.config/sxhkd
  ln_configs sxhkd/sxhkdrc ~/.config/sxhkd/sxhkdrc
fi

if [[ ! -z $ROFI ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing rofi config..."
  mk ~/.config/rofi
  ln_configs rofi/config ~/.config/rofi/config
fi

if [[ ! -z $TERMITE ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing termite config..."
  mk ~/.config/termite
  ln_configs termite/config ~/.config/termite/config
fi

if [[ ! -z $SERVICES ]] || [[ -z $NOT_ALL ]]; then
  echo "Installing services config..."
  mk ~/.config/systemd/user
  ln_configs services/mailnotify.service ~/.config/systemd/user/mailnotify.service
  ln_configs services/mbsync.service ~/.config/systemd/user/mbsync.service
  ln_configs services/mbsync.timer ~/.config/systemd/user/mbsync.timer
  ln_configs services/clipboard.service ~/.config/systemd/user/clipboard.service
fi
