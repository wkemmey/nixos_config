{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # add host-specific packages here
  ];
}
