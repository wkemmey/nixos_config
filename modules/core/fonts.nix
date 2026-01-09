{ pkgs, ... }: {
  fonts = {
    packages = with pkgs; [
      # unicode fallback and international character coverage
      dejavu_fonts
      noto-fonts              # from google - "no tofu" = no missing character boxes
      noto-fonts-color-emoji  # system-wide color emoji support
      noto-fonts-cjk-sans     # chinese/japanese/korean support
      
      # icon fonts for gui apps and web content
      font-awesome
      material-icons
      
      # nerd fonts (patched with icons/glyphs for terminals and editors)
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      
      # additional fonts
      terminus_font            # bitmap font for specific use cases
      montserrat               # sans-serif UI font
      roboto                   # google's popular UI font
      ubuntu_font_family       # clean, readable fonts
      liberation_ttf           # microsoft font compatibility (arial, times new roman, courier)
    ];
    
    fontconfig = {
      defaultFonts = {
        monospace = ["JetBrains Mono"];
        sansSerif = ["Liberation Sans" "DejaVu Sans"];
        serif = ["Liberation Serif" "DejaVu Serif"];
      };
    };
  };
}
