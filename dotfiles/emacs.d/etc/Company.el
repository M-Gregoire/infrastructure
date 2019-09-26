;; Install and use company
(use-package  company
  :hook (after-init-hook . global-company-mode)
  :config
  ;; https://emacs.stackexchange.com/questions/10837/how-to-make-company-mode-be-case-sensitive-on-plain-text
  ;; Make auto completion case sensitive
  (setq company-dabbrev-downcase nil)
  (setq company-idle-delay 0)

  )

;; Show help popups
(use-package company-quickhelp
  :after company
  :config
  (company-quickhelp-mode 1)
  )
