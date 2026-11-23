status is-interactive; or return

fish_add_path --global --move "$HOME/bin" "$HOME/.local/bin" "$HOME/.opencode/bin"

if command -q eza
    alias ls 'eza --icons=auto --group-directories-first'
    alias ll 'eza -lah --icons=auto --git --group-directories-first'
    alias la 'eza -a --icons=auto'
    alias lt 'eza --tree --level=2 --icons=auto'
end

if command -q bat
    alias cat 'bat --paging=never'
    set -gx BAT_THEME TwoDark
    set -gx BAT_PAGER 'less -FR'
end

if command -q fzf
    set -gx FZF_DEFAULT_OPTS '
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

    if command -q fd
        set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
        set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
    end

    fzf --fish | source
end

if command -q zoxide
    zoxide init fish | source
end

alias gs 'git status'
alias ga 'git add'
alias gc 'git commit'
alias gp 'git push'
alias gl 'git log --oneline --graph --decorate -15'
alias cls clear
alias sysinfo fastfetch
alias top btop
alias .. 'cd ..'
alias ... 'cd ../..'

function update
    if command -q yay
        yay -Syu $argv
    else
        sudo pacman -Syu $argv
    end
end

if command -q starship
    if not set -q STARSHIP_CONFIG; and test -r "$__fish_config_dir/../starship.toml"
        set -gx STARSHIP_CONFIG "$__fish_config_dir/../starship.toml"
    end
    starship init fish | source
end
