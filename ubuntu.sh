
# System update
sudo apt update -y
sudo apt upgrade -y
sudo apt install snapd

# Install packages


sudo apt install curl
sudo apt install exfat-utils
sudo apt install file
sudo apt install git
sudo apt install bpytop
sudo apt install cointop
sudo apt install tmux
sudo apt install vim

# Creative
sudo apt install gimp
sudo snap install blender

# Development
sudo snap install code --classic
sudo apt install build-essential
sudo apt install python3
sudo apt install python3-pip
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh # Rust

# RW
sudo snap install onlyoffice-desktopeditors

# Socail 
sudo snap install signal-desktop
sudo snap install discord

# Fun stuff
sudo apt install figlet
sudo apt install lolcat


# npm
sudo apt install nodejs
sudo npm install -g sass sass-lint
sudo npm install -g typescript
sudo npm install -g prettier
sudo npm install -g yarn
sudo npm install -g truffle

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo apt install rustc
sudo apt install cargo


# fish 
sudo apt install fish
sudo apt install fonts-firacode
sudo apt install fonts-hack-ttf
curl -L https://get.oh-my.fish | fish
chsh -s `which fish`

# Make dir 
cd desktop
mkdir -p ~/Desktop/{scripts, school, work}
cd school 
git clone https://github.com/TheArctesian/SchoolFiles.git