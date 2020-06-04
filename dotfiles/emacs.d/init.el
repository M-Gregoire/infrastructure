;; Set warning level
(setq warning-minimum-level :warning)

;; Define current directory as ue-dir
(defvar ue-dir (file-name-directory load-file-name))
(defvar etc-dir (expand-file-name "etc/" ue-dir))
(defvar dev-dir (expand-file-name "dev/" etc-dir))
(defvar pkg-dir (expand-file-name "packages/" etc-dir))

;; Always follow symlinks
(setq vc-follow-symlinks t)

;; Bug https://www.reddit.com/r/emacs/comments/cdf48c/failed_to_download_gnu_archive/
;;(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(require 'package)
(setq package-archives '(
                                        ; Use Elpa
                         ("gnu" . "https://elpa.gnu.org/packages/")
                                        ; Use Melpa
                         ("melpa" . "https://melpa.org/packages/")
                                        ; Add repo for Elpy
                         ("elpy" . "https://jorgenschaefer.github.io/packages/"))
      )

;; Install packages in separate folder
(setq package-user-dir (expand-file-name "packages" ue-dir))

;; Initialize package system
(package-initialize)

;; Set custom file and create if does not exists
(setq custom-file (expand-file-name "custom.el" ue-dir))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file nil t)

;; Handle abbrevs
(setq abbrev-file-name (expand-file-name "abbrev_defs" ue-dir))
(setq save-abbrevs 'silent)

;; Refresh packages on startup (Take some time...)
;; This is acceptable as Emacs run as daemon
(package-refresh-contents)

;; Use use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; Install all packages if not installed
(require 'use-package-ensure
         :config
         (setq use-package-always-ensure t))

;; Update all packages
(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t)
  (auto-package-update-maybe))

;; Customise how major and minor modes appear in the ModeLine
(use-package delight)

;; Load all .el in etc
(mapc (lambda (package) (load package nil t)) (file-expand-wildcards (expand-file-name "*.el" etc-dir)))

;; Load manually the "langage" packages to only pick the needed ones
(load (expand-file-name "c-cpp.el" dev-dir) nil t)
(load (expand-file-name "git.el" dev-dir) nil t)
(load (expand-file-name "golang.el" dev-dir) nil t)
(load (expand-file-name "latex.el" dev-dir) nil t)
(load (expand-file-name "lisp.el" dev-dir) nil t)
(load (expand-file-name "markdown.el" dev-dir) nil t)
(load (expand-file-name "nix.el" dev-dir) nil t)
(load (expand-file-name "orgmode.el" dev-dir) nil t)
(load (expand-file-name "protobuf.el" dev-dir) nil t)
(load (expand-file-name "python.el" dev-dir) nil t)
(load (expand-file-name "r.el" dev-dir) nil t)
(load (expand-file-name "web.el" dev-dir) nil t)
(load (expand-file-name "yaml.el" dev-dir) nil t)
