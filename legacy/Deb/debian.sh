# System update
sudo apt update -y
sudo apt upgrade -y 
sudo apt install neofetch -y

# Install packages
sudo apt install curl -y
sudo apt install git -y
sudo apt install nala -y

# Terminal tools
sudo apt install btop -y
sudo apt install neovim -y

# Development
sudo apt install build-essential -y
sudo apt install python3 -y
sudo apt install python3-pip -y

# Java (ew)
sudo apt install default-jdk -y
sudo apt update -y

# Fun stuff
sudo apt install figlet -y
sudo apt install lolcat -y

# npm
sudo apt install nodejs -y
sudo npm i -g typescript -y
sudo npm i -g yarn -y

# rust
sudo apt install rustc -y
sudo apt install cargo -y

# Terminal enhancements
sudo apt install fish -y
sudo apt install alacritty -y
sudo apt install fonts-firacode -y
sudo apt install fonts-hack-ttf -y

# Applications - using apt where possible
sudo apt install libreoffice -y
sudo apt install code -y  # VSCode

# Applications requiring external repositories
# Brave browser
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update -y
sudo apt install brave-browser -y

# Obsidian - download and install deb file
wget https://github.com/obsidianmd/obsidian-releases/releases/download/v1.5.3/obsidian_1.5.3_amd64.deb
sudo apt install ./obsidian_1.5.3_amd64.deb -y
rm obsidian_1.5.3_amd64.deb

# Zotero - download and extract
wget -q https://www.zotero.org/download/client/dl?channel=release&platform=linux-x86_64 -O zotero.tar.bz2
sudo tar -xjf zotero.tar.bz2 -C /opt/
sudo ln -s /opt/Zotero_linux-x86_64/zotero /usr/local/bin/zotero
rm zotero.tar.bz2

# Slack - using snap as an alternative
sudo apt install snapd -y
sudo snap install slack --classic

# Final system update
sudo apt update -y && sudo apt upgrade -y

# Clean up
sudo apt autoremove -y
sudo apt autoclean -y
