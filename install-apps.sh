#!/usr/bin/env bash
set -euo pipefail

if [[ ${1-} == --help || ${1-} == -h ]]; then
    printf 'Uso: %s [--zed]\nInstala Ghostty, Zed e Zen Browser no CachyOS. Use --zed para instalar só o Zed.\n' "$0"
    exit 0
fi

if (( $# > 1 || EUID == 0 )) || [[ -n ${1-} && $1 != --zed ]]; then
    printf 'Execute com seu usuário comum. Use %s --help para ver as opções.\n' "$0" >&2
    exit 2
fi

source /etc/os-release
if [[ ${ID-} != cachyos ]]; then
    printf 'Este instalador é para CachyOS.\n' >&2
    exit 1
fi

if [[ ${1-} == --zed ]]; then
    sudo pacman -Syu --needed zed
    printf 'Zed está instalado.\n'
    exit 0
fi

sudo pacman -Syu --needed ghostty zed zen-browser-bin
printf 'Ghostty, Zed e Zen Browser estão instalados.\n'
