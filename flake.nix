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

  outputs = { nixpkgs, nixvim, nixos-hardware, ... }:
    let 
      battlestation-host = "nixos-battlestation";
      thinkpad-host = "nixos-thinkpad";
      ideapad-host = "nixos-ideapad";
    in
  {
      nixosConfigurations."${battlestation-host}" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =  [
              ./hosts/battlestation/configuration.nix
          ];
          specialArgs = {
              inherit nixvim;
              inherit nixos-hardware;
              host = battlestation-host;
          };
      };
      nixosConfigurations."${ideapad-host}" = nixpkgs.lib.nixosSystem {
	system = "x86_64-linux";
	modules = [
	  ./hosts/ideapad/configuration.nix
	];
	specialArgs = {
		inherit nixvim;
		inherit nixos-hardware;
		host = ideapad-host;
	};
      };
      nixosConfigurations."${thinkpad-host}" = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =  [
              ./hosts/thinkpad/configuration.nix
              nixos-hardware.nixosModules.lenovo-thinkpad-t420
          ];
          specialArgs = {
              inherit nixvim;
              inherit nixos-hardware;
              host = thinkpad-host;
          };
      };
  };
}

