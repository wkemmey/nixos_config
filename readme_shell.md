# Shell & TUI Tools Reference

A comprehensive list of command-line and terminal user interface (TUI) tools installed on this system.

---

## Shell Environment

**Fish Shell** - Modern shell with intelligent autosuggestions and syntax highlighting
- Primary shell for interactive use
- Plugin support: fzf-fish, autopair, done, sponge

**Starship** - Fast, customizable shell prompt
- Minimal design with contextual information
- Shows git status, directory, nix-shell indicator

**Zoxide** - Smart directory jumper
- Learns your most-used directories
- Jump to frequently accessed paths with `z`

---

## Terminal Emulators

**Foot** - Lightweight Wayland terminal
- Fast, minimal resource usage
- Native Wayland support

---

## File Management

**Yazi** - Modern terminal file manager
- Fast, asynchronous file operations
- Image preview support
- Vim-style keybindings

**Eza** - Modern replacement for `ls`
- Colorized output with icons
- Git integration showing file status
- Tree view support

---

## Text Processing & Search

**Bat** - Cat clone with syntax highlighting
- Syntax highlighting for 200+ languages
- Git integration showing line changes
- Automatic paging

**Ripgrep** - Fast recursive search tool
- Blazingly fast grep alternative
- Respects .gitignore by default
- Multi-threaded searching

**FZF** - Fuzzy finder for command-line
- Interactive filtering for files, history, processes
- Integrates with shell, vim, and other tools
- Fast and responsive even with large datasets
- **Key bindings:**
  - `Ctrl+R` - Search command history
  - `Ctrl+T` - Search files and insert path
  - `Alt+C` - Search directories and cd
- **Usage examples:**
  - `vim $(fzf)` - Select a file to open
  - `cd $(find . -type d | fzf)` - Select directory to cd into
  - Works with any command that accepts file paths
- **Inside FZF:**
  - Type to fuzzy search (no exact match needed)
  - `Ctrl+J/K` or arrows to navigate
  - `Enter` to select, `Esc` to cancel
  - `Tab` for multi-select

---

## System Monitoring

**Btop** - Resource monitor with beautiful UI
- CPU, memory, disk, network monitoring
- Process management
- Mouse support

**Bottom** - Cross-platform system monitor
- Fast, customizable resource viewer
- Process viewer and manager
- Configurable layouts

**Htop** - Interactive process viewer
- Classic process management tool
- Tree view of processes
- Sortable columns

---

## Disk Usage Analysis

**Ncdu** - NCurses disk usage analyzer
- Interactive disk usage viewer
- Fast scanning of directories
- Delete files directly from the interface

**Duf** - Modern disk usage/free utility
- Prettier alternative to `df`
- Colored output with usage bars
- JSON export support

**Dysk** - Minimal disk usage tool
- Clean, simple output
- Shows disk space at a glance

**Gdu** - Fast disk usage analyzer
- Go-based, very fast
- Interactive TUI for browsing disk usage
- Export to JSON

---

## Version Control

**Git** - Distributed version control system
- Standard tool for source code management
- Configured with user credentials and aliases

**Lazygit** - Terminal UI for git
- Simple, intuitive git interface
- Visual representation of commits and branches
- Staging, committing, pushing all from one screen

**GitHub CLI (gh)** - GitHub's official CLI tool
- Create PRs, issues from terminal
- Handles authentication tokens
- Repo cloning and management

**Onefetch** - Git repository information display
- Shows repo stats, languages, contributors
- ASCII art of repo languages
- Quick project overview

---

## System Information

**Fastfetch** - Fast system information tool
- Shows OS, kernel, DE, hardware info
- Customizable output
- Runs on terminal startup

**Nitch** - Minimal fetch utility
- Ultra-minimal system info display
- Lightweight alternative to neofetch

**Inxi** - Comprehensive system information
- Detailed hardware and system data
- Network, audio, graphics information
- Used by system scripts

---

## Hardware Information

**Lm_sensors** - Hardware temperature monitoring
- CPU, GPU temperature readings
- Fan speed monitoring

**Lshw** - Hardware lister
- Detailed hardware configuration
- Shows exact hardware specs

**Pciutils** - PCI device utilities
- List and inspect PCI devices
- `lspci` for graphics cards, network adapters

**Usbutils** - USB device utilities
- List USB devices with `lsusb`
- Shows USB device hierarchy

**Mesa-demos** - OpenGL utilities
- `glxinfo` for GPU information
- Used by system info tools

---

## Network Tools

**Wget** - Non-interactive network downloader
- Download files from the web
- Resume support for interrupted downloads

**Gping** - Graphical ping tool
- Real-time ping visualization
- Shows latency over time in graph form

**Socat** - Socket utility
- Relay data between different I/O types
- Used by screenshot scripts

---

## Documentation

**Tealdeer** - Fast TLDR client
- Quick command examples
- `tldr` for common command usage
- Faster alternative to man pages for quick reference

---

## Audio & Video

**Cava** - Console audio visualizer
- Real-time audio visualization in terminal
- Configurable colors and modes
- Works with any audio source

**FFmpeg** - Video/audio encoding and editing
- Convert between media formats
- Extract audio from video
- Powerful multimedia processing

**MPV** - Minimalist media player
- Lightweight, keyboard-driven
- Plays virtually any media format
- Command-line controllable

