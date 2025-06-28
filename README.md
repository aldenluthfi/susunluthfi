<picture>
  <source media="(prefers-color-scheme: light)" srcset="/.github/meta/dark.png">
  <source media="(prefers-color-scheme: dark)" srcset="/.github/meta/light.png">
  <img alt="SusunLuthfi Dotfiles & Configs">
</picture>

## 📖 About

**SusunLuthfi** is a cross-platform dotfiles and configuration management system for Linux, macOS, and Windows. It provides a unified, organized, and reproducible way to manage your personal environment, shell, fonts, wallpapers, and system tweaks across multiple operating systems.

[**Read the publication: Triple Boot Guide →**](https://aldenluth.fi/writings/lwm-a-triple-boot-guide)

## 🌟 Features

- **Modular Structure**: Separate folders for each OS (linux, macos, windows)
- **Automated Setup Scripts**: Install, stow, and unstow dotfiles with one command
- **Font Management**: Pre-bundled FiraCode fonts in multiple formats
- **Wallpaper Collection**: Curated wallpapers for a consistent look
- **Fastfetch & PowerToys**: Windows-specific customization
- **Cross-Platform Consistency**: Achieve a similar look and feel everywhere
- **Easy Customization**: Add your own scripts, configs, and assets

## 🚀 Quick Start

### Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/) (for Linux/macOS)
- [Paru](https://github.com/Morganamilo/paru) (optional, for Arch Linux AUR)
- [Scoop](https://scoop.sh/) (for Windows, optional)

### Linux/macOS
```bash
cd linux/scripts # or macos/scripts
./stow_dotfiles.sh
```

### Windows
Use the provided PowerShell scripts in `windows/powershell/` and configuration files for Windows Terminal, PowerToys, and Fastfetch.

## 📁 Project Structure

```
agnostic/
  fonts/         # FiraCode fonts in ttf, woff, woff2
  wallpapers/    # PNG wallpapers
linux/
  home/          # Dotfiles for Linux
  scripts/       # Install and stow scripts
macos/
  home/          # Dotfiles for macOS
  scripts/       # Stow/unstow scripts
windows/
  fastfetch/     # Fastfetch config
  powershell/    # PowerShell profile and prompts
  powertoys/     # PowerToys settings
  scoop/         # Scoop startup scripts
  windows-terminal/ # Windows Terminal settings
LICENSE          # MIT License
README.md        # This file
```

## 🔧 Customization

- Add your own dotfiles to the appropriate `home/` directory
- Place custom scripts in the `scripts/` folder for each OS
- Add wallpapers or fonts to the `agnostic/` directory
- Edit Windows configs for PowerToys, Fastfetch, and Terminal as needed

## 🧩 Scripts Overview

### Linux/macOS
- `stow_dotfiles.sh` / `unstow_dotfiles.sh`: Symlink or remove dotfiles using GNU Stow
- `install.sh`: Install base packages (Linux)
- `install_paru.sh`: Install Paru AUR helper (Linux)
- `clean_packages.sh`: Clean up orphaned packages (Linux)
- `sddm_config.sh`: SDDM display manager tweaks (Linux)

### Windows
- PowerShell profiles and prompt themes
- Fastfetch and PowerToys configuration
- Scoop startup scripts

## 🖼️ Fonts & Wallpapers

- **Fonts**: FiraCode in TTF, WOFF, WOFF2, and variable formats
- **Wallpapers**: High-res PNGs for a consistent desktop look

## ⚙️ Supported Platforms

- **Linux**: Arch-based (tested), adaptable to others
- **macOS**: Modern versions
- **Windows**: 10/11 with PowerShell, Windows Terminal, PowerToys

## 🐛 Troubleshooting

- Ensure GNU Stow is installed for symlinking dotfiles
- Run scripts with appropriate permissions (`chmod +x script.sh`)
- On Windows, run PowerShell scripts as Administrator if needed

## ⚖️ License

This repository is licensed under the [MIT License](LICENSE).

With this license, you are allowed to:
- Use, copy, modify, and distribute this project freely
- Create derivative works or integrate it into your own setups
- Use the code for personal, educational, or commercial purposes
- Include these dotfiles and configs in larger projects or distributions
- Redistribute your changes under the same or a different license

## 🙏 Acknowledgements

- [FiraCode](https://github.com/tonsky/FiraCode) for fonts
- [Fastfetch](https://github.com/fastfetch-cli/fastfetch) for system info
- [PowerToys](https://github.com/microsoft/PowerToys) for Windows enhancements
- [GNU Stow](https://www.gnu.org/software/stow/) for dotfile management