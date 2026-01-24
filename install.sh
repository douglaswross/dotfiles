#!/bin/bash
# Douglas Ross's Dotfiles Installer
# This runs automatically when a new Codespace is created

set -e
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Installing dotfiles..."

# Symlink dotfiles to home directory
link_file() {
    local src="$DOTFILES_DIR/$1"
    local dst="$HOME/$2"

    if [ -f "$src" ]; then
        if [ -L "$dst" ]; then
            rm "$dst"
        elif [ -f "$dst" ]; then
            mv "$dst" "$dst.backup"
            echo "  📦 Backed up existing $dst"
        fi
        ln -sf "$src" "$dst"
        echo "  ✅ Linked $2"
    fi
}

# Link config files
link_file ".bashrc" ".bashrc"
link_file ".bash_aliases" ".bash_aliases"
link_file ".gitconfig" ".gitconfig"
link_file ".vimrc" ".vimrc"

# Create .config directory structure
mkdir -p "$HOME/.config"

# Install additional tools (optional - uncomment what you want)
install_tools() {
    echo "📦 Installing additional tools..."

    # fzf - fuzzy finder (Ctrl+R for history, Ctrl+T for files)
    if ! command -v fzf &> /dev/null; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 2>/dev/null || true
        ~/.fzf/install --all --no-update-rc 2>/dev/null || true
        echo "  ✅ fzf installed"
    fi

    # bat - better cat with syntax highlighting (aliased to 'cat')
    # Uncomment if you want it:
    # sudo apt-get install -y bat 2>/dev/null || true

    # ripgrep - faster grep (aliased to 'rg')
    # Uncomment if you want it:
    # sudo apt-get install -y ripgrep 2>/dev/null || true
}

# Uncomment to install extra tools:
# install_tools

# Source the new bashrc
echo ""
echo "✨ Dotfiles installed! Run 'source ~/.bashrc' or open a new terminal."
echo ""
