(setq init-dir (file-name-directory (or load-file-name (buffer-file-name))))

(require 'package)

(defvar gnu          '("gnu"          . "https://elpa.gnu.org/packages/"))
(defvar melpa        '("melpa"        . "https://melpa.org/packages/"))
(defvar melpa-stable '("melpa-stable" . "https://stable.melpa.org/packages/"))
(defvar org-elpa     '("org"          . "https://orgmode.org/elpa/"))

(setq package-archives nil)
(add-to-list 'package-archives melpa-stable t)
(add-to-list 'package-archives melpa t)
(add-to-list 'package-archives gnu t)
(add-to-list 'package-archives org-elpa t)

(setq package-enable-at-startup nil)
(package-initialize)

(org-babel-load-file (expand-file-name "loader.org" init-dir))
