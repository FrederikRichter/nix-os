{ config, pkgs, lib, ... }:
{
  # Services
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = lib.mkDefault "${pkgs.sway}/bin/sway --unsupported-gpu";
        user = "frederik";
      };
      default_session = initial_session;
    };
  };

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
          "sbc"
        ];
        "bluez5.roles" = [
          "a2dp_sink"
          "a2dp_source"
        ];
      };
    };
  };

    services.pipewire.extraConfig.pipewire."92-low-latency" = {
    "context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 32;
    };
  };

  #   services.pipewire.extraConfig.pipewire-pulse."93-no-crackling" = {
  #       "pulse.min.quantum"      = "256/48000";
  # };

  services.blueman.enable = lib.mkDefault false;

  # Hardware
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = lib.mkDefault false;
    settings.General = {
       Experimental = true;
        ControllerMode = "bredr";
    };
  };

  # Security
  security.polkit.enable = lib.mkDefault true;
  security.rtkit.enable = lib.mkDefault true;

# Network Drive

  boot.supportedFilesystems = [ "nfs" ];

  services.rpcbind.enable = true;
      systemd.mounts = [{
          type = "nfs";
          mountConfig = {
              Options = "noatime";
          };
          what = "192.168.1.106:/home/frederik/shared";
          where = "/mnt/shared";
      }];

  systemd.automounts = [{
      wantedBy = [ "multi-user.target" ];
      automountConfig = {
          TimeoutIdleSec = "600";
      };
      where = "/mnt/shared";
  }];

}
