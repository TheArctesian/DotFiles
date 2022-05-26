sudo pacman -S --needed base-devel
# i think you can do this with doas now
cd /opt
sudo git clone https://aur.archlinux.org/yay-git.git
sudo chown -R {name}:{name} yay-git
cd yay-git
makepkg -si
yay


