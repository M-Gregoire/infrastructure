# Here is my Emacs config !
http://www.techrepublic.com/article/why-i-love-emacs/

## Install note :
There are a lot of dependencies to this configuration of Emacs: some softwares need to be installed on the host. I manage this dependencies through NixOS so they are not documented here.

# What's in it ? (Slightly outdated)

## Visual improvements :

|Package|What does it do ?|
|---|---|
|monokai-theme|Makes emacs pretty.|
|nyan-mode|Makes emacs fun !|
|rainbow-mode|HEX/RGB color are highlighted with the color they represents.|
|rainbow-delimiters|Put delimiters in color.|
|tabbar|Use buffers with a tab bar !|
|all-the-icons|Set of icons used for neotree.|
|neotree|Tree plugin binded to F8.|

## General improvements :
|Package|What does it do ?|
|---|---|
|Ivy, Counsel, Swipper|Completion mechanism for Emacs.|
|Yasnippet|For snippets. **WARNING** : Has to required before irony.|
|expand-region|Increase region by semantic units|
|windmove|Move from window to window with shift and arrow keys. *Now included in emacs.*|
|buffer-move| Easily swap between buffers.|
|multiple-cursors| Use multiple-cursors !(!!!!).|
|Projectile|Project interfaction library.|

## Improvements for programming :

#### Programming related
|Package|What does it do ?|
|---|---|
|company-mode|Text completion framework. It comes with several back-ends.|
|company-quickhelp|Documentation popups when idling on a completion candidate.|
|flycheck|On-the-fly syntax checking supporting over 40 programming languages.|
|flycheck-pos-tip|Shows errors under point in pos-tip popups.|
|EditorConfig.org plugin|Editor-config|
#### Git & Github
|Package|What does it do ?|
|---|---|
|magit|Interface for git.|
|magithub|Interface for Github.|

#### AsciiDoc, Markdown and Github Flavored Markdown
|Package|What does it do ?|
|---|---|
|adoc-mod|Major mode for AsciiDoc files.|
|markdown-mode|Major mode for editing Markdown.|
|gfm-mode|Major mode for editing Github Flavored Markdown. *Included in markdown-mode.*|

#### C/ C++
|Package|What does it do ?|
|---|---|
|irony-mode|Minor-mode for improving C/C++/Objective-c editing experience.|
|company-irony|Provides a company-mode asynchronous completion backend for C/C++/Objective-C languages.|
|company-irony-c-headers|Provide a company-mode for C/C++ heards files that works with irony-mode. *I modified C/C++ hooks so that it doesn't break php-mode.*|
|flycheck-irony|Provides a flycheck checker for C/C++/Objective-C languages.|

#### Go
|Package|What does it do ?|
|---|---|
|go-mode|Minor-mode for go.|
|flycheck-gometalinter|Provides flycheck checker for golang.|
|go-flymake|Provides flymake style syntax checking.|
|go-flycheck|Provides flymake style syntax checking.|

#### Yaml
|Package|What does it do ?|
|---|---|
|yaml-mode|Minor-mode for yaml.|


#### Web (Html / CSS / PHP / JS / JSON / Node / NPM / React / Vue.js)
|Package|What does it do ?|
|---|---|
|web-mode|Major-mode for editing web templates.|
|php-mode|Major-mode for editing php files.|
|nvm|Manage Node versions within Emacs.|
|npm|Create and rule NPM packages from Emacs.|
|{jade, sws, stylus}-mode|Major-mode for {Jade, sws, Stylus}.|
|vue-mode|Emacs major mode for vue.js based on mmm-mode. Modified version so It uses web-mode in templates and scripts instead of vue-mode-html and js-mode.|
|graphql-mode|Emacs mode to edit GraphQL schema and queries.|

#### Lisp
|Package|What does it do ?|
|---|---|
|slime|Mode for Common Lisp.|
|slime-company|Company-mode completion backend for Slime.|

In lisp.el you can use either Slime with sbcl, Slime with allegro-express and Quicklisp or Slime with LispWorks (the last option need a paid license of LispWorks)

##### For Slime with sbcl (by default) :
Just install sbcl

##### For Slime with allegro-express & Quicklisp :
Install allegro-express (http://franz.com/downloads/clp/survey)
Install quicklisp (https://astraybi.wordpress.com/2015/08/02/how-to-install-slimesbclquicklisp-into-emacs/)
(Un)comment the needed code in lisp.el

##### For Slime with LispWorks (must have paid license) :
Follow :
http://www.lispworks.com/documentation/lw51/LWUG/html/lwuser-16.htm

#### Prolog
|Package|What does it do ?|
|---|---|
|Prolog.el|Mode for Prolog.|

#### R
|Package|What does it do ?|
|---|---|
|ess|Let Emacs speeks statistics !|
|ess-R-data-view|Data viewer for GNU R.|

#### Latex
|Package|What does it do ?|
|---|---|
|auctex|Package for writing and formatting TeX files.|
|latex-preview-pane|Integrated component for visualizing your work.|

#### Python
|Package|What does it do ?|
|---|---|
|company-jedi|Company-mode completion back-end for Python JEDI|
|elpy|Python development environment|
|py-autopep8|Automatically format and correct any PEP8 errors|

Many thanks to every developpers that contributed to the awesomess of Emacs and it's packages

*Note :* Packages are organized in levels, so they load in a coherent order.
- Level 1 - Basic Emacs improvements
- Level 2 - Company-mode
- Level 3 - Packages adding a company-backend
- Level 4 - Packages needing Irony
- Level 5 - Ivy
- Level 6 - Packages depending on Ivy [and Company]
- Level 7 - All other packages
