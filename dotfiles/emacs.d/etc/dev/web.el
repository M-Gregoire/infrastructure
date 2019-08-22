; Depends on: [ Flycheck ]

(ue-ensure-installed '(web-mode))
(ue-ensure-installed '(graphql-mode))

(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

; Javascript
(add-to-list 'auto-mode-alist '("\\.js?$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.json?$" . web-mode))

; Set to JSX mode by default
(setq web-mode-content-types-alist
      '(("jsx" . "\\.js[x]?\\'")))

(setq web-mode-markup-indent-offset 2
      web-mode-css-indent-offset 2
      web-mode-code-indent-offset 2)
(setq js-indent-level 2)

; CSS colorization
(setq web-mode-enable-css-colorization t)

; Add tag highlight
(setq web-mode-enable-current-element-highlight t)

; Only indent on demand
(setq web-mode-enable-auto-indentation nil)

; Node
(ue-ensure-installed '(nvm))

(add-hook 'projectile-after-switch-project-hook 'mjs/setup-local-eslint)

(defun mjs/setup-local-eslint ()
  "If ESLint found in node_modules directory - use that for flycheck.
Intended for use in PROJECTILE-AFTER-SWITCH-PROJECT-HOOK."
  (interactive)
  (let ((local-eslint (expand-file-name "./node_modules/.bin/eslint")))
    (setq flycheck-javascript-eslint-executable
	  (and (file-exists-p local-eslint) local-eslint))))

(with-eval-after-load 'flycheck
  (push 'web-mode (flycheck-checker-get 'javascript-eslint 'modes)))


(eval-after-load "web-mode"
  '(set-face-background 'web-mode-current-element-highlight-face "steel blue"))

;php-mode
(ue-ensure-installed '(php-mode))

(autoload 'php-mode "php-mode" "Major mode for editing php code." t)
(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.inc$" . php-mode))

; Load npm.el
(load (expand-file-name "npm.el" pkg-dir) nil t)
(require 'npm)

; Jade, sws and Stylus
(load (expand-file-name "jade-mode.el" pkg-dir) nil t)
(load (expand-file-name "sws-mode.el" pkg-dir) nil t)
(load (expand-file-name "stylus-mode.el" pkg-dir) nil t)

; Vue.js dependency
;(ue-ensure-installed '(mmm-mode))
;(ue-ensure-installed '(sass-mode))
;(ue-ensure-installed '(edit-indirect))
;(ue-ensure-installed '(vue-html-mode))

; Vue.js
;(load (expand-file-name "vue.el" pkg-dir) nil t)
;(require 'vue-mode)


(ue-ensure-installed '(vue-mode))

; Remove ugly background in mmm-mode (used by vue-mode)
(setq mmm-submode-decoration-level 0)
