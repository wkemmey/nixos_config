{...}: {
  programs.foot = {
    enable = true;
    settings = {
      # Stylix handles: font, font-size, colors, dpi-aware
      # We only configure non-conflicting settings
      
      main = {
        pad = "8x8"; # padding around text
      };
      
      scrollback = {
        lines = 10000;
      };
      
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
