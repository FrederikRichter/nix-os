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
      overlays = [
        nixvim.overlays.default
      ];
    in
    {
      # Export the overlay so other flakes can consume it.
      overlays.default = nixpkgs.lib.composeManyExtensions overlays;

      nixosConfigurations.nixos-battlestation =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            # Apply the overlays to this NixOS configuration
            {
              nixpkgs.overlays = overlays;
            }

            ./hosts/battlestation/configuration.nix
          ];

          specialArgs = {
            host = "nixos-battlestation";
            inherit nixos-hardware;
          };
        };

      nixosConfigurations.nixos-ideapad =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            {
              nixpkgs.overlays = overlays;
            }

            ./hosts/ideapad/configuration.nix
          ];

          specialArgs = {
            host = "nixos-ideapad";
            inherit nixos-hardware;
          };
        };
    };
}
