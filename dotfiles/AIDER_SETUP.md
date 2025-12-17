# Aider Setup Guide

Aider is a terminal-based AI coding assistant that can autonomously edit multiple files, run tests, and commit changes.

## Quick Start

1. **Set up API key** (choose one provider):

   ```bash
   # For Claude (recommended for coding)
   export ANTHROPIC_API_KEY="your-key-here"
   
   # Or for OpenAI
   export OPENAI_API_KEY="your-key-here"
   
   # Or for Gemini (you may already have this from gemini-cli)
   export GEMINI_API_KEY="your-key-here"
   ```

   Add to `~/.config/fish/config.fish` to make permanent (use `set -Ux` for universal variable).

2. **Copy config template**:

   ```bash
   cp ~/nixos_config/dotfiles/.aider.conf.yml.template ~/.aider.conf.yml
   ```

3. **Start using Aider**:

   ```bash
   # Navigate to your project
   cd ~/my-project
   
   # Start aider with specific files
   aider src/main.rs src/lib.rs
   
   # Or let aider auto-detect important files
   aider
   ```

## Common Usage Patterns

### Basic Coding
```bash
aider src/main.rs
# Then chat: "Add error handling for file operations"
```

### Multi-file Refactoring
```bash
aider src/**/*.rs
# Then chat: "Refactor the database module to use async/await"
```

### With Git Integration
```bash
aider --auto-commits src/
# Aider will automatically commit changes with good messages
```

### Architecture Mode (for planning)
```bash
aider --architect
# Discuss changes without making them yet
# Then switch to --code mode to implement
```

## Key Commands (in Aider chat)

- `/add <file>` - Add file to chat context
- `/drop <file>` - Remove file from context  
- `/diff` - Show pending changes
- `/undo` - Undo last change
- `/commit` - Manually commit changes
- `/run <cmd>` - Run a shell command
- `/help` - Show all commands
- `/quit` - Exit aider

## Best Practices

1. **Start with specific files**: Don't add your entire codebase at once
2. **Use git**: Aider works best with git repos
3. **Review changes**: Check diffs before accepting
4. **Iterative requests**: Break complex tasks into steps
5. **Use /architect first**: Plan big changes before implementing

## API Keys & Cost

**Claude Sonnet 3.5** (recommended):
- Best for coding tasks
- ~$3 per 1M input tokens, $15 per 1M output tokens
- Get key: https://console.anthropic.com/

**GPT-4**:
- Good alternative
- ~$30 per 1M tokens
- Get key: https://platform.openai.com/

**Gemini**:
- Most affordable
- Free tier available
- Get key: https://aistudio.google.com/apikey

## Troubleshooting

**No API key found:**
- Make sure environment variable is exported
- Check spelling: `ANTHROPIC_API_KEY` not `CLAUDE_API_KEY`

**Files not being edited:**
- Add files explicitly with `/add <file>`
- Check file permissions
- Ensure you're in a git repo

**Model too slow:**
- Try a faster model: `aider --model gemini/gemini-2.0-flash-exp`
- Or use gpt-3.5-turbo for simple tasks

## Integration with Your Workflow

Since you use Helix + Niri + terminal-focused setup:

1. Open Helix in one terminal
2. Run Aider in another terminal/tmux pane
3. Ask Aider to make changes
4. See changes live in Helix (it auto-reloads)
5. Review, test, and iterate

Or use Niri keybinds to quickly open Aider:
- Could add to `config.kdl`: `Mod+A { spawn "foot" "aider"; }`

## More Info

- Docs: https://aider.chat/docs/
- GitHub: https://github.com/paul-gauthier/aider
