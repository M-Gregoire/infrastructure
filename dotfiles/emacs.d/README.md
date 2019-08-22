# Here is my Emacs config !

## Install note :

There are a lot of dependencies to this configuration of Emacs: some softwares need to be installed on the host. I manage this dependencies through NixOS so they are not documented here, see [emacs.nix](./../../home/emacs.nix).

# What's in it ?

| Package               | What does it do ?                                                              |
|-----------------------|--------------------------------------------------------------------------------|
| ace-jump-mode         | Move your cursor to ANY position in emacs by using only 3 times key press      |
| adoc-mod              | Major mode for AsciiDoc files.                                                 |
| ag                    | An Emacs frontend to The Silver Searcher.                                      |
| all-the-icons         | Set of icons used for neotree.                                                 |
| auctex                | Package for writing and formatting TeX files.                                  |
| base16-theme          | Makes emacs pretty using base16 themes.                                        |
| buffer-move           | Easily swap between buffers.                                                   |
| company-mode          | Text completion framework. It comes with several back-ends.                    |
| company-nixos-options | Shows the documentation of the option in a popup-buffer.                       |
| company-quickhelp     | Documentation popups when idling on a completion candidate.                    |
| counsel-projectile    | Ivy UI for Projectile.                                                         |
| direnv                | Direnv integration for emacs.                                                  |
| editorconfig          | Editorconfig support.                                                          |
| eglot                 | A client for Language Server Protocol servers.                                 |
| expand-region         | Increase region by semantic units                                              |
| flycheck              | On-the-fly syntax checking supporting over 40 programming languages.           |
| flycheck-pos-tip      | Shows errors under point in pos-tip popups.                                    |
| forge                 | Work with Git forges from the comfort of Magit.                                |
| gfm-mode              | Major mode for editing Github Flavored Markdown. *Included in markdown-mode.*  |
| ivy, counsel, swipper | Completion mechanism for Emacs.                                                |
| latex-preview-pane    | Integrated component for visualizing your work.                                |
| magit                 | Interface for git.                                                             |
| markdown-mode         | Major mode for editing Markdown.                                               |
| multiple-cursors      | Use multiple-cursors !.                                                        |
| neotree               | Tree plugin binded to F8.                                                      |
| nix-mode              | Major mode for nix files.                                                      |
| nix-sandbox           | Utility functions to work with nix sandboxes.                                  |
| nixos-options         | Interface for browsing and completing NixOS options.                           |
| nyan-mode             | Makes emacs fun !                                                              |
| projectile            | Project interfaction library.                                                  |
| rainbow-delimiters    | Put delimiters in color.                                                       |
| rainbow-mode          | HEX/RGB color are highlighted with the color they represents.                  |
| slime                 | Mode for Common Lisp.                                                          |
| slime-company         | Company-mode completion backend for Slime.                                     |
| sudo-edit             | pen files as another user.                                                     |
| windmove              | Move from window to window with shift and arrow keys. *Now included in emacs.* |
| yaml-mode             | Minor-mode for yaml.                                                           |

I use the LSP servers defined in [LSP.el](./../../home/dev/LSP.nix).

## Currently disabled (Unmaintained)

#### Web

| Package                  | What does it do ?                                                                                                        |
|--------------------------|--------------------------------------------------------------------------------------------------------------------------|
| web-mode                 | Major-mode for editing web templates.                                                                                    |
| php-mode                 | Major-mode for editing php files.                                                                                        |
| nvm                      | Manage Node versions within Emacs.                                                                                       |
| npm                      | Create and rule NPM packages from Emacs.                                                                                 |
| {jade, sws, stylus}-mode | Major-mode for {Jade, sws, Stylus}.                                                                                      |
| vue-mode                 | Emacs major mode for vue.js. Modified so It uses web-mode in templates and scripts instead of vue-mode-html and js-mode. |
| graphql-mode             | Emacs mode to edit GraphQL schema and queries.                                                                           |

#### Go

| Package               | What does it do ?                                    |
|-----------------------|------------------------------------------------------|
| go-mode               | Minor-mode for go.                                   |
| flycheck-gometalinter | Provides flycheck checker for golang.                |
| go-flymake            | Provides flymake style syntax checking.              |
| go-flycheck           | Provides flymake style syntax checking.              |
| go-guru               | A tool for answering questions about Go source code. |

#### C/ C++

| Package                 | What does it do ?                                                                                                         |
|-------------------------|---------------------------------------------------------------------------------------------------------------------------|
| irony-mode              | Minor-mode for improving C/C++/Objective-c editing experience.                                                            |
| company-irony           | Provides a company-mode asynchronous completion backend for C/C++/Objective-C languages.                                  |
| company-irony-c-headers | Company mode for C/C++ heards files that works with irony-mode. *Modified C/C++ hooks so that it doesn't break php-mode.* |
| flycheck-irony          | Provides a flycheck checker for C/C++/Objective-C languages.                                                              |

#### Protobuf

| Package       | What does it do ?         |
|---------------|---------------------------|
| protobuf-mode | Major mode for protobuff. |

#### Others

| Package   | What does it do ?                                         |
|-----------|-----------------------------------------------------------|
| yasnippet | For snippets. **WARNING** : Has to required before irony. |

# Credits

Many thanks to every developpers that contributed to the awesomess of Emacs and it's packages.

## Donation

This project helped you ? You can buy me a cup of coffee  
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=EWHGT3M9899J6)
