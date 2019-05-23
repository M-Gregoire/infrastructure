; Depends on: [ Ivy ]

(ue-ensure-installed '(all-the-icons))
(ue-ensure-installed '(neotree))

; Use the icons
;(setq neo-theme 'icons)
;(add-to-list 'load-path ".")
(setq neo-theme (if (display-graphic-p) 'icons 'arrow))

; Bind neotree to F8
(global-set-key [f8] 'neotree-toggle)

; Show hidden files
(setq-default neo-show-hidden-files t)

; Show current directory in NeoTree
(setq neo-smart-open t)

; Change root when projectile is used
(setq projectile-switch-project-action 'neotree-projectile-action)

; Use ivy
(setq projectile-completion-system 'ivy)

; Disable neotree fixed width
(setq neo-window-fixed-size nil)
