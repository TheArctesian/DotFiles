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
            sudo apt install -y neovim git curl unzip nodejs npm python3 python3-pip python3-venv pipx ripgrep fd-find
            ;;
        "dnf")
            sudo dnf update
            sudo dnf install -y neovim git curl unzip nodejs npm python3 python3-pip python3-virtualenv pipx ripgrep fd-find
            ;;
        "pacman")
            sudo pacman -Syu
            sudo pacman -S neovim git curl unzip nodejs npm python python-pip python-virtualenv python-pipx ripgrep fd
            ;;
        *)
            echo "Unsupported package manager. Please install dependencies manually."
            exit 1
            ;;
    esac
}

# Install language servers and formatters
install_language_servers() {
    local PM=$(get_package_manager)
    
    # Ensure pipx is in PATH
    export PATH="$PATH:$HOME/.local/bin"
    
    # Python tools installation using pipx
    echo "Installing Python language servers and formatters..."
    pipx install pyright
    pipx install black

    # JavaScript/TypeScript
    echo "Installing JavaScript/TypeScript language servers and formatters..."
    sudo npm install -g prettier typescript typescript-language-server

    # Lua
    echo "Installing Lua formatter..."
    if ! command -v stylua &> /dev/null; then
        if ! command -v cargo &> /dev/null; then
            case $PM in
                "apt")
                    sudo apt install -y cargo
                    ;;
                "dnf")
                    sudo dnf install -y cargo
                    ;;
                "pacman")
                    sudo pacman -S rust
                    ;;
            esac
        fi
        cargo install stylua
    fi
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