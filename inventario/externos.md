# Instalações externas

O instalador automatiza Starship, ble.sh, as Nerd Fonts Hack, JetBrainsMono e Meslo e OpenCode. O Fedora fornece `uv` e `kubectl` no setup novo. O [script de aplicativos](../install-apps.sh) instala Ghostty, Zed e Zen Browser.

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
