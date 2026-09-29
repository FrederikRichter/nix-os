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

# Thunar
programs.thunar.enable = true;
programs.thunar.plugins = with pkgs; [
  thunar-archive-plugin
  thunar-volman
];


services.tumbler.enable = true; # Thumbnail support for images
}
