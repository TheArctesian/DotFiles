#!/bin/bash

# Function to detect the package manager
get_package_manager() {
    if command -v apt &> /dev/null; then
        echo "apt"
    elif command -v dnf &> /dev/null; then
        echo "dnf"
    elif command -v pacman &> /dev/null; then
        echo "pacman"
    else
        echo "unknown"
    fi
}

# Function to install packages based on the package manager
install_packages() {
    local PM=$(get_package_manager)
    
    case $PM in
        "apt")
            sudo apt update
            sudo apt install -y neovim git curl unzip nodejs npm python3 python3-pip ripgrep fd-find
            ;;
        "dnf")
            sudo dnf update
            sudo dnf install -y neovim git curl unzip nodejs npm python3 python3-pip ripgrep fd-find
            ;;
        "pacman")
            sudo pacman -Syu
            sudo pacman -S neovim git curl unzip nodejs npm python3 python-pip ripgrep fd
            ;;
        *)
            echo "Unsupported package manager. Please install dependencies manually."
            exit 1
            ;;
    esac
}

# Install language servers and formatters
install_language_servers() {
    # Python
    pip3 install pyright black

    # JavaScript/TypeScript
    sudo npm install -g prettier typescript typescript-language-server

    # Lua
    cargo install stylua || {
        # If cargo is not installed, install it first
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
        source $HOME/.cargo/env
        cargo install stylua
    }
}

# Install Packer (Neovim package manager)
install_packer() {
    PACKER_PATH="${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/packer/start/packer.nvim
    if [ ! -d "$PACKER_PATH" ]; then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim \
            "$PACKER_PATH"
    fi
}

# Main installation process
echo "Installing system packages..."
install_packages

echo "Installing language servers and formatters..."
install_language_servers

echo "Installing Packer..."
install_packer

echo "Installation complete! Please run :PackerSync in Neovim to install the plugins."

# Create necessary directories
mkdir -p ~/.config/nvim

echo "Remember to copy your init.lua to ~/.config/nvim/"