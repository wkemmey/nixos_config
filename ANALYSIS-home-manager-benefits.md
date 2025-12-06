# Home-Manager Benefits Analysis for Black Don OS

## Executive Summary

Your configuration uses home-manager for **3 major benefits**:
1. **Stylix Integration** - Unified theming across 15+ applications
2. **Nix Expression Power** - Dynamic config generation with variables and package references
3. **Declarative Package Management** - Programs and configs deployed atomically

However, **~40% of your home-manager files are just static config templating** that could be simpler as plain dotfiles in git.

---

## 1. HIGH-VALUE Home-Manager Usage

### ✅ Stylix Theme Integration (Strong Justification)

**Files leveraging Stylix colors:**
- `fish/default.nix` - Accent color in prompt: `accent = "#${config.lib.stylix.colors.base0D}"`
- `alacritty.nix` - Font size from Stylix: `size = config.stylix.fonts.sizes.terminal`
- `foot.nix` - Full Stylix theme integration (font, colors, DPI) via `include=` directive
- `lazygit.nix` - Active/inactive border colors from Stylix palette
- `nvf.nix` - Background color: `background_colour = "#${config.lib.stylix.colors.base01}"`

**Note:** `swaync.nix` exists with 52 color references but is NOT imported in `default.nix` and not running - dead code to delete.

**Value:** Change one color scheme in `variables.nix` → 5+ apps update atomically. This is **impossible** with plain dotfiles.

### ✅ Dynamic Config Generation with Nix (Strong Justification)

**Fish Shell Abbreviations:**
```nix
nxr = "sudo nixos-rebuild switch --flake .#${host}";  # Host variable injection
```
**Benefit:** Per-host commands without manual editing. The `${host}` variable makes this DRY across multiple machines.

**Alternative:** Could use `(hostname)` in Fish: `nxr = "sudo nixos-rebuild switch --flake .#(hostname)"` - This works fine and is more portable, though lacks build-time validation that the host exists in flake.nix.

**Git Configuration:**
```nix
inherit (import ../../hosts/${host}/variables.nix) gitUsername gitEmail;
user = {
  name = "${gitUsername}";
  email = "${gitEmail}";
};
```
**Benefit:** One-line change in `variables.nix` → git config updates. Git doesn't support includes for user config.

**Niri Startup with Package Paths:**
```nix
spawn-at-startup "swww-daemon"
spawn-at-startup "bash" "-c" "sleep 1 && swww img ${wallpaperImage}"
```
**Benefit:** `${wallpaperImage}` resolves to absolute Nix store path from `variables.nix`. Manual dotfile would require hardcoded paths.

**Scripts with Nix Package References:**
```nix
# emopicker.nix
${pkgs.fuzzel}/bin/fuzzel --dmenu
${pkgs.wl-clipboard}/bin/wl-copy
${pkgs.libnotify}/bin/notify-send
```
**Benefit:** Scripts reference exact Nix store paths. No PATH dependency issues, works even if packages move.

### ✅ Package Management with Config Coupling (Moderate Justification)

**Programs that bundle package + config:**
- `programs.git.enable = true` - Installs git + generates ~/.gitconfig
- `programs.foot.enable = true` - Installs foot terminal + generates config with Stylix integration
- `programs.lazygit.enable = true` - Installs lazygit + themed config
- `programs.fish.enable = true` - Installs fish + manages user config (abbreviations, plugins)
- `programs.vscode` - Installs VSCode + extensions declaratively

**Important Clarification:** Vendor completions for Fish come from `programs.fish.enable = true` in `modules/core/user.nix` (NixOS system config), NOT from home-manager. Home-manager only manages user-specific Fish config (abbreviations, plugins, init scripts).

**Benefit:** Atomic deployment - package and config always in sync. Rollback reverts both together.

---

## 2. MEDIUM-VALUE Home-Manager Usage

### ⚠️ XDG Default Applications
```nix
xdg.mimeApps.defaultApplications = {
  "text/html" = "firefox.desktop";
  "x-scheme-handler/http" = "firefox.desktop";
};
```
**Alternative:** `~/.config/mimeapps.list` (plain INI file)  
**Home-Manager Advantage:** Type-checked keys, but minimal practical benefit.

### ⚠️ GTK Theme Settings
```nix
gtk.iconTheme = {
  name = "Tela-purple-dark";
  package = pkgs.tela-icon-theme;
};
```
**Alternative:** Manual install + `~/.config/gtk-3.0/settings.ini`  
**Home-Manager Advantage:** Icon package + config coupled, but rarely changes.

