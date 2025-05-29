{ host, nixos-hardware, pkgs, lib, ... }:
{
  imports = [
    ../default/base.nix
    ../default/graphical.nix
    ../default/gaming.nix
    ./hardware-configuration.nix
  ];
  services.blueman.enable = lib.mkOverride 101 true;
  hardware.bluetooth.enable = lib.mkOverride 101 true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      
    ];
  };

 
  environment.sessionVariables = {
  };

  system.stateVersion = "25.05";
}
