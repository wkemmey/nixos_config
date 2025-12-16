# Whit's NixOS Config - AI Agent Instructions

This is a flake-based NixOS configuration system with modular architecture, home-manager integration, and hardware-profile-based deployments.

## Architecture Overview

**Three-tier structure:**
1. **Profiles** (`profiles/{amd,intel,nvidia,nvidia-laptop,vm}/`) - Hardware-specific entry points that import host + drivers
2. **Hosts** (`hosts/{hostname}/`) - Per-machine settings via `variables.nix`, plus `default.nix` and `hardware.nix`
3. **Modules** - Reusable configuration units:
   - `modules/core/` - NixOS system modules
   - `modules/home/` - Home-manager user configs
   - `modules/drivers/` - Hardware driver modules with `mkEnableOption` toggles

**Key flow:** `flake.nix` → profile → host → core modules + drivers → home-manager modules

## Critical Developer Workflows

### Building & Deploying
- **Standard rebuild:** `sudo nixos-rebuild switch --flake .#<hostname>` (or `nh os switch` if NH is configured)
- **Fish abbreviations** (see `modules/home/fish/default.nix`):
  - `nxr` - Rebuild and switch system configuration
  - `nxu` - Update flake inputs
  - `nxg` - Full garbage collection (user + system)
  - `nxcd` - cd to nixos_config directory
- **NH tool configured:** `modules/core/nh.nix` sets up `nh` with auto-cleanup (7d retention, keep 5 gens)

### Adding New Hosts
1. Create `hosts/<hostname>/` with `default.nix`, `hardware.nix`, `variables.nix`, `host-packages.nix`
2. Add to `flake.nix` nixosConfigurations using `mkHost` helper
3. Reference existing hosts (e.g., `hosts/whit2020/`) as templates
4. Use `install.sh` for interactive setup (prompts for hostname, username, profile)

### Configuration Customization
**All user preferences live in `hosts/<hostname>/variables.nix`:**
- Feature flags: `enableGamingSupport`, `enableSyncthing`, `enableCommunicationApps`, etc.
- User info: `userFullName`
- Apps: `defaultBrowser`, `defaultTerminal`, `defaultShell`, `startupApps`

**To add new features:** Check if module already exists in `modules/core/`. If it uses variables, import from host: `let inherit (import ../../hosts/${host}/variables.nix) featureFlagName;`

## Project-Specific Conventions

### Module Patterns
- **Driver modules** use `lib.mkEnableOption` with `cfg.enable` pattern (see `modules/drivers/amd-drivers.nix`)
- **Core modules** often use conditional imports via variables.nix flags with `lib.mkIf` (see `modules/core/gaming-support.nix`)
- **Home modules** in `modules/home/default.nix` are always imported; conditional logic lives inside module files

### Home Manager Integration
- User config is in `modules/core/user.nix` which imports home-manager as NixOS module
- Home configs are at `modules/home/`, imported as `imports = [ ./../home ];`
- Shell is explicitly set to Fish (`shell = pkgs.fish;`) with system-wide enable for completions

### Niri Compositor Setup
- Primary window manager, configured in `modules/home/niri/`
- Settings split across `niri.nix`, `keybinds.nix`, `layout.nix`, `startup.nix`, `windowrules.nix`
- Host-specific overrides: `modules/home/niri/hosts/<hostname>/keybinds.nix` (optional, falls back to defaults)
- Uses variables from `hosts/<hostname>/variables.nix` for terminal, browser, wallpaper

### Theming
- Theming is managed through Noctalia shell configuration
- Wallpapers are stored in `/wallpapers/` directory
- Noctalia settings in `dotfiles/.config/noctalia-shell/settings.json`

### Custom Scripts
- Defined in `modules/home/scripts/` as Nix expressions returning derivations
- Use `pkgs.writeShellScriptBin` pattern (see `dcli.nix`, `screenshootin.nix`)
- All scripts assembled in `modules/home/scripts/default.nix` and added to `home.packages`

## Important Files

- `flake.nix` - Inputs (nixpkgs, home-manager, nvf, noctalia) and host definitions via `mkHost`
- `install.sh` - Interactive installer (generates hardware-config, creates host files)
- `modules/core/user.nix` - User creation + home-manager integration point
- `modules/home/default.nix` - Home-manager module index
- `modules/core/nh.nix` - NH helper tool configuration for easier rebuilds

## Testing & Validation
- **No formal test suite** - validation is through `nixos-rebuild` build success
- **Build without activation:** `dcli build <hostname>` or `nixos-rebuild build --flake .#<hostname>`
- **Check syntax:** Nix will error on parse failures during build
- **Rollback:** NixOS generations in bootloader; `sudo nixos-rebuild switch --rollback`

## Common Tasks

**Add system package:** Edit `modules/core/packages.nix` or host-specific `hosts/<hostname>/host-packages.nix`

**Add user package:** Add to `home.packages` in relevant `modules/home/` file

**Change shell:** Update `defaultShell` in `hosts/<hostname>/variables.nix` (options: "fish", "bash")

**Add keybind:** Edit `modules/home/niri/keybinds.nix` or create host override in `modules/home/niri/hosts/<hostname>/keybinds.nix`

**Modify theme:** Edit Noctalia settings in `dotfiles/.config/noctalia-shell/settings.json`
