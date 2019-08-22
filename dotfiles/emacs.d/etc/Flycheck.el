(use-package flycheck)
(global-flycheck-mode)

; Enable popups
(use-package flycheck-pos-tip)
(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))
