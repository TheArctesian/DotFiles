timedatectl set-ntp true
fdisk /dev/nvme0n1

# File System
mkfs.fat -F 32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

# Sync sys time
ntpd -q -g 
# Pacman Repo Setup
pacman -Syy
pacman -S reflector
reflector -c "HK" -f 12 -l 10 -n 12 --save /etc/pacman.d/mirrorlist

# Mount 
mkdir /mnt/boot
mount /dev/nvme0n1p3 /mnt
mount /dev/nvme01np1 /mnt/boot
swapon /dev/nvme0n1p2

# Make Arch System
pacstrap /mnt base linux linux-firmware vim base-devel

# Gen fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Change root
arch-chroot /mnt

# Set Hardware Clock 
ln -sf /usr/share/zoneinfo/Asia/Hong_Kong /etc/localtime
hwclock --systohc

# Locale
vim /etc/locale.gen
locale-gen

# Hostname
vim /etc/hostname 
#set hostname
# the 
# or arctesian or daniel

# Hosts 
vim /etc/hosts
# 127.0.0.1 localhost
# ::1 localhost
# 127.0.1.1 the

# Set root password 
passwd

# Bootloader (Grub) TODO: Try pure pure sysd boot of lillo 
pacman -S grub efibootmgr

# Make boot efi dir
mkdir /boot/efi
mount /dev/nvme0n1p1 /boot/efi

# Grub install
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg

# Make User
useradd -m -G users,wheel,audio -s /bin/bash arctesian
passwd arctesian

# Sudo cuz yay dosnt support doas 
pacman -S sudo vi
visudo
# uncoment the wheel group 
# or directly add the user
# arctesian ALL=(ALL) ALL

# or 
pacman -S doas 
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
