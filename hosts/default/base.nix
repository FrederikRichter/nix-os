{ pkgs, nixvim, lib, host, ... }:

{
  # Services
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.fwupd.enable = true;


  boot = {
      supportedFilesystems = [ "ntfs" ];
      kernelPackages = pkgs.linuxPackages_latest;
  };


  services.keyd = {
      enable = true;
      keyboards = {
    # The name is just the name of the configuration file, it does not really matter
    default = {
        extraConfig = ''
            [ids]
            *

            [main]
            capslock = esc
            esc = capslock
      '';
    };
  };
  };


  # Networking
  networking = {
      hostName = lib.mkDefault host;
      useDHCP = false;
      dhcpcd.enable = false;
      networkmanager = {
          enable = true;
          dns = "none";
          wifi.powersave = true;
      };
      nameservers = [
          "185.222.222.222"
          "45.11.45.11"
      ];
  };

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
    extraGroups = lib.mkDefault [ "networkmanager" "wheel" "video" "podman" ];
  };

 programs.nix-ld.enable = true;

  programs.nix-ld.libraries = with pkgs; [

    # Add any missing dynamic libraries for unpackaged programs
    libc
    
  ];

# sudo

security.sudo = {
  enable = true;
  extraRules = [{
    commands = [
      {
        command = "${pkgs.systemd}/bin/systemctl suspend";
        options = [ "NOPASSWD" ];
      }
      {
        command = "${pkgs.systemd}/bin/reboot";
        options = [ "NOPASSWD" ];
      }
      {
        command = "${pkgs.systemd}/bin/poweroff";
        options = [ "NOPASSWD" ];
      }
    ];
    groups = [ "wheel" ];
  }];
  extraConfig = with pkgs; ''
      Defaults:picloud secure_path="${lib.makeBinPath [
      systemd
      ]}:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin"
      '';
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

environment.sessionVariables = { DOCKER_HOST="unix:///run/user/$UID/podman/podman.sock"; };


# fonts

fonts.packages = with pkgs; [ inter libertinus];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
}
