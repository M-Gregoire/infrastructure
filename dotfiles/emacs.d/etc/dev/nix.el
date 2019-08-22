(use-package nix-mode)
(use-package nixos-options)
(use-package company-nixos-options
  :after (company)
  :init
  (add-to-list 'company-backends 'company-nixos-options))
(use-package nix-sandbox)
