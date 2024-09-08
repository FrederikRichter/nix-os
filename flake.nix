{
  description = "Your NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # Replace with desired version
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations."nixos-thinkpad" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =  [
        ./hosts/nixos-thinkpad/configuration.nix
        ./hosts/nixos-thinkpad/hardware-configuration.nix
      ];
    };
  };
}

