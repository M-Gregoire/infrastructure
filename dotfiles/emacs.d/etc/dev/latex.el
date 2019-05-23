(ue-ensure-installed '(auctex))

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq TeX-save-query nil)
(setq TeX-PDF-mode t)

; Preview move for latex
(ue-ensure-installed '(latex-preview-pane))
(latex-preview-pane-enable)
