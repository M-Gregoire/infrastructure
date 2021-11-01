{ config, ... }:

{
  xdg.configFile."wpg/templates/dunstrc.base".text = ''
    [colors]
    	background = "{color8}"
    	foreground = "{color15}"

    [global]
        monitor = 0
        follow = mouse
        indicate_hidden = yes
        shrink = yes
        transparency = 0
        notification_height = 0
        separator_height = 3
        padding = 10
        horizontal_padding = 10
        frame_width = 3

        frame_color = "{active}"
        separator_color = auto
        sort = yes
        idle_threshold = 120

        geometry = "600x15-0+20"

        ### Text ###
        font = DejaVu Sans Mono Nerd Font 13
        line_height = 5

        markup = full

        # The format of the message.  Possible variables are:
        #   %a  appname
        #   %s  summary
        #   %b  body
        #   %i  iconname (including its path)
        #   %I  iconname (without its path)
        #   %p  progress value if set ([  0%] to [100%]) or nothing
        #   %n  progress value if set without any extra characters
        #   %%  Literal %
        # Markup is allowed
        allow_markup = yes
        format = "%s\n%b"
        alignment = left
        show_age_threshold = 60
        word_wrap = yes
        ignore_newline = no
        stack_duplicates = true
        hide_duplicate_count = false
        show_indicators = yes
        bounce_freq = 0

        ### Icons ###
        icon_position = left
        max_icon_size = 64
        icon_path = /home/${config.resources.username}/.nix-profile/share/icons/hicolor/256x256/apps/:/home/${config.resources.username}/.nix-profile/share/icons/Papirus-Dark/48x48@2x/status/

        ### History ###
        sticky_history = yes
        history_length = 20

        ### Misc/Advanced ###
        dmenu = /usr/bin/rofi -show run -p dunst:
        browser = firefox -new-tab
        always_run_script = true
        title = Dunst
        class = Dunst
        startup_notification = false
        force_xinerama = false

    [experimental]
        per_monitor_dpi = false

    [shortcuts]
        close = ctrl+space
        close_all = ctrl+shift+space
        context = ctrl+shift+period
        #history = ctrl+shift

    [urgency_low]
        background = colors.background
        foreground = colors.foreground
        timeout = 5

    [urgency_normal]
        background = colors.background
        foreground = colors.foreground
        timeout = 5

    [urgency_critical]
        background = "{color1}"
        foreground = colors.foreground
        frame_color = "{color9}"
        timeout = 0

    [Spotify]
        appname = Spotify
        format = "<b>Now Playing:</b>\n%s\n%b"
        new_icon = spotify-client
        timeout = 10
      '';
}
