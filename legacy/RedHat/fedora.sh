# chmod +x ubuntu.sh 
# System update
sudo dnf update -y
sudo dnf upgrade -y 
sudo dnf install neofetch -y
# Install packages

sudo dnf install curl -y
sudo dnf install git -y
sudo dnf install vim -y

# Creative
sudo dnf install gimp -y
sudo dnf install blender -y

# Development
sudo dnf install build-essential -y
sudo snap install bpytop -y 
sudo dnf install dnf-plugins-core -y

# npm
sudo dnf install nodejs -y

# rust
sudo dnf install rustc -y
sudo dnf install cargo -y

# fish 
sudo dnf install fish -y

# git 

git config --global user.email "stephen.d.okita@gmail.com"
git config --global user.name "theArctesian"
git config --global credential.helper store #shut up i like it

#checks 
sudo dnf upgrade --refresh -y
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
neofetch

