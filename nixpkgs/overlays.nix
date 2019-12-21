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
      emacs
      # https://github.com/ValveSoftware/steam-for-linux/issues/6499#issuecomment-553607737
      steam
    ;
  })
]
