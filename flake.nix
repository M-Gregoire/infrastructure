{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
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

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@attrs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowBroken = false;
          allowUnfree = true;
          allowUnfreePredicate = (_: true);
          allowUnfreeRedistributable = true;
        };
      };
    in {

      nixosConfigurations.vali = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = attrs // { pkgs = pkgs; } // { flake-root = ./.; };

        modules = [
          (import ./nixos/hosts/vali/configuration.nix)
          nixos-hardware.nixosModules.dell-xps-13-9350
          home-manager.nixosModules.home-manager
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
