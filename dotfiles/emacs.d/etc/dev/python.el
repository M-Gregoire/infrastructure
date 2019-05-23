; Depends on: [ Company ]

; Use jedi for completion
(ue-ensure-installed '(company-jedi))
(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)

; Start Elpy
;(ue-ensure-installed '(elpy))
;(elpy-enable)

; Py-autopep8
(ue-ensure-installed '(py-autopep8))
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)
