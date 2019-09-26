(use-package ag)

(use-package projectile
  :after ivy
  :delight
  :config

  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

  (setq projectile-completion-system 'ivy)
  (setq projectile-mode-line "Projectile")

  ;; Tramp and projectile
  ;; https://sideshowcoder.com/2017/10/24/projectile-and-tramp/
  (defadvice projectile-on (around exlude-tramp activate)
    ;;  "This should disable projectile when visiting a remote file"
    (unless  (--any? (and it (file-remote-p it))
                     (list
                      (buffer-file-name)
                      list-buffers-directory
                      default-directory
                      dired-directory))
      ad-do-it))
  )

(use-package counsel-projectile
  :after (counsel projectile)
  :config
  (setq counsel-projectile-mode t)
  )
