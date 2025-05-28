{pkgs, lib, ... }:
{

# graphical session 
security.polkit = {
enable = lib.mkDefault true;
};

security.rtkit.enable = lib.mkDefault true;


# start sway 
    services.greetd = {
        enable = true;
        settings = rec {
            initial_session = {
                command = "${pkgs.sway}/bin/sway";
                user = "frederik";
            };
            default_session = initial_session;
        };
    };

# bluetooth
services.blueman.enable = lib.mkDefault false;
hardware.bluetooth.enable = lib.mkDefault false; # enables support for Bluetooth
hardware.bluetooth.powerOnBoot = lib.mkDefault false; # powers up the default Bluetooth controller on boot


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
}
