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

  screenshot = "${config.resources.paths.home}/Screenshots/";

in

{
  imports = [
    ./i3-polybar.nix
  ];

  # Import pywal config in xresources
  xresources.extraConfig = ''#include "${config.resources.paths.home}/.cache/wal/colors.Xresources"'';

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
    rofi
    # Remove urgency
    wmctrl
    # Lock screen
    i3lock-fancy
    # Auto lock after inactivity
    xidlehook
    # Change brightness of screen
    xorg.xbacklight
    # redshift
    # Not running as a service as there is no command available to change the brightness of the screen
    # redshift
    # xidlehook script
    bc
    # Theme based on wallpaper
    pywal
    # Create GTK Theme with pywal
    wpgtk
    # Live GTK+ reload
    xsettingsd
    # Notifications
    dunst
  ];

  xsession = {
    enable = true;
    windowManager.i3.enable = true;
    windowManager.i3.package = pkgs.i3-gaps;

    windowManager.i3.config = {
      fonts = [ "${config.resources.font.name} ${config.resources.font.size}" ];
      # Use pywal
      colors = {
        focused = {
          background   = "$bg";
          border       = "$bg";
          indicator    = "$bg";
          text         = "$fg";
          childBorder  = "$bg";
        };
        unfocused = {
          background   = "$bg";
          border       = "$bg";
          indicator    = "$bg";
          text         = "$fg";
          childBorder  = "$bg";
        };
        focusedInactive = {
          background   = "$bg";
          border       = "$bg";
          indicator    = "$bg";
          text         = "$fg";
          childBorder  = "$bg";
        };
        urgent = {
          background   = "$bg";
          border       = "$bg";
          indicator    = "$bg";
          text         = "$fg";
          childBorder  = "$bg";
        };
        placeholder = {
          background   = "$bg";
          border       = "$bg";
          indicator    = "$bg";
          text         = "$fg";
          childBorder  = "$bg";
        };
        background     = "$bg";
      };
      assigns = {
        # Use xprop
        "${workspace1}" = [{class="Firefox";}];
        "${workspace8}" = [{class="rambox";}];
        "${workspace9}" = [{class="Thunderbird";} {class="Daily";}];
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
        "${modifier}+d" = "exec /home/${config.resources.username}/.config/rofi/launchers/launcher.sh";
        "${modifier}+Shift+s" = "exec /home/${config.resources.username}/.config/rofi/scripts/menu_powermenu.sh";
        "${modifier}+Shift+x" = "exec i3lock-fancy";
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
        "F2" = "exec --no-startup-id ${config.resources.paths.scripts}/switchSoundCard.sh";
        "F12" = "exec --no-startup-id ${config.resources.paths.scripts}/hidePolybar.sh";
        "Scroll_Lock" = "exec --no-startup-id $SCRIPTS/kbdLayout.sh";
        "Print" = "exec --no-startup-id scrot -e 'mv $f ${screenshot}' && notify-send 'Screenshot taken'";
        "--release ${modifier}+Print" = "exec --no-startup-id scrot -s -e 'mv $f ${screenshot}' && notify-send 'Screenshot taken'";
        # Disable Control+q in Firefox
        "Group1+${modifier}+Control+q" = "exec --no-startup-id ${config.resources.paths.scripts}/noCTRLqFirefox.sh";
        "Group2+${modifier}+Control+q" = "exec --no-startup-id ${config.resources.paths.scripts}/noCTRLqFirefox.sh";
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
        outer=1;
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
        { command = "${config.resources.pcs.browser}"; always = false; notification = false; }
        { command = "${config.resources.pcs.mailer}"; always = false; notification = false; }
        { command = "spotify"; always = false; notification = false; }
        # Set random wallpaper and generate theme based on it
        { command =  "${config.resources.paths.scripts}/theme.sh ${config.resources.paths.wallpaper.folder} ${config.resources.paths.wallpaper.current}"; always = true; notification = false; }
        { command = "${config.resources.paths.scripts}/xidlehook.sh"; always = false; notification = false; }
        # No screen saver
        { command = "xset s off"; always = false; notification = false; }
        # Remove all urgencies on startup
        { command = "sleep ${wait-for-urgency}; for win in $(wmctrl -l | awk -F' ' '{print $1}'); do wmctrl -i -r $win -b remove,demands_attention; done"; always = false; notification = false; }
        # Polybar
        { command = "${config.resources.paths.scripts}/polybar.sh"; always = true; notification = false; }
        # Spotify in Polybar
        { command = "/usr/bin/env python3 ${config.resources.paths.publicConfig}/vendor/polybar-spotify-controls/scripts/spotify/py_spotify_listener.py"; always = false; notification = false; }
        # Xbanish to hide mouse if unused
        { command = "xbanish"; always = false; notification = false; }
        # Dunst
        { command = "${config.resources.paths.scripts}/dunst.sh"; always = true; notification = false; }
      ];
    };
    windowManager.i3.extraConfig = ''
      exec --no-startup-id i3-msg "workspace ${workspace2}; append_layout ${config.resources.paths.publicDotfiles}/i3/layouts/kitty.json" && kitty
      exec --no-startup-id i3-msg "workspace ${workspace3}; append_layout ${config.resources.paths.publicDotfiles}/i3/layouts/emacs.json" &&  while ! $DOOM/bin/emacsclient -s /run/user/1000/emacs/main -ca false; do sleep 2; done;
      exec --no-startup-id i3-msg "workspace ${workspace4}; append_layout ${config.resources.paths.publicDotfiles}/i3/layouts/thunar.json" && thunar
    '';
  };
}