---

## 3. LOW-VALUE / PURE TEMPLATING

### Package Installation Reality Check

**When you install a package via plain Nix (no home-manager):**
```nix
home.packages = [ pkgs.foot ];
```
You get:
- ✅ Binary installed in Nix store
- ❌ **NO config file created** (no `~/.config/foot/foot.ini`)
- ✅ Program runs with built-in defaults

**Most packages do NOT include default config files.** The binary contains hardcoded defaults.

**With home-manager's `programs.X.enable`:**
- ✅ Binary installed
- ✅ Config file generated from your Nix settings
- ✅ Stylix can auto-inject colors/fonts
- ✅ Settings validated at build time

So the choice isn't "home-manager config vs package default config" - it's "home-manager config vs manually creating dotfiles vs using built-in defaults."

### ❌ Static Config Files (Should Consider Plain Dotfiles)

**Niri Layout (layout.nix):**
```nix
''
  layout {
      gaps 9
      center-focused-column "never"
      preset-column-widths {
          proportion 0.5
      }
  }
''
```
**Reality:** This is just a KDL string. No Nix features used. Could be `~/.config/niri/layout.kdl`.

**Yazi Config (yazi.nix):**
```nix
settings = {
  manager = {
    ratio = [ 1 4 3 ];
    sort_by = "alphabetical";
    show_hidden = false;
  };
};
```
**Reality:** Static TOML-like structure. No variables, no Stylix. Could be `~/.config/yazi/yazi.toml`.

**Noctalia Shell Settings:**
- 400+ lines of JSON templating
- Only 2 variable references: `wallpaperDirectory` and conditional `barChoice`
- Could be `~/.config/noctalia/settings.json` with manual edits

**StarShip Prompt:**
- Static TOML structure in `starship.nix`
- No Stylix colors, no variables
- Could be `~/.config/starship.toml`

**Other Static Configs:**
- `bat.nix` - Just sets theme name (could be env var)
- `bottom.nix`, `btop.nix`, `htop.nix` - Static config blocks
- `cava.nix` - Visualization settings (no theming)
- `eza.nix` - Just enables program
- `tealdeer.nix` - Just enables program
- `tmux.nix` - Static config

---

## 4. ANTI-PATTERNS TO CONSIDER

### 🔴 VSCode Settings as Immutable Symlink

**Current Issue:**
```bash
~/.config/Code/User/settings.json -> /nix/store/...-settings.json (read-only)
```
VSCode tries to write settings → conflict → file opens on every restart.

**Options:**
1. **Fully Mutable:** `mutableExtensionsDir = true` - Let VSCode manage everything
2. **Hybrid:** Define baseline settings in Nix, use `userSettings` for overrides
3. **Full Nix Control:** Declare ALL settings in Nix (high maintenance)

**Recommendation:** Use mutable approach for VSCode. Stylix still themes it via system-level integration.

---

## 5. FEATURE USAGE BREAKDOWN

| Feature | Files Using It | Value Level |
|---------|---------------|-------------|
| **Stylix Colors** | 5 files (fish, alacritty, foot, lazygit, nvf) | 🟢 HIGH |
| **Stylix via Include** | foot.nix (auto-includes generated theme file) | 🟢 HIGH |
| **Host Variables** | 6 files (fish, git, niri startup/keybinds) - *could use $(hostname) instead* | 🟡 MEDIUM |
| **Nix Package Paths** | 5 files (scripts: emopicker, dcli, screenshootin, wallsetter, nvidia-offload) | 🟢 HIGH |
| **Programs.X.enable with Stylix** | foot, alacritty, lazygit | 🟢 HIGH |
| **Programs.X.enable without Stylix** | git (structured config), others | 🟡 MEDIUM |
| **Static Config Templates** | ~15 files | 🔴 LOW |
| **Dead Code** | swaync.nix (not imported, 300+ lines) | 🔴 DELETE |

---

## 6. RECOMMENDATIONS

### Keep in Home-Manager (Strong Benefits):
1. ✅ **Stylix-themed configs**: foot (includes theme file), alacritty, lazygit, nvf
2. ✅ **Fish config with Stylix colors**: fish/default.nix (if using `accent` in prompt)
3. ✅ **Scripts using pkgs.X**: All in `modules/home/scripts/`
4. ✅ **Structured config with validation**: git (though could be plain dotfile too)

