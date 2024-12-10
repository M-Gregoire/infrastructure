{
  description = "Hades cluster";

  inputs = {
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager-linux = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs-linux";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    private-config = {
      url = "git+file:///home/gregoire/src/infrastructure-private";
      flake = false;
    };
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { self, nixpkgs-linux, home-manager-linux, nixos-hardware, deploy-rs
    , ... }@attrs:
    let
      system = "aarch64-linux";
      pkgs-linux-aarch64 = import nixpkgs-linux {
        inherit system;
        config = {
          allowBroken = false;
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          allowUnfreeRedistributable = true;
        };
      };
    in {
      nixosConfigurations = {
        hades-1 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
          } // {
            flake-root = ./.;
          };

          modules = [
            (import ./hades-1/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire =
                import ../../../home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
              } // {
                flake-root = ./.;
              };
            }
          ];
        };

        hades-2 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
          } // {
            flake-root = ./.;
          };

          modules = [
            (import ./hades-2/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire =
                import ../../../home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
              } // {
                flake-root = ./.;
              };
            }
          ];
        };

        hades-3 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
          } // {
            flake-root = ./.;
          };

          modules = [
            (import ./hades-3/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            nixos-hardware.nixosModules.raspberry-pi-4
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire =
                import ../../../home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
              } // {
                flake-root = ./.;
              };
            }
          ];
        };

        hades-4 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
          } // {
            flake-root = ./.;
          };

          modules = [
            (import ./hades-4/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            nixos-hardware.nixosModules.raspberry-pi-4
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire =
                import ../../../home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
              } // {
                flake-root = ./.;
              };
            }
          ];
        };

        hades-5 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
          } // {
            flake-root = ./.;
          };

          modules = [
            (import ./hades-5/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            nixos-hardware.nixosModules.raspberry-pi-4
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire =
                import ../../../home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
              } // {
                flake-root = ./.;
              };
            }
          ];
        };

        hades-6 = nixpkgs-linux.lib.nixosSystem {
          inherit system;

          specialArgs = attrs // {
            pkgs = pkgs-linux-aarch64;
          } // {
            flake-root = ./.;
          };

          modules = [
            (import ./hades-6/configuration.nix)
            home-manager-linux.nixosModules.home-manager
            nixos-hardware.nixosModules.raspberry-pi-4
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.gregoire =
                import ../../../home/profiles/server;

              home-manager.extraSpecialArgs = attrs // {
                pkgs = pkgs-linux-aarch64;
              } // {
                flake-root = ./.;
              };
            }
          ];
        };
      };

      deploy.nodes = {
        hades-1 = {
          hostname = "hades-1.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.${system}.activate.nixos
              self.nixosConfigurations.hades-1;
          };
          autoRollback = false;
          magicRollback = false;
        };

        hades-2 = {
          hostname = "hades-2.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.${system}.activate.nixos
              self.nixosConfigurations.hades-2;
          };
          autoRollback = false;
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
          autoRollback = false;
          magicRollback = false;
        };
        hades-4 = {
          hostname = "hades-4.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.${system}.activate.nixos
              self.nixosConfigurations.hades-4;
          };
          autoRollback = false;
          magicRollback = false;
        };
        hades-5 = {
          hostname = "hades-5.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.${system}.activate.nixos
              self.nixosConfigurations.hades-5;
          };
          autoRollback = false;
          magicRollback = false;
        };
        hades-6 = {
          hostname = "hades-6.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.${system}.activate.nixos
              self.nixosConfigurations.hades-6;
          };
          autoRollback = false;
          magicRollback = false;
        };
      };

      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };
}
