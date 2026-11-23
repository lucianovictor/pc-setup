#!/usr/bin/env bash
set -euo pipefail

if [[ ${1-} == --help || ${1-} == -h ]]; then
    printf 'Uso: %s\nInstala Python, Node.js, Java e GCC no CachyOS.\n' "$0"
    exit 0
fi

if (( $# != 0 || EUID == 0 )); then
    printf 'Execute com seu usuário comum e sem argumentos.\n' >&2
    exit 2
fi

source /etc/os-release
if [[ ${ID-} != cachyos ]]; then
    printf 'Este instalador é para CachyOS.\n' >&2
    exit 1
fi

sudo pacman -Syu --needed python python-pip uv nodejs npm jre25-openjdk-headless gcc
