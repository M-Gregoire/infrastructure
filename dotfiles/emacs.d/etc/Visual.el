; Highlight color with the color it represent
(use-package rainbow-mode
  :delight)

(define-globalized-minor-mode my-global-rainbow-mode rainbow-mode
  (lambda () (rainbow-mode 1)))

(my-global-rainbow-mode 1)

; Rainbox parenthesis
(use-package rainbow-delimiters
  :delight
  :config (; Set red background for unmatched delimiters
	   (custom-set-faces
	    '(rainbow-blocks-unmatched-face ((t (:background "red"))))
	    '(rainbow-delimiters-unmatched-face ((t (:background "red")))))
	   ))

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
