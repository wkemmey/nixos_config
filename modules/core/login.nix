{ inputs, ... }:
{
  imports = [ inputs.noctalia-greeter.nixosModules.default ];

  services.displayManager.noctalia-greeter = {
    enable = true;
    passwordless-sync-users = [ "whit" ];
    settings = {
      keyboard.layout = "us";
      cursor.size = 24;
    };
  };
}