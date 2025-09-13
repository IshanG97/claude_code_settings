# .files 
(but also, a little bit more)

Stuff might be broken, don't hate the player, hate the game.
Shout out to [Tom Cassar](https://github.com/tcassar/dotfiles) for the configs.

## .config files
Copy to `~`
- Homebrew
- Ghostty
- tmux
- tmux plugin manager (press <leader> once installed)
- neovim (don't use brew mirror, it's old)
- starship (prompt)
- a nerd font
- Karabiner (to remap keys)
- Rectangle - import via Rectangle > Settings > Import

## Claude code setup for Python, JavaScript, and C# dev
### 🚀 Quick start
```bash
git clone <repository-url> claude_code_settings
cd claude_code_settings

# Install global settings
./setup-global.sh

# Setup for a Python project
./setup.sh ~/code/my-python-project python

# Setup for a JavaScript/TypeScript project  
./setup.sh ~/code/my-react-app javascript

# Setup for a C#/.NET WinForms project
./setup.sh ~/code/my-dotnet-api csharp
```

### File structure post setup
```
/repo/
├── CLAUDE.md              # Language-specific guidelines
└── .claude/
    └── settings.json      # Generic repo settings
```

