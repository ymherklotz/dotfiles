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
;;      doom-variable-pitch-font (font-spec :family "Alegreya" :size 12)
;;      doom-serif-font (font-spec :family "Alegreya" :size 12))
)
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

;; Disable stuff
(global-prettify-symbols-mode -1)
(electric-indent-mode -1)
(menu-bar-mode -1)

;; Add some keybinding customisations.

;; Stop emacs from freezing when trying to minimize it on a tiling WM.
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "M-u")   #'upcase-dwim)
(global-set-key (kbd "M-l")   #'downcase-dwim)
(global-set-key (kbd "M-c")   #'capitalize-dwim)
(global-set-key (kbd "C-c z") #'quick-calc)
(global-set-key (kbd "<f5>")  #'revert-buffer)
(global-set-key (kbd "C-.")   #'other-window)
(global-set-key (kbd "C-,")   (lambda () (interactive) (other-window -1)))
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

(define-key y-map (kbd "p")   #'password-store-copy)
(define-key y-map (kbd "i")   #'password-store-insert)
(define-key y-map (kbd "g")   #'password-store-generate)
(define-key y-map (kbd "r")   #'toggle-rot13-mode)
(define-key y-map (kbd "c")   #'calendar)
(define-key y-map (kbd "C-r") #'ymhg/reload-keywords)
(define-key y-map (kbd "d")   #'y/insert-date)
(define-key y-map (kbd "s")   (lambda () (interactive)
                                (let ((org-agenda-files '("~/Dropbox/zk/hls.org"
                                                          "~/Dropbox/zk/computing.org"
                                                          "~/Dropbox/zk/verification.org"
                                                          "~/Dropbox/zk/mathematics.org"
                                                          "~/Dropbox/zk/hardware.org"))) (org-search-view))))

;; Mac configuration
(when (eq system-type 'darwin)
  (progn (setq mac-right-option-modifier 'none
               mac-option-key-is-meta nil
               mac-command-key-is-meta t
               mac-command-modifier 'meta
               mac-option-modifier nil)

         (defun ymhg/apply-theme (appearance)
           "Load theme, taking current system APPEARANCE into consideration."
           (mapc #'disable-theme custom-enabled-themes)
           (pcase appearance
             ('light (load-theme 'modus-operandi t))
             ('dark (load-theme 'modus-vivendi t))))

         (add-hook 'ns-system-appearance-change-functions #'ymhg/apply-theme)))

(defun y/insert-date ()
  "Insert a timestamp according to locale's date and time format."
  (interactive)
  (insert (format-time-string "%c" (current-time))))

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

     (advice-add #'tramp-set-auto-save :around #'tramp-set-auto-save--check)

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
  :bind (("C-x w" . whitespace-mode))
  :init
  (setq whitespace-style '(newline newline-mark))
  (setq whitespace-display-mappings '((newline-mark 10 [?¬ 10]))))

;; Configure expand-region mode.
(use-package! expand-region
  :bind ("M-o" . er/expand-region))

;; Delete all whitespace until the first non-whitespace character.
(use-package! hungry-delete
  :config
  (global-hungry-delete-mode)
  ;; disable hungry delete in minibuffer-mode: https://github.com/abo-abo/swiper/issues/2761
  (add-to-list 'hungry-delete-except-modes 'minibuffer-mode))

;; Org configuration
(use-package! org
  :mode ("\\.org\\'" . org-mode)
  :init
  (map! :map org-mode-map
        "M-n"   #'outline-next-visible-heading
        "M-p"   #'outline-previous-visible-heading
        "C-c ]" #'ebib-insert-citation
        "C-,"   nil)
  (setq org-src-window-setup 'current-window
        org-return-follows-link t
        org-confirm-babel-evaluate nil
        org-use-speed-commands t
        org-hide-emphasis-markers t
        org-adapt-indentation nil
        org-cycle-separator-lines 2
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
  ;;(customize-set-variable 'org-blank-before-new-entry
  ;;                        '((heading . nil)
  ;;                          (plain-list-item . nil)))
  )

(use-package! org-contacts
  :after org
  :init
  (setq org-contacts-files '("~/Dropbox/org/contacts.org")))

;; Disable org indent mode and remove C-, from the org-mode-map.
(after! org
  ;; Set agenda files, refile targets and todo keywords.
  (setq org-startup-indented nil)
  (setq org-log-done 'time
        org-log-into-drawer t)
  (setq org-agenda-files (mapcar 'expand-file-name
                                 (list "~/Dropbox/org/inbox.org"
                                       "~/Dropbox/org/main.org"
                                       "~/Dropbox/org/tickler.org"
                                       "~/Dropbox/org/projects.org"
                                       (format-time-string "~/Dropbox/org/%Y-%m.org")
                                       "~/Dropbox/bibliography/reading_list.org")))
  (setq org-refile-targets `(("~/Dropbox/org/main.org" :level . 1)
                             ("~/Dropbox/org/someday.org" :level . 1)
                             ("~/Dropbox/org/projects.org" :maxlevel . 2)
                             (,(format-time-string "~/Dropbox/org/%Y-%m.org") :level . 1)))
        ;; Set custom agenda commands which can be activated in the agenda viewer.
  (setq org-agenda-custom-commands
        '(("w" "At work" tags-todo "@work"
           ((org-agenda-overriding-header "Work")))
          ("h" "At home" tags-todo "@home"
           ((org-agenda-overriding-header "Home")))
          ("u" "At uni" tags-todo "@uni"
           ((org-agenda-overriding-header "University")))))

  (setq org-agenda-span 7
        org-agenda-start-day "."
        org-agenda-start-on-week 1)
  (setq org-agenda-include-diary t)

  (setq org-capture-templates
        `(("t" "Todo" entry (file "inbox.org")
           "* TODO %?
:PROPERTIES:
:ID: %(org-id-uuid)
:END:
:LOGBOOK:
- State \"TODO\"       from \"\"           %U
:END:" :empty-lines 1)
          ("l" "Link Todo" entry (file "inbox.org")
           "* TODO %?
:PROPERTIES:
:ID: %(org-id-uuid)
:END:
:LOGBOOK:
- State \"TODO\"       from \"\"           %U
:END:

%a" :empty-lines 1)
          ("c" "Contacts" entry (file "~/Dropbox/org/contacts.org")
           "* %(org-contacts-template-name)
  :PROPERTIES:
  :EMAIL: %(org-contacts-template-email)
  :END:" :empty-lines 1))

        org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "PROJ(p)"  ; A project, which usually contains other tasks
           "STRT(s)"  ; A task that is in progress
           "DELG(d)"  ; A task that is in progress
           "WAIT(w)"  ; Something external is holding up this task
           "HOLD(h)"  ; This task is paused/on hold because of me
           "DELG(l)"  ; This task is delegated
           "SMDY(m)" ; todo some day
           "|"
           "DONE(d!)"  ; Task successfully completed
           "KILL(k)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "[ ](T)"   ; A task that needs doing
           "[-](S)"   ; Task is in progress
           "[?](W)"   ; Task is being held up or paused
           "|"
           "[X](D)"))
        org-todo-keyword-faces '(("[-]" . +org-todo-active)
                                ("STRT" . +org-todo-active)
                                ("[?]" . +org-todo-onhold)
                                ("WAIT" . +org-todo-onhold)
                                ("HOLD" . +org-todo-onhold)
                                ("DELG" . +org-todo-onhold)
                                ("SMDY" . +org-todo-onhold)
                                ("PROJ" . +org-todo-project)
                                ("NO" . +org-todo-cancel)
                                ("KILL" . +org-todo-cancel))); Task was completed
;;  (setq org-html-head-extra
;;        "<script src=\"https://cdnjs.cloudflare.com/ajax/libs/tocbot/4.11.1/tocbot.min.js\"></script>
;;<link rel=\"stylesheet\" href=\"https://cdnjs.cloudflare.com/ajax/libs/tocbot/4.11.1/tocbot.css\">
;;<link rel=\"stylesheet\" type=\"text/css\" href=\"file:///Users/yannherklotz/Projects/orgcss/src/css/org.css\"/>"
  (setq org-html-head-extra "<link rel=\"stylesheet\" type=\"text/css\" href=\"file:///Users/yannherklotz/Projects/orgcss/src/css/org.css\"/>"
        org-html-head-include-default-style nil
        org-html-head-include-scripts nil
        org-html-postamble-format
        '(("en" ""))
        org-html-postamble t
        org-html-divs '((preamble "header" "header")
                        (content "article" "content")
                        (postamble "footer" "postamble")))

  (setq org-export-with-broken-links t)

  (require 'calendar)
  (setq calendar-mark-diary-entries-flag t)
  (setq calendar-mark-holidays-flag t)
  (setq calendar-mode-line-format nil)
  (setq calendar-time-display-form
        '(24-hours ":" minutes
                   (when time-zone
                     (format "(%s)" time-zone))))
  (setq calendar-week-start-day 1)      ; Monday
  (setq calendar-date-style 'iso)
  (setq calendar-date-display-form calendar-iso-date-display-form)
  (setq calendar-time-zone-style 'numeric) ; Emacs 28.1

  (require 'cal-dst)
  (setq calendar-standard-time-zone-name "+0000")
  (setq calendar-daylight-time-zone-name "+0100")

  (require 'diary-lib)
  (setq diary-file "~/Dropbox/org/diary")
  (setq diary-date-forms diary-iso-date-forms)
  (setq diary-comment-start ";;")
  (setq diary-comment-end "")
  (setq diary-nonmarking-symbol "!")
  (setq diary-show-holidays-flag t)
  (setq diary-display-function #'diary-fancy-display) ; better than its alternative
  (setq diary-header-line-format nil)
  (setq diary-list-include-blanks nil)
  (setq diary-number-of-entries 2)
  (setq diary-mail-days 2)
  (setq diary-abbreviated-year-flag nil)

  (add-hook 'diary-sort-entries #'diary-list-entries-hook)

  (add-hook 'calendar-today-visible-hook #'calendar-mark-today)
  (add-hook 'diary-list-entries-hook 'diary-sort-entries t)

  (add-hook 'diary-list-entries-hook 'diary-include-other-diary-files)
  (add-hook 'diary-mark-entries-hook 'diary-mark-included-diary-files)
  ;; Prevent Org from interfering with my key bindings.
  (remove-hook 'calendar-mode-hook #'org--setup-calendar-bindings)

  (let ((map calendar-mode-map))
    (define-key map (kbd "s") #'calendar-sunrise-sunset)
    (define-key map (kbd "l") #'lunar-phases)
    (define-key map (kbd "i") nil) ; Org sets this, much to my chagrin (see `remove-hook' above)
    (define-key map (kbd "i a") #'diary-insert-anniversary-entry)
    (define-key map (kbd "i c") #'diary-insert-cyclic-entry)
    (define-key map (kbd "i d") #'diary-insert-entry) ; for current "day"
    (define-key map (kbd "i i") #'diary-insert-entry) ; most common action, easier to type
    (define-key map (kbd "i m") #'diary-insert-monthly-entry)
    (define-key map (kbd "i w") #'diary-insert-weekly-entry)
    (define-key map (kbd "i y") #'diary-insert-yearly-entry)
    (define-key map (kbd "M-n") #'calendar-forward-month)
    (define-key map (kbd "M-p") #'calendar-backward-month))

  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines))

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
                                        ("blockNH" "o" "\\begin{block}%a{}" "\\end{block}")
                                        ("minipage" "o" "\\begin{minipage}[t]%o[t]{1.0\\textwidth}" "\\end{minipage}"))))

(use-package! ox-tufte
  :after org)

(use-package appt
  :config
  (setq appt-display-diary nil)
  (setq appt-disp-window-function #'appt-disp-window)
  (setq appt-display-mode-line t)
  (setq appt-display-interval 3)
  (setq appt-audible nil)
  (setq appt-warning-time-regexp "appt \\([0-9]+\\)")
  (setq appt-message-warning-time 15)
  (run-at-time 10 nil #'appt-activate 1))

;; Set up org ref for PDFs
(use-package! org-ref
  :demand
  :init
  (setq org-ref-completion-library 'org-ref-ivy-cite)
  :config
  (setq org-ref-bibliography-notes "~/Dropbox/bibliography/notes.org"
        org-ref-default-bibliography '("~/Dropbox/bibliography/references.bib")
        org-ref-pdf-directory "~/Dropbox/bibliography/papers"
        org-ref-bib-html "")
  (setq reftex-default-bibliography '("~/Dropbox/bibliography/references.bib")))

(use-package! org-transclusion
  :after org
  :config
  (setq org-transclusion-exclude-elements '(property-drawer headline)))

(use-package! org-superstar
  :hook (org-mode . org-superstar-mode)
  :config
  (setq org-superstar-headline-bullets-list '("♚" "♛" "♜" "♝" "♞" "♔" "♕" "♖" "♗" "♘" "♙")
        org-superstar-special-todo-items t))

(use-package! org-id
  :after org
  :config
  (setq org-id-link-to-org-use-id 'use-existing)
  (setq org-id-track-globally t))

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
        ebib-notes-directory "~/Dropbox/bibliography/notes/"
        ebib-notes-template "#+TITLE: Notes on: %T\n\n>|<"
        ebib-keywords (expand-file-name "~/Dropbox/bibliography/keywords.txt")
        ebib-reading-list-file "~/Dropbox/bibliography/reading_list.org"
        ebib-notes-storage 'multiple-notes-per-file)
  :config
  (add-to-list 'ebib-file-search-dirs "~/Dropbox/bibliography/papers")
  (if (eq system-type 'darwin)
      (add-to-list 'ebib-file-associations '("pdf" . "open"))
    (add-to-list 'ebib-file-associations '("pdf" . nil)))
  (add-to-list 'ebib-citation-commands '(org-mode (("ref" "cite:%(%K%,)"))))

  (advice-add 'bibtex-generate-autokey :around
              (lambda (orig-func &rest args)
                (replace-regexp-in-string ":" "" (apply orig-func args))))
  (remove-hook 'ebib-notes-new-note-hook #'org-narrow-to-subtree))

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

(use-package! elfeed-org
  :config
  (elfeed-org)
  (setq rmh-elfeed-org-files (list "~/Dropbox/org/elfeed.org")))

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

(use-package! lsp-haskell
 :config
 (setq lsp-haskell-process-path-hie "haskell-language-server-wrapper")
 ;; Comment/uncomment this line to see interactions between lsp client/server.
 ;;(setq lsp-log-io t)
)


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

;;(use-package! alectryon
;;  :load-path "/Users/yannherklotz/Projects/alectryon/etc/elisp")

(defun ymhg/incr-id (ident)
  (let* ((ident-list (append nil ident nil))
         (last-ident (last ident-list)))
    (setcar last-ident (+ (car last-ident) 1))
    (concat ident-list)))

(defun ymhg/incr-id-total (ident)
  (if (string-match-p "\\(.*[a-z]\\)\\([0-9]+\\)$" ident)
      (progn
        (string-match "\\(.*[a-z]\\)\\([0-9]+\\)$" ident)
        (let ((pre (match-string 1 ident))
              (post (match-string 2 ident)))
          (concat pre (number-to-string (+ 1 (string-to-number post))))))
    (ymhg/incr-id ident)))

(defun ymhg/branch-id (ident)
  (if (string-match-p ".*[0-9]$" ident)
      (concat ident "a")
    (concat ident "1")))

(defun ymhg/org-zettelkasten-create (incr newheading)
  (let* ((current-id (org-entry-get nil "CUSTOM_ID"))
         (next-id (funcall incr current-id)))
    (funcall newheading)
    (org-set-property "CUSTOM_ID" next-id)))

(defun org-zettelkasten-create-next ()
  (ymhg/org-zettelkasten-create
   'ymhg/incr-id 'org-insert-heading))

(defun org-zettelkasten-create-branch ()
  (ymhg/org-zettelkasten-create
   'ymhg/branch-id '(lambda () (org-insert-subheading ""))))

(defun org-zettelkasten-create-dwim ()
  (interactive)
  (let ((current-point (save-excursion
                         (org-back-to-heading)
                         (point)))
        (next-point (save-excursion
                      (org-forward-heading-same-level 1 t)
                      (point))))
    (if (= current-point next-point)
        (org-zettelkasten-create-next)
      (org-zettelkasten-create-branch))))

;;(defun org-zettelkasten-search-current-id ()
;;    (interactive)
;;    (let ((current-id (org-entry-get nil "CUSTOM_ID")))
;;      (counsel-rg (concat "#" current-id) "~/Dropbox/zk" "-g *.org" "ID: ")))

(define-key org-mode-map (kbd "C-c y n") #'org-zettelkasten-create-dwim)
(define-key org-mode-map (kbd "C-c y s") #'org-zettelkasten-search-current-id)

(use-package! ox-hugo
  :after ox)

(defun sci-hub-pdf-url (doi)
  "Get url to the pdf from SCI-HUB using DOI."
  (setq *doi-utils-pdf-url* (concat "https://sci-hub.do/" doi) ;captcha
        *doi-utils-waiting* t
        )
  ;; try to find PDF url (if it exists)
  (url-retrieve (concat "https://sci-hub.do/" doi)
                (lambda (_)
                  (goto-char (point-min))
                  (while (search-forward-regexp
                          "\\(https://\\|//sci-hub.do/downloads\\).+download=true'" nil t)
                    (let ((foundurl (match-string 0)))
                      (message foundurl)
                      (if (string-match "https:" foundurl)
                          (setq *doi-utils-pdf-url* foundurl)
                        (setq *doi-utils-pdf-url* (concat "https:" foundurl))))
                    (setq *doi-utils-waiting* nil))))
  (while *doi-utils-waiting* (sleep-for 0.1))
  *doi-utils-pdf-url*)

(defun download-pdf-from-doi (doi key)
  "Download pdf from doi with KEY name."
  (url-copy-file (sci-hub-pdf-url doi)
                 (concat "~/Dropbox/bibliography/papers/" key ".pdf")))

(defun get-bib-from-doi (doi)
  "Get the bibtex from DOI."
  (shell-command (concat "curl -L -H \"Accept: application/x-bibtex; charset=utf-8\" "
                         "https://doi.org/" doi)))

(use-package erc
  :commands (erc erc-tls)
  :bind (:map erc-mode-map
              ("C-c r" . reset-erc-track-mode))
  :preface
  (defun irc ()
    (interactive)
    (erc :server "ee-ymh15.ee.ic.ac.uk" :port 12844 :nick "ymherklotz"
             :password "ymherklotz/freenode:xxx"))

  (defun ymhg/erc-notify (nickname message)
  "Displays a notification message for ERC."
  (let* ((channel (buffer-name))
         (nick (erc-hl-nicks-trim-irc-nick nickname))
         (title (if (string-match-p (concat "^" nickname) channel)
                    nick
                  (concat nick " (" channel ")")))
         (msg (s-trim (s-collapse-whitespace message))))
    (alert (concat nick ": " msg) :title title)))
  :hook ((ercn-notify . ymhg/erc-notify))
  :config
  (setq erc-autojoin-timing 'ident)
  (setq erc-fill-function 'erc-fill-static)
  (setq erc-fill-static-center 22)
  (setq erc-hide-list '("JOIN" "PART" "QUIT"))
  (setq erc-lurker-hide-list '("JOIN" "PART" "QUIT"))
  (setq erc-lurker-threshold-time 43200)
  (setq erc-prompt-for-password nil)
  (setq erc-track-exclude-types '("JOIN" "MODE" "NICK" "PART" "QUIT"
                                  "324" "329" "332" "333" "353" "477"))
  (setq erc-fill-column 100)
  (add-to-list 'erc-modules 'notifications)
  (add-to-list 'erc-modules 'spelling)
  (erc-services-mode 1)
  (erc-update-modules)
  (erc-track-minor-mode 1)
  (erc-track-mode 1))

(use-package erc-hl-nicks
  :after erc)

(use-package znc
  :after erc
  :config
  (setq znc-servers '(("ee-ymh15.ee.ic.ac.uk" 12843 t ((freenode "ymherklotz" "xxx"))))))

(use-package alert
  :custom
  (alert-default-style 'osx-notifier))

(use-package ledger-mode)

;; Bug fixes

;; Projectile compilation buffer not there anymore for some reason
(setq compilation-buffer-name-function #'compilation--default-buffer-name)

(defun diary-last-day-of-month (date)
  "Return `t` if DATE is the last day of the month."
  (let* ((day (calendar-extract-day date))
         (month (calendar-extract-month date))
         (year (calendar-extract-year date))
         (last-day-of-month
          (calendar-last-day-of-month month year)))
    (= day last-day-of-month)))

(setq message-send-mail-function 'message-send-mail-with-sendmail)

(use-package! sendmail
  :config
  (if (eq system-type 'darwin)
      (setq sendmail-program "/usr/local/bin/msmtp")
    (setq sendmail-program "/usr/bin/msmtp")))

(setq message-signature "Yann Herklotz
Imperial College London
https://yannherklotz.com")

(setq auth-sources '("~/.authinfo" "~/.authinfo.gpg" "~/.netrc"))

(setq mail-specify-envelope-from t
      message-sendmail-envelope-from 'header
      mail-envelope-from 'header)

(use-package! modus-operandi-theme
  :config
  (custom-theme-set-faces! 'modus-operandi
    '(proof-locked-face ((t (:extend t :background "gray90"))))))

(use-package! modus-vivendi-theme
  :config
  (custom-theme-set-faces! 'modus-vivendi
    '(proof-locked-face ((t (:extend t :background "gray20"))))))

(use-package! notmuch
  :config
  (defun ymhg/notmuch-search-delete-mail (&optional beg end)
    "Delete a message."
    (interactive (notmuch-interactive-region))
    (if (member "deleted" (notmuch-search-get-tags))
        (notmuch-search-tag (list "-deleted"))
      (notmuch-search-tag (list "+deleted" "-unread") beg end)))

  (defun ymhg/notmuch-show-delete-mail (&optional beg end)
    "Delete a message."
    (interactive (notmuch-interactive-region))
    (if (member "deleted" (notmuch-show-get-tags))
        (notmuch-show-tag (list "-deleted"))
      (notmuch-show-tag (list "+deleted" "-unread") beg end)))

  (map!
   :map notmuch-show-mode-map
   "d" #'ymhg/notmuch-show-delete-mail)
  (map!
   :map notmuch-search-mode-map
   "d" #'ymhg/notmuch-search-delete-mail)

  (setq notmuch-saved-searches
        '((:name "inbox" :query "tag:inbox not tag:deleted" :key "n")
          (:name "flagged" :query "tag:flagged" :key "f")
          (:name "sent" :query "tag:sent" :key "s")
          (:name "drafts" :query "tag:draft" :key "d")
          (:name "mailbox" :query "tag:mailbox not tag:deleted not tag:sent" :key "m")
          (:name "imperial" :query "tag:imperial not tag:deleted not tag:sent" :key "i")))

  (setq notmuch-fcc-dirs
      '(("yann@yannherklotz.com"          . "mailbox/Sent -inbox +sent -unread +mailbox -new")
        ("yann.herklotz15@imperial.ac.uk" . "\"imperial/Sent Items\" -inbox +sent -unread +imperial -new"))))

;;(use-package! ox-ssh
;;  :after org
;;  :config
;;  (when (eq system-type 'darwin)
;;    (setq org-ssh-header "XAuthLocation /opt/X11/bin/xauth")))
