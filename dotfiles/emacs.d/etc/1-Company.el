; Install and use company
(ue-ensure-installed '(company))
(add-hook 'after-init-hook 'global-company-mode)

; Show help popups
(ue-ensure-installed '(company-quickhelp))
(company-quickhelp-mode 1)

; https://emacs.stackexchange.com/questions/10837/how-to-make-company-mode-be-case-sensitive-on-plain-text
; Make auto completion case sensitive
(setq company-dabbrev-downcase nil)
(setq company-idle-delay 0)
