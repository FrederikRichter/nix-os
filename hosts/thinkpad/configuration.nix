{ host, nixos-hardware, pkgs, lib, ... }:
{
  imports = [
    ../default/base.nix
    ../default/graphical.nix
    ./hardware-configuration.nix
  ];

  # Boot
  boot.extraModprobeConfig = "options thinkpad_acpi experimental=1 fan_control=1";

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

programs.hyprland.enable = true;
services.greetd = {
  enable = true;
  settings = rec {
    initial_session = {
      user = "frederik";
      command = "${pkgs.hyprland}/bin/hyprland";
    };
    default_session = initial_session;
  };
};

  programs.light.enable = true;

  console.keyMap = lib.mkOverride 101 "de";


# FANS

  services.thinkfan = {
      enable = true;
      sensors = [
      {
          query = "/sys/devices/platform/coretemp.0/hwmon";
          type = "hwmon";
          name = "coretemp";
          indices = [ 1 2 3 ];
      }
      ];
      levels = [
          # [ level (0-7) lowT highT ]  
          [ 0 0 65 ]
          [ 2 65 75 ]
          [ "level auto" 75 32767 ]
        ];
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
     turbo = "auto";
  };
  charger = {
     governor = "performance";
     turbo = "auto";
  };
};

powerManagement.powertop.enable = true;
services.system76-scheduler.settings.cfsProfiles.enable = true; # Better scheduling for CPU cycles

  system.stateVersion = "25.05";
}
