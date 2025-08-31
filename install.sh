#!/bin/bash

# Cross-platform dotfiles installer
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    else
        echo "unknown"
    fi
}

# Install packages based on OS
install_packages() {
    local os=$(detect_os)
    
    case $os in
        "macos")
            log_info "Installing macOS packages via Homebrew..."
            if ! command -v brew &> /dev/null; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            brew bundle --file=packages/Brewfile.macos
            ;;
        "linux")
            log_info "Installing Linux packages..."
            if command -v apt &> /dev/null; then
                sudo apt update
                sudo apt install -y $(cat packages/packages.linux | grep -v '^#' | tr '\n' ' ')
                
                # Install additional tools not in standard repos
                install_linux_extras
            elif command -v yum &> /dev/null; then
                sudo yum install -y $(cat packages/packages.linux | grep -v '^#' | tr '\n' ' ')
                install_linux_extras
            else
                log_error "Package manager not supported. Please install packages manually."
                exit 1
            fi
            ;;
        *)
            log_error "Unsupported operating system: $OSTYPE"
            exit 1
            ;;
    esac
}

# Install additional Linux tools not available in standard repos
install_linux_extras() {
    log_info "Installing additional tools..."
    
    # Install eza (modern ls replacement)
    if ! command -v eza &> /dev/null; then
        log_info "Installing eza..."
        # Add eza repository
        sudo mkdir -p /etc/apt/keyrings
        wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
        echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
        sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
        sudo apt update
        sudo apt install -y eza
    fi
    
    # Install lazygit
    if ! command -v lazygit &> /dev/null; then
        log_info "Installing lazygit..."
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
        rm lazygit lazygit.tar.gz
    fi
}

# Create symlinks
create_symlinks() {
    local os=$(detect_os)
    local shell_choice=${1:-"zsh"}  # Default to zsh, but allow override
    
    log_info "Creating symlinks with stow..."
    
    # Ensure we're in the dotfiles directory
    cd ~/dotfiles
    
    # Always stow shared configs and common packages
    stow shared
    stow vim
    stow nvim
    stow tmux
    
    # Stow shell-specific package
    if [[ $shell_choice == "bash" ]]; then
        log_info "Setting up bash configuration..."
        stow bash
    else
        log_info "Setting up zsh configuration..."
        stow zsh
    fi
    
    # OS-specific packages
    if [[ $os == "macos" ]]; then
        log_info "Stowing macOS-specific packages..."
        stow karabiner
    fi
}

# Setup shell
setup_shell() {
    local shell_choice=${1:-"zsh"}  # Default to zsh
    
    if [[ $shell_choice == "bash" ]]; then
        log_info "Bash configuration installed. No shell change needed."
        log_info "Reload your terminal or run: source ~/.bashrc"
    else
        log_info "Setting up zsh..."
        
        # Change default shell to zsh if not already
        if [[ $SHELL != *"zsh"* ]]; then
            chsh -s $(which zsh)
            log_info "Changed default shell to zsh. Please restart your terminal."
        fi
    fi
}

# Post-install configuration
post_install() {
    local os=$(detect_os)
    local shell_choice=${1:-"zsh"}
    
    if [[ $os == "macos" ]]; then
        log_info "Restarting Karabiner..."
        launchctl kickstart -k gui/$(id -u)/org.pqrs.karabiner.karabiner_console_user_server
    fi
    
    # Install opencode on Linux (not available via package manager)
    if [[ $os == "linux" ]]; then
        if ! command -v opencode &> /dev/null; then
            log_info "Installing opencode..."
            curl -fsSL https://opencode.ai/install.sh | bash
        fi
    fi
    
    if [[ $shell_choice == "zsh" ]]; then
        log_info "Installing zinit (zsh plugin manager)..."
        ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
        [ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
        [ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
    fi
}

# Main installation function
main() {
    local shell_choice=${1:-"zsh"}  # Allow shell choice as first argument
    
    log_info "Starting dotfiles installation for $(detect_os) with $shell_choice shell..."
    
    # Check if we're in the right directory
    if [[ ! -f "install.sh" ]]; then
        log_error "Please run this script from the dotfiles directory"
        log_error "Expected location: ~/dotfiles"
        exit 1
    fi
    
    install_packages
    create_symlinks "$shell_choice"
    setup_shell "$shell_choice"
    post_install "$shell_choice"
    
    log_info "Installation complete! Please restart your terminal."
    if [[ $shell_choice == "zsh" ]]; then
        log_warn "Note: You may need to configure git user settings manually:"
        echo "  git config --global user.name \"Your Name\""
        echo "  git config --global user.email \"your.email@example.com\""
    fi
}

# Run main function
main "$@"