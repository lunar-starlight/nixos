{ config, pkgs, hostname, ... }:
{
  imports = [
    ./hardware-configuration.nix
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
  };

  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "muf" ];

  systemd.services.set-fb = {
    enable = true;
    wantedBy = [ "getty.target" ];
    description = "Set framebuffer geometry";
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      Restart = "on-failure";
      ExecStart = ''${pkgs.bash}/bin/bash -c "until test -e '/dev/fb0'; do :; done ; ${pkgs.fbset}/bin/fbset -xres 2560 -yres 1440 -depth 24 -match"'';
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
