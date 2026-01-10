{ config, pkgs, hostname, ... }:
{
  imports = [
    ./${hostname}/hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
  ];

  hardware = {
    acpilight.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    amdgpu = {
      initrd.enable = true;
    };

    printers = {
      ensurePrinters = [
        {
          name = "printsrv";
          deviceUri = "smb://printsrv.fmf.uni-lj.si/TISKAJ";
          model = "CNRCUPSIRADVC5840ZK.ppd"; # CANON IR-ADV C5840/5850
          ppdOptions = {
            Duplex = "DuplexNoTumble";
            PageSize = "A4";
          };
        }
      ];
      ensureDefaultPrinter = "printsrv";
    };
  };

  services.printing = {
    enable = true;
    drivers = with pkgs; [ canon-cups-ufr2 ];
  };
  services.samba.enable = true;


  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
