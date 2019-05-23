(ue-ensure-installed '(lsp-mode))

(ue-ensure-installed '(lsp-ui))
(add-hook 'lsp-mode-hook 'lsp-ui-mode)

(ue-ensure-installed '(company-lsp))
(push 'company-lsp company-backends)
