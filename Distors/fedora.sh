# chmod +x ubuntu.sh 
# System update
sudo dnf update -y
sudo dnf upgrade -y 
sudo dnf install snapd -y
sudo dnf install neofetch -y
sudo dnf install gnome-tweaks -y
# Install packages


sudo dnf install curl -y
sudo dnf install exfat-utils -y
sudo dnf install file -y
sudo dnf install git -y
sudo dnf install vim -y
sudo snap install core
sudo snap install keepassxc
# Creative
sudo dnf install gimp -y
sudo snap install blender -y

# Development
sudo snap install code --classic
sudo dnf install build-essential -y
sudo dnf install python3 -y
sudo dnf install python3-pip -y
sudo snap install bpytop 
sudo snap install cointop
sudo snap install tmux
sudo snap install postman
sudo dnf install dnf-plugins-core -y

# Java (ew)
sudo dnf install default-jdk -y
sudo dnf update -y
sudo dnf install default-jre -y

# RW
sudo snap install onlyoffice-desktopeditors
sudo snap install brave
sudo snap install spotify


# Socail 
sudo snap install signal-desktop
sudo snap install discord

# Fun stuff
sudo dnf install figlet -y
sudo dnf install lolcat -y

# npm
sudo dnf install nodejs -y
sudo npm install -g sass sass-lint -y
sudo npm install -g typescript -y
sudo npm install -g prettier -y
sudo npm install -g yarn -y
sudo npm install -g truffle -y


# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo dnf install rustc -y
sudo dnf install cargo -y


# fish 
sudo dnf install fish -y
sudo dnf install fonts-firacode -y
sudo dnf install fonts-hack-ttf -y
curl -L https://get.oh-my.fish | fish
chsh -s /usr/bin/fish
omf install slavic-cat

# git 

git config --global user.email "stephen.d.okita@gmail.com"
git config --global user.name "theArctesian"
git config --global credential.helper store #shut up i like it


#checks 
sudo dnf upgrade --refresh -y
java -version 
npm -v 
python --version
