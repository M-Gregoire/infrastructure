{
  description = "M-Gregoire infrastructure";

  inputs = {
    # Linux
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager-linux = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-linux";
    };

    # Darwin
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    home-manager-darwin = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-25.05";
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
    homebrew-emacs = {
      url = "github:railwaycat/homebrew-emacsmacport";
      flake = false;
    };
    homebrew-borders = {
      url = "github:FelixKratz/homebrew-formulae";
      flake = false;
    };

    # Common
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    emacs-dotfiles = {
      url = "github:M-Gregoire/Doom-emacs-config/main";
      flake = false;
    };
    private-config = {
      url = "path:/Users/gregoire/src/infrastructure-private";
      flake = false;
    };

    sops-nix-linux = {
      url = "github:Mic92/sops-nix";
      follows = "nixpkgs-linux";
    };
    sops-nix-darwin = { url = "github:Mic92/sops-nix"; };

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    deploy-rs.url = "github:serokell/deploy-rs";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs-linux";
    };
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
  };

  outputs = { self, nixpkgs-linux, home-manager-linux, nixos-hardware
    , nix-darwin, nixpkgs-darwin, home-manager-darwin, ... }@inputs:
    let
      lib = nixpkgs-linux.lib;

      hostVars = builtins.fromJSON (builtins.readFile ./hosts.json);

      conditionalImports = relativePath:
        let
          localPath = ./. + "/${relativePath}";
          privatePath = inputs.private-config + "/${relativePath}";
        in lib.optionals (builtins.pathExists localPath) [ localPath ]
        ++ lib.optionals (builtins.pathExists privatePath) [ privatePath ];

      systemImports = relativePath: system:
        let
          localPath = ./. + "/${relativePath}";
          localPathSystem = localPath + "/${system}.nix";
          privatePath = inputs.private-config + "/${relativePath}";
          privatePathSystem = privatePath + "/${system}.nix";
        in lib.optionals (builtins.pathExists localPath) [ localPath ]
        ++ lib.optionals (builtins.pathExists privatePath) [ privatePath ]
        ++ lib.optionals (builtins.pathExists localPathSystem)
        [ localPathSystem ]
        ++ lib.optionals (builtins.pathExists privatePathSystem)
        [ privatePathSystem ];

      resourcesList = configName: system:
        let
          h = hostVars.${configName};

          systemResources = systemImports "resources" system;

          hostResources = lib.optionals (h.cluster == "")
            (conditionalImports "resources/hosts/${configName}");

          clusterResources = lib.optionals (h.cluster != "")
            (conditionalImports "resources/hosts/${h.cluster}"
              ++ conditionalImports
              "resources/hosts/${h.cluster}/${configName}");

          networkResources =
            systemImports "resources/networks/${h.network}" system;

          profilesResources =
            systemImports "resources/profiles/${h.profile}" system;

        in systemResources ++ clusterResources ++ networkResources
        ++ hostResources ++ profilesResources;

      modulesList = configName: system:
        let
          h = hostVars.${configName};

          systemModules = systemImports "machines/" system;

          hostModules = lib.optionals (h.cluster == "")
            (conditionalImports "resources/hosts/${configName}");

          clusterModules = lib.optionals (h.cluster != "")
            (conditionalImports "machines/hosts/${h.cluster}")
            ++ conditionalImports "machines/hosts/${h.cluster}/${configName}";

          networkModules =
            systemImports "machines/networks/${h.network}" system;

          profilesModules =
            systemImports "machines/profiles/${h.profile}" system;

        in systemModules ++ hostModules ++ clusterModules ++ networkModules
        ++ profilesModules;

      homeList = configName: system:
        let
          h = hostVars.${configName};

          homeModules = systemImports "home" system;

          hostModules = lib.optionals (h.cluster == "")
            (conditionalImports "home/hosts/${configName}");

          clusterModules = lib.optionals (h.cluster != "")
            (conditionalImports "home/hosts/${h.cluster}")
            ++ conditionalImports "home/hosts/${h.cluster}/${configName}";

          networkModules = systemImports "home/networks/${h.network}" system;

          profilesModules = systemImports "home/profiles/${h.profile}" system;

        in homeModules ++ hostModules ++ clusterModules ++ networkModules
        ++ profilesModules;

      mkDarwin = configName: arch: extraModules:
        let
          system = arch;
          h = hostVars.${configName};
        in nix-darwin.lib.darwinSystem {
          inherit system;
          modules = [
            ./modules
            {
              nixpkgs.config = {
                allowBroken = false;
                allowUnfree = true;
                allowUnfreePredicate = (_: true);
                allowUnfreeRedistributable = true;
              };
            }
            {
              _module.args = {
                inherit inputs system;
                inherit (inputs) private-config;
                flake-root = ./.;
                configName = configName;
                inherit (h) hostname profile network user cluster clusterRole;
              };
            }

            home-manager-darwin.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                {
                  _module.args = {
                    inherit inputs;
                    inherit (inputs) private-config;
                    flake-root = ./.;
                    configName = configName;
                    inherit (h)
                      hostname profile network user cluster clusterRole;
                  };
                }
                ./modules
              ];

              home-manager.users.${h.user} = { config, lib, pkgs, ... }: {
                imports = homeList configName "darwin"
                  ++ resourcesList configName "darwin";

              };
            }

            self.inputs.nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = false;
                user = "${h.user}";
                taps = {
                  "homebrew/homebrew-core" = self.inputs.homebrew-core;
                  "homebrew/homebrew-cask" = self.inputs.homebrew-cask;
                  "homebrew/homebrew-bundle" = self.inputs.homebrew-bundle;
                  "homebrew/homebrew-emacsmacport" = self.inputs.homebrew-emacs;
                  "FelixKratz/homebrew-formulae" = self.inputs.homebrew-borders;
                };
                mutableTaps = false;
              };
            }

            self.inputs.sops-nix-darwin.darwinModules.sops
          ] ++ modulesList configName "darwin"
            ++ resourcesList configName "darwin";
        };

      mkNixos = configName: arch: extraModules:
        let
          system = arch;
          h = hostVars.${configName};
        in nixpkgs-linux.lib.nixosSystem {
          inherit system;
          modules = [
            ./modules
            {
              nixpkgs.config = {
                allowBroken = false;
                allowUnfree = true;
                allowUnfreePredicate = (_: true);
                allowUnfreeRedistributable = true;
              };
            }
            {
              _module.args = {
                inherit inputs system;
                inherit (inputs) private-config;
                flake-root = ./.;
                configName = configName;
                inherit (h) hostname profile network user cluster clusterRole;
              };
            }

            home-manager-linux.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [
                {
                  _module.args = {
                    inherit inputs;
                    inherit (inputs) private-config;
                    flake-root = ./.;
                    configName = configName;
                    inherit (h)
                      hostname profile network user cluster clusterRole;
                  };
                }
                ./modules
              ];
              home-manager.users.${h.user} = { config, lib, pkgs, ... }: {

                imports = homeList configName "linux"
                  ++ resourcesList configName "linux";
              };
            }
          ] ++ modulesList configName "linux"
            ++ resourcesList configName "linux";
        };

    in {

      darwinConfigurations = {
        idunn = mkDarwin "idunn" "aarch64-darwin" [ ];
        datadog = mkDarwin "datadog" "aarch64-darwin" [ ];
      };

      nixosConfigurations = {
        vali = mkNixos "vali" "x86_64-linux"
          [ nixos-hardware.nixosModules.dell-xps-13-9350 ];
        mimir = mkNixos "mimir" "x86_64-linux" [
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-pc-ssd
        ];
        hades-1 = mkNixos "hades-1" "aarch64-linux"
          [ nixos-hardware.nixosModules.raspberry-pi-4 ];
        hades-2 = mkNixos "hades-2" "aarch64-linux"
          [ nixos-hardware.nixosModules.raspberry-pi-4 ];
        hades-3 = mkNixos "hades-3" "aarch64-linux"
          [ nixos-hardware.nixosModules.raspberry-pi-4 ];
        hades-4 = mkNixos "hades-4" "aarch64-linux"
          [ nixos-hardware.nixosModules.raspberry-pi-4 ];
        hades-5 = mkNixos "hades-5" "aarch64-linux"
          [ nixos-hardware.nixosModules.raspberry-pi-4 ];
        hades-6 = mkNixos "hades-6" "aarch64-linux"
          [ nixos-hardware.nixosModules.raspberry-pi-4 ];
        orion = mkNixos "orion" "x86_64-linux"
          [ self.inputs.disko.nixosModules.disko ];

      };

      deploy.nodes = {
        vali = {
          hostname = "localhost";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = self.inputs.deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.vali;
          };
        };

        mimir = {
          hostname = "localhost";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = self.inputs.deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.mimir;
          };
        };
        hades-1 = {
          hostname = "hades-1.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = self.inputs.deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-1;
          };
          magicRollback = false;
        };

        hades-2 = {
          hostname = "hades-2.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = self.inputs.deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-2;
          };
          autoRollback = false;
          magicRollback = false;
        };
        hades-3 = {
          hostname = "hades-3.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = self.inputs.deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-3;
          };
          autoRollback = false;
          magicRollback = false;
        };
        hades-4 = {
          hostname = "hades-4.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = self.inputs.deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-4;
          };
          autoRollback = false;
          magicRollback = false;
        };
        hades-5 = {
          hostname = "hades-5.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = self.inputs.deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-5;
          };
          autoRollback = false;
          magicRollback = false;
        };
        hades-6 = {
          hostname = "hades-6.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = self.inputs.deploy-rs.lib.aarch64-linux.activate.nixos
              self.nixosConfigurations.hades-6;
          };
          autoRollback = false;
          magicRollback = false;
        };
        orion = {
          hostname = "orion.martinache.net";
          sshOpts = [ "-p" "5421" ];
          sshUser = "root";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = self.inputs.deploy-rs.lib.x86_64-linux.activate.nixos
              self.nixosConfigurations.orion;
          };
          autoRollback = false;
          magicRollback = false;
        };

        # idunn = {
        #   hostname =
        #     "localhost"; # or specify the actual hostname/IP if deploying remotely
        #   sshUser = "gregoire";
        #   remoteBuild = true;
        #   profiles.system = {
        #     user = "root";
        #     path = self.inputs.deploy-rs.lib.aarch64-darwin.activate.darwin
        #       self.darwinConfigurations."Gregoires-MacBook-Pro";
        #   };
        #   autoRollback = false;
        #   magicRollback = false;
        # };

        datadog = {
          hostname =
            "localhost"; # or specify the actual hostname/IP if deploying remotely
          sshUser = "gregoire.cadenemartinache";
          remoteBuild = true;
          profiles.system = {
            user = "root";
            path = self.inputs.deploy-rs.lib.aarch64-darwin.activate.darwin
              self.darwinConfigurations.datadog;
          };
          autoRollback = false;
          magicRollback = false;
        };
      };

      # Optional: Disable global checks to avoid evaluating all hosts
      # Uncomment the line below to completely disable deploy checks for faster development
      # checks = {};

      # Current: Global checks (evaluates all hosts - slower but safer)
      checks = builtins.mapAttrs
        (system: deployLib: deployLib.deployChecks self.deploy)
        self.inputs.deploy-rs.lib;
      devShells = {
        x86_64-linux = let
          pkgs-linux = import inputs.nixpkgs-linux {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        in {
          default = pkgs-linux.mkShell {
            buildInputs = with pkgs-linux;
              [ nixos-rebuild nix-output-monitor ]
              ++ [ inputs.deploy-rs.packages.x86_64-linux.deploy-rs ];
            shellHook = ''
              export PATH="$PWD/bin:$PATH"
              echo "NixOS Infrastructure Development Shell"
              echo "Building happens on target hosts (remoteBuild = true)"
              echo ""
              echo "Available commands:"
              echo "  deploy .#<hostname>"
              echo "  deploy .# --dry-activate"
              echo "  deploy-help"
            '';
          };
        };

        aarch64-darwin = let
          pkgs-darwin = import inputs.nixpkgs-darwin {
            system = "aarch64-darwin";
            config.allowUnfree = true;
          };
        in {
          default = pkgs-darwin.mkShell {
            buildInputs = with pkgs-darwin;
              [ nix-output-monitor ]
              ++ [ inputs.deploy-rs.packages.aarch64-darwin.deploy-rs ];
            shellHook = ''
              export PATH="$PWD/bin:$PATH"
              echo "Darwin Infrastructure Development Shell"
              echo "Building happens on target hosts (remoteBuild = true)"
              echo ""
              echo "Available commands:"
              echo "  deploy .#<hostname>"
              echo "  deploy .# --dry-activate"
              echo "  deploy-help"
            '';
          };
        };
      };
    };
}
