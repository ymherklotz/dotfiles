;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


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
      doom-variable-pitch-font (font-spec :family "Libre Baskerville")
      doom-serif-font (font-spec :family "Libre Baskerville"))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'sanityinc-tomorrow-night)

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
(global-set-key (kbd "C-c c") #'org-capture)

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

;; Delete an emacs client frame.
(defun y/exit-emacs-client ()
  "consistent exit emacsclient. If not in emacs client, echo a
  message in minibuffer, don't exit emacs. If in server mode and
  editing file, do C-x # server-edit else do C-x 5 0
  delete-frame"
  (interactive)
  (if server-buffer-clients
      (server-edit)
    (delete-frame)))

(global-set-key (kbd "C-c q") #'y/exit-emacs-client)

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

(defun y/insert-date ()
  "Insert a timestamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%c" (current-time))))

(define-key y-map (kbd "d") 'y/insert-date)

;; Set backup directories into the tmp folder
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Automatically refresh files
(global-auto-revert-mode 1)
(setq auto-revert-verbose nil)

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
(use-package org
  :mode ("\\.org\\'" . org-mode)
  :init
  (map! :map org-mode-map
        "M-n" #'outline-next-visible-heading
        "M-p" #'outline-previous-visible-heading)
  (setq org-src-window-setup 'current-window
        org-return-follows-link t
        org-confirm-babel-evaluate nil
        org-use-speed-commands t
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
                                       ("t" . "theorem"))))

(use-package! org-id
  :after org)

;; Disable org indent mode and remove C-, from the org-mode-map.
(after! org
  (setq org-startup-indented nil)
  (define-key org-mode-map (kbd "C-,") nil))

;; Set agenda files, refile targets and todo keywords.
(setq org-agenda-files (mapcar 'expand-file-name
                               (list "~/Dropbox/org/inbox.org"
                                     "~/Dropbox/org/main.org"
                                     "~/Dropbox/org/tickler.org"
                                     (format-time-string "~/Dropbox/org/journals/%Y-%m.org")))
      org-refile-targets `(("~/Dropbox/org/main.org" :maxlevel . 2)
                           ("~/Dropbox/org/someday.org" :level . 1)
                           ("~/Dropbox/org/tickler.org" :maxlevel . 2)
                           (,(format-time-string "~/Dropbox/org/journals/%Y-%m.org") :maxlevel . 2))
      org-todo-keywords '((sequence "TODO(t)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")))

;; Set custom agenda commands which can be activated in the agenda viewer.
(setq org-agenda-custom-commands
        '(("w" "At work" tags-todo "@work"
           ((org-agenda-overriding-header "Work")))
          ("h" "At home" tags-todo "@home"
           ((org-agenda-overriding-header "Home")))
          ("u" "At uni" tags-todo "@uni"
           ((org-agenda-overriding-header "University")))))

;; Set up org registers to quickly jump to files that I use often.
(set-register ?l (cons 'file "~/.emacs.d/loader.org"))
(set-register ?m (cons 'file "~/Dropbox/org/main.org"))
(set-register ?i (cons 'file "~/Dropbox/org/inbox.org"))
(set-register ?c (cons 'file (format-time-string "~/Dropbox/org/journals/%Y-%m.org")))

;; Set up dictionaries
(setq ispell-dictionary "en_GB")

(use-package! flyspell
  :config
  (define-key flyspell-mode-map (kbd "C-.") nil)
  (define-key flyspell-mode-map (kbd "C-,") nil))

;; Set up zettelkasten mode
(use-package! zettelkasten
  :config
  (zettelkasten-mode t))

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
