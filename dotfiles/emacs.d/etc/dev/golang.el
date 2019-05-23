; Depends on: [ Flycheck ]

(ue-ensure-installed '(go-mode))

; Get GOPATH from shell
(exec-path-from-shell-copy-env "PATH")
(exec-path-from-shell-copy-env "GOPATH")
(exec-path-from-shell-copy-env "HOME")

(ue-ensure-installed '(flycheck-gometalinter))
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-gometalinter-setup))

;; Use a gometalinter configuration file (default: nil)
;; (setq flycheck-gometalinter-config (expand-file-name "~/.gometalinter-config.json"))

;; Set different deadline
(setq flycheck-gometalinter-deadline "20s")

;(load (expand-file-name "go-flymake.el" pkg-dir) nil t)
;(require 'go-flymake)

; Warning: Does quite a lot of computation in the background.
;(load (expand-file-name "go-flycheck.el" pkg-dir) nil t)
;(require 'go-flycheck)

(load (expand-file-name "go-guru.el" pkg-dir) nil t)
(require 'go-guru)
