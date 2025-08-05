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
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

       #Optional helps save long term battery health
       START_CHARGE_THRESH_BAT0 = 45; # 40 and below it starts to charge
       STOP_CHARGE_THRESH_BAT0 = 85; # 80 and above it stops charging

      };
};

services.system76-scheduler.settings.cfsProfiles.enable = true; # Better scheduling for CPU cycles

  system.stateVersion = "25.05";
}
