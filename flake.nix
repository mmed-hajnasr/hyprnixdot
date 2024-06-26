{
  description = "mmed configuration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    xremap-flake.url = "github:xremap/nix-flake";
    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, spicetify-nix, ... }@inputs:
    let
      SystemSettings = {
        system = "x86_64-linux";
        hostname = "mmedPC";
        timezone = "Africa/Tunis";
        locale = "en_US.UTF-8";
      };
      UserSettings = {
        username = "mmed";
        email = "mmed.benhadjnasr@gmail.com";
        homeDir = "/home/" + UserSettings.username;
        dotfilesDir = UserSettings.homeDir + "/dotfiles";
        configDir = UserSettings.homeDir + "/.config";
        screenshotDir = UserSettings.homeDir + "/Screenshots";
        scriptsDir = UserSettings.dotfilesDir + "/config_files/scripts";
        wm = "hyprland";
        browser = "firefox";
        terminal = "kitty";
        tty_editor = "nvim";
        editor = "nvim";
      };
      lib = nixpkgs.lib;
      system = SystemSettings.system;
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations.mmedPC = lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
          inherit SystemSettings;
        };
        inherit system;
        modules = [
          ./system/configuration.nix
        ];
      };
      homeConfigurations.mmed = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit UserSettings;
          inherit pkgs-unstable;
          inherit spicetify-nix;
        };
        modules = [
          ./user/home.nix
          ./user/spicetify.nix
        ];
      };
    };
}
