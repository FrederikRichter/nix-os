{pkgs, nixvim, lib, ... }:
{

# nix features
    nix = { 
        settings = {
            experimental-features = ["nix-command" "flakes"];
            trusted-users = [ "root" "@wheel" ];
        };
        gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 5d";
        };
    };


# Build optimizations
services.udisks2.enable = true;


# Bootloader.
boot.kernelPackages = pkgs.linuxPackages_latest;
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;


networking.hostName = lib.mkDefault "nixos-thinkpad"; # Define your hostname.


# udev rules
  services.udev.packages = [
    pkgs.android-udev-rules
  ];

# Enable networking
    networking.networkmanager.enable = true; # Set your time zone.
    time.timeZone = "Europe/Berlin";

# enable gvfs
    services.gvfs.enable = true; # Mount, trash, and other functionalities


# Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "de_DE.UTF-8";
        LC_IDENTIFICATION = "de_DE.UTF-8";
        LC_MEASUREMENT = "de_DE.UTF-8";
        LC_MONETARY = "de_DE.UTF-8";
        LC_NAME = "de_DE.UTF-8";
        LC_NUMERIC = "de_DE.UTF-8";
        LC_PAPER = "de_DE.UTF-8";
        LC_TELEPHONE = "de_DE.UTF-8";
        LC_TIME = "de_DE.UTF-8";
    };

# Configure console keymap
    console.keyMap = lib.mkDefault "us";


# Users
    users.users.frederik = {
        isNormalUser = lib.mkDefault true;
        description = lib.mkDefault "Frederik Richter";
        extraGroups = lib.mkDefault [ "networkmanager" "wheel" "video" ];
    };

# Allow unfree packages
    nixpkgs.config = {
        allowUnfree = true;
    };

    environment.systemPackages = with pkgs; [
        git
        home-manager
        nixvim 
    ];
}
