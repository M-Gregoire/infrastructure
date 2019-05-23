; Nyan-mode
(ue-ensure-installed '(nyan-mode))
(nyan-mode)

; Load base16 theme based on env var
(ue-ensure-installed '(base16-theme))
(if (equal nil (getenv "THEME"))
    (load-theme 'base16-classic-dark)
  (load-theme (car (read-from-string (concat "base16-" (getenv "THEME")))))
  )


(if (equal nil (getenv "TRANSPARENCY"))
    (set-frame-parameter (selected-frame) 'alpha '100)
  (set-frame-parameter (selected-frame) 'alpha (string-to-number (getenv "TRANSPARENCY")))
  )

; Font
(if (not (or (equal nil (getenv "EMACS_FONT")) (equal nil (getenv "EMACS_FONT_SIZE"))))
(set-face-attribute 'default nil
                    :family (getenv "EMACS_FONT")
		    ; Font size in 1/10th of pt
                    :height (* 10 (string-to-number (getenv "EMACS_FONT_SIZE")))
                    :weight 'normal
                    :width 'normal)
)
