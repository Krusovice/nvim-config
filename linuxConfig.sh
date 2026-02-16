#!/bin/bash

# linuxConfig.sh - Basic development tools

set -e  # Exit on error

echo "Installing basic packages..."
sudo apt update
sudo apt install -y \
    neovim \
    git \
    fzf \
    ripgrep

echo "Setup complete!"
