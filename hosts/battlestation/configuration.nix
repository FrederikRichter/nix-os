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
            extraPackages = [
                pkgs.nvidia-vaapi-driver
            ];
        };
    };
    environment.sessionVariables = {
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";
    };

networking.firewall = {
    enable = true;
    checkReversePath = false;
    allowedTCPPorts = [ 80 443 1337 ];
    allowedUDPPorts = [ 1337 ];
};
 
# vm
    programs.virt-manager.enable = true;

    users.groups.libvirtd.members = ["frederik"];

    virtualisation.libvirtd.enable = true;

    virtualisation.spiceUSBRedirection.enable = true;

    system.stateVersion = "25.05";
}
