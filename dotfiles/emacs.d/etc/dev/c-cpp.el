;; Install and use irony
(use-package irony
  :after company
  :config

  ;; Default config create errors from Irony when opening php file
  ;; See https://github.com/Sarcasm/irony-mode/issues/75
  ;; and https://lists.gnu.org/archive/html/help-gnu-emacs/2015-10/msg00257.html
  ;; and https://github.com/Sarcasm/company-irony/issues/27
  ;; I used the fix from the first link

  (defun my-c++-hooks ()
    (when (member major-mode irony-known-modes)
      (irony-mode 1)))

  (add-hook 'c++-mode-hook 'my-c++-hooks)
  (add-hook 'c-mode-hook 'my-c++-hooks)

  ;; Normal config from here
  (add-hook 'objc-mode-hook 'irony-mode)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  (add-to-list 'company-backends '(company-irony-c-headers company-irony))
  )

;; Install the company-irony
(use-package company-irony
  :after (company irony)
  )
(use-package company-irony-c-headers
  :after (company irony)
  )

;; Flycheck
(use-package flycheck-irony
  :after flycheck
  :hook (flycheck-mode . flycheck-irony-setup))
