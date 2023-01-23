{
  allowBroken = false;
  allowUnfree = true;
  allowUnfreeRedistributable = true;

  # Nixops
  permittedInsecurePackages = [
    "python2.7-certifi-2021.10.8"
    "python2.7-pyjwt-1.7.1"
  ];

  packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball
      "https://github.com/nix-community/NUR/archive/master.tar.gz") {
        inherit pkgs;
      };
  };
}
