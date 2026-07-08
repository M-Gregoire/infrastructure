{ lib, ... }:

{
  programs.tmux = {
    enable = true;
    prefix = "C-a"; # Easier than default C-b
    baseIndex = 1; # Start windows/panes at 1 (more intuitive on keyboard)
    mouse = true; # Click to select panes/windows, scroll
    keyMode = "vi"; # Vi-style copy mode
    terminal = "tmux-256color";
    historyLimit = 10000;
    escapeTime = 10; # Shorter escape time (important for emacs/nvim)

    extraConfig = ''
      # True color support
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Renumber windows when one is closed
      set -g renumber-windows on

      # Split panes - Doom Emacs style (SPC w v / SPC w s)
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Choose session - Doom Emacs style (SPC TAB)
      bind Tab choose-session

      # New window in current path
      bind c new-window -c "#{pane_current_path}"

      # Reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"

      # Navigate panes with vim keys (no prefix needed after initial)
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Resize panes
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Status bar - Nord theme
      set -g status-position bottom
      set -g status-style "bg=#2e3440,fg=#d8dee9"
      set -g status-left "#[fg=#88c0d0,bold] #S  "
      set -g status-left-length 40
      set -g status-right "#[fg=#4c566a] %H:%M "
      set -g status-right-length 20
      set -g window-status-format "#[fg=#4c566a] #I:#W "
      set -g window-status-current-format "#[fg=#88c0d0,bold] #I:#W "
      set -g window-status-separator ""

      # Pane borders - Nord theme
      set -g pane-border-style "fg=#3b4252"
      set -g pane-active-border-style "fg=#88c0d0"

      # Message style
      set -g message-style "bg=#3b4252,fg=#88c0d0"

      # Focus events: let apps (pi, emacs) detect pane focus changes
      set -g focus-events on

      # Extended keys (csi-u) for better key handling in pi/emacs
      set -g extended-keys always
      set -g extended-keys-format csi-u
      set -as terminal-features "xterm-kitty:extkeys"
    '';
  };

  programs.zsh.initContent = lib.mkAfter ''
    # wtc - Create or attach a tmux session for the current (or named) worktree
    #
    # Usage:
    #   wtc          - session for current directory
    #   wtc <name>   - switch to worktree <name> and create/attach its session
    #
    # Session name is derived from: <repo>-<worktree>
    # e.g. ~/dd/dd-source/gcp-work → session "dd-source-gcp-work"
    wtc() {
      local target_dir session_name repo_name wt_name

      if [[ -n "$1" ]]; then
        # Switch worktree first, then build session from new location
        wt switch "$1" || return 1
        target_dir=$(pwd)
      else
        target_dir=$(pwd)
      fi

      # Build session name from repo + worktree folder names
      repo_name=$(basename "$(dirname "$target_dir")")
      wt_name=$(basename "$target_dir")
      # Sanitize: replace any char that tmux dislikes with a dash
      session_name=$(echo "''${repo_name}-''${wt_name}" | tr -cs '[:alnum:]-_' '-' | sed 's/-$//')

      if tmux has-session -t "=''${session_name}" 2>/dev/null; then
        # Session exists — switch to it
        if [[ -n "$TMUX" ]]; then
          tmux switch-client -t "=''${session_name}"
        else
          tmux attach-session -t "=''${session_name}"
        fi
      else
        # Create new session: window 0 = shell, window 1 = claude
        tmux new-session -d -s "''${session_name}" -c "''${target_dir}" -n "shell"
        tmux new-window -t "''${session_name}" -c "''${target_dir}" -n "claude"
        tmux select-window -t "''${session_name}:shell"

        if [[ -n "$TMUX" ]]; then
          tmux switch-client -t "=''${session_name}"
        else
          tmux attach-session -t "=''${session_name}"
        fi
      fi
    }
  '';
}
