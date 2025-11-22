{config, ...}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        # Stylix will handle font and colors
        # Use Stylix's terminal font size
        font = "${config.stylix.fonts.monospace.name}:size=${toString config.stylix.fonts.sizes.terminal}";
        dpi-aware = "yes";
        pad = "8x8"; # padding around text
      };
      
      scrollback = {
        lines = 10000;
      };
      
      cursor = {
        color = "111111 cccccc"; # will be overridden by Stylix
      };
      
      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
