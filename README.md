# Douglas Ross's Dotfiles

Personal configuration files for GitHub Codespaces. Automatically installed in every new Codespace.

## What's Included

| File | Purpose |
|------|---------|
| `.bashrc` | Shell configuration, prompt, environment |
| `.bash_aliases` | Git, npm, docker aliases + utility functions |
| `.gitconfig` | Git identity, aliases, colors |
| `.vimrc` | Vim configuration |
| `install.sh` | Auto-runs to set everything up |

## Quick Aliases

```bash
# Git
gs    # git status
gp    # git push
gcm   # git commit -m
gaa   # git add -A

# npm
dev   # npm run dev
nrd   # npm run dev
nrb   # npm run build

# Utility
ll    # ls -alF
ports # show listening ports
mkcd  # mkdir + cd
```

## Setup

1. This repo is automatically cloned when you create a Codespace
2. `install.sh` runs and symlinks configs to your home directory
3. Open a new terminal to apply changes

## Customizing

Edit files here, changes will apply to all future Codespaces.

To test changes in current session:
```bash
source ~/.bashrc
```
