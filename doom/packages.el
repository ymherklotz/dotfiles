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
(package! org-zettelkasten
  :recipe (:host github :repo "ymherklotz/emacs-zettelkasten"))
(package! elfeed-org)

;; Latex stuff
(package! pdf-tools)

;; Bibtex stuff
(package! ebib)

;; Haskell stuff
(package! ormolu)

;; Completion
(package! orderless)
(package! vertico)
(package! marginalia)
(package! embark)
(package! consult)
(package! embark-consult)
(package! ripgrep)

;; Extra language mobdes
(package! yaml-mode)
(package! slime)
(package! pollen-mode)

;; Nix
(package! direnv)

;; Misc dependencies
(package! hungry-delete)
(package! elfeed)

;; Chatting
(package! plz
  :recipe (:host github :repo "alphapapa/plz.el"))
(package! ement
  :recipe (:host github :repo "alphapapa/ement.el"))
(package! erc-hl-nicks)
(package! alert)
(package! znc)

;; Coq
(package! alectryon) ;; Coq documentation tool

;; Teaching
(package! boogie-friends)

(package! isar-mode
  :recipe (:host github :repo "m-fleury/isar-mode"))
(package! isar-goal-mode
  :recipe (:host github :repo "m-fleury/simp-isar-mode"))
(package! lsp-isar
  :recipe (:host github :repo "m-fleury/isabelle-emacs"
           :branch "Isabelle2021-more-vscode"
           :files ("src/Tools/emacs-lsp/lsp-isar/*.el")))
(package! session-async)

;; Privacy
(package! pinentry)

;; Emacs lisp
(package! package-lint)

;; Themes
(package! color-theme-sanityinc-tomorrow)
(package! modus-themes)

;; Temp fixes
;; https://github.com/hlissner/doom-emacs/issues/5667#issuecomment-948229579
(package! gitconfig-mode
  :recipe (:host github :repo "magit/git-modes"
           :files ("gitconfig-mode.el")))
(package! gitignore-mode
  :recipe (:host github :repo "magit/git-modes"
           :files ("gitignore-mode.el")))
