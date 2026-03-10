{ config, lib, pkgs, inputs, ... }:

{
  # Worktrunk - CLI for Git worktree management, designed for parallel AI agent workflows
  home.packages = [ inputs.worktrunk.packages.${pkgs.system}.default ];

  programs.zsh.initContent = ''
    # Create a new worktree with branch prefix and switch to it
    nw() {
      if [[ -z "$1" ]]; then
        echo "Usage: nw <worktree-name>"
        echo "Creates a new worktree with branch greg.cm/<worktree-name>"
        return 1
      fi

      local worktree_name="$1"
      local branch_name="greg.cm/$worktree_name"

      # Get the current directory's worktree root (canonical path)
      local current_worktree_root
      current_worktree_root=$(git rev-parse --show-toplevel 2>/dev/null)

      if [[ -z "$current_worktree_root" ]]; then
        echo "Not in a git repository"
        return 1
      fi

      # Find the repository root (parent directory containing all worktrees)
      # Get the common git directory, which is always in the main worktree
      local git_common_dir
      git_common_dir=$(git -C "$current_worktree_root" rev-parse --git-common-dir 2>/dev/null)
      
      # The repo root is the parent of the common git dir
      local repo_root
      repo_root=$(dirname "$git_common_dir")

      # Construct the new worktree path
      local new_worktree_path="$repo_root/$worktree_name"

      # Check if worktree already exists
      if [[ -d "$new_worktree_path" ]]; then
        echo "Worktree already exists at: $new_worktree_path"
        return 1
      fi

      # Check if branch already exists
      if git -C "$current_worktree_root" show-ref --verify --quiet "refs/heads/$branch_name"; then
        echo "Branch $branch_name already exists"
        echo "Creating worktree from existing branch..."
        git -C "$current_worktree_root" worktree add "$new_worktree_path" "$branch_name"
      else
        # Get the default branch (trunk/main/master)
        local default_branch
        default_branch=$(git -C "$current_worktree_root" symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
        
        if [[ -z "$default_branch" ]]; then
          # Fallback: try common default branch names
          for branch in trunk main master; do
            if git -C "$current_worktree_root" show-ref --verify --quiet "refs/heads/$branch"; then
              default_branch="$branch"
              break
            fi
          done
        fi

        if [[ -z "$default_branch" ]]; then
          echo "Could not determine default branch"
          return 1
        fi

        echo "Creating new branch $branch_name from $default_branch..."
        git -C "$current_worktree_root" worktree add -b "$branch_name" "$new_worktree_path" "$default_branch"
      fi

      if [[ $? -eq 0 ]]; then
        echo "Worktree created at: $new_worktree_path"
        echo "Switching to new worktree..."
        
        # Get relative path from current worktree root to preserve directory structure
        local current_real_path
        current_real_path=$(realpath "$PWD")
        local rel_path="''${current_real_path#$current_worktree_root}"
        rel_path="''${rel_path#/}"  # Remove leading slash

        local target="$new_worktree_path"
        [[ -n "$rel_path" ]] && target="$new_worktree_path/$rel_path"

        if [[ -d "$target" ]]; then
          cd "$target" && zoxide add "$target"
        else
          echo "Note: Path doesn't exist in new worktree: $target"
          echo "Going to worktree root instead"
          cd "$new_worktree_path" && zoxide add "$new_worktree_path"
        fi
      else
        echo "Failed to create worktree"
        return 1
      fi
    }

    # Worktrunk shell integration for directory navigation
    eval "$(wt config shell-hook zsh)"
  '';
}
