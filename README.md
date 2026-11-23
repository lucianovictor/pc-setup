# Configuração do meu PC

Configuração do Bash e instaladores de pacotes para o CachyOS.

## Instalação

```bash
./install.sh               # Ferramentas do terminal, desenvolvimento e configuração do Bash
./install.sh --apps        # Também instala os aplicativos de desktop
./install.sh --config-only # Copia somente os arquivos de configuração
./install.sh --fish        # Instala o Fish e as ferramentas para o terminal
./install.sh --fish-config-only # Aplica somente a configuração do Fish e o tema
./install-apps.sh          # Instala só Ghostty, Zed e Zen Browser
./install-languages.sh     # Instala só as linguagens e ferramentas de desenvolvimento
```

Execute os scripts como usuário comum. O `pacman` roda com `sudo` para instalar pacotes dos repositórios e atualizar o sistema. O setup principal instala `yay` e `base-devel` pelo `pacman` e usa `yay` como usuário comum para instalar o `blesh-git`. No Bash, o comando `update` usa `yay -Syu` quando disponível e recorre a `sudo pacman -Syu` nas demais instalações.

O `install-languages.sh` instala Python com pip e uv, Node.js com npm e npx, o runtime Java 25 e o GCC para C e C++. O setup principal também chama esse script.

O `install-apps.sh` instala Ghostty, Zed e Zen Browser pelo `pacman`. O modo `--apps` também instala Kitty, Qtile, Rofi, i3status, feh, VLC, qBittorrent, RetroArch, Bitwarden, Discord, Spotify Launcher, Podman Desktop e Obsidian.

O instalador copia o `bash/bashrc` para `~/.bashrc`, o `bash/modern.sh` para `~/.config/bash/modern.sh` e o tema para `~/.config/starship.toml`. Se algum desses arquivos já existir e for diferente, ele salva uma cópia `*.bak.*` ao lado antes de substituir. Abra um novo terminal depois de instalar.

O Bash mantém os atalhos de Git, o histórico, o tema do fzf, o zoxide e o prompt do Starship. O ble.sh cuida das sugestões e do destaque de sintaxe. O `eza`, sucessor do `exa`, é o comando que seu Bash usa para `ls`, `ll`, `la` e `lt`. Com uma Nerd Font selecionada no terminal, esses comandos e o prompt exibem os ícones.

A configuração do Fish reaproveita o tema do Starship, os aliases de Git e de listagem, o comando `update` e os atalhos do fzf. O instalador preserva o conteúdo de `config.fish`, salva um backup antes de adicionar a configuração e mantém o shell padrão da conta.

## Inventário da instalação anterior

- [Pacotes RPM do Fedora KDE](inventario/rpm.txt)
- [Aplicativos Flatpak e seus remotos no Fedora](inventario/flatpak.tsv)
- [Instalações externas e aplicativos de instalação separada](inventario/externos.md)
