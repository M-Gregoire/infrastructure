{ config, pkgs, lib, ... }:

let

  modifier = "Mod4";
  floating-modifier = "Mod4";

  wait-for-urgency = "15";

  workspace1 = "1";
  workspace2 = "2";
  workspace3 = "3";
  workspace4 = "4";
  workspace5 = "5";
  workspace6 = "6";
  workspace7 = "7";
  workspace8 = "8";
  workspace9 = "9";
  workspace10 = "10";

  screenshot = "${config.home.sessionVariables.HOME}/Screenshots/";

  i3Theme = import ./theme/i3.nix {
    theme=config.resources.theme;
    withBorder=false;
    overrideIndicator="00FF00";
  };

in

{

  imports = [
    ./i3-polybar.nix
  ];

  home.packages = with pkgs; [
    # Manage acpi events
    acpi
    # Temperature and fans
    lm_sensors
    # Displays management
    arandr
    # Get key inputs
    xorg.xev
    # Notification (notify-send)
    libnotify
    # D-menu replacement
    albert
    # Remove urgency
    wmctrl
    # Auto lock
    xautolock
  ];

  xdg.configFile."i3/layouts".source = ../dotfiles/i3/layouts;

  xsession = {
    enable = true;
    windowManager.i3.enable = true;
    windowManager.i3.package = pkgs.i3-gaps;

   windowManager.i3.config = {
     fonts = [ "${config.resources.font.name} ${config.resources.font.size}" ];
     colors = i3Theme;
     assigns = {
       # Use xprop
       "${workspace1}" = [{class="Firefox";}];
       "${workspace3}" = [{class="Emacs";}];
       "${workspace7}" = [{class="KeePass"; title="Open Database - Passwords.kdbx";} {class="KeePass"; title="Passwords.kdbx - KeePass";}];
       "${workspace8}" = [{class="rambox";}];
       "${workspace9}" = [{class="Thunderbird";}];
     };

     keybindings = {
        # Basic actions
        # https://faq.i3wm.org/question/118/mouse-cursor-remains-waiting-after-closing-last-tile.1.html
        "${modifier}+Return" = "exec --no-startup-id i3-sensible-terminal";
        "${modifier}+Shift+f" = " exec --no-startup-id firefox";
        "${modifier}+Shift+c" = " reload";
        "${modifier}+Shift+r" = " restart";
        "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
        "Group1+${modifier}+Shift+a" = "kill";
        "Group2+${modifier}+Shift+a" = "kill";
        "${modifier}+d" = "exec albert show";
        "${modifier}+Shift+s" = "exec $SCRIPTS/shutdownMenu.sh";
        "${modifier}+Shift+x" = "exec dm-tool lock";
        # Basic movements/focus
        "${modifier}+j" = "focus left";
        "${modifier}+k" = "focus down";
        "${modifier}+i" = "focus up";
        "${modifier}+l" = "focus right";
        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";
        "${modifier}+Shift+j" = "move left";
        "${modifier}+Shift+k" = "move down";
        "${modifier}+Shift+l" = "move up";
        "${modifier}+Shift+m" = "move right";
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+h" = "split h";
        "${modifier}+v" = "split v";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+s" = "layout stacking";
        "${modifier}+z" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";
        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";
        "${modifier}+q" = "focus parent";
        # Media bindings
        "XF86AudioRaiseVolume" = "exec --no-startup-id pulseaudio-ctl up";
        "XF86AudioLowerVolume" = "exec --no-startup-id pulseaudio-ctl down";
        "XF86AudioMute" = "exec --no-startup-id pulseaudio-ctl mute";
        "XF86AudioPlay" = "exec --no-startup-id dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
        "XF86AudioPause" = "exec --no-startup-id dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
        "XF86AudioNext" = "exec --no-startup-id dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next";
        "XF86AudioPrev" = "exec --no-startup-id dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous";
        # Modes
        "${modifier}+r" = "mode \"resize\"";
        "${modifier}+m" = " focus floating; mode \"moveit\"";
        # Functions
        "F1" = "exec --no-startup-id mono ${pkgs.keepass.out}/lib/dotnet/keepass/KeePass.exe --auto-type";
        "F2" = "exec --no-startup-id $SCRIPTS/switchSoundCard.sh";
        "Escape" = "exec --no-startup-id $SCRIPTS/hidePolybar.sh";
        "Scroll_Lock" = "exec --no-startup-id $SCRIPTS/kbdLayout.sh";
        "Print" = "exec --no-startup-id scrot -e 'mv $f ${screenshot}' && notify-send 'Screenshot taken'";
        "--release ${modifier}+Print" = "exec --no-startup-id scrot -s -e 'mv $f ${screenshot}' && notify-send 'Screenshot taken'";
        # Disable Control+q in Firefox
        "Group1+${modifier}+Control+q" = "exec --no-startup-id $SCRIPTS/noCTRLqFirefox.sh";
        "Group2+${modifier}+Control+q" = "exec --no-startup-id $SCRIPTS/noCTRLqFirefox.sh";
        # Change workspace
        "Group1+${modifier}+1" = "workspace ${workspace1}";
        "Group1+${modifier}+2" = "workspace ${workspace2}";
        "Group1+${modifier}+3" = "workspace ${workspace3}";
        "Group1+${modifier}+4" = "workspace ${workspace4}";
        "Group1+${modifier}+5" = "workspace ${workspace5}";
        "Group1+${modifier}+6" = "workspace ${workspace6}";
        "Group1+${modifier}+7" = "workspace ${workspace7}";
        "Group1+${modifier}+8" = "workspace ${workspace8}";
        "Group1+${modifier}+9" = "workspace ${workspace9}";
        "Group1+${modifier}+0" = "workspace ${workspace10}";
        "Group2+${modifier}+exclam" = "workspace ${workspace1}";
        "Group2+${modifier}+at" = "workspace ${workspace2}";
        "Group2+${modifier}+numbersign" = "workspace ${workspace3}";
        "Group2+${modifier}+dollar" = "workspace ${workspace4}";
        "Group2+${modifier}+percent" = "workspace ${workspace5}";
        "Group2+${modifier}+asciicircum" = "workspace ${workspace6}";
        "Group2+${modifier}+ampersand" = "workspace ${workspace7}";
        "Group2+${modifier}+asterisk" = "workspace ${workspace8}";
        "Group2+${modifier}+parenleft" = "workspace ${workspace9}";
        "Group2+${modifier}+parenright" = "workspace ${workspace10}";
        # Move containers
        "Group1+${modifier}+Shift+1" = "move container to workspace ${workspace1}";
        "Group1+${modifier}+Shift+2" = "move container to workspace ${workspace2}";
        "Group1+${modifier}+Shift+3" = "move container to workspace ${workspace3}";
        "Group1+${modifier}+Shift+4" = "move container to workspace ${workspace4}";
        "Group1+${modifier}+Shift+5" = "move container to workspace ${workspace5}";
        "Group1+${modifier}+Shift+6" = "move container to workspace ${workspace6}";
        "Group1+${modifier}+Shift+7" = "move container to workspace ${workspace7}";
        "Group1+${modifier}+Shift+8" = "move container to workspace ${workspace8}";
        "Group1+${modifier}+Shift+9" = "move container to workspace ${workspace9}";
        "Group1+${modifier}+Shift+0" = "move container to workspace ${workspace10}";
        "Group2+${modifier}+Shift+exclam" = "move container to workspace ${workspace1}";
        "Group2+${modifier}+Shift+at" = "move container to workspace ${workspace2}";
        "Group2+${modifier}+Shift+numbersign" = "move container to workspace ${workspace3}";
        "Group2+${modifier}+Shift+dollar" = "move container to workspace ${workspace4}";
        "Group2+${modifier}+Shift+percent" = "move container to workspace ${workspace5}";
        "Group2+${modifier}+Shift+asciicircum" = "move container to workspace ${workspace6}";
        "Group2+${modifier}+Shift+ampersand" = "move container to workspace ${workspace7}";
        "Group2+${modifier}+Shift+asterisk" = "move container to workspace ${workspace8}";
        "Group2+${modifier}+Shift+parenleft" = "move container to workspace ${workspace9}";
        "Group2+${modifier}+Shift+parenright" = "move container to workspace ${workspace10}";
      };

      bars = [
      ];

      gaps = {
        inner=5;
        outer=0;
        smartBorders="on";
        smartGaps=true;
      };

      floating = {
        criteria = [
          #{ class = "feh"; }
        ];
      };

      focus.followMouse = false;

      window = {
        hideEdgeBorders = "both";
        titlebar = false;

        commands =  [
          { command = "move to workspace ${workspace10}"; criteria = { class = "Spotify"; } ; }
        ];
      };

      modes = {
        resize = {
          # Pressing left will shrink the window’s width.
          # Pressing right will grow the window’s width.
          # Pressing up will shrink the window’s height.
          # Pressing down will grow the window’s height.
          "j" = "resize shrink width 10 px or 10 ppt";
          "k" = "resize grow height 10 px or 10 ppt";
          "l" = "resize shrink height 10 px or 10 ppt";
          "m" = "resize grow width 10 px or 10 ppt";

          # Same bindings, but for the arrow keys
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";

          # Back to normal: Enter or Escape
          "Return" = "mode \"default\"";
          "Escape" = "mode \"default\"";
        };

        "moveit" = {
          "Up" = "move up 20px";
          "Left" = "move left 20px";
          "Down" = "move down 20px";
          "Right" = "move right 20px";
          "${modifier}+m" ="mode \"default\"";
        };
      };

      startup = [
        { command = "${config.resources.browser}"; always = false; notification = false; }
        { command = "${config.resources.mailer}"; always = false; notification = false; }
        { command = "spotify"; always = false; notification = false; }
        { command = "compton"; always = false; notification = false; }
        # Same random wallpaper on two screens with different resolution
        { command =  "$SCRIPTS/randWallpaper.sh"; always = true; notification = false; }
        { command = "albert"; always = false; notification = false; }
        #{ command = "xautolock -time 4 -locker 'dm-tool lock' &"; always = false; notification = false; }
        # No screen saver
        { command = "xset s off"; always = false; notification = false; }
        { command = "mkdir -p ${screenshot}"; always = false; notification = false; }
        { command = "emacs --daemon && emacsclient -c"; always = false; notification = false; }
        { command = "keepass ${config.resources.keepass.db} -preselect:${config.resources.keepass.key}"; always = false; notification = false; }
        #{ command = "udiskie"; always = false; notification = false; }
        # Allow accents using ralt
        { command = "setxkbmap -layout us -option compose:ralt"; always = false; notification = false; }
        # Remove all urgencies on startup
        { command = "sleep ${wait-for-urgency}; for win in $(wmctrl -l | awk -F' ' '{print $1}'); do wmctrl -i -r $win -b remove,demands_attention; done"; always = false; notification = false; }
        # Polybar
        { command = "$SCRIPTS/polybar.sh"; always = true; notification = false; }
        # Spotify in Polybar
        { command = "/usr/bin/env python3 $SCRIPTS/polybar-spotify-controls/scripts/spotify/py_spotify_listener.py"; always = false; notification = false; }
      ];
    };
    windowManager.i3.extraConfig = ''
      exec --no-startup-id i3-msg "workspace ${workspace2}; append_layout $HOME/.config/i3/layouts/kitty.json" && $TERMINAL
      exec --no-startup-id i3-msg "workspace ${workspace4}; append_layout $HOME/.config/i3/layouts/thunar.json" && thunar
    '';
  };
}
