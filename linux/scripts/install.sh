sudo pacman -Syu --noconfirm hyprland kitty git neovim openssh sddm fastfetch qt5-wayland qt6-wayland stow rsync os-prober ntfs-3g pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumber xdg-desktop-portal-hyprland polkit-kde-agent
./install_paru.sh
paru rofi-lbonn-wayland-git ttf-firacode
./sddm_config.sh
./stow_dotfiles.sh