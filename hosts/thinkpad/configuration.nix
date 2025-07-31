{ host, nixos-hardware, pkgs, lib, ... }:
{
  imports = [
    ../default/base.nix
    ../default/graphical.nix
    ./hardware-configuration.nix
  ];

  # Boot
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.enableCryptodisk = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/boot/crypto_keyfile.bin" = null;
  };


  boot.initrd.luks.devices."luks-f90e1a1e-aeb4-4da6-9051-82b62e012eac".keyFile = "/boot/crypto_keyfile.bin";

  services.logind.extraConfig = ''
    HandleLidSwitchDocked=ignore
  '';

  # WM

programs.sway.enable = true;
services.greetd = {
  enable = true;
  settings.command = "${pkgs.sway}/bin/sway";
};

  programs.light.enable = true;

  console.keyMap = lib.mkOverride 101 "de";


  hardware.graphics.extraPackages = with pkgs; [
      vaapiIntel intel-media-driver 
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

 # POWER
powerManagement.enable = true;

 services.tlp = {
      enable = false;
};

services.auto-cpufreq.enable = true;
services.auto-cpufreq.settings = {
  battery = {
     governor = "powersave";
     turbo = "never";
  };
  charger = {
     governor = "performance";
     turbo = "auto";
  };
};
powerManagement.powertop.enable = true;
  system.stateVersion = "25.05";
}
