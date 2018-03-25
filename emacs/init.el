
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("43c1a8090ed19ab3c0b1490ce412f78f157d69a29828aa977dae941b994b4147" "a866134130e4393c0cad0b4f1a5b0dd580584d9cf921617eee3fd54b6f09ac37" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "ad109c1ad8115573f40e22ac2b996693b5d48052fa37b5919f70ea37c62a965e" "77bddca0879cb3b0ecdf071d9635c818827c57d69164291cb27268ae324efa84" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" default)))
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(jdee-server-dir "/home/yannherklotz/.emacs.d/jars/")
 '(org-agenda-files nil)
 '(package-selected-packages
   (quote
    (rust-mode helm-ag edit-indirect ox-twbs request-deferred alert org-gcal plan9-theme monokai-theme material-theme diminish telephone-line monokai smart-tabs-mode zenburn-theme yasnippet use-package undo-tree smartparens pug-mode powerline paredit org-bullets multiple-cursors moe-theme leuven-theme jedi hungry-delete haskell-mode gruvbox-theme glsl-mode ggtags flycheck counsel-projectile company-c-headers color-theme-sanityinc-tomorrow color-theme cider bison-mode base16-theme ace-window)))
 '(safe-local-variable-values
   (quote
    ((projectile-project-compilation-cmd . "mkdir -p build && cd build && cmake -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .. && ninja -j4")
     (projectile-project-compilation-cmd . "mkdir -p build && cd build && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .. && make -j4")
     (projectile-project-compilation-cmd . "mkdir -p build && cd build && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON .. && make -j")
     (projectile-project-run-cmd . "./build/bin/learn_opengl")
     (projectile-project-compilation-cmd . "mkdir -p build && cd build && cmake .. && make -j")
     (projectile-project-run-cmd . "./build/bin/simplegame")
     (projectile-project-test-cmd . "cd build/tests && ctest")
     (projectile-project-compilation-cmd . "mkdir -p build && cd build && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DYAGE_BUILD_TESTS=ON .. && make -j9")
     (company-c-headers-path-user "../include/")
     (company-clang-arguments "-I../include/")
     (projectile-project-run-cmd . "./bin/simplegame")
     (projectile-project-test-cmd . "cd build && ctest")
     (projectile-project-compilation-cmd . "mkdir -p build && cd build && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DUNIT_TESTS=ON .. && make -j9")
     (eval progn
           (require
            (quote projectile))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "yage")))))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "lib/googletest/googletest/include")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "yage")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root))))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "lib/googletest/googletest/include"))))))
     (eval progn
           (require
            (quote projectile))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "include")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "include"))))))
     (eval progn
           (require
            (quote projectile))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "include"))))))
     (eval progn
           (require
            (quote projectile))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "yage"))))))
     (eval progn
           (require
            (quote projectile))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "yage")))))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root))))))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "lib/googletest/googletest/include")))))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "lib/rapidjson/include")))))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "lib/glfw/include")))))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "lib/glad/include")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "yage")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root))))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "lib/googletest/googletest/include")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "lib/glfw/include")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "lib/glad/include")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "lib/rapidjson/include"))))))
     (eval progn
           (require
            (quote projectile))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "yage")))))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root))))))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "lib/googletest/googletest/include")))))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "lib/rapidjson/include")))))
           (setq company-clang-arguments
                 (delete-dups
                  (append company-clang-arguments
                          (list
                           (concat "-I"
                                   (projectile-project-root)
                                   "lib/glfw/include")))))
           (setq company-clang-arguments
                 (delete-dups
                  ((append)
                   company-clang-arguments
                   (list
                    (concat "-I"
                            (projectile-project-root)
                            "lib/glad/include")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "yage")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root))))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "lib/googletest/googletest/include")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "lib/glfw/include")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  ((append)
                   flycheck-clang-include-path
                   (list
                    (concat
                     (projectile-project-root)
                     "lib/glad/include")))))
           (setq flycheck-clang-include-path
                 (delete-dups
                  (append flycheck-clang-include-path
                          (list
                           (concat
                            (projectile-project-root)
                            "lib/rapidjson/include"))))))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq init-dir (file-name-directory (or load-file-name (buffer-file-name))))
(org-babel-load-file (expand-file-name "loader.org" init-dir))
