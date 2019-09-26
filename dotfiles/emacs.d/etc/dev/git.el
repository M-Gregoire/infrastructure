(use-package magit
  :after (ivy)
  :config
  ;; Use ivy
  (setq magit-completing-read-function 'ivy-completing-read)
  ;; Merging and conflict
  (setq smerge-command-prefix (kbd "C-c v"))
  )

(use-package forge
  :after (magit))
