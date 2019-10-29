export GITHUB_HOME=$HOME/Github
export ALTERNATE_EDITOR="emacs -nw -Q"
export EDITOR='emacsclient -nw'
export VISUAL='emacsclient -c'
export TERM='xterm-256color'

export PATH="${HOME}/.gem/ruby/2.6.0/bin:/usr/local/bin:${PATH}"
export PATH="/usr/bin:${PATH}"
export PATH="${HOME}/.yarn/bin:${PATH}"
export PATH="${PATH}:/opt/Xilinx/Vivado/2019.1/bin"
export PATH="${PATH}:/opt/intelFPGA_lite/18.1/quartus/bin"
export PATH="${HOME}/.local/bin:${PATH}"
export PATH="${HOME}/.cargo/bin:${PATH}"
export PATH="${HOME}/.cabal/bin:${PATH}"

# Stop dotnet telemetry
export DOTNET_CLI_TELEMETRY_OPTOUT=1

# Fix java windows for tiling window managers
export _JAVA_AWT_WM_NONREPARENTING=1
