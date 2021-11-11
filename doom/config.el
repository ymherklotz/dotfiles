(setq doom-font (font-spec :family "Iosevka" :size 16))
(when (eq system-type 'darwin)
  (setq doom-variable-pitch-font (font-spec :family "Alegreya" :size 12))
  (setq doom-serif-font (font-spec :family "Alegreya" :size 12)))

(setq org-directory "~/Dropbox/org/")

(setq display-line-numbers-type nil)

(use-package modus-themes
  :init
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-region '(bg-only no-extend))

  ;; Load the theme files before enabling a theme
  (modus-themes-load-themes)
  (custom-theme-set-faces! '(modus-vivendi modus-operandi)
    '(proof-locked-face :inherit modus-themes-nuanced-cyan)
    '(proof-queue-face :inherit modus-themes-nuanced-magenta))
  :config
  ;; Load the theme of your choice:
  (modus-themes-load-operandi) ;; OR (modus-themes-load-vivendi)
  :bind ("<f6>" . modus-themes-toggle))

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
(global-set-key (kbd "C-x m") #'+notmuch/compose)

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
;(define-key y-map (kbd "r")   #'toggle-rot13-mode)
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
       (list ;;'("\\.\\(vcf\\|gpg\\)\\'" . sensitive-minor-mode)
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

;; Remove automatic `auto-fill-mode', and replace it by `visual-line-mode', which is a personal
;; preference.
(setq-default fill-column 100)
;;(remove-hook 'text-mode-hook #'auto-fill-mode)
(add-hook 'text-mode-hook #'auto-fill-mode)
;;(add-hook 'text-mode-hook #'+word-wrap-mode)
;;(add-hook 'text-mode-hook #'visual-fill-column-mode)

;; Set up magit when C-c g is called
(use-package! magit
  :bind (("C-x g" . magit-status))
  :config
  (add-hook 'magit-status-sections-hook #'magit-insert-modules 90))

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
        org-goto-interface 'outline-path-completion
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
  (require 'org-habit)
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines))

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
    (define-key map (kbd "i m") #'diary-insert-monthly-entry)
    (define-key map (kbd "i w") #'diary-insert-weekly-entry)
    (define-key map (kbd "i y") #'diary-insert-yearly-entry)
    (define-key map (kbd "M-n") #'calendar-forward-month)
    (define-key map (kbd "M-p") #'calendar-backward-month))

  (defun diary-schedule (y1 m1 d1 y2 m2 d2 dayname)
    "Entry applies if date is between dates on DAYNAME.
    Order of the parameters is M1, D1, Y1, M2, D2, Y2 if
    `european-calendar-style' is nil, and D1, M1, Y1, D2, M2, Y2 if
    `european-calendar-style' is t. Entry does not apply on a history."
    (let ((date1 (calendar-absolute-from-gregorian (list m1 d1 y1)))
          (date2 (calendar-absolute-from-gregorian (list m2 d2 y2)))
          (d (calendar-absolute-from-gregorian date)))
      (if (and
           (<= date1 d)
           (<= d date2)
           (= (calendar-day-of-week date) dayname)
           (not (calendar-check-holidays date)))
          entry)))

  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines))

  (require 'ox-beamer)
  (require 'ox-latex)
  (require 'ox-texinfo)
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
  (setq org-latex-pdf-process '("latexmk -f -pdf -%latex -shell-escape -interaction=nonstopmode -output-directory=%o %f"))
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

(after! pdf-tools
  (pdf-tools-install))

(after! latex
  (setq TeX-view-program-selection '((output-pdf "PDF Tools"))
        TeX-source-correlate-start-server t)
  (setq-default TeX-command-extra-options "-shell-escape")
  (add-hook 'TeX-after-compilation-finished-functions
            #'TeX-revert-document-buffer))

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

(after! flyspell
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
      proof-multiple-frames-enable nil
      proof-three-window-enable nil
      proof-auto-raise-buffers nil
      coq-compile-before-require nil
      coq-compile-vos t
      coq-compile-parallel-in-background t
      coq-max-background-compilation-jobs 4
      coq-compile-keep-going nil
      coq-compile-quick 'no-quick)

;; Removes performance problems with opening coq files.
(after! core-editor
  (add-to-list 'doom-detect-indentation-excluded-modes 'coq-mode))

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

(use-package! alectryon)

(use-package! org-zettelkasten
  :config
  (add-hook 'org-mode-hook #'org-zettelkasten-mode)

  (defun org-zettelkasten-search-current-id ()
    "Use `consult-ripgrep' to search for the current ID in all files."
    (interactive)
    (let ((current-id (org-entry-get nil "CUSTOM_ID")))
      (consult-ripgrep org-zettelkasten-directory (concat "[\\[:]." current-id "\\]#"))))

  (define-key org-zettelkasten-mode-map (kbd "r") #'org-zettelkasten-search-current-id)
  (setq org-zettelkasten-directory "~/Dropbox/zk"))

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
(setq message-fill-column 80)

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

(use-package! orderless
  :custom (completion-styles '(substring orderless)))

(use-package! vertico
  :init
  (vertico-mode))

(use-package! savehist
  :init
  (savehist-mode))

;; Enable richer annotations using the Marginalia package
(use-package! marginalia
  ;; Either bind `marginalia-cycle` globally or only in the minibuffer
  :bind (("M-A" . marginalia-cycle)
         :map minibuffer-local-map
         ("M-A" . marginalia-cycle))

  ;; The :init configuration is always executed (Not lazy!)
  :init

  ;; Must be in the :init section of use-package such that the mode gets
  ;; enabled right away. Note that this forces loading the package.
  (marginalia-mode))


(use-package! embark
  :bind
  (("C-;" . embark-act))
  :init
  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)
  :config
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package! embark-consult
  :after (embark consult)
  :demand t ; only necessary if you have the hook below
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; Example configuration for Consult
(use-package! consult
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c b" . consult-bookmark)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ("<help> a" . consult-apropos)            ;; orig. apropos-command
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s f" . consult-find)
         ("M-s F" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch)
         :map isearch-mode-map
         ("M-e" . consult-isearch)                 ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch)               ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi))           ;; needed by consult-line to detect isearch

  ;; Enable automatic preview at point in the *Completions* buffer.
  ;; This is relevant when you use the default completion UI,
  ;; and not necessary for Vertico, Selectrum, etc.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  (setq register-preview-delay 0
        register-preview-function #'consult-register-format)

  (advice-add #'register-preview :override #'consult-register-window)

  ;; Optionally replace `completing-read-multiple' with an enhanced version.
  (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)
  :config

  (consult-customize
   consult-theme
   :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-file consult--source-project-file consult--source-bookmark
   :preview-key (kbd "M-."))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  (setq consult-project-root-function
        (lambda ()
          (when-let (project (project-current))
            (car (project-roots project))))))

(use-package! emacs
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; Alternatively try `consult-completing-read-multiple'.
  (defun crm-indicator (args)
    (cons (concat "[CRM] " (car args)) (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  (setq read-extended-command-predicate
        #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(use-package! boogie-friends)

(use-package! isar-mode
  :mode "\\.thy\\'")

(use-package isar-goal-mode)

(use-package lsp-isar
  :after lsp-mode
  :commands lsp-isar-define-client-and-start
  :init
  (add-hook 'isar-mode-hook #'lsp-isar-define-client-and-start)
  (add-hook 'lsp-isar-init-hook 'lsp-isar-open-output-and-progress-right-spacemacs)
  :config
  (setq lsp-isar-path-to-isabelle "~/projects/isabelle-emacs")
  (setq lsp-isabelle-options (list "-d" "\$AFP")))

(use-package session-async)

(defun ymhg/reset-coq-windows ()
  "Resets the Goald and Response windows."
  (interactive)
  (other-frame 1)
  (delete-other-windows)
  (split-window-below)
  (switch-to-buffer "*goals*")
  (other-window 1)
  (switch-to-buffer "*response*")
  (other-frame 2))

(define-key y-map (kbd "o")   #'ymhg/reset-coq-windows)
