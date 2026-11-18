#!/usr/bin/env bash
set -euo pipefail

if [[ ${1-} == --help || ${1-} == -h ]]; then
    printf 'Uso: %s\nInstala Ghostty, Zed e Zen Browser no Fedora.\n' "$0"
    exit 0
fi

if (( $# != 0 || EUID == 0 )); then
    printf 'Execute com seu usuário comum e sem argumentos.\n' >&2
    exit 2
fi

source /etc/os-release
if [[ $ID != fedora ]]; then
    printf 'Este instalador é para Fedora.\n' >&2
    exit 1
fi

export PATH="$HOME/.local/bin:$PATH"

if ! rpm -q ghostty >/dev/null; then
    sudo dnf install dnf5-plugins
    sudo dnf copr enable scottames/ghostty
    sudo dnf install ghostty
fi

if ! command -v zed >/dev/null; then
    if ! command -v curl >/dev/null; then
        sudo dnf install curl
    fi
    work_dir=$(mktemp -d)
    trap 'rm -rf -- "$work_dir"' EXIT
    curl -fsSL https://zed.dev/install.sh -o "$work_dir/zed.sh"
    sh "$work_dir/zed.sh"
fi

if ! command -v flatpak >/dev/null; then
    sudo dnf install flatpak
fi

zen=app.zen_browser.zen
if ! flatpak info "$zen" >/dev/null 2>&1; then
    flatpak remote-add --user --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    flatpak install --user flathub "$zen"
fi

printf 'Ghostty, Zed e Zen Browser estão instalados.\n'
