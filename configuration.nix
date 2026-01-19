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
    ./${hostname}/configuration.nix
  ];

  # Bootloader.
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    initrd.kernelModules = [ "amdgpu" ];
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
    #river-classic
    #xdg-desktop-portal-wlr
    #fish
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

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      river = {
        prettyName = "River Classic";
        comment = "River Classic compositor managed by UWSM";
        binPath = "${pkgs.river-classic}/bin/river";
      };
    };
  };
  environment.loginShellInit = ''
    if uwsm check may-start; then
      exec uwsm start hyprland.desktop
    fi
  '';

  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
      wireplumber = {
        enable = true;
      };
    };
 
    #displayManager.ly = {
    #  enable = true;
      #settings = {
      #  animation = "matrix";
      #  bigclock = "en";
      #  clear_password = true;
      #  restart_cmd = "systemctl reboot";
      #  shutdown_cmd = "systemctl poweroff";
      #  sleep_cmd = "systemctl sleep";
      #};
    #};

    udev.extraRules = ''
      KERNEL=="uinput", MODE="0660", GROUP="input", OPTIONS+="static_node=uinput"
    '';
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
      #xdg-desktop-portal-luminous
    ];
    configPackages = [ pkgs.river-classic ];
    #config.common.default = [ "luminous" "wlr" "gtk" ];
    #wlr.enable = true;
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
}
