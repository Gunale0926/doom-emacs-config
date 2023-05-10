;;; $DOWDIER/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. MPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Carter Cao"
      user-mail-address "Gunale0926@hotmail.com")
;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

(setq doom-font (font-spec :family "SF Mono" :size 16)
      doom-unicode-font (font-spec :family "FiraCode Nerd Font" :size 16))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-xcode)
(setq doom-theme 'dracula-pro-vanhelsing)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(after! org
  (setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f" "xelatex -interaction nonstopmode %f"))
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2.0))
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-cite-csl-styles-dir "~/Zotero/styles")
  (setq org-cite-global-bibliography '("~/Documents/Org/biblio.bib"))
  (setq org-directory "~/Documents/Org")
  (setq org-agenda-files (directory-files-recursively "~/Documents/Org/" "\\.org$")))

(after! org-roam
  (setq org-roam-directory "~/Documents/Org")
  (setq org-roam-dailies-directory "~/Documents/Org/Journals")
  (setq org-roam-capture-templates
        '(("m" "Main" plain
           "%?"
           :if-new (file+head "Main/${id}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("s" "Study notes" plain "%?"
           :if-new (file+head "Study/${id}.org"
                              "#+title: ${title}\n#+filetags: :${subject}:CNUHS-2023-Spring:\n")
           :immediate-finish t
           :unnarrowed t)
          ("d" "Dev notes" plain "%?"
           :if-new (file+head "Dev/${id}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)))
  (use-package! org-roam-ui
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t)))

(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))

(use-package! python-black
  :demand t
  :after python)
(add-hook! 'python-mode-hook #'python-black-on-save-mode)

(use-package! nov
  :mode ("\\.epub\\'" . nov-mode)
  :config
  (setq nov-save-place-file (concat doom-cache-dir "nov-places")))

(add-to-list 'load-path "~/.doom.d/plugins/")

(use-package! org-modern-indent
  :hook (org-mode . org-modern-indent-mode))

(use-package org-modern
  :ensure t
  :custom
  (org-modern-hide-stars nil)
  (org-modern-table nil)
  (org-modern-list
   '((?- . "-")
     (?* . "•")
     (?+ . "‣")))
  :hook
  (org-mode . org-modern-mode)
  (org-agenda-finalize . org-modern-agenda))

(add-to-list 'load-path "~/.doom.d/plugins/org-noter-plus-djvu/modules")
(add-to-list 'load-path "~/.doom.d/plugins/org-noter-plus-djvu")

(after! org-noter
  (setq org-noter-highlight-selected-text t))
(require 'org-noter-pdf)
(require 'org-noter-nov)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
