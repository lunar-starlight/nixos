{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { nixpkgs, ... }@inputs:
  let
    desktop = "pink-pear";
    laptop  = "rainbow-lemon";
    machine = { hostname, specialArgs ? {}, modules ? []}: {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { hostname = hostname; } // specialArgs;
        modules = [
          ./configuration.nix
        ] ++ modules;
      };
    };
  in
    nixpkgs.lib.attrsets.foldAttrs (x: acc: x // acc) {} [
      (machine { hostname = desktop; })
      (machine { hostname = laptop; })
    ];
}
