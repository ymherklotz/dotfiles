;; Disabling packages
(disable-packages! undo-tree org-bullets helm pretty-code)

;; `org-mode' dependencies
(package! ol-notmuch)
;; `org-bullets' replacement
(package! org-superstar)
(package! ox-gfm)
(package! ox-tufte
  :recipe (:host nil :repo "https://git.sr.ht/~ymherklotz/ox-tufte"))
(package! scroll-other-window
  :recipe (:host nil :repo "https://git.sr.ht/~ymherklotz/scroll-other-window"))
(package! cdlatex)
(package! citeproc)
(package! ox-context
  :recipe (:host github :repo "Jason-S-Ross/ox-context"))
(package! org-transclusion
  :recipe (:host github :repo "nobiot/org-transclusion"))
(package! org-zettelkasten
  :recipe (:host github :repo "ymherklotz/emacs-zettelkasten"))
(package! elfeed-score)

(package! alectryon)

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

;; Nix
(package! direnv)

;; Misc dependencies
(package! hungry-delete)

;; Teaching
(package! boogie-friends)

;; Privacy
(package! pinentry)

;; Emacs lisp
(package! package-lint)

;; Themes
(package! color-theme-sanityinc-tomorrow)
(package! modus-themes)
