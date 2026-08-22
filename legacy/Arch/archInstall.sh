#!/bin/bash



echo "-------------------"
echo "| Welcome to arch |"
echo "-------------------"


# Vars 
fdisk -l >> devices

sudo pacman -S --noconfirm --needed base-devel wget git


# choose video driver
echo "1) xf86-video-intel 	2) xf86-video-amdgpu 3) nvidia 4) Skip"
read -r -p "Choose you video card driver(default 1)(will not re-install): " vid

case $vid in 
[1])
	DRIV='xf86-video-intel'
	;;

[2])
	DRIV='xf86-video-amdgpu'
	;;

[3])
    DRIV='nvidia nvidia-settings nvidia-utils'
    ;;

[4])
	DRIV=""
	;;
[*])
	DRIV='xf86-video-intel'
	;;
esac

sudo pacman -S --noconfirm --needed rofi feh xorg xorg-xinit xorg-xinput $DRIV xmonad