# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./hyprland.nix
      inputs.xremap-flake.nixosModules.default
    ];

  # xremap configuration
  /* Enable Hypr feature support */
  services.xremap.withHypr = true;
  # Modmap for single key rebinds
  services.xremap.config.modmap = [
    {
      name = "Global";
      remap = { "CapsLock" = "Esc"; }; # globally remap CapsLock to Esc
    }
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;


  # Enable networking
  networking.hostName = "mmedPC"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Africa/Tunis";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mmed = {
    isNormalUser = true;
    description = "mmed";
    # default shell
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
  };

  programs.zsh.enable = true;
  programs.zsh.autosuggestions.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Gtk configuration
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.systemPackages = with pkgs; [
    #* dotfiles
    home-manager

    #* notification
    inotify-tools

    #* Development
    git
    vim
    gh
    kitty
    unzip # self-explanatory 

    #* sound and video
    pamixer
    brightnessctl
    playerctl

    #* browser
    firefox

    #* file manager
    yazi

    #* fonts
    font-awesome

    #* bluetooth
    bluez-tools
    blueberry

    #* xdg configuration
    xdg-utils

    #* Shells
    nushell
    zsh
  ];

  fonts.packages = with pkgs; [
    font-awesome
    nerdfonts
    meslo-lgs-nf
  ];

  # enable auto-updates
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = [
      "--update-input"
      "nixpkgs"
      "-L"
    ];
    dates = "09:00";
    randomizedDelaySec = "45min";
  };

  system.stateVersion = "23.11"; # Did you read the comment?

}
