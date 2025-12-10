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
