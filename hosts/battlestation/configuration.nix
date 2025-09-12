{ config, host, nixos-hardware, pkgs, lib, ... }:
{

  # Console keymap
  console.keyMap = lib.mkDefault "us";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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
                command = "${pkgs.hyprland}/bin/hyprland";
            };
            default_session = initial_session;
        };
    };

    services.blueman.enable = lib.mkOverride 101 true;
    hardware.bluetooth.enable = lib.mkOverride 101 true;
    

    hardware.bluetooth.powerOnBoot = lib.mkOverride 101 true;


    services.xserver.videoDrivers = [ "nvidia" ];
    nixpkgs.config.nvidia.acceptLicense = true;

    hardware = {
        nvidia = {
            open = true;   
# Modesetting is required.
            modesetting.enable = true;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.production.overrideAttrs {
                version = "580.76.05";
                src = pkgs.fetchurl {
                    url = "https://download.nvidia.com/XFree86/Linux-x86_64/580.82.07/NVIDIA-Linux-x86_64-580.82.07.run";
                    sha256 = "061e48e11fe552232095811d0b1cea9b718ba2540d605074ff227fce0628798c";
                };
      };        };
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
        GSK_RENDERER = "ngl";
        ENABLE_HDR_WSI = 1;
    };
    
# HDR fix
    environment.systemPackages = [pkgs.vulkan-hdr-layer-kwin6];

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
