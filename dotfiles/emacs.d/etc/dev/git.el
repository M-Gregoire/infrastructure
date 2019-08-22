(use-package magit
  :after (ivy))
(use-package forge
  :after (magit))

; Recover the SSH agent to use SSH keys in emacs
(use-package exec-path-from-shell)
(exec-path-from-shell-initialize)

(exec-path-from-shell-copy-env "SSH_AGENT_PID")
(exec-path-from-shell-copy-env "SSH_AUTH_SOCK")

; Use ivy
(setq magit-completing-read-function 'ivy-completing-read)

; Merging and conflict
(setq smerge-command-prefix (kbd "C-c v"))
