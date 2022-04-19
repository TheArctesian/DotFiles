timedatectl set-ntp true
fdisk /dev/nvme0n1

# File System
mkfs.fat -F 32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

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
vim /etc/hostname #set hostname

# Hosts 
vim /etc/hosts
# 127.0.0.1 localhost
# ::1 localhost
# 127.0.1.1 the

# Set Pass 
passwd

# Grub
pacman -S grub efibootmgr

# Make Root Dir
mkdir /boot/efi
mount /dev/nvme0n1p1 /boot/efi
grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/boot/efi
grub-mkconfig -o /boot/grub/grub.cfg



