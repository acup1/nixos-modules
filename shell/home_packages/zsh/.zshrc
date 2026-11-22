[[ -o interactive ]] || return

typeset -U path
if [[ "$OSTYPE" == darwin* ]]; then
  wakeup() { sudo pmset -a disablesleep 1; }
  wakedown() { sudo pmset -a disablesleep 0; }

  if [[ -d /opt/homebrew/bin ]]; then
    path=(/opt/homebrew/bin "${path[@]}")
  fi
fi
path=("$HOME/.local/bin" "${path[@]}")

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias c='clear'
alias ..='cd ..'
alias n='nvim'
alias nv='nvim'
alias py='python3'
alias cmatrix='cmatrix -C white'
alias neofetch='c && neofetch && read'
alias du='du -sh'
alias ns='nix-shell'
alias nd='nix develop'
alias nixcleanup='sudo nix-collect-garbage -d'

if (( $+commands[pacman] )); then
  alias pm='sudo pacman --noconfirm'
fi
if (( $+commands[yay] )); then
  alias yy='yay --noconfirm'
fi
if (( $+commands[hyprctl] )); then
  alias hde='hyprctl dispatch exec'
fi
if (( $+commands[poweroff] )); then
  alias pwrff='poweroff'
fi

bindkey -s '^L' 'ls -la^M'
bindkey -s '^U' 'c^M'
bindkey -s '^Y' 'yazi^M'
bindkey -s '^B' 'btop^M'
bindkey -s '^Z' 'fg^M'
bindkey -s '^N' 'fastfetch^M'
bindkey -s '^T' 'du .^M'
if (( $+commands[pokemon-colorscripts] )); then
  bindkey -s '^P' 'clear && pokemon-colorscripts -r -b^M'
fi

export NIXPKGS_ALLOW_UNFREE=1
export EDITOR=nvim
if (( $+commands[zsh] )); then
  export SHELL="$commands[zsh]"
fi

if [[ "$OSTYPE" == darwin* && -f "$HOME/.skillstore/.env" ]]; then
  source "$HOME/.skillstore/.env"
fi
