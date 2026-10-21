{ inputs, ... }:
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  services.displayManager.noctalia-greeter = {
    enable = true;
    settings = {
      keyboard.layout = "us";
      cursor.size = 24;
    };
  };
}