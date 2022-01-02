;; Disabling packages
(disable-packages! undo-tree org-bullets helm pretty-code company-coq)

;; `org-mode' dependencies
(package! org-ref)
(package! ol-notmuch)
;; `org-bullets' replacement
(package! org-superstar)
(package! ox-reveal)
(package! ox-tufte)
(package! org-transclusion
  :recipe (:host github :repo "nobiot/org-transclusion"))
(package! org-zettelkasten
  :recipe (:host github :repo "ymherklotz/emacs-zettelkasten"))
(package! elfeed-score)

;; Bibtex stuff
(package! ebib)

;; Haskell stuff
(package! ormolu)

;; Completion
(package! orderless)
(package! marginalia)
(package! embark)
(package! embark-consult)
(package! ripgrep)

;; Extra language mobdes
(package! yaml-mode)
(package! pollen-mode)

;;(package! tree-sitter)
;;(package! tree-sitter-langs)

;; Nix
(package! direnv)

;; Misc dependencies
(package! hungry-delete)

;; Coq

;; Teaching
(package! boogie-friends)

;; Privacy
(package! pinentry)

;; Emacs lisp
(package! package-lint)

;; Themes
(package! color-theme-sanityinc-tomorrow)
(package! modus-themes)
(package! elpher)
