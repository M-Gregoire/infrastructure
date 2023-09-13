{ lib, buildKodiAddon, fetchFromGitHub }:
buildKodiAddon rec {
  pname = "catchuptvandmore";
  namespace = "plugin.video.catchuptvandmore";
  version = "master";

  src = fetchFromGitHub rec {
    owner = "Catch-up-TV-and-More";
    repo = "plugin.video.catchuptvandmore";
    rev = "85357137b5d5b36551c24fef2b45e5e48b7ca1d7";
    sha256 = "1fj3ry5s44nf1jzxk4bmnpa4b9p23nrpmpj2a4i6xf94h7jl7p5k";
  };

  propagatedBuildInputs = [ ];

  meta = with lib; {
    homepage = "https://catch-up-tv-and-more.github.io/";
    description = "Replay, Live TV and websites videos addon for Kodi";
    longDescription = ''
      Catch-Up TV & More is a video addon for the Kodi media center (former XBMC). This plugin brings together all the videos of the various services and channels of catch-up TV. Furthermore, this addon allows you to quickly access the videos and content offered by certain websites. Catch-Up TV & More is compatible with Kodi "17 Krypton" and higher versions.
    '';
    license = licenses.gpl2Only;
    maintainers = teams.kodi.members;
  };
}
