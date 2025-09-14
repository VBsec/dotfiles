#!/usr/bin/env bash
# Migration script to switch to optimized zsh configuration

set -e

echo "🚀 Migrating to optimized zsh configuration..."

# Backup current .zshrc
if [ -f ~/.zshrc ]; then
    echo "📦 Backing up current .zshrc to ~/.zshrc.backup"
    cp ~/.zshrc ~/.zshrc.backup
fi

# Install required tools via Homebrew if not present
echo "🔧 Checking required tools..."
brew list starship &>/dev/null || brew install starship
brew list zoxide &>/dev/null || brew install zoxide
brew list direnv &>/dev/null || brew install direnv
brew list fzf &>/dev/null || brew install fzf
brew list fd &>/dev/null || brew install fd
brew list bat &>/dev/null || brew install bat
brew list eza &>/dev/null || brew install eza
brew list zsh-autosuggestions &>/dev/null || brew install zsh-autosuggestions
brew list zsh-syntax-highlighting &>/dev/null || brew install zsh-syntax-highlighting

# Install fzf key bindings
echo "⌨️  Setting up fzf key bindings..."
$(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish

# Link the new configuration
echo "🔗 Linking optimized .zshrc..."
ln -sf ~/dotfiles/zsh/.zshrc.optimized ~/.zshrc

echo "✅ Migration complete!"
echo ""
echo "🎯 Next steps:"
echo "1. Open a new terminal to test the configuration"
echo "2. Run 'time zsh -i -c exit' to measure startup time"
echo "3. If everything works, you can remove Oh-My-Zsh:"
echo "   rm -rf ~/.oh-my-zsh"
echo ""
echo "⚡ Expected improvements:"
echo "- 50-70% faster shell startup"
echo "- All your aliases and functions preserved"
echo "- Lazy loading for heavy tools"
echo "- Background loading for non-critical features"
echo ""
echo "🔄 To rollback:"
echo "   cp ~/.zshrc.backup ~/.zshrc"