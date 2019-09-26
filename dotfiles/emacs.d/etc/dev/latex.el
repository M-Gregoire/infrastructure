(use-package tex-mode
  :ensure auctex
  :defer t
  :config
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-save-query nil)
  (setq TeX-PDF-mode t)
  )
;; Preview move for latex
(use-package latex-preview-pane
  :config
  (latex-preview-pane-enable)
  )