**Playerctl** - Media player control
- Control media players from scripts
- Play/pause, next/previous track
- Works with MPRIS-compatible players

**Pavucontrol** - PulseAudio volume control
- GUI for audio settings
- Per-application volume control
- Input/output device management

---

## Development Tools

**Rustup** - Rust toolchain installer
- Manages Rust versions
- Install stable, beta, nightly toolchains

**Rust-analyzer** - Rust language server
- IDE features for Rust development
- Code completion, goto definition

**GCC** - GNU Compiler Collection
- C/C++ compiler
- Required for some Rust dependencies

**Nixd** - Nix language server
- IDE features for Nix expressions
- Syntax checking and completion

**Nil** - Nix language server alternative
- Another Nix LSP implementation
- Used by text editors

**Nixfmt-rfc-style** - Nix code formatter
- Format Nix files to standard style
- Consistent code formatting

---

## Utilities

**Brightnessctl** - Screen brightness control
- Adjust display backlight
- Used by keybindings and scripts

**Killall** - Process killer by name
- Kill all processes matching a name
- Simpler than finding PIDs manually

**Cmatrix** - Matrix movie effect
- Fun terminal screensaver
- Shows falling green characters

**Gum** - Shell script styling tool
- Beautiful prompts and inputs for scripts
- Spinners, progress bars, confirmations
- Makes shell scripts more interactive

**Libnotify** - Desktop notification library
- Send notifications from scripts
- `notify-send` command
- Used by various scripts

---

## Terminal Multiplexing

*No terminal multiplexer currently configured* - Using Niri's native window management instead

---

## Notes

Most tools are configured via dotfiles in `~/nixos_config/dotfiles/.config/` and managed with dotbot for easy editing and version control.


dev shell--------------------------------

Of course. Here is a well-commented `flake.nix` that demonstrates the hybrid "rustup + Nix Shell" approach.

This flake sets up an environment that provides `rustup` and all the necessary system libraries (like `glib`, `openssl`, etc.) from the Nix store. Inside this environment, you can then use `rustup` and `cargo` as you normally would.

A key best practice added here is the use of a `shellHook` to make `rustup` and `cargo` store their data *inside your project directory* rather than your user's home directory. This makes each project fully self-contained.

### `flake.nix` for `rustup` + Nix Shell

```nix
{
  description = "A hybrid Rust development environment using rustup and a Nix shell";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # This is the development shell you will enter with `nix develop`
        devShell = pkgs.mkShell {
          # 'buildInputs' provides the dependencies for the shell environment.
          # The Nix-provided versions of these tools and libraries will be on your PATH.
          buildInputs = [
            # 1. The core tools for the hybrid approach
            # --------------------------------------------
            pkgs.rustup       # The Rust toolchain manager itself.
            pkgs.pkg-config   # The crucial bridge for *-sys crates to find C libraries.

            # 2. Example system libraries your Rust code might depend on
            # ----------------------------------------------------------
            # Add any C/system library your project needs here. Nix will ensure
            # pkg-config knows how to find them in the Nix store.
            pkgs.glib
            pkgs.openssl
            pkgs.gtk4         # For GUI apps using gtk4-rs
            pkgs.vulkan-loader # For graphics/game development with Vulkan
          ];

          # The shellHook runs commands every time you enter `nix develop`.
          shellHook = ''
            # Greet the user
            echo "--- Rustup Hybrid Nix Shell ---"

            # BEST PRACTICE: Set RUSTUP_HOME and CARGO_HOME to a project-local directory.
            # This avoids polluting your user's home directory (~/.rustup, ~/.cargo)
            # and keeps each project's toolchains and dependencies completely isolated.
            export RUSTUP_HOME="$(pwd)/.nix-rustup"
            export CARGO_HOME="$(pwd)/.nix-cargo"

            # Add the project-local cargo binaries (from `cargo install`) to the PATH.
            export PATH="$CARGO_HOME/bin:$PATH"

            # Check if a rust toolchain is installed in the local RUSTUP_HOME
            # and provide guidance to the user on the first run.
            if ! rustup toolchain list | grep -q "stable"; then
              echo ""
              echo "Rust toolchain not found in this project's environment."
              echo "To get started, please run:"
              echo "  > rustup toolchain install stable"
              echo "  > rustup default stable"
              echo ""
            fi
          '';
        };
      }
    );
}
```

### How to Use This Flake

1.  **Save the Code**: Place the code above into a file named `flake.nix` in the root of your Rust project.
2.  **Enter the Environment**: Run the following command in your terminal from the project directory:
    ```bash
    nix develop
    ```
3.  **First-Time Setup**: The `shellHook` will detect that you haven't installed a toolchain yet and will prompt you. Follow its instructions:
    ```bash
    rustup toolchain install stable
    rustup default stable
    ```
4.  **Ready to Code**: That's it! You are now in a shell where:
    *   `cargo`, `rustc`, and `rustup` commands work.
    *   Any `*-sys` crate in your project (like `glib-sys` or `openssl-sys`) will automatically find the corresponding libraries provided by Nix because `pkg-config` is correctly configured by the environment.
    *   Your Rust toolchain and compiled dependencies are neatly contained within `.nix-rustup/` and `.nix-cargo/` in your project folder. You can safely add these directories to your `.gitignore` file.