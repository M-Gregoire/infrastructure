(ue-ensure-installed '(flycheck))
(global-flycheck-mode)

; Enable popups
(ue-ensure-installed '(flycheck-pos-tip))
(with-eval-after-load 'flycheck
  (flycheck-pos-tip-mode))
