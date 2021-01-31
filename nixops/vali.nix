{
  vali =
    { config, pkgs, ... }:
    {
      deployment = {
        targetHost = "${config.resources.hosts.vali.hostname}.${config.resources.domain}";
        targetPort = config.resources.hosts.vali.ssh.port;
      };
    };
}
