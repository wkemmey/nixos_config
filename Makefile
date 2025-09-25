
update: 
	sudo nix flake update
	
nix:
	sudo nixos-rebuild switch --flake . --impure

whit:
	sudo nixos-rebuild switch --flake /etc/nixos#whit_2022

macos:
	sudo darwin-rebuild switch --flake .#

gc: 
	# run garbage collection
	nix-collect-garbage --delete-older-than 5d

fmt:
	# format the nix files in this repo
	nix fmt ./



git add file1 file2 (etc..) to stage commits
git commit -m "commit message" to commit changes
git push remote-name branch-name to push to the remote


https://github.com/cideM/dotfiles

terminal emulator:  alacritty, kitty, or foot
shell:  fish


This is a **vast improvement**\! The fixes related to variable passing and Home Manager integration are excellent. Your configuration is now correct and portable.

While the files will work as-is, here are several suggested improvements to enhance **robustness, efficiency, and adherence to best practices** in your NixOS/Home Manager configuration:

## I. Configuration.nix Improvements

### 1\. Robustness: Handle the `bootMode` Argument 🛠️

You passed the `bootMode` variable in your `flake.nix`, but you aren't using it. This is a common pattern to create a unified configuration that works on both UEFI and BIOS machines.

**Improvement:** Use the `bootMode` variable to conditionally enable the correct bootloader options.

```nix
{ config, pkgs, mySettings, hostname, bootMode, ... }:

{
  # ...

  #### boot loader ####

  # Use systemd-boot for UEFI, and GRUB for BIOS, based on the argument
  boot.loader.systemd-boot.enable = bootMode == "uefi";
  boot.loader.efi.canTouchEfiVariables = bootMode == "uefi";

  boot.loader.grub.enable = bootMode == "bios";
  # Only set device if GRUB is enabled
  boot.loader.grub.device = if bootMode == "bios" then "/dev/sda" else null;
  boot.loader.grub.useOSProber = true;
  
  # ...
}
```

### 2\. Consistency: Use a Terminal Emulator Alias 💡

Your Hyprland configuration is binding `SUPER + Q` to the generic `fish` command, but `fish` is a shell, not a terminal emulator. You'll need an application like Kitty, Alacritty, or Ghostty to run it.

**Improvement:** Install a terminal emulator and reference it explicitly.

```nix
  #### system packages ####

  environment.systemPackages = with pkgs; [
    fish
    git
    # Add a terminal emulator
    kitty # or alacritty, or ghostty
    wayland-utils
    rofi
  ];

  # ...

  environment.etc."hypr/hyprland.conf".text = ''
    # ...
    # Use the terminal emulator you installed (e.g., kitty)
    bind = $mainMod, Q, exec, kitty
    # ...
  '';
```

### 3\. Best Practice: Consolidate User Shell/Packages 📦

You are correctly setting the user's shell: `users.users.${mySettings.username}.shell = pkgs.fish;`. You also add `fish` to `environment.systemPackages`. While harmless, it's slightly redundant to list `fish` under `systemPackages` if its primary use is as a user's shell, and it's already pulled in by the user definition.

**Improvement:** You can remove `fish` from `environment.systemPackages` unless you need it in the root environment for some reason. The user definition will ensure it's available for your user.

### 4\. Audio: Enable PipeWire 🔊

You have commented-out blocks for PipeWire. It is the modern standard for audio on Linux, replacing PulseAudio.

**Improvement:** Uncomment and enable PipeWire for a functioning audio setup.

```nix
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Add optional features for better desktop integration
    # wireplumber is the modern session manager for pipewire
    wireplumber.enable = true; 
  };
```

-----

## II. Home.nix Improvements

### 1\. Robustness: Correct String Interpolation for Git 🔗

In Nix, when interpolating variables into a string, you generally need to enclose the variable in `${...}`. For your `git` configuration, you are missing the quotes around the interpolated values.

**Potential Error:** If `mySettings.name` contains spaces, the line might fail to compile or be interpreted as multiple options.

**The Fix:** Wrap the interpolated variables in quotes.

```nix
{ config, pkgs, mySettings, ... }:

{
  # ...

  programs.git = {
    enable = true;
    # FIX: Wrap in quotes!
    userName = "${mySettings.name}";
    userEmail = "${mySettings.email}";
    extraConfig = {
      init.defaultBranch = "main";
      # Also good practice for paths, though often unnecessary for elements in a list.
      safe.directory = [ "/etc/nixos" "${mySettings.dotfilesDir}" ];
    };
  };

}
```

### 2\. Best Practice: Home Directory Variable 🏠

You are correctly setting `home.homeDirectory` using string interpolation: `/home/${mySettings.username}`.

**Alternative Improvement:** NixOS provides a built-in variable that handles this, making it more declarative.

```nix
{ config, pkgs, mySettings, ... }:

{
  # ...
  home.homeDirectory = config.home.homeDirectory; 
  # This uses the default home directory assigned by NixOS,
  # which is calculated based on the username you defined.
  # This simplifies your code slightly and avoids re-calculating the path.
  # Note: You still need to manually set home.username.
  home.username = "${mySettings.username}";
  # ...
}
```

-----

## III. Flake.nix Improvements

### 1\. Consistency: Use String Interpolation for Attributes 🏷️

In your `flake.nix`, when defining the attribute set for Home Manager users, it's safer to use string interpolation for the username key, even if it's already a string.

**Improvement:** Use `${...}` around the variable for the attribute key.

```nix
# ... inside nixosConfigurations modules ...

home-manager.users.${mySettings.username} = { # <-- Good, but still better to use interpolation
# Should be:
home-manager.users."${mySettings.username}" = {
  imports = [ ./home.nix ];
  extraSpecialArgs = { inherit mySettings; };
};
```

This prevents potential issues if your username ever contains non-alphanumeric characters (though "whit" is fine), and it clearly indicates that the key is a variable.

### 2\. Robustness: Pass Inputs to Modules 🔄

If you ever decide to use packages or options from one of your other inputs (like a custom Hyprland package from the `hyprland` input in your `home.nix`), you'll need to pass the inputs to Home Manager as well.

**Improvement:** Inherit all top-level inputs into Home Manager's `extraSpecialArgs`.

```nix
# ... inside nixosConfigurations modules ...

home-manager.nixosModules.home-manager {
  # ...
  home-manager.users.${mySettings.username} = {
    imports = [ ./home.nix ];
    extraSpecialArgs = {
      inherit mySettings;
      # Pass ALL the flake's top-level inputs to home.nix
      # This allows home.nix to access things like hyprland, disko, etc.
      inherit nixpkgs home-manager hyprland; 
    };
  };
}
```

If you apply these suggestions, you'll have a very **clean, robust, and idiomatic** NixOS configuration\!