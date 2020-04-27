;; Nyan-mode
(use-package nyan-mode
  :config
  (nyan-mode)
  )

(load (expand-file-name "xresources-theme.el" pkg-dir) nil t)
(load-theme 'xresources t)

;; https://emacs.stackexchange.com/a/53021
;; SIGUSR1 to reload config files
(defun sigusr1-handler ()
  (interactive)
  (load (expand-file-name "xresources-theme.el" pkg-dir) nil t))
(define-key special-event-map [sigusr1] 'sigusr1-handler)
