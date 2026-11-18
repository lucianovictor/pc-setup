#!/usr/bin/env bash
set -euo pipefail

if [[ ${1-} == --help || ${1-} == -h ]]; then
    printf 'Uso: %s\nInstala Python, Node.js, Java e GCC no Fedora.\n' "$0"
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

sudo dnf install \
    python3 python-unversioned-command python3-pip uv \
    nodejs nodejs-npm \
    java-25-openjdk-headless \
    gcc gcc-c++
