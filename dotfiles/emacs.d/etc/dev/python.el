;; Use jedi for completion
(use-package company-jedi
  :after compamy
  :config
  (defun my/python-mode-hook ()
    (add-to-list 'company-backends 'company-jedi))
  :hook (python-mode . my/python-mode-hook)
  )

;; Start Elpy
(use-package elpy
  :config
  (elpy-enable)
  )

;; Py-autopep8
(use-package py-autopep8
  :hook (elpy-mode . py-autopep8-enable-on-save)
  )
