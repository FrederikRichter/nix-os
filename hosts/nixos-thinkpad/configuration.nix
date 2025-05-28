# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ nixos-hardware, pkgs, lib, ... }:
{

    modules = [ nixos-hardware.nixosModules.lenovo-thinkpad-l14-intel ];

    imports = [
        ../default/base.nix
        ../default/graphical.nix
        ./hardware-configuration.nix
    ];

    services.logind = {
        extraConfig = ''
            HandleLidSwitchDocked=ignore
            '';
    };

    programs.light.enable = true;

    networking.hostName = lib.mkOverride 101 "nixos-thinkpad"; # Define your hostname.

        services.blueman.enable = lib.mkOverride 101 true;
    hardware.bluetooth.enable = lib.mkOverride 101 true; # enables support for Bluetooth


        boot.initrd.luks.devices."luks-b1f28213-6a9b-4f3f-8d1b-cb4c98dc9c66".device = "/dev/disk/by-uuid/b1f28213-6a9b-4f3f-8d1b-cb4c98dc9c66";

# Configure console keymap
    console.keyMap = lib.mkOverride 101 "uk";

# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "24.05"; # Did you read the comment?
# hardware settings
        hardware.graphics = {
            enable = true;
            extraPackages = with pkgs; [
                intel-media-driver
            ];
        };
    environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; }; # Force intel-media-driver
}
