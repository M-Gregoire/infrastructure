(use-package markdown-mode
  ;; Use classic markdown except for README.md, use Github Flavored Markdown (gfm)
  :config
  (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
  (add-to-list 'auto-mode-alist '("README\\.md\\'" . gfm-mode))
  )

(use-package adoc-mode)
