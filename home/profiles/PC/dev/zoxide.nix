{ config, lib, pkgs, ... }:

{
  programs.zsh.initContent = ''
    # Only alias cd to z in interactive shells
    if [[ -o interactive ]]; then
      alias cd=z
    fi

    # Switch to another worktree in the same repo, maintaining relative path
    sw() {
      # Get the current directory's worktree root (canonical path)
      local current_worktree_root
      current_worktree_root=$(git rev-parse --show-toplevel 2>/dev/null)

      if [[ -z "$current_worktree_root" ]]; then
        echo "Not in a git repository"
        return 1
      fi

      # Check if this repo has multiple worktrees
      local worktree_count
      worktree_count=$(git -C "$current_worktree_root" worktree list | wc -l | tr -d ' ')

      if [[ $worktree_count -le 1 ]]; then
        echo "This repository has no other worktrees"
        return 1
      fi

      # Get relative path from current worktree root
      # Use realpath to resolve symlinks in PWD to match git's canonical path
      local current_real_path
      current_real_path=$(realpath "$PWD")
      local rel_path="''${current_real_path#$current_worktree_root}"
      rel_path="''${rel_path#/}"  # Remove leading slash

      # Get all worktrees except the current one
      local worktrees=()
      while IFS= read -r line; do
        if [[ "$line" != "$current_worktree_root" ]]; then
          worktrees+=("$line")
        fi
      done < <(git -C "$current_worktree_root" worktree list --porcelain | awk '/^worktree/ {print $2}')

      if [[ ''${#worktrees[@]} -eq 0 ]]; then
        echo "No other worktrees found"
        return 1
      fi

      # Show interactive selection
      local selection
      if command -v fzf >/dev/null 2>&1; then
        selection=$(printf '%s\n' "''${worktrees[@]}" | \
          fzf --height 40% --reverse \
              --prompt "Switch to worktree: " \
              --preview 'echo "Path: {}"; echo ""; echo "Branch: $(git -C {} branch --show-current 2>/dev/null)"')
      else
        echo "Available worktrees:"
        PS3="Switch to worktree: "
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

      # Get relative path from worktree root
      # Use realpath to resolve symlinks in top_match to match git's canonical path
      local top_match_real
      top_match_real=$(realpath "$top_match")
      local rel_path="''${top_match_real#$worktree_root}"
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
