# Whit's NixOS Config

A modular, flake-based NixOS configuration system with home-manager integration and hardware-profile-based deployments.

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

### 4. Install VS Code Extensions (Manual)

Some VS Code extensions aren't available in nixpkgs and must be installed through the VS Code UI:

1. Open VS Code (Ctrl+Shift+X to open Extensions panel)
2. Search for and install:
   - **SpecStory** - Automatically logs GitHub Copilot chat history (save, export, search conversations)

Extensions installed via the UI are stored in `~/.vscode/extensions/` and coexist with Nix-managed extensions.

### 5. Customize Variables

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

If you enabled `enableSyncthing = true` in variables.nix, access the web UI at:

```
http://localhost:8384
```

Configure folders and devices through the web interface.

### 7. Printing and Scanning

If you enabled `enablePrint = true` in variables.nix:

**Web Interface (CUPS):**
1. Open browser to `http://localhost:631`
2. Click "Administration" → "Add Printer"
3. Select your network printer from the discovered list
4. Follow the wizard (drivers auto-configure)

**Command Line:**
```bash
# List discovered printers
lpinfo -v

# Add printer
lpadmin -p PrinterName -v <printer-uri> -E

# Print a test page
lp -d PrinterName /path/to/file.pdf

# List all printers
lpstat -p -d
```

**Scanning:**
```bash
# List available scanners
scanimage -L

# Scan to file
scanimage --format=png > scan.png

# Or use Simple Scan GUI
simple-scan
```

### 8. AI Code Editors (Optional)

If you enabled `enableAiCodeEditors = true` in variables.nix, you have access to:

**Claude Code** - Graphical AI IDE with chat interface

**Aider** - Terminal-based agentic AI coding assistant

**Gemini CLI** - Terminal AI assistant

**Setting up API keys:**

For **Aider** (uses Claude by default):
```bash
# Get your API key from https://console.anthropic.com/
# Set it permanently in Fish
set -Ux ANTHROPIC_API_KEY "your-anthropic-key-here"

# Or for OpenAI GPT models
set -Ux OPENAI_API_KEY "your-openai-key-here"

# Or for Google Gemini
set -Ux GEMINI_API_KEY "your-gemini-key-here"
```

For **Gemini CLI** (optional - falls back to web login without key):
```bash
# Copy template and add your key
cp ~/nixos_config/dotfiles/gem.key.template ~/gem.key
# Edit ~/gem.key and replace YOUR_API_KEY_HERE
chmod 600 ~/gem.key
```

**Using Aider:**
```bash
cd your-project
aider src/main.rs src/lib.rs
# Chat with AI to make code changes
```

See `dotfiles/AIDER_SETUP.md` for comprehensive Aider documentation.

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

## Containers (Docker)

This system includes Docker for running containers. 

### Basic Docker Usage

```bash
# Run a container
docker run hello-world
docker run -it ubuntu bash          # Interactive Ubuntu container
docker run -d -p 8080:80 nginx      # Run nginx in background, expose port 8080

# List containers
docker ps                            # Running containers
docker ps -a                         # All containers (including stopped)

# Manage containers
docker stop <container-id>           # Stop a running container
docker start <container-id>          # Start a stopped container
docker rm <container-id>             # Remove a container

# Images
docker images                        # List downloaded images
docker pull <image-name>             # Download an image
docker rmi <image-name>              # Remove an image

# Logs and debugging
docker logs <container-id>           # View container logs
docker exec -it <container-id> bash  # Open shell in running container
```

### Docker Management with lazydocker

For a better experience, use `lazydocker` (a terminal UI for Docker):

```bash
lazydocker
```

Navigate with arrow keys, press `x` to see available actions, `q` to quit.

## Virtual Machines

This system includes KVM/QEMU with virt-manager for full virtualization.

### Quick Start

1. **Download an OS ISO** and place it in `/var/lib/libvirt/isos/`

```bash
# Create directory if needed (should already exist)
sudo mkdir -p /var/lib/libvirt/isos

# Download an ISO (example: Ubuntu)
cd /var/lib/libvirt/isos
sudo wget https://releases.ubuntu.com/22.04/ubuntu-22.04.3-desktop-amd64.iso
```

2. **Launch virt-manager:**

```bash
virt-manager
# Or use keybind: Ctrl+Mod+V
```

3. **Create a new VM:**
   - Click "Create a new virtual machine"
   - Choose "Local install media (ISO image)"
   - Browse to `/var/lib/libvirt/isos/` and select your ISO
   - Set memory (4096 MB recommended) and CPUs (2-4 recommended)
   - Create disk (20-40 GB recommended, format is qcow2 by default)
   - Name your VM and click "Finish"

### VM Storage Locations

- **ISO files:** `/var/lib/libvirt/isos/` - Put OS installation ISOs here
- **VM disk images:** `/var/lib/libvirt/images/` - VM disk files stored here (qcow2 format)

### Useful VM Commands

```bash
# List all VMs
virsh list --all

# Start/stop VMs from command line
virsh start <vm-name>
virsh shutdown <vm-name>
virsh destroy <vm-name>      # Force power off

# Autostart VM on boot
virsh autostart <vm-name>
virsh autostart --disable <vm-name>

# VM information
virsh dominfo <vm-name>
virt-top                     # htop for VMs
```

### Features Enabled

Your VM setup includes:
- **Hardware acceleration (KVM)** - VMs run at near-native speed
- **SPICE** - Better graphics, clipboard sharing, USB redirection
- **UEFI support** - Can install modern OSes like Windows 11
- **TPM emulation** - Required for Windows 11
- **3D acceleration** - Basic 3D graphics support in VMs
- **Snapshots** - Disk format (qcow2) supports VM snapshots

### Tips

- **Performance:** VMs use host CPU passthrough for best performance
- **Display:** Resize virt-manager window and the VM display will auto-resize
- **USB devices:** Can be passed through to VMs via virt-manager device menu
- **Networking:** VMs automatically get internet through NAT (virbr0 bridge)
- **Windows drivers:** virtio-win package included for Windows guest optimization

## Resources

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Niri Documentation](https://github.com/YaLTeR/niri)
- [Docker Documentation](https://docs.docker.com/)
- [libvirt Documentation](https://libvirt.org/)

## Credits & Thanks

This configuration is based on the excellent work of:

- **ZaneyOS** by Zaney - [GitHub](https://github.com/Zaney1/ZaneyOS)
  - Original flake-based NixOS configuration system that pioneered many of the modular patterns used here

- **Black Don's NixOS Config** by Black Don - [GitHub](https://github.com/BlackDon/nixos-config)
  - Built upon ZaneyOS with additional refinements and features

This configuration continues that evolution with further customizations and adaptations to my workflow. Thank you to both authors for their foundational work!
