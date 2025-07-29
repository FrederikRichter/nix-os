{ host, nixos-hardware, pkgs, lib, ... }:
{
  imports = [
    ../default/base.nix
    ../default/graphical.nix
    ./hardware-configuration.nix
  ];

  services.logind.extraConfig = ''
    HandleLidSwitchDocked=ignore
  '';

  programs.light.enable = true;

  console.keyMap = lib.mkOverride 101 "de";

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  system.stateVersion = "24.05";
}
