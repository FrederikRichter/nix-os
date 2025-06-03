{ config, pkgs, lib, ... }:
{
programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
};
programs.appimage.enable = true;
programs.appimage.binfmt = true;

programs.gamemode.enable = true;

users.users.frederik = {
    extraGroups = lib.mkOverride 101 [ "networkmanager" "wheel" "video" "gamemode" ];
  };
}
