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


    --------------------


    Excellent question. Integrating `rust-analyzer` is the final piece of the puzzle for a smooth IDE experience.

The core challenge is that your IDE (like VS Code) runs as a separate process and doesn't automatically know about the environment you've configured in your `flake.nix`. When `rust-analyzer` starts, it won't see the special `PATH`, `RUSTUP_HOME`, or `PKG_CONFIG_PATH` variables from your `devShell`.

The solution is to use a specific IDE extension that makes your editor "Nix-aware." For VS Code, the standard tool for this is the **`nix-environment-selector`** extension.

Here is the step-by-step guide and the updated `flake.nix`.

### Step 1: Update Your `flake.nix`

We need to add `rust-analyzer` itself to the shell environment, along with the Rust standard library's source code, which `rust-analyzer` needs for "go to definition" and type analysis.

```nix
{
  description = "A hybrid Rust development environment with rust-analyzer integration";

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
        devShell = pkgs.mkShell {
          buildInputs = [
            # 1. Core Tools
            pkgs.rustup
            pkgs.pkg-config

            # 2. Rust Analyzer Support
            # --------------------------
            # Add rust-analyzer to the environment. The VS Code extension will find it here.
            pkgs.rust-analyzer
            # Add the Rust standard library source code.
            pkgs.rust-src

            # 3. Example System Libraries
            pkgs.glib
            pkgs.openssl
          ];

          # Set the RUST_SRC_PATH environment variable. rust-analyzer will
          # automatically pick this up to find the standard library source.
          RUST_SRC_PATH = pkgs.rust-src.src;

          shellHook = ''
            echo "--- Rustup Hybrid Nix Shell (with rust-analyzer) ---"

            export RUSTUP_HOME="$(pwd)/.nix-rustup"
            export CARGO_HOME="$(pwd)/.nix-cargo"
            export PATH="$CARGO_HOME/bin:$PATH"

            if ! rustup toolchain list | grep -q "stable"; then
              echo ""
              echo "Rust toolchain not found. To get started, run:"
              echo "  > rustup toolchain install stable"
              echo "  > rustup default stable"
              echo ""
              echo "NOTE: rust-analyzer needs the 'rust-src' component."
              echo "You can add it by running:"
              echo "  > rustup component add rust-src"
              echo ""
            fi
          '';
        };
      }
    );
}
```

**What changed?**

1.  We added `pkgs.rust-analyzer` to `buildInputs`. This makes the `rust-analyzer` language server binary available inside the Nix environment.
2.  We added `pkgs.rust-src` to `buildInputs`.
3.  We set the `RUST_SRC_PATH` environment variable to point directly to the location of the source code provided by `pkgs.rust-src`. This is the most robust way to ensure `rust-analyzer` finds it.

### Step 2: Configure Your IDE (VS Code Example)

1.  **Install Extensions**: Make sure you have these three extensions installed in VS Code:
    *   `rust-lang.rust-analyzer` (the official one)
    *   `jnoortheen.nix-ide` (A good alternative is `arrterian.nix-env-selector` )
    *   `bbenoist.Nix` (for syntax highlighting)

2.  **Configure `rust-analyzer`**: Open your VS Code settings (`settings.json`) and add the following line. This tells the extension *not* to download its own binary, but to use the one provided by our Nix environment.

    ```json
    {
        "rust-analyzer.server.path": "rust-analyzer"
    }
    ```
    This simply tells it to find `rust-analyzer` on the `PATH`. The `nix-ide` extension will handle making sure the correct `PATH` is used.

### Step 3: The Workflow in Action

1.  **Close and Re-open VS Code**: Open your Rust project folder in VS Code.

2.  **Allow the Nix Environment**: The `nix-ide` extension will detect your `flake.nix` and show a prompt at the bottom-right corner asking for permission to load it. It will look something like this:

    > `Nix-IDE: Select nix-shell environment for this workspace...`

    Click it and select `flake.nix` (`devShell`).

3.  **It Just Works**: The extension will now automatically load the Nix environment *for the VS Code window*. When the `rust-analyzer` extension tries to start its server, it will do so within this Nix-prepared environment.

### How It All Works Together

1.  `nix-ide` runs `nix develop` in the background and applies the resulting environment (all the `PATH`s and other variables) to your VS Code session.
2.  The `rust-analyzer` extension starts and looks for a binary named `rust-analyzer` on the `PATH` (per our `settings.json`). It finds the one from our `flake.nix`.
3.  The `rust-analyzer` server process inherits the full Nix environment.
4.  When it needs to check your code:
    *   It finds the `rust-src` because `RUST_SRC_PATH` is set.
    *   When it needs to build a proc-macro that depends on `glib`, it runs `cargo check`, which correctly finds `glib` because `PKG_CONFIG_PATH` is set.

You now have a perfectly integrated setup where your interactive terminal (`nix develop`) and your IDE's language server share the exact same reproducible environment.

---------------------------

