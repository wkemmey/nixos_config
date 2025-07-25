{pkgs, ...}: {
  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk-sans
      font-awesome
      #symbola
      material-icons
      fira-code
      fira-code-symbols
      jetbrains-mono
      maple-mono.NF
      terminus_font
    ];
  };
}
