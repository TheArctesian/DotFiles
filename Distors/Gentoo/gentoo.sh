fdisk -l 
fdisk /dev/nvme0n1

# Format Disks
mkfs.fat -F 32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3
swapon /dev/sda2


# Mount the system 
mount /dev/nvme0n1p3 /mnt/gentoo
cd /mnt/gentoo
links gentoo.org/downloads
tar xpvf stage3-*.tar.xz --xattrs-include='*.*' --numeric-owner

# Config portage
vi /mnt/gentoo/etc/portage/make.conf
# add -march=native
MAKEOPTS="-jx"
USE="X elogind -kde -smth"
ACCEPT_LICENSE="*"

mirrorselect -i -o >> /mnt/gentoo/etc/portage/make.conf

mkdir --parents /mnt/gentoo/etc/portage/repos.conf

cp /mnt/gentoo/usr/share/portage/config/repos.conf /mnt/gentoo/etc/portage/repos.conf/gentoo.conf

cp --dereference /etc/resolv.conf /mnt/gentoo/etc/

mount --types proc /proc /mnt/gentoo/proc
mount --rbind /sys /mnt/gentoo/sys
mount --make-rslave /mnt/gentoo/sys
mount --rbind /dev /mnt/gentoo/dev
mount --make-rslave /mnt/gentoo/dev
mount --bind /run /mnt/gentoo/run
mount --make-slave /mnt/gentoo/run

chroot /mnt/gentoo /bin/bash
source /etc/profile
export PS1="(choo choo) ${PS1}"

mount /dev/nvme0n1p1 /boot

emerge-webrsync

emerge --sync -q 

eselect profile list

eselect profile set x

emerge --ask --verbose --update --deep --newuse @world

echo "Asia/Hong_Kong" > /etc/timezone

emerge --config sys-libs/timezone-data

vim /etc/locale.gen

# add the right things 
locale-gen

eselect locale list

eselect locale set x

env-update && source /etc/profile && export PS1="(choo choo) ${PS1}"

emerge --ask sys-kernel/linux-firmware

emerge --ask sys-kernel/gentoo-sources

eselect kernel list

eselect kernel set 1

emerge --ask sys-apps/pciutils

emerge --ask sys-kernel/installkernel-gentoo

emerge --ask sys-kernel/gentoo-kernel

emerge --depclean

emerge --ask @module-rebuild

vim /etc/fstab

vim /etc/conf.d/hostname

vim /etc/conf.d/net

emerge --ask net-misc/dhcpcd

rc-update add dhcpcd default
rc-service dhcpcd start

emerge --ask --noreplace net-misc/netifrc

vim /etc/hosts

emerge --ask sys-apps/pcmciautils

passwd

emerge --ask app-admin/sysklogd

rc-update add sysklogd default

emerge --ask sys-process/cronie

rc-update add cronie default

emerge --ask sys-apps/mlocate

rc-update add sshd default

emerge --ask net-misc/chrony

rc-update add chronyd default

emerge --ask net-misc/dhcpcd

emerge --ask net-wireless/iw net-wireless/wpa_supplicant

echo 'GRUB_PLATFORMS="efi-64"' >> /etc/portage/make.conf

emerge --ask sys-boot/grub

grub-install /dev/nvme0n1p1

grub-install --target=x86_64-efi --efi-directory=/boot

grub-mkconfig -o /boot/grub/grub.cfg

exit

cd 

umount -l /mnt/gentoo/dev{/shm,/pts,}
umount -R /mnt/gentoo

# now reboot
