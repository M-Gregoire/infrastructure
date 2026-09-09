{
  config,
  configName,
  lib,
  pkgs,
  private-config,
  ...
}:

let
  isMaster = configName == "hades-1";
  upsName = "eaton5px";
  masterAddr = "192.168.3.31";
  upsAddr = "192.168.5.31";
  unasProAddr = "192.168.3.30";

  # Script called by upsmon on UPS events (master only).
  # Shuts down the UNAS Pro on low battery before hades-1 goes down.
  notifyCmd = pkgs.writeShellScript "nut-notify" ''
    case "$NOTIFYTYPE" in
      LOWBATT|FSD)
        ${pkgs.openssh}/bin/ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no \
          root@${unasProAddr} "shutdown -h now 'UPS low battery'" &
        ;;
    esac
  '';
in
{
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."nut/upsmon_password" = {
    sopsFile = builtins.toPath "${private-config}/secrets/hades.yaml";
    mode = "0400";
  };

  power.ups = {
    enable = true;
    mode = if isMaster then "netserver" else "netclient";

    # UPS driver — master only (talks to the Eaton via SNMP/XML)
    ups = lib.mkIf isMaster {
      ${upsName} = {
        driver = "netxml-ups";
        port = "http://${upsAddr}";
        description = "Eaton 5PX2200";
        directives = [
          "pollinterval = 10"
        ];
      };
    };

    # upsd — listen on all interfaces on master
    upsd.listen = lib.mkIf isMaster [
      {
        address = "0.0.0.0";
        port = 3493;
      }
    ];

    # upsd user for upsmon authentication — master only
    users = lib.mkIf isMaster {
      upsmon = {
        passwordFile = config.sops.secrets."nut/upsmon_password".path;
        upsmon = "primary";
      };
    };

    # upsmon — runs on all nodes
    upsmon = {
      monitor.${upsName} = {
        system =
          if isMaster then "${upsName}@localhost" else "${upsName}@${masterAddr}:3493";
        powerValue = 1;
        user = "upsmon";
        passwordFile = config.sops.secrets."nut/upsmon_password".path;
        type = if isMaster then "master" else "slave";
      };
      settings = {
        DEADTIME = 15;
        FINALDELAY = 5;
        POLLFREQ = 5;
        POLLFREQALERT = 5;
      } // lib.optionalAttrs isMaster {
        NOTIFYCMD = notifyCmd;
        NOTIFYFLAG = [
          [ "LOWBATT" "SYSLOG+EXEC" ]
          [ "FSD" "SYSLOG+EXEC" ]
          [ "ONBATT" "SYSLOG" ]
          [ "ONLINE" "SYSLOG" ]
        ];
      };
    };
  };

  # Ensure /var/lib/nut exists before drivers start — the NixOS module
  # relies on systemd StateDirectory but upsdrvctl runs outside that context.
  systemd.tmpfiles.rules = [
    "d /var/lib/nut 0750 nut nut -"
  ];

  # Open NUT port on master for slave connections and Home Assistant
  networking.firewall.allowedTCPPorts = lib.mkIf isMaster [ 3493 ];
}
