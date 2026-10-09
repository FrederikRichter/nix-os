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



    # Auto login on TTY1 (Hyprland is started by Home Manager via zsh)
    services.getty.autologinUser = "frederik";

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


    # tailscale
    services.tailscale.enable = true;

    # Network Drive
    fileSystems."/media/shared-tailscale" = {
        device = "radxa-zero3:/srv/storage";
        fsType = "nfs";
        options = [
            "x-systemd.automount"
            "noauto"
            "x-systemd.idle-timeout=600"
            "x-systemd.mount-timeout=5s"
            "x-gvfs-show"
            "nofail"
            "_netdev"
            "noatime"
        ];
    };


    # POWER
    services.upower.enable = true;
    services.power-profiles-daemon.enable = false;
    powerManagement = { 
        enable = true;
        cpuFreqGovernor = "schedutil";
        powertop.enable = true;
    };

    services.auto-epp = {
        enable = true;
        settings.Settings = {
            epp_state_for_AC = "balance_performance";
            epp_state_for_BAT = "balance_power";
        };
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
