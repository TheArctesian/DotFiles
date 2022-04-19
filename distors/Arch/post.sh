# Make User
useradd -m -G users,wheel,audio -s /bin/bash arctesian
passwd arctesian

# Sudo cuz yay dosnt support doas 
pacman -S sudo vi
visudo
# uncoment the wheel group 
# or directly add the user
# arctesian ALL=(ALL) ALL

# Install Cinnamon 
pacman -S xorg xterm cinnamon alacritty gdm

# Install Xmonad 
pacman -S xmonad xmonad-contrib xmobar xmonad-utils feh picom ttf-fira-mono

# Switch user now 
su arctesian

# Plug
sudo pacman -S neovim
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Xmonad stuff
mkdir ~/.xmonad
git clone https://github.com/TheArctesian/DotFiles.git
cp -r ~/DotFiles/xmobar ~/.config 
cp ~/DotFiles/xmonad/xmonad.hs ~/.config 
cp -r ~/DotFiles/Wallpaper ~/ 
# feh --bg-fill ~/Wallpaper/1080/whatever you want.png
cp ~/DotFiles/Xmonad/xmonad.hs ~/.xmonad 

systemctl enable sddm.service
systemctl enable NetworkManager.service
