; Depends on: [ Company ]

; From https://www.reddit.com/r/emacs/comments/5vhlws/using_tab_for_both_yasnippet_and_company/de27khs?utm_source=share&utm_medium=web2x
;(yas-global-mode 1)
;(define-key yas-minor-mode-map [(tab)]        nil)
;(define-key yas-minor-mode-map (kbd "TAB")    nil)
;(define-key yas-minor-mode-map (kbd "<tab>")  nil)

;(defun try-flyspell (arg)
;  (if (nth 4 (syntax-ppss))
;      (call-interactively 'flyspell-correct-word-before-point)
;  nil))

;(setq hippie-expand-try-functions-list
;      '(try-flyspell
;        yas-hippie-try-expand
;        try-expand-dabbrev-visible
;        (lambda (arg) (call-interactively 'company-complete))
;        ))

;(global-set-key (kbd "<tab>")  'hippie-expand)
;(global-set-key (kbd "TAB")  'hippie-expand)
