{ config, host, nixos-hardware, pkgs, lib, ... }:
{
    imports = [
        ../default/base.nix
        ../default/graphical.nix
        ../default/gaming.nix
        ./hardware-configuration.nix
    ];
    services.blueman.enable = lib.mkOverride 101 true;
    hardware.bluetooth.enable = lib.mkOverride 101 true;
    

    hardware.bluetooth.powerOnBoot = lib.mkOverride 101 true;


    services.xserver.videoDrivers = [ "nvidia" ];
    nixpkgs.config.nvidia.acceptLicense = true;

    programs.noisetorch.enable = true;

    hardware = {
        nvidia = {
            open = true;   
# Modesetting is required.
            modesetting.enable = true;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.beta;
        };
        graphics = {
            enable = true;
        };
    };
    environment.sessionVariables = {
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };
    
# vpn
    networking.firewall = {
        enable = true;
        checkReversePath = false;
        allowedTCPPorts = [ 80 443 1337 ];
        allowedUDPPorts = [ 1337 ];
    };
 
 services.resolved = {
  enable = true;
  dnssec = "true";
  domains = [ "~." ];
  #dnsovertls = "true";
};

networking.networkmanager.dns = "systemd-resolved";

    system.stateVersion = "25.05";

}
