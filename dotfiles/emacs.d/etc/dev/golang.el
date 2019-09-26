(use-package go-mode
  :after exec-path-from-shell
  :config
  ;; Get GOPATH from shell
  (exec-path-from-shell-copy-env "PATH")
  (exec-path-from-shell-copy-env "GOPATH")
  (exec-path-from-shell-copy-env "HOME")
  )


(use-package flycheck-gometalinter
  :after flycheck
  :hook (flycheck-mode . flycheck-gometalinter-setup)
  :config
  ;; Use a gometalinter configuration file (default: nil)
  ;; (setq flycheck-gometalinter-config (expand-file-name "~/.gometalinter-config.json"))

  ;; Set different deadline
  (setq flycheck-gometalinter-deadline "20s")
  )

(load (expand-file-name "go-guru.el" pkg-dir) nil t)
(require 'go-guru)
