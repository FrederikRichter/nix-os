{
  description = "NixOS configuration by FrederikRichter";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixvim = {
        url = "github:FrederikRichter/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixvim, nixos-hardware, ... }: {
    nixosConfigurations."nixos-thinkpad" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =  [
            ./hosts/nixos-thinkpad/configuration.nix
      ];
      specialArgs = {
          inherit nixvim;
          inherit nixos-hardware;
      };
    };
  };
}

