{ pkgs, nixvim, lib, host, ... }:

{
  # Services
  services.udisks2.enable = true;

  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  services.gvfs.enable = true;

  # Boot
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Console keymap
  console.keyMap = lib.mkDefault "us";

  # Networking
  networking.networkmanager.enable = true;
  networking.hostName = lib.mkDefault host;

  # Environment packages
  environment.systemPackages = with pkgs; [
    git
    home-manager
  ] ++ [
  nixvim
  ];

  # Nix features
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "@wheel" ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };

  # Time and Locale
  time.timeZone = "Europe/Berlin";

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

  # Users
  users.users.frederik = {
    isNormalUser = lib.mkDefault true;
    description = lib.mkDefault "Frederik Richter";
    extraGroups = lib.mkDefault [ "networkmanager" "wheel" "video" ];
  };
    

# ssh
    services.fail2ban.enable = true;

    services.openssh = {
        enable = true;
        ports = [ 22 ];
        settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
        };
    };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
