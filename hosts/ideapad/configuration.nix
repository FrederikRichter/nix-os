{ config, host, nixos-hardware, pkgs, lib, ... }:
{
  # Boot
  boot.kernelParams = [ "amd_pstate=active" ];

  # Console keymap
  console.keyMap = lib.mkDefault "us";


    imports = [
        ../default/base.nix
        ../default/graphical.nix
        ../default/gaming.nix
        ./hardware-configuration.nix
    ];



# WM
    programs.hyprland = {
        enable = true;
    };

    services.greetd = {
        enable = true;
        settings = rec {
            initial_session = {
                user = "frederik";
                command = "${pkgs.hyprland}/bin/start-hyprland";
            };
            default_session = initial_session;
        };
    };

    services.blueman.enable = lib.mkOverride 101 true;
    hardware.bluetooth.enable = lib.mkOverride 101 true;

# AMD
    hardware.cpu.amd.updateMicrocode = true;
    hardware.enableAllFirmware = true;
    hardware.graphics = {
        enable = true;
        enable32Bit = true;
    };


    hardware.bluetooth.powerOnBoot = lib.mkOverride 101 true;

# Screen

# virt
virtualisation = {
  containers.enable = true;
  podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
  };
};


 
 # POWER
services.upower.enable = true;
services.power-profiles-daemon.enable = false;
powerManagement = { 
    enable = true;
    cpuFreqGovernor = "ondemand";
    powertop.enable = true;
};


services.logind.settings.Login = {
  HandleLidSwitch = "suspend";
  HandleLidSwitchExternalPower = "suspend";
  HandleLidSwitchDocked = "ignore";
};

    system.stateVersion = "25.11";
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
