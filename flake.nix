{
  description = "A simple NixOS flake";

  inputs = {
    # Linux
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager-linux = {
      url = "github:nix-community/home-manager/release-24.05";
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
      url = "git+file:///home/gregoire/src/infrastructure-private";
      flake = false;
    };
    # private-config = {
    #   url =
    #     "git+ssh://git@git.martinache.net:2222/M-Gregoire/infrastructure-private.git";
    #   flake = false;
    # };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs-linux";
    };
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    deploy-rs.url = "github:serokell/deploy-rs";

    # nixos-anywhere

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-linux";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs = { self, nixpkgs-linux, home-manager-linux, nixos-hardware
    , nix-darwin, nixpkgs-darwin, home-manager-darwin, deploy-rs
    , nixpkgs-unstable, ... }@attrs:
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

      pkgs-linux-aarch64 = import nixpkgs-linux {
        system = "aarch64-linux";
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
      darwinConfigurations."Gregoires-MacBook-Pro" =
        nix-darwin.lib.darwinSystem {

          specialArgs = attrs // {
            pkgs = pkgs-darwin;
            inputs = self.inputs;
            flake-root = ./.;
          };

          modules = [
            (import ./nixos/hosts/idunn/configuration.nix)
            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gregoire = import ./home/home.nix;
              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-darwin;
                flake-root = ./.;
              };
            }
            self.inputs.nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = false;
                user = "gregoire";
                taps = {
                  "homebrew/homebrew-core" = self.inputs.homebrew-core;
                  "homebrew/homebrew-cask" = self.inputs.homebrew-cask;
                  "homebrew/homebrew-bundle" = self.inputs.homebrew-bundle;
                  "d12frosted/homebrew-emacs-plus" = self.inputs.emacs-plus;
                };
                mutableTaps = false;
              };
            }
          ];
        };

      nixosConfigurations = {
        vali = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            inputs = self.inputs;
            pkgs = pkgs-linux;
            flake-root = ./.;
          };

          modules = [
            (import ./nixos/hosts/vali/configuration.nix)
            nixos-hardware.nixosModules.dell-xps-13-9350
            home-manager-linux.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire = import ./home/home.nix;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux;
                flake-root = ./.;
              };
            }
          ];
        };

        mimir = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux;
            inputs = self.inputs;
            flake-root = ./.;
          };

          modules = [
            (import ./nixos/hosts/mimir/configuration.nix)
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-pc-ssd
            home-manager-linux.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire = import ./home/home.nix;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux;
                flake-root = ./.;
              };
            }
          ];
        };
        hades-1 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
            inputs = self.inputs;
            flake-root = ./.;
          };

          modules = [
            (import ./nixos/hosts/hades/hades-1/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire = import ./home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
                flake-root = ./.;
              };
            }
          ];
        };

        hades-2 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
            inputs = self.inputs;
            flake-root = ./.;
          };

          modules = [
            (import ./nixos/hosts/hades/hades-2/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire = import ./home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
                flake-root = ./.;
              };
            }
          ];
        };

        hades-3 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
            inputs = self.inputs;
            flake-root = ./.;
          };

          modules = [
            (import ./nixos/hosts/hades/hades-3/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            nixos-hardware.nixosModules.raspberry-pi-4
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire = import ./home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
                flake-root = ./.;
              };
            }
          ];
        };

        hades-4 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
            inputs = self.inputs;
            flake-root = ./.;
          };

          modules = [
            (import ./nixos/hosts/hades/hades-4/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            nixos-hardware.nixosModules.raspberry-pi-4
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire = import ./home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
                flake-root = ./.;
              };
            }
          ];
        };

        hades-5 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
            inputs = self.inputs;
            flake-root = ./.;
          };

          modules = [
            (import ./nixos/hosts/hades/hades-5/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            nixos-hardware.nixosModules.raspberry-pi-4
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire = import ./home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
                flake-root = ./.;
              };
            }
          ];
        };

        hades-6 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
            inputs = self.inputs;
            flake-root = ./.;
          };

          modules = [
            (import ./nixos/hosts/hades/hades-6/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            nixos-hardware.nixosModules.raspberry-pi-4
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire = import ./home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
                flake-root = ./.;
              };
            }
          ];
        };

        orion = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux;
            inputs = self.inputs;
            flake-root = ./.;
          };

          modules = [
            home-manager-linux.nixosModules.home-manager
            self.inputs.disko.nixosModules.disko
            (import ./nixos/hosts/orion/configuration.nix)
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire = import ./home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux;
                flake-root = ./.;
              };
            }
          ];
        };

      };

      deploy.nodes = {
        vali = {
          hostname = "localhost";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.vali;
          };
        };

        mimir = {
          hostname = "localhost";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.mimir;
          };
        };
        hades-1 = {
          hostname = "hades-1.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-1;
          };
          magicRollback = false;
        };

        hades-2 = {
          hostname = "hades-2.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-2;
          };
          magicRollback = false;
        };
        hades-3 = {
          hostname = "hades-3.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-3;
          };
          magicRollback = false;
        };
        hades-4 = {
          hostname = "hades-4.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-4;
          };
          magicRollback = false;
        };
        hades-5 = {
          hostname = "hades-5.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-5;
          };
          magicRollback = false;
        };
        hades-6 = {
          hostname = "hades-6.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-6;
          };
          magicRollback = false;
        };
        orion = {
          hostname = "orion.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.orion;
          };
          autoRollback = false;
          magicRollback = false;
        };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
