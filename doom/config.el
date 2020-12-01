;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Yann Herklotz"
      user-mail-address "yann@yannherklotz.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Iosevka" :size 16)
      doom-variable-pitch-font (font-spec :family "Libre Baskerville" :size 12)
      doom-serif-font (font-spec :family "Libre Baskerville" :size 12))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'modus-operandi)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/Dropbox/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; Add some keybinding customisations.

;; Stop emacs from freezing when trying to minimize it on a tiling WM.
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "M-u")   #'upcase-dwim)
(global-set-key (kbd "M-l")   #'downcase-dwim)
(global-set-key (kbd "M-c")   #'capitalize-dwim)
(global-set-key (kbd "C-c z") #'quick-calc)
(global-set-key (kbd "<f5>")  #'revert-buffer)
(global-set-key (kbd "C-.")   #'other-window)
(global-set-key (kbd "C-,")   #'(lambda () (interactive) (other-window -1)))
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c /") #'avy-goto-word-1)
(global-set-key (kbd "M-=")   #'count-words)

;; Set undo-only correctly
(global-set-key (kbd "C-\\") 'undo-only)

;; Revert C-a and C-e to go to the beginning and end of line, not a fan of the
;; default smart functions.
(global-set-key (kbd "C-a") #'beginning-of-line)
(global-set-key (kbd "C-e") #'end-of-line)

;; Define functions to push and pop from mark.
(defun push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
   Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))

(defun jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
  This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))

(global-set-key (kbd "C-`")   #'push-mark-no-activate)
(global-set-key (kbd "M-`")   #'jump-to-mark)

;; Swap two window positions.
(defun y/swap-windows ()
  "Swaps two windows and leaves the cursor in the original one"
  (interactive)
  (ace-swap-window)
  (aw-flip-window))

;; Define a custom key map for other useful commands.
(define-prefix-command 'y-map)
(global-set-key (kbd "C-c y") 'y-map)

(define-key y-map (kbd "s") 'y/swap-windows)
(define-key y-map (kbd "p") 'password-store-copy)
(define-key y-map (kbd "i") 'password-store-insert)
(define-key y-map (kbd "g") 'password-store-generate)
(define-key y-map (kbd "r") 'toggle-rot13-mode)

(electric-indent-mode -1)

;; Mac configuration
(when (eq system-type 'darwin)
  (setq mac-right-option-modifier 'none
        mac-option-key-is-meta nil
        mac-command-key-is-meta t
        mac-command-modifier 'meta
        mac-option-modifier nil))

(defun y/insert-date ()
  "Insert a timestamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%c" (current-time))))

(define-key y-map (kbd "d") 'y/insert-date)

;; Set backup directories into the tmp folder
(defvar --backup-directory (concat user-emacs-directory "backups"))
(if (not (file-exists-p --backup-directory))
    (make-directory --backup-directory t))
(setq backup-directory-alist `(("." . ,--backup-directory)))
(setq make-backup-files t               ; backup of a file the first time it is saved.
      backup-by-copying t               ; don't clobber symlinks
      version-control t                 ; version numbers for backup files
      delete-old-versions t             ; delete excess backup files silently
      delete-by-moving-to-trash t
      kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t               ; auto-save every buffer that visits a file
      auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
      )

(setq tramp-auto-save-directory "/tmp")
(defvar disable-tramp-backups '(all))
(eval-after-load "tramp"
  '(progn
     ;; Modified from https://www.gnu.org/software/emacs/manual/html_node/tramp/Auto_002dsave-and-Backup.html
     (setq backup-enable-predicate
           (lambda (name)
             (and (normal-backup-enable-predicate name)
              ;; Disable all tramp backups
              (and disable-tramp-backups
                   (member 'all disable-tramp-backups)
                   (not (file-remote-p name 'method)))
              (not ;; disable backup for tramp with the listed methods
               (let ((method (file-remote-p name 'method)))
                 (when (stringp method)
                   (member method disable-tramp-backups)))))))

     (defun tramp-set-auto-save--check (original)
       (if (funcall backup-enable-predicate (buffer-file-name))
           (funcall original)
         (auto-save-mode -1)))

     (advice-add 'tramp-set-auto-save :around #'tramp-set-auto-save--check)

     ;; Use my ~/.ssh/config control master settings according to https://puppet.com/blog/speed-up-ssh-by-reusing-connections
     (setq tramp-ssh-controlmaster-options "")))


;; Set sensitive data mode
(setq auto-mode-alist
      (append
       (list '("\\.\\(vcf\\|gpg\\)\\'" . sensitive-minor-mode)
             '("\\.sv\\'" . verilog-mode))
       auto-mode-alist))

(after! verilog-mode
  (setq verilog-simulator "iverilog"))

;; Remove the ring for emacs
(setq ring-bell-function 'ignore)

;; Automatically refresh files
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)

;; Set sentence to end with double space
(setq sentence-end-double-space t)

;; Remove automatic `auto-fill-mode', and replace it by `visual-line-mode',
;; which is a personal preference.
(setq-default fill-column 100)
(remove-hook 'text-mode-hook #'auto-fill-mode)
(add-hook 'text-mode-hook #'+word-wrap-mode)
(add-hook 'text-mode-hook #'visual-fill-column-mode)

;; Set up magit when C-c g is called
(use-package! magit
  :bind (("C-x g" . magit-status)))

;; Configure activation for whitespace mode
(use-package! whitespace
  :bind (("C-x w" . whitespace-mode)))

;; Configure expand-region mode.
(use-package! expand-region
  :bind ("M-o" . er/expand-region))

;; Delete all whitespace until the first non-whitespace character.
(use-package! hungry-delete
  :config (global-hungry-delete-mode))

;; Org configuration
(use-package! org
  :mode ("\\.org\\'" . org-mode)
  :init
  (map! :map org-mode-map
        "M-n" #'outline-next-visible-heading
        "M-p" #'outline-previous-visible-heading)
  (setq org-src-window-setup 'current-window
        org-return-follows-link t
        org-confirm-babel-evaluate nil
        org-use-speed-commands t
        org-hide-emphasis-markers t
        org-adapt-indentation nil
        org-cycle-separator-lines 1
        org-structure-template-alist '(("a" . "export ascii")
                                       ("c" . "center")
                                       ("C" . "comment")
                                       ("e" . "example")
                                       ("E" . "export")
                                       ("h" . "export html")
                                       ("l" . "export latex")
                                       ("q" . "quote")
                                       ("s" . "src")
                                       ("v" . "verse")
                                       ("el" . "src emacs-lisp")
                                       ("d" . "definition")
                                       ("t" . "theorem")))
  (customize-set-variable 'org-blank-before-new-entry
                          '((heading . nil)
                            (plain-list-item . nil))))

(use-package! org-contacts
  :after org
  :init
  (setq org-contacts-files '("~/Dropbox/org/contacts.org")))

;; Disable org indent mode and remove C-, from the org-mode-map.
(after! org
  (define-key org-mode-map (kbd "C-,") nil)
  ;; Set agenda files, refile targets and todo keywords.
  (setq org-startup-indented nil
        org-agenda-files (mapcar 'expand-file-name
                                 (list "~/Dropbox/org/inbox.org"
                                       "~/Dropbox/org/main.org"
                                       "~/Dropbox/org/tickler.org"
                                       "~/Dropbox/org/projects.org"
                                       (format-time-string "~/Dropbox/org/%Y-%m.org")))
        org-refile-targets `(("~/Dropbox/org/main.org" :maxlevel . 2)
                             ("~/Dropbox/org/someday.org" :level . 1)
                             ("~/Dropbox/org/projects.org" :level . 1)
                             (,(format-time-string "~/Dropbox/org/%Y-%m.org") :level . 1))
        ;; Set custom agenda commands which can be activated in the agenda viewer.
        org-agenda-custom-commands
        '(("w" "At work" tags-todo "@work"
           ((org-agenda-overriding-header "Work")))
          ("h" "At home" tags-todo "@home"
           ((org-agenda-overriding-header "Home")))
          ("u" "At uni" tags-todo "@uni"
           ((org-agenda-overriding-header "University"))))
        org-log-done 'time
        org-capture-templates
        `(("t" "Todo" entry (file+headline ,(format-time-string "~/Dropbox/org/%Y-%m.org") "Tasks")
           "* TODO %^{Title}\nCreated: %U\n\n%?\n")
          ("c" "Contacts" entry (file "~/Dropbox/org/contacts.org")
           "* %(org-contacts-template-name)
  :PROPERTIES:
  :EMAIL: %(org-contacts-template-email)
  :END:"))
        org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "PROJ(p)"  ; A project, which usually contains other tasks
           "STRT(s)"  ; A task that is in progress
           "WAIT(w)"  ; Something external is holding up this task
           "HOLD(h)"  ; This task is paused/on hold because of me
           "|"
           "DONE(d!)"  ; Task successfully completed
           "KILL(k)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "[ ](T)"   ; A task that needs doing
           "[-](S)"   ; Task is in progress
           "[?](W)"   ; Task is being held up or paused
           "|"
           "[X](D)"))); Task was completed
  (setq org-html-head-extra
        "<script src=\"https://cdnjs.cloudflare.com/ajax/libs/tocbot/4.11.1/tocbot.min.js\"></script>
<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/tocbot/4.11.1/tocbot.css\">
<link rel=\"stylesheet\" type=\"text/css\" href=\"file:///Users/yannherklotz/Projects/orgcss/src/css/org.css\"/>"

        org-html-head-include-default-style nil
        org-html-head-include-scripts nil
        org-html-postamble-format
        '(("en" "<script>tocbot.init({
  tocSelector: '#table-of-contents',
  contentSelector: '#content',
  headingSelector: 'h2, h3',
  hasInnerContainers: true,
});</script>"))
        org-html-postamble t)

  (require 'ox-beamer)
  (require 'ox-latex)
  (add-to-list 'org-latex-classes
               '("beamer"
                 "\\documentclass\[presentation\]\{beamer\}"
                 ("\\section\{%s\}" . "\\section*\{%s\}")
                 ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
                 ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")))
  (add-to-list 'org-latex-classes
               '("scrartcl"
                 "\\documentclass\{scrartcl\}"
                 ("\\section\{%s\}" . "\\section*\{%s\}")
                 ("\\subsection\{%s\}" . "\\subsection*\{%s\}")
                 ("\\subsubsection\{%s\}" . "\\subsubsection*\{%s\}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")))
  (add-to-list 'org-latex-packages-alist '("" "minted"))
  (setq org-latex-listings 'minted)

  (setq org-latex-pdf-process
        '("%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (setq-default TeX-command-extra-options "-shell-escape"
        TeX-engine 'xetex)
  (setq org-beamer-environments-extra '(("onlyenv" "o" "\\begin{onlyenv}%a{%h}" "\\end{onlyenv}")
                                        ("onlyenvNH" "o" "\\begin{onlyenv}%a" "\\end{onlyenv}")
                                        ("blockNH" "o" "\\begin{block}%a{}" "\\end{block}"))))

;; Set up org ref for PDFs
(use-package! org-ref
  :demand
  :init
  (setq org-ref-completion-library 'org-ref-ivy-cite)
  :config
  (setq org-ref-bibliography-notes "~/Dropbox/bibliography/notes.org"
        org-ref-default-bibliography '("~/Dropbox/bibliography/references.bib")
        org-ref-pdf-directory "~/Dropbox/bibliography/papers")
  (setq reftex-default-bibliography '("~/Dropbox/bibliography/references.bib")))

;; Set up org-noter
(use-package! org-noter
  :after org
  :commands org-noter
  :config (setq org-noter-default-notes-file-names '("notes.org")
                org-noter-notes-search-path '("~/org/bibliography")
                org-noter-separate-notes-from-heading t))

(use-package! org-superstar
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list '("♠" "♣" "♥" "♦")
        org-superstar-special-todo-items t))

;; Set up org registers to quickly jump to files that I use often.
(set-register ?l (cons 'file "~/.emacs.d/loader.org"))
(set-register ?m (cons 'file "~/Dropbox/org/main.org"))
(set-register ?i (cons 'file "~/Dropbox/org/inbox.org"))
(set-register ?p (cons 'file "~/Dropbox/org/projects.org"))
(set-register ?c (cons 'file (format-time-string "~/Dropbox/org/%Y-%m.org")))

;; Bibtex stuff
(use-package! ebib
  :bind (("C-c y b" . ebib))
  :init
  (setq ebib-preload-bib-files '("~/Dropbox/bibliography/references.bib")
        ebib-notes-directory "~/Dropbox/bibliography/notes/")
  :config
  (add-to-list 'ebib-file-search-dirs "~/Dropbox/bibliography/papers")
  (add-to-list 'ebib-file-associations '("pdf" . "open"))
  (advice-add 'bibtex-generate-autokey :around
              #'(lambda (orig-func &rest args)
                  (replace-regexp-in-string ":" "" (apply orig-func args)))))

;; Set up dictionaries
(setq ispell-dictionary "en_GB")

(use-package! flyspell
  :hook (text-mode . flyspell-mode)
  :config
  (define-key flyspell-mode-map (kbd "C-.") nil)
  (define-key flyspell-mode-map (kbd "C-,") nil))

;; Set up zettelkasten mode
(use-package! zettelkasten
  :bind-keymap
  ("C-c k" . zettelkasten-mode-map))

;; Proof general configuration
(setq proof-splash-enable nil
      proof-auto-action-when-deactivating-scripting 'retract
      proof-delete-empty-windows nil
      proof-auto-raise-buffers t
      coq-compile-before-require nil
      coq-compile-vos t
      coq-compile-parallel-in-background t
      coq-max-background-compilation-jobs 4
      coq-compile-keep-going nil
      coq-compile-quick 'no-quick)

(setq coq-may-use-prettify nil
      company-coq-prettify-symbols nil)
(global-prettify-symbols-mode -1)

(use-package! smartparens
  :config
  (map! :map smartparens-mode-map
        "M-[" #'sp-backward-unwrap-sexp
        "M-]" #'sp-unwrap-sexp
        "C-M-f" #'sp-forward-sexp
        "C-M-b" #'sp-backward-sexp
        "C-M-d" #'sp-down-sexp
        "C-M-a" #'sp-backward-down-sexp
        "C-M-e" #'sp-up-sexp
        "C-M-u" #'sp-backward-up-sexp
        "C-M-t" #'sp-transpose-sexp
        "C-M-n" #'sp-next-sexp
        "C-M-p" #'sp-previous-sexp
        "C-M-k" #'sp-kill-sexp
        "C-M-w" #'sp-copy-sexp
        "C-)" #'sp-forward-slurp-sexp
        "C-}" #'sp-forward-barf-sexp
        "C-(" #'sp-backward-slurp-sexp
        "C-{" #'sp-backward-barf-sexp
        "M-D" #'sp-splice-sexp
        "C-]" #'sp-select-next-thing-exchange
        "C-<left_bracket>" #'sp-select-previous-thing
        "C-M-]" #'sp-select-next-thing
        "M-F" #'sp-forward-symbol
        "M-B" #'sp-backward-symbol
        "M-r" #'sp-split-sexp)
  (require 'smartparens-config)
  (show-smartparens-global-mode +1)
  (smartparens-global-mode 1))

;;(use-package! ormolu
;;  :hook (haskell-mode . ormolu-format-on-save-mode)
;;  :bind
;;  (:map haskell-mode-map
;;   ("C-c r" . ormolu-format-buffer)))

(after! writeroom-mode (setq +zen-text-scale 1))

(setq pdf-view-use-scaling t)

(setq doc-view-resolution 300)

(after! tuareg-mode
  (add-hook 'tuareg-mode-hook
            (lambda ()
              (define-key tuareg-mode-map (kbd "C-M-<tab>") #'ocamlformat)
              (add-hook 'before-save-hook #'ocamlformat-before-save))))

(use-package! ox-reveal
  :after org)

(use-package! direnv
  :config
  (direnv-mode))

(use-package! alectryon
  :load-path "/Users/yannherklotz/Projects/alectryon/etc/elisp")

;;(use-package! ox-ssh
;;  :after org
;;  :config
;;  (when (eq system-type 'darwin)
;;    (setq org-ssh-header "XAuthLocation /opt/X11/bin/xauth")))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-blank-before-new-entry (quote ((heading) (plain-list-item))))
 '(package-selected-packages (quote (org-plus-contrib)))
 '(safe-local-variable-values
   (quote
    ((eval add-to-list
           (quote auto-mode-alist)
           (quote
            ("\\.v\\'" . verilog-mode)))
     (eval setq org-ref-pdf-directory
           (concat
            (projectile-project-root)
            "papers/"))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
