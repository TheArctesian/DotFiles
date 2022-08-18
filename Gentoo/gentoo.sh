# set up wifi
net-setup eth0

# or just test
ping -c 3 gentoo.org

# check the disks
fdisk -l 
# or
lsblk

# fmt the drive replace sda with main boot drive
fdisk /dev/sda

# Format Disks
mkfs.fat -F 32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

# Mount the system 
mount /dev/nvme0n1p3 /mnt/gentoo
cd /mnt/gentoo
ntpd -q -g # sync system time
links gentoo.org/downloads
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

# Config portage
vi /mnt/gentoo/etc/portage/make.conf
COMMON_FLAGS="-march=native -02 -pipe"
MAKEOPTS="-jx"
USE="X elogind profile -kde -smth"
ACCEPT_LICENSE="*"
INPUT_DEVICES="libinput synaptics"
## (For NVIDIA cards)
VIDEO_CARDS="nouveau"
VIDEO_CARDS="nvidia"
## (For AMD/ATI cards)
VIDEO_CARDS="radeon amdgpu"

# Config mirrors
mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

# Config Repos 
mkdir --parents /mnt/gentoo/etc/portage/repos.conf
cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

# Mount system 
mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run

# Choroot to /mnt/gentoo 
chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(choo choo) ${PS1}"

# Mount boot system partition
mount /dev/nvme0n1p1 /boot

# Update Portage 
emerge-webrsync 
emerge --sync -q 

# Select profile
eselect profile list
eselect profile set x

# Emerge worldset 
emerge --ask --verbose --update --deep --newuse @world

# Set timezone 
echo "Asia/Hong_Kong" > /etc/timezone 

# Set locale
emerge --config sys-libs/timezone-data
vim /etc/locale.gen
locale-gen
eselect locale list
eselect locale set x

# Rechroot
env-update && source /etc/profile && export PS1="(choo choo) ${PS1}"

# Kernel Time
emerge --ask sys-kernel/linux-firmware
emerge --ask sys-kernel/gentoo-sources
eselect kernel list
eselect kernel set 1
emerge --ask sys-apps/pciutils
emerge --ask sys-kernel/installkernel-gentoo
emerge --ask sys-kernel/gentoo-kernel
emerge --depclean
emerge --ask @module-rebuild

# Fstab 
vim /etc/fstab

# Hostname
vim /etc/conf.d/hostname

# Network
vim /etc/conf.d/net
emerge --ask net-misc/dhcpcd
rc-update add dhcpcd default
rc-service dhcpcd start
emerge --ask --noreplace net-misc/netifrc
vim /etc/hosts
# 127.0.0.1 localhost
# ::1 localhost
# 127.0.1.1 the
emerge --ask sys-apps/pcmciautils

# Su password
passwd

# Syslog
emerge --ask app-admin/sysklogd
rc-update add sysklogd default

# Task 
emerge --ask sys-process/cronie
rc-update add cronie default

# Fast grep
emerge --ask sys-apps/mlocate

# Ssh
rc-update add sshd default

# Time
emerge --ask net-misc/chrony
rc-update add chronyd default

# Wireless 
emerge --ask net-wireless/iw net-wireless/wpa_supplicant

# Grub
echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf
emerge --ask sys-boot/grub
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

# User
useradd -m -G users,wheel,audio -s /bin/bash arctesian
passwd arctesian
emerge -aq app-admin/doas
vim /etc/doas
permit :wheel

# GUI
emerge --ask x11-base/xorg-server
emerge --pretend --verbose x11-base/xorg-drivers

# KDE 
eselect profile set default/linux/amd64/17.1/desktop/plasma
emerge -aq plasma-meta plasma-desktop
env-update && source /etc/profile
rc-update add elogind boot
rc-service elogind start
emerge --ask --noreplace gui-libs/display-manager-init
vim /etc/conf.d/display-manager
   DISPLAYMANAGER="ssdm"

# Gnome 
eselect profile set default/linux/amd64/17.1/desktop/gnome
emerge --ask gnome-base/gnome-light
env-update && source /etc/profile
rc-update add elogind boot
rc-service elogind start
emerge --ask --noreplace gui-libs/display-manager-init
vim /etc/conf.d/display-manager
   DISPLAYMANAGER="gdm"

# TODO: DWM 


# Display Manager
rc-update add display-manager default
emerge -aq xterm dwm st git alacritty

exit

cd 

umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo

# now reboot
