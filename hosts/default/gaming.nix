{ config, pkgs, lib, ... }:
{
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  extraCompatPackages = [
        pkgs.proton-ge-bin
  ];
};
programs.appimage.enable = true;
programs.appimage.binfmt = true;

programs.gamemode.enable = true;

networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 8469 27015 27036 ];
};

users.users.frederik = {
    extraGroups = lib.mkOverride 101 [ "networkmanager" "wheel" "video" ];
  };
}
