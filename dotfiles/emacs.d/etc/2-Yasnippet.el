; Depends on: [ Company ]

(ue-ensure-installed '(yasnippet))
(yas-global-mode 1)

; Make yasnippet compatible with Company (see https://stackoverflow.com/questions/2087225/about-the-fix-for-the-interference-between-company-mode-and-yasnippet)
(defun company-yasnippet-or-completion ()
  (interactive)
  (let ((yas-fallback-behavior nil))
    (unless (yas-expand)
      (call-interactively #'company-complete-common))))

(add-hook 'company-mode-hook (lambda ()
  (substitute-key-definition 'company-complete-common
                             'company-yasnippet-or-completion
                             company-active-map)))
