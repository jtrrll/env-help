{
  description = "jtrrll's declarative dotfiles";

  inputs = {
    devenv = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:cachix/devenv";
    };
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    nix-vscode-extensions = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nix-vscode-extensions";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixvim";
    };
    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:danth/stylix";
    };
  };

  outputs = {
    flake-parts,
    home-manager,
    nix-vscode-extensions,
    nixpkgs,
    nixvim,
    stylix,
    ...
  } @ inputs:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        ./modules
      ];
      flake = let
        dotfiles = import ./dotfiles [
          nixvim.homeManagerModules.nixvim
          stylix.homeManagerModules.stylix
        ];
        overlay = final: _: {
          vscode-extensions = nix-vscode-extensions.extensions.${final.system}.vscode-marketplace;
        };
      in {
        inherit dotfiles overlay;
        homeConfigurations = let
          ### start "impure" ###
          HOME = builtins.getEnv "HOME";
          SYSTEM = builtins.currentSystem;
          USER = builtins.getEnv "USER";
          ### end "impure" ###
          mkConfig = modules:
            home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules =
                [
                  dotfiles
                  {
                    dotfiles = {
                      enable = true;
                      homeDirectory = HOME;
                      username = USER;
                    };
                  }
                ]
                ++ modules;
            };
          pkgs = import nixpkgs {
            inherit SYSTEM;
            overlays = [overlay];
          };
        in {
          # default configuration.
          "${USER}" = mkConfig [
            {
              dotfiles.theme = {
                enable = true;
                base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
              };
            }
          ];
          # default configuration with modifications to support CI.
          # - neovim is not included because it is slow to build and bloats the filesystem.
          # - the theme module is disabled because it doesn't work on headless systems.
          "ci" = mkConfig [
            {
              dotfiles = {
                programs.editors = ["vscode"];
                theme.enable = false;
              };
            }
          ];
        };
      };
    };
}
