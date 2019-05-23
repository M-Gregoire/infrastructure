{ pkgs, lib,... }:

{
  imports = [
    ../modules
  ];

  config.resources = with lib; mapAttrs (_: v: mkDefault v) {
    git.username = "M-Gregoire";
    config.publicRepo = "infrastructure";
    config.privateRepo = "infrastructure-private";

    ssh.publicKeys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCj79SiNMAbXEwz10p1+qxjfQHLcK/+/qSLZmnRaskKR5pEUVSzXQ6kX3dBoXrz2TFV5UJ2Y//LtUJzOLMTYcDC3hBOrsl/9wp8TzirVqlmRH1wgx6loH6y4rJM5N3dAqigKa+Pnop3HXb7ea14/vnf5RaFpjdPxRZOVJm7BoTmMa5R1HbJkCkYqvLtuLtLDaprgDwaCH8fE6/c3FTln3WGe/u71c+WT2IFJgtqOuFwuKyOmGy8t4Iu1lN6ULBZWs0lGt+5jzc6N21PJQvxHkgLMNZgFMJYLzDFcSB2M5jZwqAUoPQl2GOHcKuej5apxxBvMzPMYO1p3PZKaws8ujtx gm"
    ];
    gpg.publicKey.fingerprint = "94693149B3B3BD62B5F977ACD188E9DC20B4AA39";

    font.name = "DejaVu Sans Mono Nerd Font";
    font.size = "12";

    bar.font.name = "DejaVu Sans Mono Nerd Font";
    bar.font.size = "12";

    theme = {
      name  = "tomorrow-night";
      cursors = "capitaine-cursors";
      alpha = "F7";
      alphaPercent = "97";
      base00="1d1f21"; #1d1f21
      base01="282a2e"; #282a2e
      base02="373b41"; #373b41
      base03="969896"; #969896
      base04="b4b7b4"; #b4b7b4
      base05="c5c8c6"; #c5c8c6
      base06="e0e0e0"; #e0e0e0
      base07="ffffff"; #ffffff
      base08="cc6666"; #cc6666
      base09="de935f"; #de935f
      base0A="f0c674"; #f0c674
      base0B="b5bd68"; #b5bd68
      base0C="8abeb7"; #8abeb7
      base0D="81a2be"; #81a2be
      base0E="b294bb"; #b294bb
      base0F="a3685a"; #a3685a
    };
  };
}
