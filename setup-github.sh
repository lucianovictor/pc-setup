#!/usr/bin/env bash
set -euo pipefail

if [[ ${1-} == --help || ${1-} == -h ]]; then
    printf 'Uso: %s\nConfigura o GitHub CLI e o acesso por SSH no CachyOS.\n' "$0"
    exit 0
fi

if (( $# != 0 || EUID == 0 )) || [[ ! -t 0 || ! -t 1 ]]; then
    printf 'Execute como usuário comum, em um terminal interativo e sem argumentos.\n' >&2
    exit 2
fi

source /etc/os-release
if [[ ${ID-} != cachyos ]]; then
    printf 'Este instalador é para CachyOS.\n' >&2
    exit 1
fi

if ! command -v git >/dev/null || ! command -v gh >/dev/null ||
    ! command -v ssh >/dev/null || ! command -v ssh-keygen >/dev/null; then
    sudo pacman -Syu --needed git github-cli openssh
fi

# A configuração é para a conta persistida no gh, inclusive quando há um token no ambiente.
unset GH_TOKEN GITHUB_TOKEN

if gh auth status --hostname github.com &&
    git ls-remote git@github.com:cli/cli.git HEAD >/dev/null; then
    gh config set git_protocol ssh --host github.com
else
    printf 'No GitHub CLI, selecione sua chave pública ou aceite criar uma. Autorize o login no navegador.\n'
    gh auth login --hostname github.com --git-protocol ssh --web
    gh auth status --hostname github.com
    if ! git ls-remote git@github.com:cli/cli.git HEAD >/dev/null; then
        printf 'O login do gh foi confirmado. O teste de acesso ao GitHub por SSH falhou.\n' >&2
        exit 1
    fi
fi

printf 'GitHub CLI autenticado e acesso Git por SSH verificado.\n'
