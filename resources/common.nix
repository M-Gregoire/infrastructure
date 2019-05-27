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
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFryLXHpP1vlCy1SujFhdnannj+tAt8Wgw2WYJICgwj+BywYwPzm6rhM1V65nmPnO6+KNVqm4aHrPP0mp3ZeIepHky53iaZ4Op91xwTaSMYyWqIdxuQzayq3MNU2C7MEniwr8wd7SxBVhGnIGYZqnUmvZA5i0/VmOKDfax43vsmRPkAsU+fp3sbwzVXcS+seXE8GBcC4T2AOeAyjmBRjGOYJQbjMztfasBWTwLOibzJ2qwfs2qPg50UNP0Ps0fKoGaKlwly45rWSlFEWPK5F2jfSBDSDUtoxXv6i5M7r4zjULwrZCbeyuHRFuvxNI/LiaHrDFusS6jXOmQvfZF7F2lDiFYaOg6MpTpP2evx1hVCXs+bsIwta2sk+E+igzaHe5wJ7VIwAXu92L7NpypbdEOXF8fDEPPasz9//z9r6HfH+/1C9r3WDG+VA9r+tQegpHBsoOnn8J0ePuwiGupzg09T02uizLfhCYZUjCE9c4j+s1pplznvILHbe7fnVw+5soMYo++3O665KwO/O18m+Gbl0D6/QYXXJY6nnivpWbeigqAmYBx+dg6Noy8c6TVIunUGS1fnFYhppNIrrZtcrs5vEs3YbkvjvmNfGGxNo2VxvUGWkOx1MhFZvqo8abNA0nvK71jdCrfJLNG+crTC7Br5/UYV2PVMwZztrFKLYCkjw== backup-machine"
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
