; Depends on: [ Ivy ]

(ue-ensure-installed '(magit))
(ue-ensure-installed '(forge))

; Recover the SSH agent to use SSH keys in emacs
(ue-ensure-installed '(exec-path-from-shell))
(exec-path-from-shell-initialize)

(exec-path-from-shell-copy-env "SSH_AGENT_PID")
(exec-path-from-shell-copy-env "SSH_AUTH_SOCK")

; Use ivy
(setq magit-completing-read-function 'ivy-completing-read)

; Merging and conflict
(setq smerge-command-prefix (kbd "C-c v"))
