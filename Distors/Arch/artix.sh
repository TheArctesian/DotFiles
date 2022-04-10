#config and gen 
sudo pacman -Sy git
sudo pacman -S --needed base-devel
cd Downloads/
# Yay
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
yay -S brave-bin #brave
cd -
# Snap
git clone https://aur.archlinux.org/snapd.git && cd snapd && makepkg -si && sudo systemctl enable --now snapd.socket && sudo ln -s /var/lib/snapd/snap /snap && sudo snap install snapd

git clone https://AUR.archlinux.org/visual-studio-code-bin.git && cd visual-studio-code-bin/ && makepkg -s && sudo pacman -U visual-studio-code-bin-1.64.0-1-x86_64.pkg.tar.zst 


# Langs
pacman -S nodejs npm
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

