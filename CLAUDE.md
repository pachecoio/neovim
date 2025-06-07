# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Plugin Management
- **Update plugins**: `:Lazy update` - Updates all plugins to their latest versions
- **Check plugin status**: `:Lazy` - Opens the Lazy plugin manager UI
- **Sync plugin lock file**: `:Lazy restore` - Restores plugins to versions in lazy-lock.json

### Development Commands
- **Format current buffer**: `<leader>f` or `:Format`
- **Run tests**:
  - `<leader>tt` - Run test at cursor position
  - `<leader>tf` - Run all tests in current file
  - `<leader>ts` - Run entire test suite
  - `<leader>to` - Show test output panel
- **Git pre-commit check**: `<leader>gv` - Runs pre-commit verification
- **Check Neovim health**: `:checkhealth` - Verify all dependencies and configurations

### Language Server Commands
- **Install LSP servers**: `:Mason` - Opens Mason UI to install/manage language servers
- **LSP diagnostics**: `<leader>q` - Open diagnostics list
- **Code actions**: `<leader>ca` - Show available code actions at cursor

## Architecture

This is a modular Neovim configuration based on kickstart.nvim that uses lazy.nvim for plugin management. Key architectural decisions:

1. **Plugin Organization**: All custom plugins are in `lua/custom/plugins/` as separate modules, making it easy to add, remove, or modify functionality without affecting the core configuration.

2. **Dual-Mode Support**: The configuration detects VSCode-Neovim and loads a minimal configuration (`lua/vscode-config.lua`) when running inside VSCode, preventing conflicts and improving performance.

3. **Lazy Loading**: Plugins are loaded on-demand based on events (BufRead, LspAttach, etc.) to optimize startup time. The lazy.nvim plugin manager handles this automatically based on plugin specifications.

4. **Test Framework Integration**: Neotest is configured with adapters for multiple languages (Python, Go, Jest, Rust, Elixir, Deno). Test commands are mapped under `<leader>t*` for consistency.

5. **Git Workflow**: Extensive git integration through vim-fugitive with custom keymaps under `<leader>g*`. LazyGit is available as a floating terminal for complex operations.

6. **AI Integration**: Multiple AI assistants are integrated:
   - GitHub Copilot for inline suggestions
   - Claude Code (`claude-code.nvim`) for AI-powered editing
   - Commented configurations for Avante.nvim and MCPHub

7. **Leader Key Pattern**: Space is the leader key with mnemonic mappings:
   - `s` for search operations
   - `g` for git operations  
   - `t` for test operations
   - `c` for code/LSP operations
   - `h` for harpoon navigation

The configuration prioritizes developer experience with consistent keybindings, comprehensive language support through LSP, and modern development tools while maintaining good performance through lazy loading.
