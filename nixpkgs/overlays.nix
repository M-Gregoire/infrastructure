[
  (_: _: let
    unstable = import ../vendor/nixpkgs-unstable { config = import ./config.nix; overlays = []; };
  in {
    inherit (unstable)
    rambox
    signal-desktop
    ;
  })
  (_: _: let
    unstable = import ../vendor/nixpkgs-m-gregoire { config = import ./config.nix; overlays = []; };
  in {
    inherit (unstable)
    # Empty
    ;
  })
]
