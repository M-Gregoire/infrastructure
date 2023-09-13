{ config, lib, newScope, kodi, libretro }:

with lib;

let inherit (libretro) genesis-plus-gx mgba snes9x;

in let
  self = rec {

    addonDir = "/share/kodi/addons";
    rel = "Matrix";

    callPackage = newScope self;

    inherit kodi;

    # Convert derivation to a kodi module. Stolen from ../../../top-level/python-packages.nix
    toKodiAddon = drv:
      drv.overrideAttrs (oldAttrs: {
        # Use passthru in order to prevent rebuilds when possible.
        passthru = (oldAttrs.passthru or { }) // {
          kodiAddonFor = kodi;
          requiredKodiAddons = requiredKodiAddons drv.propagatedBuildInputs;
        };
      });

    # Check whether a derivation provides a Kodi addon.
    hasKodiAddon = drv: drv ? kodiAddonFor && drv.kodiAddonFor == kodi;

    # Get list of required Kodi addons given a list of derivations.
    requiredKodiAddons = drvs:
      let modules = filter hasKodiAddon drvs;
      in unique
      (modules ++ concatLists (catAttrs "requiredKodiAddons" modules));

    # package update scripts

    addonUpdateScript =
      callPackage ../applications/video/kodi/addons/addon-update-script { };

    # package builders

    buildKodiAddon =
      callPackage ../applications/video/kodi/build-kodi-addon.nix { };

    buildKodiBinaryAddon =
      callPackage ../applications/video/kodi/build-kodi-binary-addon.nix { };

    # regular packages

    kodi-platform =
      callPackage ../applications/video/kodi/addons/kodi-platform { };

    # addon packages
    invidious-test = callPackage ./invidious.nix { };
  };
in self // lib.optionalAttrs config.allowAliases { }
