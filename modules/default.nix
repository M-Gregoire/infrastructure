{ config, lib, ... }:

{
  options.resources = with lib; {
    paths = {
      home = mkOption {
        type = types.str;
        example = "/home/me";
        description = "Home path";
      };
      publicConfig = mkOption {
        type = types.str;
        example = "/home/me/src/me/infrastracture";
        description = "Public config path";
      };
      privateConfig = mkOption {
        type = types.str;
        example =
          "/home/me/src/me/infrastracture/vendor/infrastructure-private";
        description = "Private config path";
      };
      scripts = mkOption {
        type = types.str;
        example = "/home/me/.scripts";
        description = "Scripts folder path";
      };
      publicDotfiles = mkOption {
        type = types.str;
        example = "/path/to/dotfiles/";
        description = "Dotfiles folder path";
      };
      privateDotfiles = mkOption {
        type = types.str;
        example = "/path/to/dotfiles/";
        description = "Dotfiles folder path";
      };
      secrets = mkOption {
        type = types.str;
        example = "/path/to/secrets/";
        description = "Secrets folder path";
      };
    };
    pcs = {
      firefox.profile = mkOption {
        type = types.str;
        example = "abcdef12.default";
        description = "Firefox profile name";
      };

      terminal = mkOption {
        type = types.str;
        example = "kitty";
        description = "Terminal emulator";
      };

      browser = mkOption {
        type = types.str;
        example = "firefox";
        description = "Browser";
      };

      mailer = mkOption {
        type = types.str;
        example = "thunderbird";
        description = "Email reader";
      };

      wallpaper = {
        current = mkOption {
          type = types.str;
          example = "wallpaper.jpg";
          description = "Wallpaper name";
        };
        folder = mkOption {
          type = types.str;
          example = "/path/to/wallpapers/";
          description = "Folder containing wallpapers";
        };
      };
    };
    screen = {
      dpi = mkOption {
        type = types.str;
        example = "96";
        description = "Dot per inch";
      };

      scaleFactor = mkOption {
        type = types.str;
        example = "1";
        description = "Scale factor for Electron app";
      };
    };

    hostname = mkOption {
      type = types.str;
      example = "foo";
      description = "Hostname";
    };

    username = mkOption {
      type = types.str;
      example = "bar";
      description = "Session username";
    };

    geo = {
      latitude = mkOption {
        type = types.float;
        example = 1.1;
        description = "Latitude";
      };
      longitude = mkOption {
        type = types.float;
        example = 1.1;
        description = "Longitude";
      };
      elevation = mkOption {
        type = types.int;
        example = 1;
        description = "Elevation (in m)";
      };
    };

    luks.drive = mkOption {
      type = types.str;
      example = "/dev/disk/by-uuid/<uuid>";
      description = "Path to LUKS drive";
    };

    pki = {
      acrs = mkOption {
        type = with types; listOf str;
        example = [ "-----BEGIN CERTIFICATE-----..." ];
        description = "Trusted ACRs to add to cert store";
      };
    };

    services = {
      gotify = {
        url = mkOption {
          type = types.str;
          example = "https://gotify.my.server";
          description = "Gofity url";
        };
        token = mkOption {
          type = types.str;
          example = "T0k3n";
          description = "Gofity app token";
        };
      };

      git = {
        username = mkOption {
          type = types.str;
          example = "John-Doe";
          description = "Git username";
        };
        email = mkOption {
          type = types.str;
          example = "john@doe.com";
          description = "Git email";
        };
      };

      nextcloud = {
        url = mkOption {
          type = types.str;
          example = "https://cloud.domain.com";
          description = "Nextcloud url";
        };
        username = mkOption {
          type = types.str;
          example = "John-Doe";
          description = "Nextcloud username";
        };
        password = mkOption {
          type = types.str;
          example = "superSecretP@ssw0rd";
          description = "Nextcloud password";
        };
      };

      ssh = {
        port = mkOption {
          type = types.port;
          example = [ "22" ];
          description = "Specifies on which port the SSH daemon listens.";
        };
        publicKeys = mkOption {
          type = with types; listOf str;
          example = [
            "ssh-ed25519 AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIIIJJJJKKKKLLLLMMMMNNNNOOOOPPPPQQQQ"
          ];
          description = "Public SSH keys to allow access to";
        };
      };

      email.backup = {
        fqdn = mkOption {
          type = types.str;
          example = "fqdn";
          description = "fqdn";
        };
        account = mkOption {
          type = types.str;
          example = "account@me.com";
          description = "Account";
        };
        hashedPassword = mkOption {
          type = types.str;
          example = "hash";
          description = "Hashed password";
        };
      };
    };

    gpg.publicKey.fingerprint = mkOption {
      type = types.strMatching "[[:alnum:]]{40}";
      description = "GPG key fingerprint";
    };

    networking = {
      DNS = mkOption {
        type = types.listOf types.str;
        description =
          "The list of nameservers. It can be left empty if it is auto-detected.";
      };
      fallbackDNS = mkOption {
        type = types.listOf types.str;
        description =
          "The list of fallback nameservers. It can be left empty if it is auto-detected.";
      };

      domain = mkOption {
        type = types.str;
        example = "foo";
        description = "local.domain";
      };

      searchDomains = mkOption {
        type = types.listOf types.str;
        description =
          "list of domains. These domains are used as search suffixes when resolving single-label host names (domain names which contain no dot), in order to qualify them into fully-qualified domain names (FQDNs).";
      };

      defaultGateway = mkOption {
        type = types.str;
        example = "1.2.3.4";
        description = "Default gateway";
      };
      nameservers = mkOption {
        type = with types; listOf str;
        example = [ "1.2.3.4" "4.3.2.1" ];
        description = "Nameservers";
      };
      ip = mkOption {
        type = types.str;
        example = "1.1.1.1";
        description = "Ip of the host";
      };
      ipv6 = mkOption {
        type = types.str;
        example = "::01";
        description = "ipv6 address";
      };
      initrd.ssh.port = mkOption {
        type = types.port;
        example = 22;
        description = "Initrd port";
      };

      firewall = {
        openTCPPorts = mkOption {
          type = with types; listOf port;
          example = [ "[ 22 ]" ];
          description = "Specifies open TCP ports.";
        };
        openUDPPorts = mkOption {
          type = with types; listOf port;
          example = [ "[ 22 ]" ];
          description = "Specifies open UDP ports.";
        };
        openTCPPortsRange = mkOption {
          type = with types; listOf (attrsOf port);
          example = [ "[ { from = 22; to = 25; } ]" ];
          description = "Specifies open TCP ports range.";
        };
        openUDPPortsRange = mkOption {
          type = with types; listOf (attrsOf port);
          example = [ "[ { from = 22; to = 25; } ]" ];
          description = "Specifies open UDP ports range.";
        };
      };
    };

    font = {
      name = mkOption {
        type = types.str;
        example = "DejaVu Sans Mono Nerd Font";
        description = "Font";
      };
      size = mkOption {
        type = types.float;
        example = 11.0;
        description = "Font size";
      };
    };

    keyboard = {
      layout = mkOption {
        type = types.str;
        example = "us";
        description = "Keyboard layout";
      };
      xkbOptions = mkOption {
        type = types.str;
        example = "compose:ralt";
        description = "Keyboard layout options";
      };
    };

    console.font = {
      name = mkOption {
        type = types.str;
        example = "DejaVu Sans Mono Nerd Font";
        description = "Console Font";
      };
    };

    bar.font = {
      name = mkOption {
        type = types.str;
        example = "FontAwesome";
        description = "Font in i3status";
      };
      size = mkOption {
        type = types.float;
        example = 12.0;
        description = "Font size in i3status";
      };
    };

    theme = {
      name = mkOption {
        type = types.str;
        example = "tomorrow-night";
        description = "Name of the base16 theme";
      };
      cursors = mkOption {
        type = types.str;
        example = "capitaine-cursors";
        description = "Name of the cursors";
      };
      alpha = mkOption {
        type = types.str;
        example = "CC";
        description = "Alpha channel (Hex)";
      };
      alphaPercent = mkOption {
        type = types.str;
        example = "90";
        description = "Alpha channel (Percentage)";
      };
      base00 = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base01 = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base02 = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base03 = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base04 = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base05 = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base06 = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base07 = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base08 = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base09 = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base0A = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base0B = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base0C = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base0D = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base0E = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
      base0F = mkOption {
        type = types.str;
        example = "ffffff";
        description = "Base color for base16 theme";
      };
    };
  };
}
