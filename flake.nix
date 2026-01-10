{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { nixpkgs, ... }@inputs:
  let
    lib = nixpkgs.lib;
    machine = { hostname, specialArgs ? {}, modules ? []}: {
      nixosConfigurations.${hostname} = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit hostname; } // specialArgs;
        modules = [
          ./configuration.nix
        ] ++ modules;
      };
    };
    hosts = [
      { hostname = "pink-pear"; }
      { hostname = "rainbow-lemon"; }
    ];
  in
    lib.foldAttrs lib.mergeAttrs {} (
      lib.map machine hosts
    );
}
