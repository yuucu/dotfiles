# 🏠 dotfiles

Modern dotfiles configuration managed with [chezmoi](https://www.chezmoi.io/), centered around Neovim and optimized for macOS/Linux development environments.

## ⚡ Quick Start

Clone and apply in one command:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply yuucu/dotfiles
```

## 🔧 Environment Variables Management

This dotfiles repository separates public configuration from sensitive information for security.

### Option 1: ~/.zshrc.local (Recommended)

1. Run the setup script:
   ```bash
   ./scripts/setup-env.sh
   ```

2. Edit `~/.zshrc.local` with your actual tokens:
   ```bash
   # Add your real API tokens and passwords
   export ZENPAY_REPO_PAT="ghp_your_real_token"
   export NPM_AUTH_TOKEN="npm_your_real_token"
   
   # Database aliases with real passwords
   alias common="mysql -h hostname -u user -pYourPassword"
   ```

3. The file is automatically loaded by zshrc and ignored by git.

### Option 2: Encrypted chezmoi Management

For maximum security, use chezmoi's age encryption:

```bash
# Add encrypted environment file
chezmoi add --encrypt ~/.env

# Edit encrypted file
chezmoi edit ~/.env
```

### Option 3: Project-specific .env with direnv

For project-specific environment variables:

```bash
# Install direnv (already included in dotfiles)
brew install direnv

# Create .env in your project
cp ~/.env.template .env
# Edit .env with project-specific values

# direnv will automatically load/unload variables
```

### Security Best Practices

- ✅ **Never commit** `.env`, `.zshrc.local`, or any file with real secrets
- ✅ **Use different tokens** for development and production  
- ✅ **Rotate API tokens** regularly
- ✅ **Store secrets** in a password manager
- ✅ **Use environment-specific** configurations

## 🌟 Features

- **🚀 One-liner installation** with immediate usability
- **🔐 Secure secret management** with multiple options
- **🎯 Neovim-centered** development environment
- **🎨 Beautiful UI** with Starship prompt
- **🔧 Developer tools** integration (Git, Docker, Cloud tools)
- **🔄 Cross-platform** support (macOS/Linux)
- **📦 Package management** with Homebrew/apt
- **🎛️ Plugin management** with lazy.nvim and Zinit

## 📁 Structure

```
dotfiles/
├── README.md              # You are here
├── LICENSE                # MIT License
├── .chezmoi.yaml          # chezmoi configuration
├── .chezmoiignore         # Files to exclude from management
├── scripts/
│   ├── bootstrap.sh       # Initial setup script
│   └── setup-env.sh       # Environment variables setup
├── dot_config/
│   └── nvim/              # Neovim configuration (Lua + lazy.nvim)
│       ├── init.lua
│       └── lua/
└── private/               # Encrypted files (age)
```

## 🛠️ Dependencies

- **chezmoi** ≥ 2.50 (package manager for dotfiles)
- **age** (encryption tool for secrets)
- **git** (version control)
- **neovim** ≥ 0.10 (text editor)
- **fzf** (fuzzy finder)
- **starship** (shell prompt)

All dependencies are automatically installed via the bootstrap script.

## 📋 Included Configurations

### Shell & Terminal
- **Zsh** with Zinit plugin manager
- **Starship** prompt with Git integration
- **Alacritty** terminal emulator
- **tmux** terminal multiplexer

### Development Tools
- **Neovim** with Lua configuration and 50+ plugins
- **Git** with aliases and enhanced workflow
- **LazyGit** TUI for Git operations
- **mise** (runtime version manager)
- **direnv** (environment variable manager)

### Productivity
- **fzf** for fuzzy searching everywhere
- **eza** (better ls with Git integration)
- **bat** (syntax-highlighted cat)
- **ripgrep** (faster grep)
- **zoxide** (smarter cd command)

## 🚀 Usage

After installation, you'll have access to:

### Quick Navigation
```bash
fgh          # Browse and cd to any git repository
z <partial>  # Jump to frequently used directories
..           # cd ..
...          # cd ../..
```

### Git Workflow
```bash
g            # git
gs           # git status
ga           # git add
gc           # git commit
gp           # git push
lg           # lazygit TUI
```

### Development
```bash
v filename   # Open in Neovim
work-git     # Switch to work Git identity  
personal-git # Switch to personal Git identity
```

## 🔄 Updates

```bash
# Update dotfiles
chezmoi update

# Update Neovim plugins
nvim --headless "+Lazy! sync" +qa
```

## 🤝 Contributing

1. Fork this repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [chezmoi](https://www.chezmoi.io/) for excellent dotfiles management
- [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management
- [Starship](https://starship.rs/) for the beautiful prompt
- All the amazing open-source tools that make development a joy

---

**✨ Happy coding!** If you found this helpful, please give it a ⭐
