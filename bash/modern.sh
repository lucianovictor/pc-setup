# EZA
if command -v eza &>/dev/null; then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -lah --icons=auto --git --group-directories-first'
  alias la='eza -a --icons=auto'
  alias lt='eza --tree --level=2 --icons=auto'
fi

# BAT
if command -v bat &>/dev/null; then
  alias cat='bat --paging=never'
  export BAT_THEME="TwoDark"
  export BAT_PAGER="less -FR"
fi

# FZF
if command -v fzf &>/dev/null; then
  export FZF_DEFAULT_OPTS='
    --height=40%
    --layout=reverse
    --border=rounded
    --info=inline
    --prompt="󰍉 "
    --pointer="▶"
    --marker="✓"
    --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
    --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
    --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  '

  if command -v fd &>/dev/null; then
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  fi

  if [[ ${BLE_VERSION-} ]]; then
    [[ ! -r /etc/profile.d/bash_completion.sh ]] || source /etc/profile.d/bash_completion.sh
    ble-import integration/fzf-completion
    ble-import integration/fzf-key-bindings
  else
    eval "$(fzf --bash)"
  fi
fi

# ZOXIDE
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi

# GIT
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -15'

# SISTEMA
alias cls='clear'
update() {
  if command -v yay &>/dev/null; then
    yay -Syu "$@"
  else
    sudo pacman -Syu "$@"
  fi
}
alias sysinfo='fastfetch'
alias top='btop'
alias ..='cd ..'
alias ...='cd ../..'

# HISTÓRICO
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoreboth
shopt -s histappend
if [[ $(declare -p PROMPT_COMMAND 2>/dev/null) == 'declare -a '* ]]; then
  PROMPT_COMMAND=('history -a' "${PROMPT_COMMAND[@]}")
else
  PROMPT_COMMAND="history -a${PROMPT_COMMAND:+;$PROMPT_COMMAND}"
fi

# STARSHIP
if command -v starship &>/dev/null; then
  if [[ ! ${STARSHIP_CONFIG-} && -r ${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml ]]; then
    export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
  fi
  eval "$(starship init bash)"
fi
