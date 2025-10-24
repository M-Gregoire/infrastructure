{ config, lib, pkgs, flake-root, hostname, ... }:

{

  sops.defaultSopsFile = builtins.toPath "${flake-root}/secrets/datadog.yaml";
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets."datadog/hades-cluster/api_secret" = {
    mode = "0440";
    owner = config.systemd.services.datadog-agent.serviceConfig.User;
    group = config.systemd.services.datadog-agent.serviceConfig.Group;
  };

  sops.templates."datadog_env" = {
    content = ''
      DD_API_KEY="${config.sops.placeholder."datadog/hades-cluster/api_secret"}"
    '';
    owner = config.systemd.services.datadog-agent.serviceConfig.User;
  };

  systemd.services.datadog-agent = {
    serviceConfig = {
      EnvironmentFile = "${config.sops.templates."datadog_env".path}";
    };
  };

  services.datadog-agent = {
    enable = true;
    site = "datadoghq.eu";
    hostname = hostname;
    # This should work but the API key is not taken into account.
    # So I use EnvironmentFile to specify DD_API_KEY in the systemd service.
    apiKeyFile =
      "${config.sops.secrets."datadog/hades-cluster/api_secret".path}";

    tags = [ "env:prod" "role:host" ];
    extraConfig = {
      logs_enabled = true;
      logs_config.use_http = true;
    };
    checks.journald = {
      logs = [{
        type = "journald";
        path = "/var/log/journal";
        # include_units = [ "sshd.service" "k3s.service" ];
        service = "system"; # tag 'service:system' on these entries
        source = "journald";
      }];
    };

  };

  systemd.services.datadog-agent.serviceConfig.SupplementaryGroups =
    [ "systemd-journal" ];
  # users.users.datadog.extraGroups = [ "systemd-journal" ];
}
