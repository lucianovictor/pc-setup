#!/usr/bin/env bash
set -euo pipefail

repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
config_dir=${XDG_CONFIG_HOME:-$HOME/.config}
data_dir=${XDG_DATA_HOME:-$HOME/.local/share}
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"

case "${1-}" in
    ''|--apps|--config-only) ;;
    -h|--help)
        printf 'Uso: %s [--apps | --config-only]\n' "$0"
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

if [[ ${1-} != --config-only ]]; then
    source /etc/os-release
    if [[ $ID != fedora ]]; then
        printf 'Este instalador de pacotes é para Fedora. Use --config-only para copiar o Bash.\n' >&2
        exit 1
    fi

    sudo dnf install bash-completion eza bat fzf fd-find zoxide btop fastfetch \
        git git-delta gh ripgrep jq neovim helix tree curl wget2-wget zip unzip xz \
        nodejs nodejs-npm python3-pip java-25-openjdk-headless uv fontconfig

    work_dir=$(mktemp -d)
    trap 'rm -rf -- "$work_dir"' EXIT

    if ! command -v kubectl >/dev/null; then
        sudo dnf install kubernetes1.36-client
    fi

    if ! command -v opencode >/dev/null; then
        curl -fsSL https://opencode.ai/install -o "$work_dir/opencode.sh"
        bash "$work_dir/opencode.sh" --no-modify-path
    fi

    if ! command -v starship >/dev/null; then
        mkdir -p -- "$HOME/.local/bin"
        curl -fsSL https://starship.rs/install.sh -o "$work_dir/starship.sh"
        sh "$work_dir/starship.sh" --yes --bin-dir "$HOME/.local/bin"
    fi

    if [[ ! -r $data_dir/blesh/ble.sh ]]; then
        curl -fsSL https://github.com/akinomyoga/ble.sh/releases/download/nightly/ble-nightly.tar.xz \
            -o "$work_dir/ble.tar.xz"
        tar -xJf "$work_dir/ble.tar.xz" -C "$work_dir"
        mkdir -p -- "$data_dir"
        bash "$work_dir/ble-nightly/ble.sh" --install "$data_dir"
    fi

    fonts=$(fc-list : family)
    for font in Hack JetBrainsMono Meslo; do
        if ! grep -qE "${font}[^,]* Nerd Font" <<< "$fonts"; then
            font_dir=$data_dir/fonts/NerdFonts/$font
            mkdir -p -- "$font_dir"
            curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$font.zip" \
                -o "$work_dir/$font.zip"
            unzip -oq "$work_dir/$font.zip" -d "$font_dir"
            fc-cache -f "$font_dir"
        fi
    done
fi

backup_file "$repo/bash/starship.toml" "$config_dir/starship.toml"
backup_file "$repo/bash/modern.sh" "$config_dir/bash/modern.sh"
backup_file "$repo/bash/bashrc" "$HOME/.bashrc"

if [[ ${1-} == --apps ]]; then
    "$repo/install-apps.sh"
    sudo dnf install flatpak kitty qtile rofi i3status feh vlc qbittorrent retroarch

    flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    while read -r app remote; do
        if [[ $remote == flathub && $app != app.zen_browser.zen ]]; then
            flatpak install --user --or-update flathub "$app"
        fi
    done < "$repo/inventario/flatpak.tsv"
fi

printf 'Configuração instalada. Abra um terminal novo para carregar o Bash.\n'
