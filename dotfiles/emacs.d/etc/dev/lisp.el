(setq package-enable-at-startup nil)

;;; Install slime and slime-company
(use-package slime
  :config
  ;; Ask before using slime server
  (setq slime-auto-connect 'ask)
  ;; Define which lisp compiler to use
  (setq inferior-lisp-program "sbcl")

  (require 'slime-autoloads)
  (slime-setup '(slime-fancy))
  )

(use-package slime-company
  :after (slime company))
