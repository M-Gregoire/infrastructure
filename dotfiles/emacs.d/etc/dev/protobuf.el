(load (expand-file-name "protobuf-mode.el" pkg-dir) nil t)
(add-to-list 'auto-mode-alist '("\\.proto?\\'" . protobuf-mode))
