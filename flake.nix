{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { nixpkgs, ... }@inputs:
  let
    desktop = "pink-pear";
    laptop  = "rainbow-lemon";
    machine = { hostname, extraSpecialArgs ? {}, extraModules ? []}: {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { hostname = hostname; } // extraSpecialArgs;
        modules = [
          ./configuration.nix
        ] ++ extraModules;
      };
    };
  in
    nixpkgs.lib.attrsets.foldAttrs (x: acc: x // acc) {} [
      (machine { hostname = desktop; })
      (machine { hostname = laptop; })
    ];
}
