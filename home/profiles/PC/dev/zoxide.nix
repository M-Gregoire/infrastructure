{ config, lib, pkgs, ... }:

{
  home.shellAliases = {
    cd = "zw";
  };

  programs.zsh.initContent = ''
    # Custom zoxide function with worktree support
    zw() {
      local query="$*"

      # Get the top zoxide match
      local top_match
      top_match=$(zoxide query "$query" 2>/dev/null)

      if [[ -z "$top_match" ]]; then
        echo "No matches found"
        return 1
      fi

      # Check if it's in a git repo
      local worktree_root
      worktree_root=$(git -C "$top_match" rev-parse --show-toplevel 2>/dev/null)

      if [[ -z "$worktree_root" ]]; then
        # Not a git repo, use regular zoxide
        __zoxide_z "$query"
        return
      fi

      # Check if this repo has multiple worktrees
      local worktree_count
      worktree_count=$(git -C "$worktree_root" worktree list | wc -l | tr -d ' ')

      if [[ $worktree_count -le 1 ]]; then
        # No worktrees, use regular zoxide
        __zoxide_z "$query"
        return
      fi

      # Get relative path from current worktree root
      local rel_path="''${top_match#$worktree_root}"
      rel_path="''${rel_path#/}"  # Remove leading slash

      # Get all worktrees
      local worktrees=()
      while IFS= read -r line; do
        worktrees+=("$line")
      done < <(git -C "$worktree_root" worktree list --porcelain | awk '/^worktree/ {print $2}')

      # Show interactive selection
      local selection
      if command -v fzf >/dev/null 2>&1; then
        selection=$(printf '%s\n' "''${worktrees[@]}" | \
          fzf --height 40% --reverse \
              --prompt "Select worktree: " \
              --preview 'echo "Path: {}"; echo ""; echo "Branch: $(git -C {} branch --show-current 2>/dev/null)"')
      else
        echo "Multiple worktrees found:"
        PS3="Select worktree: "
        select selection in "''${worktrees[@]}"; do
          [[ -n "$selection" ]] && break
        done
      fi

      if [[ -n "$selection" ]]; then
        local target="$selection"
        [[ -n "$rel_path" ]] && target="$selection/$rel_path"

        if [[ -d "$target" ]]; then
          cd "$target" && zoxide add "$target"
        else
          echo "Warning: Path doesn't exist in selected worktree: $target"
          echo "Going to worktree root instead"
          cd "$selection" && zoxide add "$selection"
        fi
      fi
    }
  '';

  # If you also want this for bash, uncomment:
  # programs.bash.initExtra = ''
  #   # (same function as above)
  # '';
}
