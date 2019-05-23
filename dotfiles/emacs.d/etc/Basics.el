; Remove startup message
(setq inhibit-startup-message t)

; Open an empty scratch on startup
(setq initial-scratch-message "")

; Move arround with ALT+Arrow
(windmove-default-keybindings 'meta)

; Print line and columns at the bottom
(line-number-mode t)
(column-number-mode t)

; Print line number on the left
(global-linum-mode t)

; Stop the cursor from blinking
(blink-cursor-mode 0)

; Highlight the matching parenthesis
(show-paren-mode 1)

; Remove delay before show the associated parenthesis
(setq show-paren-delay 0)

; Fullscreen
(toggle-frame-fullscreen)

;; Ask "y" or "n" instead of "yes" or "no"
(fset 'yes-or-no-p 'y-or-n-p)

;; Highlight tabulations
(setq-default highlight-tabs t)

;; Show trailing whitespaces
(setq-default show-trailing-whitespace t)

; Remove all menu/tool bar and scrollbar
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

; Change cursor
(setq-default cursor-type 'bar)
(setq default-frame-alist
      '((cursor-color . "LimeGreen")))

; Replace selected text when typing
(delete-selection-mode 1)

; Disable beeps
(setq ring-bell-function 'ignore)

; Enable direnv
(ue-ensure-installed '(direnv))
(direnv-mode)
