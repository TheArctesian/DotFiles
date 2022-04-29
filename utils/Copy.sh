# Make config 
mkdir ~/.config

cp -r ~/Dotfiles/Wallpaper ~/
mkdir ~/.xmonad
mkdir ~/.xmonad/lib
cp ~/Dotfiles/Xmonad/ xmonad.hs ~/.xmonad

cp -r ~/Dotfiles/Xmonad/Lib ~/.xmonad/Lib
cp -r ~/Dotfiles/xmobar ~/.config/

cp -r ~/Dotfiles/nvim ~/.config

cp -r ~/Dotfiles/bin ~/.local

cp ~/Dotfiles/utils/Git/lgit /bin/
