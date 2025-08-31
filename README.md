# Cross-Platform Dotfiles

Modern dotfiles configuration that works on both macOS and Linux with automatic OS detection and installation.

## Features

- **Cross-platform**: Works on macOS and Linux
- **Automatic installation**: One script handles everything
- **Modern tools**: Uses zinit, fzf, eza, neovim
- **Terminal**: iTerm2 themes included, works with any terminal

## Quick Installation

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles
cd ~/dotfiles

# For zsh (development machines)
./install.sh

# For bash (servers/VPS)
./install.sh bash
```

## Manual Installation with Stow

If you prefer to install manually or selectively:

```bash
# Install packages first (see Platform-Specific sections)
# Then stow the packages you want:
cd ~/dotfiles

# Essential packages (always install these)
stow shared      # Common aliases and functions
stow vim         # Vim configuration  
stow nvim        # Neovim configuration
stow tmux        # Tmux configuration

# Choose your shell:
stow zsh         # Rich zsh setup (development)
# OR
stow bash        # Lightweight bash setup (servers)

# macOS only:
stow karabiner   # Key remapping
```

## Manual Git Configuration

After installation, configure git with your details:
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## What's Included

### Shell Options
- **Zsh**: Rich configuration with zinit, powerlevel10k theme, plugins
- **Bash**: Lightweight server-friendly configuration
- **Shared**: Common aliases, functions, and environment variables

### Development Tools
- **Git**: Enhanced with lazygit TUI (`lg` alias)
- **AI Assistant**: opencode for AI-powered coding (`oc` alias)
- **Editors**: Neovim with LazyVim configuration
- **Terminal**: tmux with modern configuration

### Editor (Neovim)
- LazyVim configuration
- Minimal, fast setup
- Works on both platforms

### Terminal Multiplexer (tmux)
- Modern tmux configuration
- Vi-mode key bindings

### Terminal Themes
- Catppuccin and Gruvbox color schemes
- iTerm2 color profiles included

## Platform-Specific Features

### macOS
- Karabiner Elements configuration (Caps Lock → Ctrl/Escape)
- Hyper key setup (Ctrl → ⌃⌥⇧⌘)
- Homebrew package management

### Linux
- APT/YUM package management

## Manual Setup (if needed)

If you prefer to set things up manually or the install script doesn't work:

### Install Stow
```bash
# macOS
brew install stow

# Linux (Ubuntu/Debian)
sudo apt install stow
```

### Stow Packages
```bash
cd ~/dotfiles

# Essential for both shells
stow shared vim nvim tmux

# Choose shell
stow zsh    # Development machines
stow bash   # Servers/VPS

# macOS only
stow karabiner
```

## Shell-Specific Usage

### For Development (zsh)
Rich shell with plugins, themes, and advanced features:
```bash
./install.sh        # Installs zsh by default
```

### For Servers (bash)
Lightweight, fast, universally compatible:
```bash
./install.sh bash   # Server-optimized bash setup
```

Both shells share common aliases, functions, and environment variables while maintaining their unique strengths.

## Notes
- Clone to ~/notes: `make notes` (optional)
- Hyper key on macOS = Ctrl mapped to all modifiers (⌃⌥⇧⌘)
- Caps Lock → Ctrl when held, Escape when tapped alone (macOS only)