Of course. Setting up `direnv` with Neovim is a fantastic workflow. It's arguably the most seamless way to work with Nix-defined environments in a terminal-based editor.

The magic of this setup is that the act of simply `cd`-ing into your project directory is enough to load the entire environment. Neovim, when opened, will inherit this environment automatically, making your Language Server Protocol (LSP) client work perfectly.

Here is the complete, step-by-step guide.

---

### The Goal

1.  When you `cd` into your project folder, `direnv` will automatically run `nix develop` in the background.
2.  When you open Neovim, it will inherit the environment from `direnv`.
3.  Your LSP client (`nvim-lspconfig`) will start `rust-analyzer` within this correct environment, giving it access to `rustup`, `pkg-config`, `glib`, etc.

---

### Step 1: Install and Configure `direnv` on NixOS

First, you need to ensure `direnv` is installed and properly "hooked" into your shell.

In your `/etc/nixos/configuration.nix`, enable the `direnv` program. This is the most idiomatic way as it also handles the shell hooks for you.

```nix
# /etc/nixos/configuration.nix
{ pkgs, ... }: {
  # ... other config
  programs.direnv = {
    enable = true;
    # This automatically handles hooking direnv into bash, zsh, and fish.
    # It's equivalent to manually adding `eval "$(direnv hook ...)"`
    nix-direnv.enable = true;
  };
}
```

After adding this, rebuild your system:
```bash
sudo nixos-rebuild switch
```
And restart your shell session (close and reopen your terminal) for the changes to take effect. The `nix-direnv.enable` option automatically adds support for the `use flake` command we'll need next.

---

### Step 2: Create the Project `.envrc` File

Now, tell `direnv` what to do when you enter your project directory.

In the root of your project (the same directory where your `flake.nix` lives), create a new file named `.envrc`.

```bash
# In your project's root, create this file:
# file: .envrc

use flake
```

That's it. This one command instructs `direnv` to load the `devShell` from the `flake.nix` in the current directory.

The first time you `cd` into this directory, `direnv` will show a security warning and refuse to run. You must explicitly grant it permission by running:

```bash
direnv allow
```

From now on, `direnv` will automatically load/unload the environment every time you enter/leave this directory. You'll see a message like `direnv: loading ~/path/to/project/.envrc`.

---

### Step 3: Configure Neovim

You need to ensure Neovim has two things:
1.  An LSP client configured for Rust (`nvim-lspconfig` + `rust-analyzer`).
2.  A plugin to make Neovim aware of `direnv`.

Here is an example using the popular `lazy.nvim` package manager. You can adapt this to any other plugin manager.

```lua
-- Example using lazy.nvim
-- file: ~/.config/nvim/lua/plugins/lsp.lua (or similar)

return {
  -- 1. The core LSP configuration engine
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Ensure rust-analyzer is installed via Mason or your preferred method
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- This sets up rust-analyzer to be started by nvim-lspconfig.
      -- It will automatically run inside the direnv-provided environment.
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        -- You can add server-specific settings here if needed
        -- settings = { ... }
      })
    end,
  },

  -- 2. The direnv integration plugin
  {
    "nvim-treesitter/nvim-treesitter", -- direnv plugin has a treesitter dependency
    opts = {
      ensure_installed = "bash" -- required by nvim-direnv
    }
  },
  {
    "leoluz/nvim-dap-go", -- direnv plugin has a dap-go dependency
    module = "dap-go"
  },
  {
    "mfussenegger/nvim-dap", -- direnv plugin has a dap dependency
    module = "dap"
  },
  {
    "rcarriga/nvim-dap-ui", -- direnv plugin has a dap-ui dependency
    module = "dapui"
  },
  {
    "theHamsta/nvim-dap-virtual-text", -- direnv plugin has a dap-virtual-text dependency
    module = "dap-virtual-text"
  },
  {
    'https://git.sr.ht/~motorto/nvim-direnv',
    config = function()
      require('direnv').setup()
    end,
  }
}
```

**Why this works:** The `nvim-direnv` plugin ensures that your project's `.envrc` is loaded *before* `nvim-lspconfig` tries to start the `rust-analyzer` server. This means the server process spawns with the full environment, and the circle is complete.

---

### The Final Workflow

Once the setup above is complete, here is what your day-to-day workflow looks like:

1.  **Open a terminal.**
2.  **Navigate to your project:**
    ```bash
    cd ~/my-rust-project
    # direnv automatically loads the Nix environment
    # Output: direnv: loading ~/my-rust-project/.envrc
    ```
3.  **Launch Neovim:**
    ```bash
    nvim .
    ```
4.  **Start coding.** Your `rust-analyzer` LSP will start up, correctly find `rust-src`, and be able to compile `sys` crates because it can see `pkg-config` and all the libraries from your `flake.nix`.

It feels completely seamless, as if the tools were globally installed, but you get all the power and reproducibility of a per-project Nix environment.

---------------

