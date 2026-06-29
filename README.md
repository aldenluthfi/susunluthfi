<picture>
  <source media="(prefers-color-scheme: light)" srcset="/.github/meta/dark.png">
  <source media="(prefers-color-scheme: dark)" srcset="/.github/meta/light.png">
  <img alt="SusunLuthfi Dotfiles & Configs">
</picture>

<pre>
[ ABOUT ]

SusunLuthfi is a cross-platform dotfiles and configuration management
system for Linux, macOS, and Windows. It provides a unified, organized,
and reproducible way to manage your personal environment, shell, fonts,
wallpapers, and system tweaks across multiple operating systems.

Publication  --> <a href="https://aldenluth.fi/writings/lwm-a-triple-boot-guide">Read the publication: Triple Boot Guide →</a>

[ FEATURES ]

Modular Structure        --> separate folders for each OS (linux, macos,
                             windows)
Automated Setup Scripts  --> install, stow, and unstow dotfiles with one
                             command
Font Management          --> pre-bundled FiraCode fonts in multiple
                             formats
Wallpaper Collection     --> curated wallpapers for a consistent look
Fastfetch & PowerToys    --> Windows-specific customization
Cross-Platform           --> achieve a similar look and feel everywhere
Easy Customization       --> add your own scripts, configs, and assets

[ QUICK START ]

Prerequisites:

    <a href="https://www.gnu.org/software/stow/">GNU Stow</a>                  (for Linux/macOS)
    <a href="https://github.com/Morganamilo/paru">Paru</a>                      (optional, for Arch Linux AUR)
    <a href="https://scoop.sh/">Scoop</a>                     (for Windows, optional)

Linux/macOS:

    cd linux/scripts # or macos/scripts
    ./stow_dotfiles.sh

Windows:

    Use the provided PowerShell scripts in windows/powershell/ and
    configuration files for Windows Terminal, PowerToys, and Fastfetch.

[ PROJECT STRUCTURE ]

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

[ CUSTOMIZATION ]

- Add your own dotfiles to the appropriate home/ directory
- Place custom scripts in the scripts/ folder for each OS
- Add wallpapers or fonts to the agnostic/ directory
- Edit Windows configs for PowerToys, Fastfetch, and Terminal as needed

[ SCRIPTS OVERVIEW ]

Linux/macOS:

    stow_dotfiles.sh    --> Symlink dotfiles using GNU Stow
    unstow_dotfiles.sh  --> Remove dotfiles using GNU Stow
    install.sh          --> Install base packages (Linux)
    install_paru.sh     --> Install Paru AUR helper (Linux)
    clean_packages.sh   --> Clean up orphaned packages (Linux)
    sddm_config.sh      --> SDDM display manager tweaks (Linux)

Windows:

    - PowerShell profiles and prompt themes
    - Fastfetch and PowerToys configuration
    - Scoop startup scripts

[ FONTS & WALLPAPERS ]

Fonts       --> FiraCode in TTF, WOFF, WOFF2, and variable formats
Wallpapers  --> High-res PNGs for a consistent desktop look

[ SUPPORTED PLATFORMS ]

Linux    --> Arch-based (tested), adaptable to others
macOS    --> Modern versions
Windows  --> 10/11 with PowerShell, Windows Terminal, PowerToys

[ TROUBLESHOOTING ]

- Ensure GNU Stow is installed for symlinking dotfiles
- Run scripts with appropriate permissions (chmod +x script.sh)
- On Windows, run PowerShell scripts as Administrator if needed

[ LICENSE ]

This repository is licensed under the <a href="LICENSE">MIT License</a>.

With this license, you are allowed to:
- Use, copy, modify, and distribute this project freely
- Create derivative works or integrate it into your own setups
- Use the code for personal, educational, or commercial purposes
- Include these dotfiles and configs in larger projects or distributions
- Redistribute your changes under the same or a different license

[ ACKNOWLEDGEMENTS ]

<a href="https://github.com/tonsky/FiraCode">FiraCode</a>      --> for fonts
<a href="https://github.com/fastfetch-cli/fastfetch">Fastfetch</a>     --> for system info
<a href="https://github.com/microsoft/PowerToys">PowerToys</a>     --> for Windows enhancements
<a href="https://www.gnu.org/software/stow/">GNU Stow</a>      --> for dotfile management
</pre>
