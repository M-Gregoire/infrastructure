{ pkgs, config, lib, ... }:

{
  imports = [
    ../../vendor/infrastructure-private/resources/home/aliases.nix
  ];

  home.packages = with pkgs; [
    kitty
    bat
  ];

  xdg.configFile."kitty/kitty.conf".source = ../../dotfiles/kitty/kitty.conf;

  programs = {
    zsh = {
      enable = true;
      plugins = [
        {
          name = "base16-shell";
          src =  ./../../vendor/base16-shell;
        }
      ];
      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [
        "sudo"
        "git"
      ];
      oh-my-zsh.theme = "agnoster";
      enableCompletion = true;

      shellAliases = {
        tmux="tmux -2";
        copy="rsync --progress -h";
        copyFolder="rsync --progress -hrtva";
        resumeFolderCopy="rsync --progress --append-verify -hrtva";
        search="find / -name";
        removeExif="exiftool -all=";
        viewExif="identify -verbose";
        icat="kitty +kitten icat";
        # Really clear the terminal
        clear="tput reset";
        myip="curl ifconfig.co";
        myip4="curl -4 ifconfig.co";
        myip6="curl -6 ifconfig.co";
        weather="curl http://wttr.in/paris";
        restartWifi="nmcli radio wifi off && nmcli radio wifi on";
        restartNetwork="nmcli networking off && nmcli networking on";
        restartVPN="sudo systemctl restart wireguard-wg0.service";
        compressJpg="mogrify -quality 50";
        compressPdf="gs  -q -dNOPAUSE -dBATCH -dSAFER -sDEVICE=pdfwrite -dCompatibilityLevel=1.3 -dPDFSETTINGS=/screen -dEmbedAllFonts=true -dSubsetFonts=true -dColorImageDownsampleType=/Bicubic -dColorImageResolution=72 -dGrayImageDownsampleType=/Bicubic -dGrayImageResolution=72 -dMonoImageDownsampleType=/Bicubic -dMonoImageResolution=72 -sOutputFile=$2 $1";
        getMimeType="file -b --mime-type";
      };

      initExtra = ''
        khal && $SCRIPTS/showTodo.sh
        # https://github.com/gopasspw/gopass/issues/585#issuecomment-355339632
        source <(gopass completion zsh | head -n -1 | tail -n +2)
        compdef _gopass gopass
      '';
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
