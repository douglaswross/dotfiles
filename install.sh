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

# ===== Install specgofer extension =====
echo "📦 Installing specgofer extension..."

REPO="eai-tools/specgofer"
VSIX_DIR="/tmp"
PERSISTED_VSIX_DIR="/workspaces/.codespaces/.persistedshare/extensions"

# Check for persisted vsix first
PERSISTED_VSIX=$(ls -t "$PERSISTED_VSIX_DIR"/specgofer*.vsix 2>/dev/null | head -1)
if [ -n "$PERSISTED_VSIX" ] && [ -f "$PERSISTED_VSIX" ]; then
    echo "  🔧 Installing from persisted extension..."
    code --install-extension "$PERSISTED_VSIX" --force 2>/dev/null || true
    echo "  ✅ specgofer installed from cache"
else
    # Try downloading
    download_vsix() {
        if [ -n "$SPECGOFER_TOKEN" ]; then
            GH_TOKEN="$SPECGOFER_TOKEN" gh release download --repo "$REPO" --pattern "*.vsix" --dir "$VSIX_DIR" --clobber 2>/dev/null && return 0
        fi
        if command -v gh &> /dev/null; then
            gh release download --repo "$REPO" --pattern "*.vsix" --dir "$VSIX_DIR" --clobber 2>/dev/null && return 0
            (unset GITHUB_TOKEN; gh release download --repo "$REPO" --pattern "*.vsix" --dir "$VSIX_DIR" --clobber 2>/dev/null) && return 0
        fi
        return 1
    }

    if download_vsix; then
        VSIX_FILE=$(ls -t "$VSIX_DIR"/specgofer*.vsix 2>/dev/null | head -1)
        if [ -n "$VSIX_FILE" ] && [ -f "$VSIX_FILE" ]; then
            code --install-extension "$VSIX_FILE" --force 2>/dev/null || true
            # Persist for future rebuilds
            mkdir -p "$PERSISTED_VSIX_DIR"
            cp "$VSIX_FILE" "$PERSISTED_VSIX_DIR/" 2>/dev/null || true
            echo "  ✅ specgofer installed and cached"
        fi
    else
        echo "  ⚠️  specgofer: Set SPECGOFER_TOKEN secret or run 'gh auth login'"
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
