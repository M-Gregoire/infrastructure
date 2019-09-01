[
  (
    self: super: {
      unstable = import ~/.nix-defexpr/channels/unstable {};
    }
  )
  (_: _: let
    unstable = import ~/.nix-defexpr/channels/unstable { config = import ./config.nix; overlays = []; };
  in {
    inherit (unstable)
      docker
    ;
  })
]
