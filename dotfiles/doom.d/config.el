
;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
;;(setq user-full-name "John Doe"
;;      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-tomorrow-night)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;; Easier window movement
;;(windmove-defaut-keybindings)

(defhydra hydra-zoom (global-map "<f2>")
  "zoom"
  ("g" text-scale-increase "in")
  ("l" text-scale-decrease "out"))

(defhydra hydra-splitter (global-map "C-M-s")
  "splitter"
  ("h" hydra-move-splitter-left)
  ("j" hydra-move-splitter-down)
  ("k" hydra-move-splitter-up)
  ("l" hydra-move-splitter-right))

(defhydra hydra-windows ()
  "C-arrow = switch, S-arrow = size, M-arrow = move"
  ("C-<left>" windmove-left nil)
  ("C-<right>" windmove-right nil)
  ("C-<up>" windmove-up nil)
  ("C-<down>" windmove-down nil)
  ("S-<left>" hydra-move-splitter-left nil)
  ("S-<right>" hydra-move-splitter-right  nil)
  ("S-<up>" hydra-move-splitter-up nil)
  ("S-<down>" hydra-move-splitter-down nil)
  ("M-<left>" buf-move-left nil)
  ("M-<right>" buf-move-right nil)
  ("M-<up>" buf-move-up nil)
  ("M-<down>" buf-move-down nil)
  ("p" previous-buffer "prev-buf")
  ("n" next-buffer "next-buf")
  ("1" delete-other-windows "1")
  ("d" delete-window "del")
  ("k" kill-buffer "kill")
  ("s" save-buffer "save")
  ("u" (progn (winner-undo) (setq this-command 'winner-undo)) "undo")
  ("r" winner-redo "redo")
  ("b" helm-mini "helm-mini" :exit t)
  ("f" helm-find-files "helm-find" :exit t)
  ("|" (lambda () (interactive) (split-window-right) (windmove-right)))
  ("_" (lambda () (interactive) (split-window-below) (windmove-down)))
  ("q" nil "cancel")
  )

(global-set-key (kbd "M-#") 'hydra-windows/body)

;; Org mode
; Add timestamp to done item
(after! org
  (setq org-directory "~/Documents/org/")
  (setq org-agenda-files '("~/Documents/org/agenda.org"))
  (setq org-log-done 'time)
; Prevent long line in src block
(setq org-latex-minted-options '(("breaklines" "true")
                                 ("breakanywhere" "true")))

;; Syntax coloring in latex export
(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

)

;; Key chords
(require 'key-chord)
(key-chord-mode t)
(key-chord-define evil-insert-state-map "jk" 'evil-normal-state)

;; Projectile
(setq projectile-project-search-path '("~/src"))
(setq projectile-globally-ignored-directories '("node_modules"))

;; Word-wrap
(global-visual-line-mode t)
; Make horizontal movement cross lines
(setq-default evil-cross-lines t)
