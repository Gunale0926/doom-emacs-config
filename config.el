;;; $DOWDIER/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. MPG configuration, email
;; clients, file templates and snippets. It is optional.
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq user-full-name "Yang Cao"
      user-mail-address "Gunale0926@hotmail.com")
;; Doom exposes five (optional) variables for controlling fonts in Doom:
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:

(setq doom-font (font-spec :family "Liga SFMono Nerd Font" :size 14))

;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:

(setq doom-theme 'doom-xcode)

;; (use-package! nano)

;; (setq doom-theme 'dracula-pro-vanhelsing)
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq! display-line-numbers-type 'relative)

;;(setenv "PATH" (concat (getenv "PATH") ":/Library/TeX/texbin/"))
;;(setq exec-path (append exec-path '("/Library/TeX/texbin/")))

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!

(use-package! eshell
  :config
  (conda-env-initialize-eshell)
  (conda-env-initialize-interactive-shells))


(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)
              ("C-n" . 'copilot-next-completion)
              ("C-p" . 'copilot-previous-completion))

  :config
  (add-to-list 'copilot-indentation-alist '(prog-mode 2))
  (add-to-list 'copilot-indentation-alist '(org-mode 2))
  (add-to-list 'copilot-indentation-alist '(text-mode 2))
  (add-to-list 'copilot-indentation-alist '(closure-mode 2))
  (add-to-list 'copilot-indentation-alist '(emacs-lisp-mode 2)))

(use-package! vertico
  :config (vertico-posframe-mode 1))


;; (use-package! minimap
;;   :config
;;   (minimap-mode 1))

;;Cpp
(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
;;Python
(use-package! python-black
  :demand t
  :after python)
(add-hook! 'python-mode-hook #'python-black-on-save-mode)

(use-package! conda
  :config
  (setq conda-env-autoactivate-mode t))

;; Org-Mode
(use-package! org
  :config
  (setq org-attach-store-link-p 'attached)
  (setq org-directory "~/Documents/Org/")
  (setq org-cite-global-bibliography '("~/Documents/References/biblib.bib"))
  (setq bibtex-completion-bibliography  org-cite-global-bibliography)
  (setq org-attach-id-dir (concat org-directory "Attachments/"))
  (setq org-latex-pdf-process
        (let
            ((cmd (concat "xelatex -shell-escape -interaction nonstopmode"
                          " --synctex=1"
                          " -output-directory %o %f")))
          (list cmd
                "cd %o; if test -r %b.idx; then makeindex %b.idx; fi"
                "cd %o; bibtex %b"
                cmd
                cmd)))
  (setq org-preview-latex-default-process 'dvisvgm)
  (setq org-format-latex-options (plist-put org-format-latex-options :scale 2))
  (setq org-cite-csl-styles-dir "~/Zotero/styles")
  (setq org-latex-prefer-user-labels t)
  (setq org-agenda-files (directory-files-recursively org-directory "\\.org$"))
  )

(defun org-babel-edit-prep:python (babel-info)
  (setq-local buffer-file-name (->> babel-info caddr (alist-get :tangle)))
  (lsp))

(after! org-roam
  (setq org-roam-directory org-directory)
  (setq org-roam-dailies-directory "./journals")
  (setq org-roam-file-exclude-regexp (concat "^" (expand-file-name org-roam-directory) "logseq/"))
  (setq org-roam-capture-templates
        '(("p" "page" plain
           "%?"
           :if-new (file+head "pages/${id}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed f)
          ("r" "reference" plain
           "%?"
           :if-new (file+head "%(expand-file-name (or citar-org-roam-subdir \"\") org-roam-directory)/refs/${citar-citekey}.org"
                              "#+title: ${note-title}\n\n")
           :immediate-finish t
           :unnarrowed f)
          ("a" "SemAI" plain
           "%?"
           :if-new (file+head "semai/${id}.org"
                              "#+title: ${note-title}\n\n")
           :immediate-finish t
           :unnarrowed f)
          ("m" "mla" plain
           "%?"
           :if-new (file+head "pages/${id}.org"
                              "#+title: ${title}\n#+OPTIONS: author:nil date:nil toc:nil title:nil\nCITE_EXPORT: csl ~/Zotero/styles/modern-language-association.csl\n#+LATEX_HEADER: \\usepackage{mla13}\n#+LATEX_HEADER: \\firstname{Yang}\n#+LATEX_HEADER: \\lastname{Cao}\n#+LATEX_HEADER: \\professor{${prof}}\n#+LATEX_HEADER: \\class{${class}}\n#+LATEX_HEADER: \\title{${title}}\n\\makeheader")

           :immediate-finish t
           :unnarrowed f)
          ))

  (use-package! org-roam-ui
    :config
    (map! :leader "n r u" #'org-roam-ui-open)
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start t))
  (use-package! consult-org-roam
    :config
    (map! :leader "n r c" #'consult-org-roam-search)))

(use-package! citar
  :init
  (setq citar-bibliography org-cite-global-bibliography)
  (setq citar-notes-paths (list org-directory))
  :custom
  (org-cite-insert-processor 'citar)
  (org-cite-follow-processor 'citar)
  (org-cite-activate-processor 'citar))

(use-package! citar-org-roam
  :after (citar org-roam)
  :config
  (citar-org-roam-mode)
  (setq citar-org-roam-note-title-template "${title}")
  (setq citar-org-roam-capture-template-key "r"))

;; (use-package! zotxt
;;  :init
;;  (require 'org-zotxt-noter)
;;  (map! :leader
;;        (:prefix ("z" . "Zotxt")
;;                 (:desc "insert citekey" "i" #'zotxt-citekey-insert)
;;                 (:desc "open attachment" "o" #'org-zotxt-open-attachment)
;;                 (:desc "open noter" "e" #'org-zotxt-noter)))
;;  :hook
;;  (org-mode . org-zotxt-mode))

;; (use-package! nov
;;   :mode ("\\.epub\\'" . nov-mode)
;;   :config
;;   (setq nov-save-place-file (concat doom-cache-dir "nov-places")))

(use-package! org-noter
  :config
  (setq org-noter-highlight-selected-text t))

(use-package! pdf-view
  :config
  (setq rectangle-mark-mode t)
  :hook
  (pdf-view-mode . pdf-view-midnight-minor-mode))

(use-package! org-modern
  :hook (org-mode . org-modern-mode)
  :hook (org-mode . +org-pretty-mode)
  :config
  (setq
   ;; Edit settings
   org-fold-catch-invisible-edits 'show-and-error
   org-special-ctrl-a/e t
   org-insert-heading-respect-content t
   ;; Appearance
   org-modern-hide-stars "·"
   org-modern-star ["⁖"]
   org-modern-keyword t
   +org-pretty-mode t
   ))

(use-package! org-appear
  :hook
  (org-mode . org-appear-mode)
  :config
  (setq org-hide-emphasis-markers t
        org-appear-autolinks t))


;; (add-to-list 'load-path "~/.config/doom/plugins/")

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
