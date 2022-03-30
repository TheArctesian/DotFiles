# for init boot install just use archfi 
# curl -L archfi.sf.net/archfi > archfi

# Then here is where I put the shit I need

sudo pacman -S nodejs npm xmonad xmobar alacritty xmonad-contrib xterm ttf-fira-mono feh picom neovim github-cli btop htop fish git chrony

cd ~/
mkdir Build
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R {name}:{name} yay-git
cd yay-git
makepkg -si
yay

systemctl enable --now chronyd

