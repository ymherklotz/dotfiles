(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(beacon-color "#ff9da4")
 '(fci-rule-color "#B8A2CE")
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(frame-background-mode 'dark)
 '(jdee-db-active-breakpoint-face-colors (cons "#464258" "#C5A3FF"))
 '(jdee-db-requested-breakpoint-face-colors (cons "#464258" "#C2FFDF"))
 '(jdee-db-spec-breakpoint-face-colors (cons "#464258" "#656565"))
 '(ledger-reports
   '(("equity" "ledger equit")
     ("bal" "%(binary) -f %(ledger-file) bal")
     ("reg" "%(binary) -f %(ledger-file) reg")
     ("payee" "%(binary) -f %(ledger-file) reg @%(payee)")
     ("account" "%(binary) -f %(ledger-file) reg %(account)")))
 '(notmuch-saved-searches
   '((:name "inbox" :query "tag:inbox not tag:trash" :key "i")
     (:name "flagged" :query "tag:flagged" :key "f")
     (:name "sent" :query "tag:sent" :key "s")
     (:name "drafts" :query "tag:draft" :key "d")
     (:name "imperial" :query "tag:imperial")
     (:name "mailbox" :query "tag:mailbox")))
 '(objed-cursor-color "#CC6666")
 '(org-agenda-files
   '("~/Dropbox/zk/computing.org" "/Users/yannherklotz/Dropbox/org/inbox.org" "/Users/yannherklotz/Dropbox/org/main.org" "/Users/yannherklotz/Dropbox/org/tickler.org" "/Users/yannherklotz/Dropbox/org/projects.org" "/Users/yannherklotz/Dropbox/bibliography/reading_list.org"))
 '(org-blank-before-new-entry '((heading) (plain-list-item)))
 '(package-selected-packages '(zettelkasten org-zettelkasten org-plus-contrib))
 '(pdf-view-midnight-colors (cons "#F8F8F0" "#5a5475"))
 '(rustic-ansi-faces
   ["#5a5475" "#CC6666" "#C2FFDF" "#FFEA00" "#55b3cc" "#FFB8D1" "#96CBFE" "#F8F8F0"])
 '(safe-local-variable-values
   '((TeX-command-extra-options . "-shell-escape")
     (eval add-to-list 'auto-mode-alist
           '("\\.v\\'" . verilog-mode))
     (eval setq org-ref-pdf-directory
           (concat
            (projectile-project-root)
            "papers/"))))
 '(window-divider-mode nil)
 '(znc-servers nil))
(put 'narrow-to-region 'disabled nil)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
