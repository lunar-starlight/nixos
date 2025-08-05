{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs = { nixpkgs, ... }@inputs:
  let
    hostname = "rainbow-lemon";
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit hostname; };
      modules = [
        ./configuration.nix
      ];
    };
  };
}
