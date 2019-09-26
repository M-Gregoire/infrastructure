;; Highlight color with the color it represent
(use-package rainbow-mode
  :delight
  :hook prog-mode)

;; Rainbox parenthesis
(use-package rainbow-delimiters
  :delight
  :hook (prog-mode . rainbow-delimiters-mode)
  :config
  ;; Set red background for unmatched delimiters
  (custom-set-faces
   '(rainbow-blocks-unmatched-face ((t (:background "red"))))
   '(rainbow-delimiters-unmatched-face ((t (:background "red")))))
  )
