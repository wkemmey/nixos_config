{
  lib,
  config,
  ...
}: {
  programs.alacritty = 
  let
    font_family = lib.mkForce "Maple Mono NF";
  in {
    enable = true;
    settings = {
      # Force Wayland backend (not X11/Xwayland)
      env.WINIT_UNIX_BACKEND = "wayland";
      
      font = {
        normal = {
          family = font_family;
          style = "Regular";
        };
        bold = {
          family = font_family;
          style = "Bold";
        };
        italic = {
          family = font_family;
          style = "Italic";
        };
        bold_italic = {
          family = font_family;
          style = "Bold Italic";
        };
        # Use Stylix's terminal font size instead of hardcoded value
        size = config.stylix.fonts.sizes.terminal;
      };
    };
  };
}
