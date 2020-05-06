[
  (_: _: let
    unstable = import ~/.nix-defexpr/channels/unstable { config = import ./config.nix; overlays = []; };
  in {
    inherit (unstable)
      oh-my-zsh
    ;
  })
]
