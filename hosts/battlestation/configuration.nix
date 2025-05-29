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


    nixpkgs.config.nvidia.acceptLicense = true;

    hardware = {
        nvidia = {
            open = false;  # see the note above
            # Modesetting is required.
            modesetting.enable = true;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.beta;
        };
        graphics = {
            enable = true;
            extraPackages = with pkgs; [
                vulkan-loader
                vulkan-validation-layers
                vulkan-tools
            ];
        };
    };
 
  environment.sessionVariables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  system.stateVersion = "25.05";
}
