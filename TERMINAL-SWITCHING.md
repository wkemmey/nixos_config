# Terminal Emulator Switching Guide

Both foot and alacritty are configured and installed. Here's how to switch between them:

## Method 1: Launch directly from command line
```fish
# Try foot
foot

# Try alacritty
alacritty
```

## Method 2: Update the default terminal keybind in Niri

Edit `modules/home/niri/keybinds.nix` and look for the terminal keybind (usually Mod+Return or Mod+T):

Change from:
```nix
"Mod+Return".action.spawn = ["alacritty"];
```

To:
```nix
"Mod+Return".action.spawn = ["foot"];
```

Then rebuild:
```fish
home-manager switch --flake .#whit2020
```

## Method 3: Test both side-by-side
```fish
# Open foot
foot &

# Open alacritty
alacritty &
```

Compare them and see which you prefer!

## Current Configuration

**Foot:**
- Wayland-native
- Uses Stylix for fonts (size 18) and colors
- Lightweight and fast
- Configured in: `modules/home/foot.nix`

**Alacritty:**
- Forced to use Wayland backend (not X11)
- Uses Stylix for fonts (size 18) and colors
- Uses "Maple Mono NF" font family override
- Configured in: `modules/home/alacritty.nix`

## Check which terminal you're currently using:
```fish
echo $TERM
ps aux | grep -E "(foot|alacritty)" | grep -v grep
```

## Performance comparison:
```fish
# Check memory usage
ps aux | grep -E "(foot|alacritty)" | awk '{print $11, $6}'
```
