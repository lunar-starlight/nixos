{ config, pkgs, hostname, ... }:
{
  nixpkgs.overlays = [ (final: prev: {
    inherit (prev.lixPackageSets.stable)
      nixpkgs-review
      nix-eval-jobs
      nix-fast-build
      colmena;
  }) ];

  nix.package = pkgs.lixPackageSets.stable.lix;

  imports = [
    ./hardware-configuration-${hostname}.nix
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.kernelModules = [ "amdgpu" ];
    #kernelParams = [
    #  "video=DP-1:2560x1440@60"
    #  "video=HDMI-A-2:1440x900@60"
    #];
    #uvesafb = {
    #  enable = true;
    #  gfx-mode = "2560x1440-0";
    #};
  };

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Ljubljana";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_DK.UTF-8";
    LC_IDENTIFICATION = "en_DK.UTF-8";
    LC_MEASUREMENT = "en_DK.UTF-8";
    LC_MONETARY = "en_DK.UTF-8";
    LC_NAME = "en_DK.UTF-8";
    LC_NUMERIC = "en_DK.UTF-8";
    LC_PAPER = "en_DK.UTF-8";
    LC_TELEPHONE = "sl_SI.UTF-8";
    LC_TIME = "en_DK.UTF-8";
  };

  users.users.muf = {
    isNormalUser = true;
    description = "Luna Strah";
    extraGroups = [ "networkmanager" "wheel" "input" "video"];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    #"no-url-literals"
    #"pipe-operators"
  ];
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    home-manager
    river-classic
    #xdg-desktop-portal-wlr
    fish
    acpilight
    fbset

    # audio
    wireplumber
    pipewire
    pulseaudio
  ];

  programs.river-classic.enable = true;
  programs.river-classic.extraPackages = [];
  programs.fish.enable = true;

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
      };
    };
 
    displayManager.ly = {
      enable = true;
      #settings = {
      #  animation = "matrix";
      #  bigclock = "en";
      #  clear_password = true;
      #  restart_cmd = "systemctl reboot";
      #  shutdown_cmd = "systemctl poweroff";
      #  sleep_cmd = "systemctl sleep";
      #};
    };

    udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
    '';
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      #xdg-desktop-portal-gtk
    ];
    configPackages = [ pkgs.river-classic ];
    #config.common.default = [ "wlr" ];
    #config.river = {
    #  default = [ "wlr" ];
    #};
    #wlr.enable = true;
  };

  hardware = {
    acpilight.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    #graphics = {
    #  enable32Bit = true;
    #  extraPackages = with pkgs; [ amdvlk ];
    #  extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    #};

    amdgpu = {
      initrd.enable = true;
    };
    #display = {
    #  outputs = {
    #    "DP-1".mode = "2560x1440@60";
    #  };
    #};
  };

  systemd.services = {
    set-fb = {
      enable = true;
      wantedBy = [ "getty.target" ];
      description = "Set framebuffer geometry";
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        Restart = "on-failure";
        #ExecStart = "fbset -g 2560 1440 2560 1440 32";
        ExecStart = ''${pkgs.bash}/bin/bash -c "until test -e '/dev/fb0'; do :; done ; ${pkgs.fbset}/bin/fbset -xres 2560 -yres 1440 -depth 24 -match"'';
      };
    };
  };

  security.rtkit.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
