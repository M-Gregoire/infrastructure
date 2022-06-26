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

in {
  imports = [ ./i3-polybar.nix ];

  # Import pywal config in xresources
  xresources.extraConfig =
    ''#include "${config.resources.paths.home}/.cache/wal/colors.Xresources"'';

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
      fonts = {
        names = [ "${config.resources.font.name}" ];
        size = config.resources.font.size;
      };
      # Use pywal
      # Based on https://github.com/dylanaraps/pywal/wiki/Customization#i3
      # + my interpretation of https://github.com/base16-project/base16/blob/main/styling.md
      colors = {
        focused = {
          background = "$color0";
          border = "$color2";
          indicator = "$color0";
          text = "$color7";
          childBorder = "$color2";
        };
        unfocused = {
          background = "$color0";
          border = "$color0";
          indicator = "$color0";
          text = "$color7";
          childBorder = "$color0";
        };
        focusedInactive = {
          background = "$color0";
          border = "$color0";
          indicator = "$color0";
          text = "$color7";
          childBorder = "$color0";
        };
        urgent = {
          background = "$color0";
          border = "$color1";
          indicator = "$color0";
          text = "$color7";
          childBorder = "$color1";
        };
        placeholder = {
          background = "$color0";
          border = "$color0";
          indicator = "$color0";
          text = "$color7";
          childBorder = "$color0";
        };
        background = "$color0";
      };
      assigns = {
        # Use xprop
        "${workspace1}" = [{ class = "firefox"; }];
        "${workspace9}" = [{ class = "Thunderbird"; }];
      };

      defaultWorkspace = "workspace ${workspace1}";

      keybindings = {
        # Basic actions
        # https://faq.i3wm.org/question/118/mouse-cursor-remains-waiting-after-closing-last-tile.1.html
        "${modifier}+Return" = "exec --no-startup-id i3-sensible-terminal";
        "${modifier}+Shift+f" = " exec --no-startup-id firefox";
        # "${modifier}+Shift+c" = " reload";
        "${modifier}+Shift+r" = " restart";
        "${modifier}+Shift+e" =
          "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
        "${modifier}+Shift+a" = "kill";
        "${modifier}+d" =
          "exec color='nordic' theme='ribbon_left_round' /home/${config.resources.username}/.config/rofi/launchers/ribbon/launcher.sh";
        "${modifier}+Shift+s" =
          "exec theme='row_rounded' color='nordic' shutdown='襤' reboot='ﰇ' lock='' suspend='⏾' logout='' /home/${config.resources.username}/.config/rofi/powermenu/powermenu.sh";
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
        # Dunst
        "${modifier}+c" = "exec ${pkgs.dunst}/bin/dunstctl close";
        "${modifier}+shift+c" = "exec ${pkgs.dunst}/bin/dunstctl close-all";
        # Media bindings
        "XF86AudioRaiseVolume" = "exec --no-startup-id pamixer -i 5";
        "XF86AudioLowerVolume" = "exec --no-startup-id pamixer -d 5";
        "XF86AudioMute" = "exec --no-startup-id pamixer -t";
        "XF86AudioPlay" =
          "exec --no-startup-id dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
        "XF86AudioPause" =
          "exec --no-startup-id dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlayPause";
        "XF86AudioNext" =
          "exec --no-startup-id dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Next";
        "XF86AudioPrev" =
          "exec --no-startup-id dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Previous";
        # Modes
        "${modifier}+r" = ''mode "resize"'';
        "${modifier}+m" = " focus floating; mode \"moveit\"";
        # Functions
        "F2" =
          "exec --no-startup-id ${config.resources.paths.scripts}/switchSoundCard.sh";
        "F12" =
          "exec --no-startup-id ${config.resources.paths.scripts}/hidePolybar.sh";
        "Scroll_Lock" = "exec --no-startup-id $SCRIPTS/kbdLayout.sh";
        "Print" =
          "exec --no-startup-id scrot -e 'mv $f ${screenshot}' && notify-send 'Screenshot taken'";
        "--release ${modifier}+Print" =
          "exec --no-startup-id scrot -s -e 'mv $f ${screenshot}' && notify-send 'Screenshot taken'";
        # Disable Control+q in Firefox
        "${modifier}+Control+q" =
          "exec --no-startup-id ${config.resources.paths.scripts}/noCTRLqFirefox.sh";
        # Change workspace
        "${modifier}+1" = "workspace ${workspace1}";
        "${modifier}+2" = "workspace ${workspace2}";
        "${modifier}+3" = "workspace ${workspace3}";
        "${modifier}+4" = "workspace ${workspace4}";
        "${modifier}+5" = "workspace ${workspace5}";
        "${modifier}+6" = "workspace ${workspace6}";
        "${modifier}+7" = "workspace ${workspace7}";
        "${modifier}+8" = "workspace ${workspace8}";
        "${modifier}+9" = "workspace ${workspace9}";
        "${modifier}+0" = "workspace ${workspace10}";
        # Move containers
        "${modifier}+Shift+1" = "move container to workspace ${workspace1}";
        "${modifier}+Shift+2" = "move container to workspace ${workspace2}";
        "${modifier}+Shift+3" = "move container to workspace ${workspace3}";
        "${modifier}+Shift+4" = "move container to workspace ${workspace4}";
        "${modifier}+Shift+5" = "move container to workspace ${workspace5}";
        "${modifier}+Shift+6" = "move container to workspace ${workspace6}";
        "${modifier}+Shift+7" = "move container to workspace ${workspace7}";
        "${modifier}+Shift+8" = "move container to workspace ${workspace8}";
        "${modifier}+Shift+9" = "move container to workspace ${workspace9}";
        "${modifier}+Shift+0" = "move container to workspace ${workspace10}";
      };

      bars = [ ];

      gaps = {
        inner = 5;
        outer = 1;
        smartBorders = "on";
        smartGaps = true;
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

        commands = [{
          command = "move to workspace ${workspace10}";
          criteria = { class = "Spotify"; };
        }];
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
          "Return" = ''mode "default"'';
          "Escape" = ''mode "default"'';
        };

        "moveit" = {
          "Up" = "move up 20px";
          "Left" = "move left 20px";
          "Down" = "move down 20px";
          "Right" = "move right 20px";
          "${modifier}+m" = ''mode "default"'';
        };
      };

      startup = [
        #{ command = "${config.resources.pcs.browser}"; always = false; notification = false; }
        #{ command = "${config.resources.pcs.mailer}"; always = false; notification = false; }
        {
          command =
            "while ! systemctl is-active --quiet network-online.target; do sleep 3; done; spotify --force-device-scale-factor=${config.resources.screen.scaleFactor}";
          always = false;
          notification = false;
        }
        {
          command =
            "${config.resources.paths.scripts}/theme.sh ${config.resources.paths.wallpaper.folder} ${config.resources.paths.wallpaper.current} > /tmp/theme.sh.log 2>&1";
          always = true;
          notification = false;
        }
        {
          command = "${config.resources.paths.scripts}/xidlehook.sh";
          always = false;
          notification = false;
        }
        # No screen saver
        {
          command = "xset s off";
          always = false;
          notification = false;
        }
        # Remove all urgencies on startup
        {
          command =
            "sleep ${wait-for-urgency}; for win in $(wmctrl -l | awk -F' ' '{print $1}'); do wmctrl -i -r $win -b remove,demands_attention; done";
          always = false;
          notification = false;
        }
        # Polybar
        {
          command = "${config.resources.paths.scripts}/polybar.sh";
          always = true;
          notification = false;
        }
        # Spotify in Polybar
        {
          command =
            "while ! ps -aux | grep 'spotify'; do sleep 3; done; /usr/bin/env python3 ${config.resources.paths.publicConfig}/vendor/polybar-spotify-controls/scripts/spotify/py_spotify_listener.py";
          always = false;
          notification = false;
        }
        # Xbanish to hide mouse if unused
        {
          command = "xbanish";
          always = false;
          notification = false;
        }
      ];
    };
    windowManager.i3.extraConfig = ''
      exec --no-startup-id i3-msg "workspace ${workspace2}; append_layout ${config.resources.paths.publicDotfiles}/i3/layouts/kitty.json" && kitty
      exec --no-startup-id i3-msg "workspace ${workspace3}; append_layout ${config.resources.paths.publicDotfiles}/i3/layouts/emacs.json" &&  while ! ${pkgs.emacs}/bin/emacsclient -s /run/user/1000/emacs/main -ca false; do sleep 2; done;
      exec --no-startup-id i3-msg "workspace ${workspace4}; append_layout ${config.resources.paths.publicDotfiles}/i3/layouts/pcmanfm.json" && pcmanfm

      # Get color from Xresources
      # https://i3wm.org/docs/userguide.html#xresources
      # Defaults to ugly red so I can immediatelyly see there is an issue
      set_from_resource $color0 i3wm.color0 #FF0000
      set_from_resource $color1 i3wm.color1 #FF0000
      set_from_resource $color2 i3wm.color2 #FF0000
      set_from_resource $color3 i3wm.color3 #FF0000
      set_from_resource $color4 i3wm.color4 #FF0000
      set_from_resource $color5 i3wm.color5 #FF0000
      set_from_resource $color6 i3wm.color6 #FF0000
      set_from_resource $color7 i3wm.color7 #FF0000
      set_from_resource $color8 i3wm.color8 #FF0000
      set_from_resource $color9 i3wm.color9 #FF0000
      set_from_resource $color10 i3wm.color10 #FF0000
      set_from_resource $color11 i3wm.color11 #FF0000
      set_from_resource $color12 i3wm.color12 #FF0000
      set_from_resource $color13 i3wm.color13 #FF0000
      set_from_resource $color14 i3wm.color14 #FF0000
      set_from_resource $color15 i3wm.color15 #FF0000

      # Make sure all windows have border, to show they are focused
      # https://gist.github.com/lirenlin/9892945
      default_border pixel 1
      default_floating_border pixel 1
      # Above does not work with Kitty
      for_window [class="^kitty$"] border pixel 1
    '';
  };
}
