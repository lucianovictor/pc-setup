# Configuração do meu PC

Configuração do Bash e inventário do meu Fedora KDE.

## Instalação

```bash
./install.sh               # Ferramentas do terminal, desenvolvimento e configuração do Bash
./install.sh --apps        # Também instala os aplicativos de desktop
./install.sh --config-only # Copia somente os arquivos de configuração
./install-apps.sh          # Instala só Ghostty, Zed e Zen Browser
./install-languages.sh     # Instala só as linguagens e ferramentas de desenvolvimento
```

O `install-languages.sh` instala Python com `python`, `python3`, pip e uv, Node.js com npm e npx, o runtime Java 25 que está neste PC e os compiladores GCC para C e C++. O setup principal também chama esse script.

O `install-apps.sh` usa o COPR para o Ghostty, o instalador oficial para o Zed e o Flathub para o Zen Browser. Execute como usuário comum. O script chama `sudo` quando precisa instalar pacotes do Fedora. [Ghostty](https://ghostty.org/docs/install/binary#fedora) · [Zed](https://zed.dev/docs/installation#linux) · [Zen Browser](https://docs.zen-browser.app/guides/install-linux)

O instalador copia o `bash/bashrc` para `~/.bashrc`, o `bash/modern.sh` para `~/.config/bash/modern.sh` e o tema para `~/.config/starship.toml`. Se algum desses arquivos já existir e for diferente, ele salva uma cópia `*.bak.*` ao lado antes de substituir. Abra um novo terminal depois de instalar.

O Bash mantém os atalhos de Git, o histórico, o tema do fzf, o zoxide e o prompt do Starship. O ble.sh cuida das sugestões e do destaque de sintaxe. O `eza`, sucessor do `exa`, é o comando que seu Bash usa para `ls`, `ll`, `la` e `lt`. Com uma Nerd Font selecionada no terminal, esses comandos e o prompt exibem os ícones.

## Inventário

- [RPMs marcados como instalados pelo usuário no DNF](inventario/rpm.txt). A lista inclui a base do Fedora KDE e os pacotes de repositórios externos.
- [Aplicativos Flatpak e seus remotos](inventario/flatpak.tsv).
- [Ferramentas e aplicativos de instalação separada](inventario/externos.md).
