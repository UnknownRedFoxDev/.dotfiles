export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)

source $ZSH/oh-my-zsh.sh

alias mypaint='/usr/bin/MyPaint 2>/dev/null >/dev/null'
alias cat='$HOME/.cargo/bin/bat'
alias ls="$HOME/.cargo/bin/eza -l --icons --time-style=long-iso --group-directories-first"
alias ll='ls -la --icons --time-style=long-iso --group-directories-first'
alias larth='ls -larhsmodified'
alias ff='fastfetch -c ~/.config/fastfetch/test.jsonc'
alias cls='clear'

export EDITOR='nvim'
export XDG_CONFIG_HOME="$HOME/.config"
export PAGER=nvimpager
