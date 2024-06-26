{ config, pkgs, UserSettings, ... }:
let
  static_files = UserSettings.dotfilesDir + "/config_files";
in
{
  home.username = UserSettings.username;
  home.homeDirectory = UserSettings.homeDir;

  home.stateVersion = "24.05";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  imports = [
    ./CLI/default.nix
    ./management.nix
    ./apps.nix
    ./hyprland.nix
    ./music.nix
    ./theming.nix
    ./vanity.nix
    ./vscode.nix
    ./xdg.nix
    ./gtk.nix
    ./games.nix
    ./nvim.nix
    ./discord.nix
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/kitty/kitty.conf".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/kitty.conf";
    ".config/hypr".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/hypr";
    ".config/starship.toml".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/starship.toml";
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/waybar";
    ".config/zathura".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/zathura";
    ".config/scripts".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/scripts";
    ".config/yazi/yazi.toml".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/yazi.toml";
    ".config/flavours".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/flavours";
    ".config/cava".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/cava";
    ".config/neofetch".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/neofetch";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/nvim";
    ".config/functions.sh".source = config.lib.file.mkOutOfStoreSymlink "${static_files}/functions.sh";
  };

  home.sessionVariables = {
    EDITOR = UserSettings.tty_editor;
    BROWSER = UserSettings.browser;
  };

  # GIT configuration
  programs.git = {
    enable = true;
    userName = UserSettings.username;
    userEmail = UserSettings.email;
  };

  programs.home-manager.enable = true;
}
