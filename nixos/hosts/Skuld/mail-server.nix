{ config, pkgs, ... }:
{
  imports = [
    (builtins.fetchTarball {
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/v2.2.0/nixos-mailserver-v2.2.0.tar.gz";
      sha256 = "0gqzgy50hgb5zmdjiffaqp277a68564vflfpjvk1gv6079zahksc";
    })
  ];


  # Use to generate passwords
  environment.systemPackages = with pkgs; [ mkpasswd ];

  mailserver = {
    enable = true;
    fqdn = "${config.resources.email.backup.fqdn}";
    #domains = [ "example.com" "example2.com" ];
    loginAccounts = {
        "${config.resources.email.backup.account}" = {
            # Obtained using mkpasswd -m sha-512 "pass"
            hashedPassword = "${config.resources.email.backup.hashedPassword}";
        };
    };
    # Enable IMAP and POP3
    enableImap = true;
    enablePop3 = false;
    enableImapSsl = true;
    enablePop3Ssl = false;

    # Enable the ManageSieve protocol
    enableManageSieve = false;

    # whether to scan inbound emails for viruses (note that this requires at least
    # 1 Gb RAM for the server. Without virus scanning 256 MB RAM should be plenty)
    virusScanning = false;

    # Don't use kresd which binds to port 53 and prevents dnsmasq from running
    localDnsResolver = false;
  };
}
