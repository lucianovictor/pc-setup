#!/usr/bin/env bash
set -euo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}

case "${1-}" in
    ''|--apps|--config-only|--fish|--fish-config-only) ;;
    -h|--help)
        printf 'Uso: %s [--apps | --config-only | --fish | --fish-config-only]\n' "$0"
        exit 0
        ;;
    *)
        printf 'Opção desconhecida: %s\n' "$1" >&2
        exit 2
        ;;
esac

if (( $# > 1 || EUID == 0 )); then
    printf 'Execute com seu usuário comum e informe no máximo uma opção.\n' >&2
    exit 2
fi

backup_file() {
    local src=$1 dest=$2 backup
    if cmp -s -- "$src" "$dest"; then
        return
    fi
    mkdir -p -- "$(dirname -- "$dest")"
    if [[ -e $dest || -L $dest ]]; then
        backup=$(mktemp -- "$dest.bak.XXXXXX")
        cp -p -- "$dest" "$backup"
        printf 'Backup salvo em %s\n' "$backup"
    fi
    install -m 644 -- "$src" "$dest"
}

if [[ ${1-} != --config-only && ${1-} != --fish-config-only ]]; then
    source /etc/os-release
    if [[ ${ID-} != cachyos ]]; then
        printf 'Este instalador de pacotes é para CachyOS. Use --config-only ou --fish-config-only para copiar as configurações.\n' >&2
        exit 1
    fi
fi

if [[ ${1-} == --fish || ${1-} == --fish-config-only ]]; then
    if [[ $1 == --fish ]]; then
        sudo pacman -Syu --needed fish eza bat fzf fd zoxide starship git btop fastfetch yay \
            ttf-hack-nerd ttf-jetbrains-mono-nerd ttf-meslo-nerd
    fi

    backup_file "$repo/bash/starship.toml" "$config_dir/starship.toml"
    backup_file "$repo/fish/modern.fish" "$config_dir/fish/modern.fish"

    fish_config=$config_dir/fish/config.fish
    fish_source='source "$__fish_config_dir/modern.fish"'
    if [[ ! -f $fish_config ]] || ! grep -Fxq -- "$fish_source" "$fish_config"; then
        staged_config=$(mktemp)
        trap 'rm -f -- "$staged_config"' EXIT
        if [[ -f $fish_config ]]; then
            cat -- "$fish_config" > "$staged_config"
        fi
        printf '\n%s\n' "$fish_source" >> "$staged_config"
        backup_file "$staged_config" "$fish_config"
    fi

    printf 'Configuração do Fish instalada. Abra um terminal novo ou execute fish.\n'
    exit 0
fi

if [[ ${1-} != --config-only ]]; then

    "$repo/install-languages.sh"

    sudo pacman -S --needed bash-completion eza bat fzf fd zoxide btop fastfetch \
        git git-delta github-cli ripgrep jq neovim helix tree curl wget zip unzip xz fontconfig \
        kubectl opencode starship ttf-hack-nerd ttf-jetbrains-mono-nerd ttf-meslo-nerd \
        yay base-devel

    yay -S --needed blesh-git
fi

backup_file "$repo/bash/starship.toml" "$config_dir/starship.toml"
backup_file "$repo/bash/modern.sh" "$config_dir/bash/modern.sh"
backup_file "$repo/bash/bashrc" "$HOME/.bashrc"

if [[ ${1-} == --apps ]]; then
    "$repo/install-apps.sh"
    sudo pacman -S --needed kitty qtile rofi i3status feh vlc vlc-plugins-all qbittorrent \
        retroarch bitwarden discord spotify-launcher podman-desktop obsidian
fi

printf 'Configuração instalada. Abra um terminal novo para carregar o Bash.\n'
