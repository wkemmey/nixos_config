# Black Don OS

A modular, flake-based NixOS configuration system built on ZaneyOS with home-manager integration and hardware-profile-based deployments.

## Quick Start

### Installation

Run the interactive installer on a fresh NixOS system:

```bash
./install.sh
```

The installer will:
- Detect your hardware and suggest an appropriate GPU profile
- Prompt for hostname, username, timezone, and keyboard layout
- Generate hardware configuration
- Create host-specific configuration files
- Build and activate your system

### Building & Deploying

After installation, use these Fish abbreviations to manage your system:

```bash
nxr      # Rebuild and switch to new configuration
nxu      # Update flake inputs
nxg      # Full garbage collection (clean old generations)
nxcd     # Navigate to nixos_config directory
```

Or use the standard NixOS commands:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

## Post-Installation Setup

After installing a new system, you'll need to complete these steps:

### 1. GitHub Authentication

Your Git configuration uses GitHub CLI for authentication. Set it up once:

```bash
gh auth login
```

Follow the prompts to authenticate with GitHub. Choose:
- **Account:** GitHub.com
- **Protocol:** HTTPS
- **Authentication method:** Login with a web browser (recommended)

This stores your credentials securely and Git will use them automatically for all GitHub operations (push, pull, clone).

To verify authentication:

```bash
gh auth status
git config --list | grep credential
```

### 2. Configure Display Outputs (Niri)

Edit your host-specific output configuration at `modules/home/niri/hosts/<hostname>/outputs.nix`:

```nix
{ host, ... }:
''
  output "eDP-1" {
    mode "1920x1080@60.000"
    scale 1.0
    position x=0 y=0
  }

  output "HDMI-A-1" {
    mode "2560x1440@144.000"
    scale 1.0
    position x=1920 y=0
  }
''
```

Find your output names with:

```bash
niri msg outputs
```

### 3. Update Git Configuration

Edit `hosts/<hostname>/variables.nix` to set your actual Git email:

```nix
gitEmail = "your.email@example.com";
```

### 4. Customize Variables

Review and update other settings in `hosts/<hostname>/variables.nix`:
- Enable optional features (gaming support, communication apps, etc.)
- Set your preferred browser and terminal
- Configure startup applications
- Change wallpaper path

After making changes, rebuild with `nxr`.

### 5. SSH Keys (Optional)

If you need SSH access to remote systems or for Git over SSH:

```bash
ssh-keygen -t ed25519 -C "your.email@example.com"
cat ~/.ssh/id_ed25519.pub  # Copy this to GitHub/GitLab/etc.
```

### 6. Syncthing (Optional)

If you enabled `syncthingEnable = true` in variables.nix, access the web UI at:

```
http://localhost:8384
```

Configure folders and devices through the web interface.

## Architecture

### Three-Tier Structure

1. **Profiles** (`profiles/{amd,intel,nvidia,nvidia-laptop,vm}/`)
   - Hardware-specific entry points
   - Import host configuration and driver modules
   - Enable appropriate GPU drivers

2. **Hosts** (`hosts/{hostname}/`)
   - `variables.nix` - All user preferences and feature flags
   - `default.nix` - Host system configuration
   - `hardware.nix` - Generated hardware configuration
   - `host-packages.nix` - Host-specific packages

3. **Modules**
   - `modules/core/` - NixOS system modules
   - `modules/home/` - Home-manager user configurations
   - `modules/drivers/` - Hardware driver modules

### Configuration Flow

```
flake.nix → profile → host → core modules + drivers → home-manager modules
```

## Customization

### Adding Packages

**System-wide packages:** Edit `modules/core/packages.nix` or `hosts/<hostname>/host-packages.nix`

**User packages:** Add to `home.packages` in the relevant `modules/home/` file

### Keybinds

**Niri keybinds:**
- Global: `modules/home/niri/keybinds.nix`
- Host-specific: `modules/home/niri/hosts/<hostname>/keybinds.nix`

### Theming

Edit the base16 color scheme in `modules/core/stylix.nix` to customize colors across all applications.

### Adding New Hosts

1. Create `hosts/<hostname>/` directory with required files
2. Add to `flake.nix` using the `mkHost` helper:

```nix
newhostname = mkHost {
  hostname = "newhostname";
  profile = "amd";  # or nvidia, intel, nvidia-laptop, vm
  username = "yourusername";
};
```

3. Rebuild and switch

## Useful Commands

```bash
# System management
nxr                           # Rebuild system
nxu                           # Update flake inputs
nxg                           # Garbage collect old generations
sudo nixos-rebuild boot       # Set config for next boot

# Git operations (using Fish abbreviations)
gc "message"                  # Commit all changes
gp                            # Push to origin
gpl                           # Pull from origin
gs                            # Git status

# Niri compositor
niri msg outputs              # List displays
niri validate                 # Validate config
niri msg version              # Check Niri version

# View generations
nix-env --list-generations    # User generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system  # System
```

## Troubleshooting

### Config won't build

Check for syntax errors:

```bash
nix flake check
```

### Niri config errors

Validate the generated KDL config:

```bash
niri validate
```

Note: KDL uses `//` for comments, not `#`.

### Rollback to previous generation

Boot into a previous generation from the bootloader, or:

```bash
sudo nixos-rebuild switch --rollback
```

### GitHub authentication not working

Re-authenticate with GitHub CLI:

```bash
gh auth logout
gh auth login
```

Verify your Git credential configuration:

```bash
git config --list | grep credential
```

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Niri Documentation](https://github.com/YaLTeR/niri)
- [Stylix Documentation](https://github.com/danth/stylix)
