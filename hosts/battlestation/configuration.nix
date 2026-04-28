{ config, host, nixos-hardware, pkgs, lib, ... }:
{

  # Console keymap
  console.keyMap = lib.mkDefault "us";

  boot = {
      loader = {
          grub = {
              enable = true;
              useOSProber = true;
              devices = [ "nodev" ];
              efiSupport = true;
          };
          efi = {
              canTouchEfiVariables = true;
          };
          timeout = 5;
      };
  };

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
            package = config.boot.kernelPackages.nvidiaPackages.beta;
        };
        graphics = {
            enable = true;
            extraPackages = [
                pkgs.nvidia-vaapi-driver
            ];
        };
    };

    environment.variables = {
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        NVD_BACKEND = "direct";
        # GSK_RENDERER = "ngl"; # HOTFIX
        ENABLE_HDR_WSI = 1;
        WEBKIT_DISABLE_COMPOSITING_MODE=1; # HOTFIX
        MOZ_DISABLE_RDD_SANDBOX = "1"; # UNSAFE
    };
    
# HDR fix
    environment.systemPackages = [pkgs.vulkan-hdr-layer-kwin6 pkgs.libva-utils ];

# Networking

# virt
virtualisation = {
  containers.enable = true;
  podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
  };
};

    system.stateVersion = "25.05";
}
