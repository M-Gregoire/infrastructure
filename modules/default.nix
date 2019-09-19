{ lib, ... }:

{
  options.resources = with lib; {
    pcs = {
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
          example = "/home/me/src/me/infrastracture/vendor/infrastructure-private";
          description = "Private config path";
        };
        scripts = mkOption {
          type = types.str;
          example = "/home/me/.scripts";
          description = "Scripts folder path";
        };
      };
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

    host = {
      name = mkOption {
        type = types.str;
        example = "foo";
        description = "Hostname";
      };
      username = mkOption {
        type = types.str;
        example = "bar";
        description = "Session username";
      };
    };

    wifi.workSSID = mkOption {
      type = types.str;
      example = "foobar";
      description = "Work wifi SSID";
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

    hosts = {
      beyla = {
        ip = mkOption {
          type = types.str;
          example = "1.1.1.1";
          description = "Ip of the host";
        };
        extraDomains = mkOption {
          type = types.listOf types.str;
          description = "Domain aliases";
        };
      };
      bur = {
        ip = mkOption {
          type = types.str;
          example = "1.1.1.1";
          description = "Ip of the host";
        };
        extraDomains = mkOption {
          type = types.listOf types.str;
          description = "Domain aliases";
        };
      };
      eldir = {
        ip = mkOption {
          type = types.str;
          example = "1.1.1.1";
          description = "Ip of the host";
        };
        extraDomains = mkOption {
          type = types.listOf types.str;
          description = "Domain aliases";
        };
      };
      mimir = {
        ip = mkOption {
          type = types.str;
          example = "1.1.1.1";
          description = "Ip of the host";
        };
        wifi.ip = mkOption {
          type = types.str;
          example = "1.1.1.1";
          description = "Ip of the host";
        };
        eth.ip = mkOption {
          type = types.str;
          example = "1.1.1.1";
          description = "Ip of the host";
        };
        extraDomains = mkOption {
          type = types.listOf types.str;
          description = "Domain aliases";
        };
      };
      skuld = {
        ip = mkOption {
          type = types.str;
          example = "1.1.1.1";
          description = "Ip of the host.";
        };
        extraDomains = mkOption {
          type = types.listOf types.str;
          description = "Domain aliases";
        };
      };
      octopi = {
        ip = mkOption {
          type = types.str;
          example = "1.1.1.1";
          description = "Ip of the host";
        };
        extraDomains = mkOption {
          type = types.listOf types.str;
          description = "Domain aliases";
        };
      };
      idunn = {
        ip = mkOption {
          type = types.str;
          example = "1.1.1.1";
          description = "Ip of the host";
        };
        wifi.ip = mkOption {
          type = types.str;
          example = "1.1.1.1";
          description = "Ip of the host";
        };
        eth.ip = mkOption {
          type = types.str;
          example = "1.1.1.1";
          description = "Ip of the host";
        };
        extraDomains = mkOption {
          type = types.listOf types.str;
          description = "Domain aliases";
        };
      };
    };

    taskd = {
      theme = mkOption {
        type = types.str;
        example = "dark-16";
        description = "Taskd theme";
      };
      certificate = mkOption {
        type = types.str;
        example = "/path/to/certificate";
        description = "Taskd certificate location";
      };
      key = mkOption {
        type = types.str;
        example = "/path/to/key";
        description = "Taskd key location";
      };
      ca = mkOption {
        type = types.str;
        example = "/path/to/ca";
        description = "Taskd ca location";
      };
      server = mkOption {
        type = types.str;
        example = "myserver.com";
        description = "Taskd server";
      };
      port = mkOption {
        type = types.str;
        example = "53589";
        description = "Taskd port";
      };
      credentials = mkOption {
        type = types.str;
        example = "foo/bar/aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee";
        description = "Taskd credentials";
      };
    };

    nextcloud = {
      username = mkOption {
        type = types.str;
        example = "John-Doe";
        description = "Nextcloud username";
      };
      password = mkOption {
        type = types.str;
        example = "SomePassw0rdExample";
        description = "Nextcloud password";
      };
      url = mkOption {
        type = types.str;
        example = "https://my.nextcloud.server/";
        description = "Nextcloud url";
      };
      localFolder = mkOption {
        type = types.str;
        example = "/Nextcloud/folder/";
        description = "Local folder path";
      };
    };

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

    config = {
      publicRepo = mkOption {
        type = types.str;
        example = "infrastructure";
        description = "Public repo containing config";
      };
      privateRepo = mkOption {
        type = types.str;
        example = "infrastructure-private";
        description = "Private repo containing config";
      };
    };

    ssh = {
      publicKeys = mkOption {
        type = with types; listOf str;
        example = [ "ssh-ed25519 AAAABBBBCCCCDDDDEEEEFFFFGGGGHHHHIIIIJJJJKKKKLLLLMMMMNNNNOOOOPPPPQQQQ" ];
        description = "Public SSH keys to allow access to";
      };
      ports = mkOption {
        type = with types; listOf port;
        example = [ "[ 22 ]" ];
        description = "Specifies on which ports the SSH daemon listens.";
      };
      deploymentPort = mkOption {
        type = types.port;
        example = [ "22" ];
        description = "Specifies on which port NixOps should deploy.";
      };
    };
    gpg.publicKey.fingerprint = mkOption {
      type = types.strMatching "[[:alnum:]]{40}";
      description = "GPG key fingerprint";
    };

    network = {
      DNS = mkOption {
        type = types.listOf types.str;
        description = "The list of nameservers. It can be left empty if it is auto-detected.";
      };
      fallbackDNS = mkOption {
        type = types.listOf types.str;
        description = "The list of fallback nameservers. It can be left empty if it is auto-detected.";
      };
    };

    wireguard = {
      client = {
        publicKey = mkOption {
          type = types.str;
          description = "Wireguard public key";
        };
        privateKey = mkOption {
          type = types.str;
          description = "Wireguard private key";
        };
        endpointIp = mkOption {
          type = types.str;
          description = "Wireguard endpoint ip";
        };
        endpointPort = mkOption {
          type = types.str;
          description = "Wireguard endpoint port";
        };
        address = mkOption {
          type = types.listOf types.str;
          description = "The IP addresses of the interface";
        };
        dns = mkOption {
          type = types.listOf types.str;
          description = "The IP addresses of the DNS servers";
        };
      };
      server = {
        externalInterface = mkOption {
          type = types.str;
          description = "External interface";
        };
        internalInterfaces = mkOption {
          type = types.listOf types.str;
          description = "Internal interfaces";
        };
        port = mkOption {
          type = types.int;
          example = 51820;
          description = "Port Wireguard server listens to";
        };
        ips = mkOption {
          type = types.listOf types.str;
          description = "IP address and subnet of the server's end of the tunnel interface";
        };
        privateKey = mkOption {
          type = types.str;
          description = "Private key";
        };
        peers = {
          publicKey = mkOption {
            type = types.str;
            description = "Public key of the peer ";
          };
          allowedIPs = mkOption {
            type = types.listOf types.str;
            description = "List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.";
          };
        };
      };
    };

    firefox.profile = mkOption {
      type = types.str;
      example = "abcdef12.default";
      description = "Firefox profile name";
    };

    font = {
      name = mkOption {
        type = types.str;
        example = "DejaVu Sans Mono Nerd Font";
        description = "Font";
      };
      size = mkOption {
        type = types.str;
        example = "11";
        description = "Font size";
      };
    };

    bar.font = {
      name = mkOption {
        type = types.str;
        example = "FontAwesome";
        description = "Font in i3status";
      };
      size = mkOption {
        type = types.str;
        example = "12";
        description = "Font size in i3status";
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
