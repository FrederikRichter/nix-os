{
  description = "Your NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # Replace with desired version
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {
    nixosConfigurations."nixos-thinkpad" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =  [
        ./hosts/nixos-thinkpad/configuration.nix
        ./hosts/nixos-thinkpad/hardware-configuration.nix
         nixos-hardware.nixosModules.lenovo-thinkpad-l14-intel
      ];
    };
  };
}

