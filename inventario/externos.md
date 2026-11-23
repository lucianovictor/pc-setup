# Instalações externas

A tabela registra instalações do PC com Fedora. No CachyOS, os scripts instalam Starship, as Nerd Fonts Hack, JetBrains Mono e Meslo, OpenCode, uv, kubectl, Ghostty, Zed e Zen Browser pelo `pacman` e o ble.sh pelo `yay`.

| Encontrado no PC | Origem |
| --- | --- |
| Docker CE, Buildx, Compose e Docker Desktop | Repositório e pacotes do Docker. A cópia independente de `docker-compose` em `/usr/local/bin` também consta no PC. |
| Visual Studio Code | Repositório `vscode` |
| ChatGPT | Repositório `chatgpt` |
| Google Chrome | RPM `google-chrome-stable` |
| Insync | Repositório `insync` |
| Notion e Dolphin Emulator | Remotos Flatpak `notion-origin` e `dolphin` |
| Codex | Binário local em `~/.local/bin/codex` |

Os itens da tabela precisam ser instalados separadamente. O [inventário RPM](rpm.txt) guarda os nomes dos pacotes e o [inventário Flatpak](flatpak.tsv) guarda os identificadores dos aplicativos.
