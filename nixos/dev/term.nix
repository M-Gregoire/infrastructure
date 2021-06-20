{ pkgs, config,  ... }:

{
  environment.systemPackages = with pkgs; [
    bat
    # Allow the use of tic command
    # Which allow sending kitty terminfo to remote servers
    # To do so, use
    # kitty +kitten ssh fenrirHome
    # See https://sw.kovidgoyal.net/kitty/faq.html#id4
    ncurses
    # Command-line fuzzy finder
    fzf
    # Load and unload environment variables depending on the current directory.
    direnv
  ];

  environment.variables."FZF_BASE" = "$(fzf-share)";

  programs = {
    # Needed for LightDM to remember the user
    # See https://github.com/NixOS/nixpkgs/issues/10349#issuecomment-341810990
    zsh = {
      enable = true;
      ohMyZsh.enable = true;
      ohMyZsh.plugins = [
        "colored-man-pages"
        "command-not-found"
        "direnv"
        "docker"
        "docker-compose"
        "fzf"
        "git"
        # Prevent running pasted command
        "safe-paste"
        "sudo"
        "systemd"
        "tmux"
      ];
      # Make sure to start gpg-agent
      # And create socket dir for gpg forwarding
      # https://wiki.gnupg.org/AgentForwarding
      interactiveShellInit = ''
        gpgconf --create-socketdir
        gpg-connect-agent /bye
      '';
      ohMyZsh.theme = "agnoster";
      enableCompletion = true;
    };
  };
}
