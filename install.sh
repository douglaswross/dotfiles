#!/bin/bash
# Douglas Ross's Dotfiles Installer
# Runs automatically when a new Codespace is created

set -e
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🚀 Installing Douglas's dotfiles..."

# ===== Symlink dotfiles =====
link_file() {
    local src="$DOTFILES_DIR/$1"
    local dst="$HOME/$2"

    if [ -f "$src" ]; then
        if [ -L "$dst" ]; then
            rm "$dst"
        elif [ -f "$dst" ]; then
            mv "$dst" "$dst.backup"
        fi
        ln -sf "$src" "$dst"
        echo "  ✅ Linked $2"
    fi
}

link_file ".bashrc" ".bashrc"
link_file ".bash_aliases" ".bash_aliases"
link_file ".gitconfig" ".gitconfig"
link_file ".vimrc" ".vimrc"

# ===== Install uv (Python package manager) =====
echo "🐍 Installing uv..."
if ! command -v uvx &> /dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
    echo "  ✅ uv installed"
else
    echo "  ✅ uv already installed"
fi

# ===== Install Claude Code CLI =====
echo "🤖 Installing Claude Code CLI..."
if ! command -v claude &> /dev/null; then
    npm install -g @anthropic-ai/claude-code 2>/dev/null || sudo npm install -g @anthropic-ai/claude-code
    echo "  ✅ Claude Code CLI installed"
else
    echo "  ✅ Claude Code CLI already installed"
fi

# ===== Credential Persistence =====
# These helpers persist credentials across Codespace rebuilds

# GitHub CLI credentials
GH_PERSIST_DIR="/workspaces/.codespaces/.persistedshare/.config/gh"
GH_HOME_DIR="$HOME/.config/gh"
if [ -d "$GH_PERSIST_DIR" ] && [ -f "$GH_PERSIST_DIR/hosts.yml" ]; then
    echo "🔐 Restoring GitHub CLI credentials..."
    mkdir -p "$HOME/.config"
    rm -rf "$GH_HOME_DIR"
    ln -sf "$GH_PERSIST_DIR" "$GH_HOME_DIR"
    echo "  ✅ gh credentials restored"
fi

# Claude credentials
CLAUDE_PERSIST_DIR="/workspaces/.codespaces/.persistedshare/.claude"
CLAUDE_HOME_DIR="$HOME/.claude"
if [ -d "$CLAUDE_PERSIST_DIR" ]; then
    echo "🔐 Restoring Claude Code credentials..."
    rm -rf "$CLAUDE_HOME_DIR"
    ln -sf "$CLAUDE_PERSIST_DIR" "$CLAUDE_HOME_DIR"
    if [ -f "/workspaces/.codespaces/.persistedshare/.claude.json" ]; then
        ln -sf "/workspaces/.codespaces/.persistedshare/.claude.json" "$HOME/.claude.json"
    fi
    echo "  ✅ Claude credentials restored"
fi

# ===== Install gofer extension =====
echo "📦 Installing gofer extension..."

GOFER_RELEASES_URL="https://eai-tools.github.io/gofer/releases.json"
GOFER_BASE_URL="https://eai-tools.github.io/gofer/releases"
GOFER_VSIX_DIR="/tmp"
GOFER_PERSISTED_DIR="/workspaces/.codespaces/.persistedshare/extensions"

# Check for persisted vsix first
GOFER_PERSISTED_VSIX=$(ls -t "$GOFER_PERSISTED_DIR"/gofer-*.vsix 2>/dev/null | head -1)
if [ -n "$GOFER_PERSISTED_VSIX" ] && [ -f "$GOFER_PERSISTED_VSIX" ]; then
    echo "  🔧 Installing from persisted extension..."
    code --install-extension "$GOFER_PERSISTED_VSIX" --force 2>/dev/null || true
    echo "  ✅ gofer installed from cache"
else
    # Get latest version from releases.json and download
    GOFER_LATEST=$(curl -sL "$GOFER_RELEASES_URL" | grep -o '"tag_name":"[^"]*"' | head -1 | sed 's/"tag_name":"v\?\([^"]*\)"/\1/')
    if [ -z "$GOFER_LATEST" ]; then
        # Fallback: try to extract version differently
        GOFER_LATEST=$(curl -sL "$GOFER_RELEASES_URL" | python3 -c "import sys,json; releases=json.load(sys.stdin); print(releases[0]['tag_name'].lstrip('v') if releases else '')" 2>/dev/null)
    fi

    if [ -n "$GOFER_LATEST" ]; then
        GOFER_VSIX_NAME="gofer-${GOFER_LATEST}.vsix"
        GOFER_DOWNLOAD_URL="${GOFER_BASE_URL}/${GOFER_VSIX_NAME}"

        echo "  📥 Downloading gofer v${GOFER_LATEST}..."
        if curl -sL -o "${GOFER_VSIX_DIR}/${GOFER_VSIX_NAME}" "$GOFER_DOWNLOAD_URL"; then
            code --install-extension "${GOFER_VSIX_DIR}/${GOFER_VSIX_NAME}" --force 2>/dev/null || true
            # Persist for future rebuilds
            mkdir -p "$GOFER_PERSISTED_DIR"
            cp "${GOFER_VSIX_DIR}/${GOFER_VSIX_NAME}" "$GOFER_PERSISTED_DIR/" 2>/dev/null || true
            echo "  ✅ gofer v${GOFER_LATEST} installed and cached"
        else
            echo "  ⚠️  Failed to download gofer extension"
        fi
    else
        echo "  ⚠️  Could not determine latest gofer version"
    fi
fi

# ===== Install fzf (fuzzy finder) =====
if ! command -v fzf &> /dev/null; then
    echo "🔍 Installing fzf..."
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf 2>/dev/null || true
    ~/.fzf/install --all --no-update-rc 2>/dev/null || true
    echo "  ✅ fzf installed"
fi

echo ""
echo "✨ Dotfiles installed! Open a new terminal to apply changes."
echo ""
