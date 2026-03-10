{ config, lib, pkgs, inputs, ... }:

{
  # Worktrunk - CLI for Git worktree management, designed for parallel AI agent workflows
  home.packages = [ inputs.worktrunk.packages.${pkgs.system}.default ];

  # Worktrunk configuration
  xdg.configFile."worktrunk/config.toml".text = ''
    # Worktree path template - siblings alongside trunk
    # For repo at ~/dd/dd-source/trunk, branch greg.cm/gcp-work creates ~/dd/dd-source/gcp-work
    # Strip greg.cm/ prefix from folder name while keeping it in branch name
    worktree-path = '{{ repo_path }}/../{{ branch | replace("greg.cm/", "") | sanitize }}'

    [commit]
    # Auto-stage all changes before commit
    stage = "all"

    # [commit.generation]
    # Uncomment to enable LLM-generated commit messages
    # command = "claude -p --model=haiku --tools='''' --disable-slash-commands"

    [merge]
    # Squash commits into one (use --no-squash to preserve history)
    squash = true
    # Commit uncommitted changes first
    commit = true
    # Rebase onto target before merge
    rebase = true
    # Remove worktree after successful merge
    remove = true
    # Run project hooks
    verify = true

    [list]
    # Don't show LLM summaries by default (can be slow)
    summary = false
    # Don't show full details by default
    full = false
  '';


  programs.zsh.initContent = ''
    # Worktrunk shell integration for directory navigation
    eval "''$(wt config shell init zsh)"

    # Wrapper for wt switch --create to enforce greg.cm/ branch prefix
    wtn() {
      local branch_name="''$1"
      shift  # Remove first argument, keep the rest

      # Add greg.cm/ prefix if not already present
      if [[ ! "''$branch_name" =~ ^greg\.cm/ ]]; then
        branch_name="greg.cm/''$branch_name"
      fi

      wt switch --create "''$branch_name" "''$@"
    }
  '';
}
