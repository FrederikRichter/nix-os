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


    # atmega debugging

    services.udev.packages = [ pkgs.openocd ];
    services.udev.extraRules = ''
          # Atmel-ICE (JTAG / ISP / debugWIRE / PDI)
          SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", ATTR{idProduct}=="2140", MODE="0660", TAG+="uaccess"

          # FT2232H on the evaluation board (OpenOCD JTAG and UART)
          SUBSYSTEM=="usb", ATTR{idVendor}=="0403", ATTR{idProduct}=="6010", MODE="0660", TAG+="uaccess"
          KERNEL=="ttyUSB[0-9]*", TAG+="uaccess"
          KERNEL=="ttyACM[0-9]*", TAG+="uaccess"
    '';


    system.stateVersion = "25.11";

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
}
