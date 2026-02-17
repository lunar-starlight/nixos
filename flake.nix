{
  description = "NixOS config flake";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-25.11/nixexprs.tar.xz";
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
