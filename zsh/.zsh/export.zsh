. $HOME/.nix-profile/etc/profile.d/nix.sh

export GITHUB_HOME=$HOME/Projects
export FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore'
export ALTERNATE_EDITOR="emacs -nw -Q"
export EDITOR='emacsclient -nw'
export VISUAL='emacsclient -c'
export TERM='xterm-256color'
export CLICOLOR=1

export PATH="${HOME}/.gem/ruby/2.6.0/bin:/usr/local/bin:${PATH}"
export PATH="${HOME}/.yarn/bin:${PATH}"
export PATH="${PATH}:/opt/Xilinx/Vivado/2019.1/bin"
export PATH="${PATH}:/opt/intelFPGA_lite/18.1/quartus/bin"
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/.cargo/bin:${PATH}"
export PATH="${HOME}/.cabal/bin:${PATH}"
if [[ -d "${HOME}/.gem/ruby/2.7.0/bin" ]]; then export PATH="${HOME}/.gem/ruby/2.7.0/bin:${PATH}"; fi
export PATH="/usr/local/bin:${PATH}"
export PATH="/Library/TeX/texbin:${PATH}"
export PATH="${PATH}:/Users/yannherklotz/Library/Python/3.7/bin"

# Stop dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Fix java windows for tiling window managers
if [[ $(uname -r) = "Linux" ]]; then export _JAVA_AWT_WM_NONREPARENTING=1; fi

[ -f "$HOME/.travis/travis.sh" ] && source "$HOME/.travis/travis.sh"

# Direnv hook setup
command -v direnv >/dev/null 2>&1
if [[ "$?" -eq 0 ]]; then eval "$(direnv hook zsh)"; fi

# Opam hook setup and initialising it
command -v opam >/dev/null 2>&1
if [[ "$?" -eq 0 ]]; then
    test -r /home/yannherklotz/.opam/opam-init/init.zsh && . /home/yannherklotz/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true
    eval "$(opam env)";
fi
