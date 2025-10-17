#!/bin/bash

set -e
shopt -s globstar

# Set git hooks path
git config core.hooksPath hooks

# Make everything executable
chmod +x ./hooks/**/*
chmod +x ./scripts/**/*

# Ask for setup
cat <<EOF
The current setup (if there is any) will be renamed to:
"nvim-bak"

And be kept inside .config directory, so no configuration will be lost.

Setup Neovim? (y/n)
EOF

read setup
if [[ "$setup" =~ ^[nN]([oO])?$ ]]; then
  exit 0
fi

PATH_NVIM="$HOME/.config/nvim"

# Backup existing config
if [ -d "$PATH_NVIM" ]; then
  mv "$PATH_NVIM" "$HOME/.config/nvim-bak/"
fi

# Copy new config
mkdir -p "$PATH_NVIM"
cp -r ./init.lua ./lazy-lock.json ./scripts ./lua "$PATH_NVIM/"

# Ask about clearing cache
read -p "Should Neovim cache and storage be erased (.cache and .local)? (y/n): " erase
if [[ "$erase" =~ ^[nN]([oO])?$ ]]; then
  exit 0
fi

rm -rf "$HOME/.local/share/nvim/"
rm -rf "$HOME/.cache/nvim/"

echo "Neovim setup complete."

