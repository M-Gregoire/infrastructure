(use-package flycheck
  :config
  (global-flycheck-mode)
  )

;; Enable popups
(use-package flycheck-pos-tip
  :after flycheck
  :config
  (with-eval-after-load 'flycheck
    (flycheck-pos-tip-mode))
  )
