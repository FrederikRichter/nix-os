{ config, pkgs, lib, ... }:
{
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    services.pipewire.extraConfig.pipewire."92-low-latency" = {
        "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 32;
        };
    };
environment.systemPackages = with pkgs; [
  mesa
  libGL
  libglvnd
  libdrm
];

# Hardware
    hardware.bluetooth = {
        enable = lib.mkDefault false;
        powerOnBoot = lib.mkDefault false;
        settings.General = {
            Enable = "Source,Sink,Media,Socket";
            ControllerMode = "bredr";

            KernelExperimental = true;
            Experimental = true;

            FastConnectable = true;
        };
    };

# Security
    security.polkit.enable = lib.mkDefault true;
    security.rtkit.enable = lib.mkDefault true;


# Networking
networking.firewall = {
    enable = true;
    checkReversePath = false;
    allowedTCPPorts = [ 53317 ];
    allowedUDPPorts = [ 53317 24727 ];
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


# Thunar
programs.thunar.enable = true;
programs.thunar.plugins = with pkgs; [
  thunar-archive-plugin
  thunar-volman
];


services.tumbler.enable = true; # Thumbnail support for images
}