### Delete (Dead Code):
1. ❌ **swaync.nix** - Not imported in default.nix, not running, 300+ wasted lines

### Consider Moving to Plain Dotfiles:
1. ❓ **Niri layout.nix** → `~/.config/niri/layout.kdl` (pure KDL, no Nix features)
2. ❓ **Yazi configs** → `~/.config/yazi/*.toml` (static settings)
3. ❓ **Noctalia settings** → `~/.config/noctalia/settings.json` (mostly static JSON)
4. ❓ **StarShip** → `~/.config/starship.toml` (no variables used)
5. ❓ **Bat/Bottom/Btop/Htop** → Plain config files (no theming integration)

### Hybrid Approach (Best of Both Worlds):
```nix
# Keep Nix for package installation + base settings
programs.yazi.enable = true;

# Let yazi manage its own config
# Don't use programs.yazi.settings = { ... }
# Just edit ~/.config/yazi/yazi.toml directly
```

**Workflow:**
- Home-manager installs programs
- Dotfiles repo manages configs (git stow, chezmoi, or plain symlinks)
- Niri/KDL configs edited with KDL-aware editor (better syntax checking)

---

## 7. THE CORE QUESTION

**"Am I getting enough benefit from home-manager config management?"**

### You ARE getting significant value from:
- **Stylix integration** (7 files, auto-theming impossible otherwise)
- **Host variable injection** (DRY multi-host setup)
- **Nix package path references** (robust scripts)
- **Atomic package+config deployment** (rollback safety)

### You are NOT getting much value from:
- **40% of your config files are static templates**
- **No cross-config validation** (fish abbr could be in wrong format, no type checking)
- **Lost editor intelligence** (KDL/JSON/TOML editors better than Nix strings)
- **Debugging complexity** (generated config requires checking Nix store paths)

---

## 8. SUGGESTED SPLIT

### Keep in Home-Manager:
```
modules/home/
├── fish/          # Uses ${host}, Stylix colors
├── git.nix        # Uses ${gitUsername}
├── alacritty.nix  # Uses Stylix fonts
├── foot.nix       # Full Stylix integration
├── lazygit.nix    # Uses Stylix colors
├── swaync.nix     # Heavy Stylix usage (52 refs)
├── nvf.nix        # Uses Stylix background
├── scripts/       # All use pkgs.X paths
├── stylix.nix     # Core theming
└── niri/startup.nix  # Uses ${wallpaperImage}
```

### Move to Dotfiles Repo:
```
~/.config/
├── niri/
│   ├── layout.kdl      # Pure KDL, edit with KDL LSP
│   ├── keybinds.kdl    # (Keep host-specific in Nix)
│   └── windowrules.kdl # Pure KDL
├── yazi/
│   ├── yazi.toml       # Static settings
│   └── theme.toml      # Could use Stylix later
├── starship.toml       # Static prompt config
├── noctalia/
│   └── settings.json   # Large static JSON
└── [bat, bottom, btop, htop, cava]/
```

---

## 9. FINAL VERDICT

**Your home-manager usage is ~50% justified:**

**Strong Justifications (Keep):**
- Stylix theme propagation via auto-generated include files (foot.nix)
- Stylix color variables in configs (fish accent, lazygit borders)
- Script robustness with package paths (scripts/)
- Atomic rollbacks for configs that change frequently

**Corrections to Original Analysis:**
- ❌ Fish vendor completions come from NixOS system config, not home-manager
- ❌ swaync.nix is dead code (not imported, not running)
- ⚠️ Host variables could be replaced with $(hostname) shell command
- ⚠️ Most packages include NO default config, so comparison is to manual dotfiles, not package defaults

**Weak Justifications (Consider Alternatives):**
- Static config templating (better editors available)
- VSCode immutable settings (causing friction)
- Large JSON/TOML blocks with no Nix features

**Hybrid Approach Recommendation:**
1. Keep home-manager for **programs + dynamic configs**
2. Use separate **dotfiles repo for static configs**
3. Edit configs with **language-specific tools** (KDL LSP, JSON schemas)
4. Let home-manager **install programs**, dotfiles **manage configs**

This gives you:
- ✅ Stylix theming benefits
- ✅ Multi-host variable injection
- ✅ Better config editing experience
- ✅ Simpler debugging (check actual config files, not Nix expressions)
- ✅ Easier sharing (dotfiles are universal, Nix expressions aren't)
