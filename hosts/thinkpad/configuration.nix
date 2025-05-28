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

  services.blueman.enable = lib.mkOverride 101 true;

  programs.light.enable = true;

  hardware.bluetooth.enable = lib.mkOverride 101 true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  boot.initrd.luks.devices."luks-b1f28213-6a9b-4f3f-8d1b-cb4c98dc9c66".device = "/dev/disk/by-uuid/b1f28213-6a9b-4f3f-8d1b-cb4c98dc9c66";

  console.keyMap = lib.mkOverride 101 "uk";

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  system.stateVersion = "24.05";
}
