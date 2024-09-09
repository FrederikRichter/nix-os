# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  # nix features
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than +5";
  };
  security.polkit.enable = true;
  security.rtkit.enable = true;

# disable autologin xorg
services.displayManager = {
      defaultSession = "sway";
      autoLogin = {
          enable = true;
          user = "frederik";
      }; };

programs.light.enable = true;

# kanshi systemd service
  systemd.user.services.kanshi = {
    description = "kanshi daemon";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.kanshi}/bin/kanshi -c kanshi_config_file'';
    };
  };

# bluetooth

services.blueman.enable = true;
hardware.bluetooth.enable = true; # enables support for Bluetooth
hardware.bluetooth.powerOnBoot = false; # powers up the default Bluetooth controller on boot

# audio
services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
            "bluez5.enable-hw-volume" = true;
            "bluez5.codecs" = [
              "ldac"
              "aptx"
              "aptx_ll_duplex"
              "aptx_ll"
              "aptx_hd"
              "opus_05_pro"
              "opus_05_71"
              "opus_05_51"
              "opus_05"
              "opus_05_duplex"
              "aac"
              "sbc_xq"
              "msbc"
            ];
            "bluez5.roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
            "a2dp_sink"
            "a2dp_source"
            "bap_sink"
            "bap_source"
            ];
        };
    };
};


  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-b1f28213-6a9b-4f3f-8d1b-cb4c98dc9c66".device = "/dev/disk/by-uuid/b1f28213-6a9b-4f3f-8d1b-cb4c98dc9c66";
  networking.hostName = "nixos-thinkpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true; # Set your time zone.
  time.timeZone = "Europe/Berlin";

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
  console.keyMap = "uk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.frederik = {
    isNormalUser = true;
    description = "Frederik Richter";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
#  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
#  wget
      kanshi
      home-manager
  ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

# hardware settings
    hardware.opengl = {
        enable = true;
        extraPackages = with pkgs; [
            intel-compute-runtime
            intel-media-driver
        ];
    };
}
