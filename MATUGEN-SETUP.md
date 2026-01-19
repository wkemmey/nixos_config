# Matugen Theme Switching

This setup allows you to change color schemes without a NixOS rebuild using Matugen.

## How It Works

1. **Templates** in `~/.config/matugen/templates/` define how colors map to app configs
2. **Matugen** reads a wallpaper or predefined scheme and generates colors
3. **Generated files** are written to `~/.config/*/themes/matugen`
4. **Your main configs** include these generated theme files
5. **Apps reload** automatically to apply new colors

## Usage

### From a Wallpaper
```bash
theme-switch ~/wallpapers/my-image.png
```

### From a Color
```bash
# Use a hex color as the base
theme-switch --color "#cba6f7"  # Catppuccin Mocha mauve
theme-switch --color "#7aa2f7"  # Tokyo Night blue
```

## Supported Apps

Currently configured:
- **Foot** - Terminal colors
- **Fuzzel** - Launcher colors  
- **Niri** - Border and focus ring colors
- **Cava** - Visualizer colors (template needs creation)

## Adding More Apps

1. Create a template in `dotfiles/.config/matugen/templates/<app>.ext`
2. Use Matugen variables like `{{ colors.primary.default.hex }}`
3. Add template config to `dotfiles/.config/matugen/config.toml`
4. Update app config to include the generated file
5. Add reload command to `theme-switch.nix` if needed

## Available Color Variables

See [Matugen docs](https://github.com/InioX/matugen) for full list. Common ones:
- `{{ colors.primary.default.hex }}` - Primary theme color
- `{{ colors.surface.default.hex }}` - Background color
- `{{ colors.on_surface.default.hex }}` - Text color on background
- `{{ colors.secondary.default.hex }}` - Secondary accent
- `{{ colors.tertiary.default.hex }}` - Tertiary accent
- `{{ colors.error.default.hex }}` - Error color

## Current Setup Status

- [ ] Replace Noctalia theme includes with Matugen includes
- [ ] Create Cava template
- [ ] Test theme switching
- [ ] Add more apps (VSCode, yazi, etc.)
