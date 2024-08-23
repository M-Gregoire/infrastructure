{
  description = "A simple NixOS flake";

  inputs = {
    # Linux
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager-linux = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs-linux";
    };

    # Darwin
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    emacs-plus = {
      url = "github:d12frosted/homebrew-emacs-plus";
      flake = false;
    };

    # Common
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    emacs-dotfiles = {
      url = "github:M-Gregoire/Doom-emacs-config/main";
      flake = false;
    };
    private-config = {
      url =
        "git+ssh://git@git.martinache.net:2222/M-Gregoire/infrastructure-private.git";
      flake = false;
    };
    spicetify-nix.url = "github:the-argus/spicetify-nix";
  };

  outputs = { self, nixpkgs-linux, home-manager-linux, nixos-hardware, nix-darwin, nixpkgs-darwin, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, home-manager-darwin, emacs-plus, ... }@attrs:
    let
      system = "x86_64-linux";
      pkgs-linux = import nixpkgs-linux {
        inherit system;
        config = {
          allowBroken = false;
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          allowUnfreeRedistributable = true;
        };
      };
      
      pkgs-darwin = import nixpkgs-darwin {
        #inherit system;
        system = "aarch64-darwin";
        config = {
          allowBroken = false;
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          allowUnfreeRedistributable = true;
        };
      };

    in {


    #darwinPackages = self.darwinConfigurations."Gregoires-MacBook-Pro".pkgs;
    darwinConfigurations."Gregoires-MacBook-Pro" = nix-darwin.lib.darwinSystem {


      specialArgs = attrs // { pkgs = pkgs-darwin; } // { flake-root = ./.; };
      
      modules = [ 
        (import ./nixos/hosts/idunn/configuration.nix)
        home-manager-darwin.darwinModules.home-manager
        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gregoire = import ./home/home.nix;
            home-manager.extraSpecialArgs = attrs // { pkgs = pkgs-darwin; } // { flake-root = ./.; };
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "gregoire";
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
              "d12frosted/homebrew-emacs-plus" = emacs-plus;
            };
            mutableTaps = false;
          };
        }
      ];
    };

    nixosConfigurations.vali = nixpkgs-linux.lib.nixosSystem {
      inherit system;

      specialArgs = attrs // { pkgs = pkgs-linux; } // { flake-root = ./.; };

      modules = [
        (import ./nixos/hosts/vali/configuration.nix)
        nixos-hardware.nixosModules.dell-xps-13-9350
        home-manager-linux.nixosModules.home-manager
        {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.gregoire = import ./home/home.nix;

            home-manager.extraSpecialArgs = attrs // { flake-root = ./.; };
        }
      ];
    };
  };
}
