; Highlight color with the color it represent
(ue-ensure-installed '(rainbow-mode))
(define-globalized-minor-mode my-global-rainbow-mode rainbow-mode
  (lambda () (rainbow-mode 1)))

(my-global-rainbow-mode 1)

; Rainbox parenthesis
(ue-ensure-installed '(rainbow-delimiters))
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

; Set red background for unmatched delimiters
(custom-set-faces
 '(rainbow-blocks-unmatched-face ((t (:background "red"))))
 '(rainbow-delimiters-unmatched-face ((t (:background "red")))))
