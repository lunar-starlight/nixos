{ config, pkgs, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  environment.systemPackages = with pkgs; [
    evsieve
  ];

  # HM doesn't have steam module, and this does some driver setup
  programs.steam.enable = true;

  hardware = {
    acpilight.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    amdgpu = {
      initrd.enable = true;
    };
  };

  systemd.services = {
    "evsieve-G520X" = {
      description = "Clone mouse events";
      wantedBy = [ "graphical.target" ];
      serviceConfig = {
        Type = "notify";
        ExecStart = "${pkgs.evsieve}/bin/evsieve --input /dev/input/by-id/usb-Logitech_USB_Receiver-if02-event-mouse --output create-link=/dev/input/by-id/G502X";
      };
    };
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "muf" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
