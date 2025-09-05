{ pkgs, ... }:

{
  security.pam.services.smart-card.text = ''
    auth       sufficient pam_pkcs11.so
  '';
}
