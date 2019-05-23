; Depends on: [ Company ]

(setq package-enable-at-startup nil)

; Install slime and slime-company
(ue-ensure-installed '(slime))
(ue-ensure-installed '(slime-company))

; Ask before using slime server
(setq slime-auto-connect 'ask)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Slime with allegro ;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Load quicklisp
;(load (expand-file-name "~/quicklisp/slime-helper.el"))


;(eval-after-load "slime"
;  '(progn
;    (add-to-list 'load-path "/usr/local/slime/contrib")
;    (slime-setup '(slime-fancy slime-banner))
;    (setq slime-complete-symbol*-fancy t)
;    (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol)))

;(setq inferior-lisp-program "/usr/local/acl100express/allegro-express")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; Slime with sbcl ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Define which lisp compiler to use
(setq inferior-lisp-program "sbcl")

(require 'slime-autoloads)
(slime-setup '(slime-fancy))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Correct indent when indenting with one [;] ;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun lisp-indent-line (&optional _whole-exp)
  "Indent current line as Lisp code.
With argument, indent any additional lines of the same expression
rigidly along with this one.
Modified to indent single semicolon comments like double semicolon comments"
  (interactive "P")
  (let ((indent (calculate-lisp-indent)) shift-amt
	(pos (- (point-max) (point)))
	(beg (progn (beginning-of-line) (point))))
    (skip-chars-forward " \t")
    (if (or (null indent) (looking-at "\\s<\\s<\\s<"))
	;; Don't alter indentation of a ;;; comment line
	;; or a line that starts in a string.
        ;; FIXME: inconsistency: comment-indent moves ;;; to column 0.
	(goto-char (- (point-max) pos))
      (if (listp indent) (setq indent (car indent)))
      (setq shift-amt (- indent (current-column)))
      (if (zerop shift-amt)
	  nil
	(delete-region beg (point))
	(indent-to indent))
      ;; If initial point was within line's indentation,
      ;; position after the indentation.  Else stay at same point in text.
      (if (> (- (point-max) pos) (point))
	  (goto-char (- (point-max) pos))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
