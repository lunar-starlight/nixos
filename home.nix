{ config, pkgs , ... }:
{
  inputs = [
    ./river
  ];

  home.username = "muf";
  home.homeDirectory = "/home/muf";

  home.packages = with pkgs; [
    # archives
    zip
    xz
    unzip

    # utils
    eza
    mtr
    btop
    alacritty
    zsh
    
    # sys utils
    lm_sensors
    ethtool
    pciutils
    usbutils

    # browser
    firefox
    ladybird

    # editor
    emacs
    vscode

    # WM
    river
  ];

  programs.git = {
    enable = true;
    userName = "Luna Strah";
    userEmail = "strah.luna@gmail.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.alacritty = {
    enable = true;
  };

  programs.zsh = {
    enable = true;
  };



  # do NOT the version
  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
