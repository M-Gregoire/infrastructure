; Set warning level
(setq warning-minimum-level :warning)

; Define current directory as ue-dir
(defvar ue-dir (file-name-directory load-file-name))
(defvar etc-dir (expand-file-name "etc/" ue-dir))
(defvar dev-dir (expand-file-name "dev/" etc-dir))
(defvar pkg-dir (expand-file-name "packages/" etc-dir))

; Always follow symlinks
(setq vc-follow-symlinks t)

; Use melpa
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))

; Add repo for Elpy
(add-to-list 'package-archives
             '("elpy" . "https://jorgenschaefer.github.io/packages/"))

; Install packages in separate folder
(setq package-user-dir (expand-file-name "packages" ue-dir))

; Initialize package system
(package-initialize)

; Refresh package list on startyp
;(unless package-archive-contents
  (package-refresh-contents)
;  )

; Quick function to download and activate package
(defun ue-ensure-installed (packages)
  (dolist (package packages)
    (unless (package-installed-p package)
      (package-install package))))

; Set custom file and create if does not exists
(setq custom-file (expand-file-name "custom.el" ue-dir))
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file nil t)

; Handle abbrevs
(setq abbrev-file-name (expand-file-name "abbrev_defs" ue-dir))
(setq save-abbrevs 'silent)

; Load all .el in etc
(mapc (lambda (package) (load package nil t)) (file-expand-wildcards (expand-file-name "*.el" etc-dir)))

; Load manually the "langage" packages to only pick the needed ones
;(load (expand-file-name "c-ccp.el" dev-dir) nil t)
(load (expand-file-name "git.el" dev-dir) nil t)
(load (expand-file-name "golang.el" dev-dir) nil t)
;(load (expand-file-name "latex.el" dev-dir) nil t)
(load (expand-file-name "lisp.el" dev-dir) nil t)
(load (expand-file-name "markdown.el" dev-dir) nil t)
(load (expand-file-name "nix.el" dev-dir) nil t)
;(load (expand-file-name "orgmode.el" dev-dir) nil t)
;(load (expand-file-name "prolog.el" dev-dir) nil t)
(load (expand-file-name "protobuf.el" dev-dir) nil t)
(load (expand-file-name "python.el" dev-dir) nil t)
;(load (expand-file-name "r.el" dev-dir) nil t)
(load (expand-file-name "web.el" dev-dir) nil t)
(load (expand-file-name "yaml.el" dev-dir) nil t)
