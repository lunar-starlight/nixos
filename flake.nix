{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { nixpkgs, ... }@inputs:
  let
    desktop = "pink-pear";
    laptop  = "rainbow-lemon";
  in {
    nixosConfigurations.${laptop} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { hostname = laptop; };
      modules = [
        ./configuration.nix
      ];
    };
    nixosConfigurations.${desktop} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { hostname = desktop; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
