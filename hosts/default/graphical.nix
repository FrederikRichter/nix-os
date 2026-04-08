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
            Experimental = true;
            ControllerMode = "bredr";
            Enable = "Source,Sink,Media,Socket";
        };
    };

# Security
    security.polkit.enable = lib.mkDefault true;
    security.rtkit.enable = lib.mkDefault true;

# Network Drive

    # boot.supportedFilesystems = [ "nfs" ];
    #
    # services.rpcbind.enable = true;
    # systemd.mounts = [{
    #     type = "nfs";
    #     mountConfig = {
    #         Options = "noatime";
    #     };
    #     what = "192.168.1.106:/home/frederik/shared";
    #     where = "/mnt/shared";
    # }];
    #
    # systemd.automounts = [{
    #     wantedBy = [ "multi-user.target" ];
    #     automountConfig = {
    #         TimeoutIdleSec = "600";
    #     };
    #     where = "/mnt/shared";
    # }];
    #

# Networking
networking.firewall = {
    enable = true;
    checkReversePath = false;
    allowedTCPPorts = [ 3333 ];
    allowedUDPPorts = [ 3333 ];
};

# Thunar
programs.thunar.enable = true;
programs.thunar.plugins = with pkgs; [
  thunar-archive-plugin
  thunar-volman
];


services.tumbler.enable = true; # Thumbnail support for images
}
