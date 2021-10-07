;; Disabling packages
(disable-packages! undo-tree org-bullets helm pretty-code company-coq)

;; `org-mode' dependencies
(package! org-ref)
;; `org-bullets' replacement
(package! org-superstar)
(package! ox-reveal)
;(package! ox-ssh)
(package! ox-tufte)
(package! org-transclusion
  :recipe (:host github :repo "nobiot/org-transclusion"))

;; Bibtex stuff
(package! ebib)

;; Haskell stuff
(package! ormolu)

;; completion
(package! orderless)
(package! vertico)
(package! marginalia)
(package! embark)
(package! consult)
(package! embark-consult)
(package! ripgrep)

(package! direnv)
(package! yaml-mode)

(package! erc-hl-nicks)
(package! alert)
(package! znc)

(package! elfeed)
(package! elfeed-org)

;; Misc dependencies
(package! hungry-delete)
(package! vagrant-tramp)

(package! plz
  :recipe (:host github :repo "alphapapa/plz.el"))
(package! ement
  :recipe (:host github :repo "alphapapa/ement.el"))
(package! org-zettelkasten
  :recipe (:host github :repo "ymherklotz/emacs-zettelkasten"))

(package! pinentry)

(package! package-lint)

;; Themes
(package! color-theme-sanityinc-tomorrow)
(package! modus-themes)
;;(package! modus-operandi-theme)
;;(package! modus-vivendi-theme)
