# chmod +x ubuntu.sh 
# System update
sudo apt update -y
sudo apt upgrade -ybefore 
sudo apt install snapd
sudo apt install neofetch -y
sudo apt install gnome-tweaks
# Install packages


sudo apt install curl -y
sudo apt install exfat-utils -y
sudo apt install file -y
sudo apt install git -y
sudo apt install vim -y
sudo snap install keepassxc
# Creative
sudo apt install gimp -y
sudo snap install blender -y

# Development
sudo snap install code --classic -y
sudo apt install build-essential -y
sudo apt install python3 -y
sudo apt install python3-pip -y
sudo snap install bpytop 
sudo snap install cointop
sudo snap install tmux
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # Rust

# Java (ew)
sudo apt install default-jdk
sudo apt update
sudo apt install default-jre
sudo add-apt-repository ppa:webupd8team/java

# RW
sudo snap install onlyoffice-desktopeditors
sudo snap install brave

# Socail 
sudo snap install signal-desktop
sudo snap install discord

# Fun stuff
sudo apt install figlet -y
sudo apt install lolcat -y


# npm
sudo apt install nodejs -y
sudo npm install -g sass sass-lint -y
sudo npm install -g typescript -y
sudo npm install -g prettier -y
sudo npm install -g yarn -y
sudo npm install -g truffle -y

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo apt install rustc 
sudo apt install cargo 

# fish 
sudo apt install fish -y
sudo apt install fonts-firacode -y
sudo apt install fonts-hack-ttf -y
curl -L https://get.oh-my.fish | fish
chsh -s `which fish`
fish
omf install aight
# Make dir 
cd
cd desktop
mkdir scripts
mkdir work
mkdir school
cd school 
git clone https://github.com/TheArctesian/SchoolFiles.git
git config --global user.email "stephen.d.okita@gmail.com"
git config --global user.name "theArctesian"
git config --global credential.helper store #shut up i like it
sudo apt-get upgrade && sudo apt-get upgrade

#checks 
java -version 
npm -v 
python --version
