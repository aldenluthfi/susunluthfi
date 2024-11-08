cat pacman_packages | tr '\n' ' ' | xargs sudo pacman -Syu --noconfirm

./install_paru.sh
./clean_packages.sh

cat paru_packages | tr '\n' ' ' | xargs paru --noconfirm

./stow_dotfiles.sh
./sddm_config.sh
sudo systemctl enable sddm
