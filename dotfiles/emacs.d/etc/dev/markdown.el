(ue-ensure-installed '(markdown-mode))

; Use classic markdown except for README.md, use Github Flavored Markdown (gfm)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))

(ue-ensure-installed '(adoc-mode))
