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
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
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
          "msbc"
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
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 32;
    };
  };

  services.blueman.enable = lib.mkDefault false;

  # Hardware
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
    settings.General = {
       Experimental = true;
        ControllerMode = "bredr";
    };
  };

  hardware.enableAllFirmware = true;

  # Security
  security.polkit.enable = lib.mkDefault true;
  security.rtkit.enable = lib.mkDefault true;
}
