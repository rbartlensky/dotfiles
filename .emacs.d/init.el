;;; init.el --- starts here
;;; Commentary:
;;; Code:

(package-initialize)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

(require 'use-package)
(eval-when-compile (require 'use-package))

;; misc things
(tool-bar-mode -1) ;; no more toolbar
(global-linum-mode 1) ;; line numbers
(delete-selection-mode) ;; when copying over a selected text, delete it
(global-hl-line-mode 1) ;; highlight current line
(show-paren-mode 1) ;; show matching parenthesis
(electric-pair-mode 1) ;; closes brackets when opening one
(windmove-default-keybindings) ;; shit-arrow to move around windows

(setq column-number-mode t) ;; column numbers
(setq-default indent-tabs-mode nil) ;; no tabs
(setq inhibit-startup-message t) ;; no more startup message
(setq mode-require-final-newline 1)
(setq latex-run-command "pdflatex")
;; improves completion performance
(setq gc-cons-threshold (* 100 1024 1024))
(setq read-process-output-max (* 1024 1024))

;; keybinds
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c v") 'uncomment-region)
(global-set-key [f11] 'smerge-keep-lower)
(global-set-key [f12] 'smerge-keep-upper)

;; extra hooks
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package flycheck :ensure)
(use-package helm :ensure :config (helm-mode))
(use-package helm-xref :ensure :after (helm))
(use-package which-key :ensure :config (which-key-mode))
(use-package zenburn-theme :ensure :config (load-theme 'zenburn t))

(use-package company
  :ensure
  :hook (after-init . global-company-mode)
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.6))

(defun rb/c-mode ()
  (c-set-offset 'substatement-open 0)
  (setq-default c-default-style "linux"))
(add-hook 'c-mode-hook 'rb/c-mode)

(defun rb/c++-mode ()
  (c-set-offset 'substatement-open 0)
  (setq-default c-basic-offset 4)
  (setq-default c-indent-level 4))
(add-hook 'c++-mode-hook 'rb/c++-mode)

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode))

(use-package go-to-char
  :bind (("C-f" . go-to-char-forward))
  :load-path "~/.emacs.d/go-to-char")

(use-package rustic
  :ensure
  :init
  ;; to use rustic-mode even if rust-mode also installed
  (setq auto-mode-alist (delete '("\\.rs\\'" . rust-mode) auto-mode-alist))
  ;; (setq rustic-format-trigger 'on-save)
  (setq rustic-rustfmt-args "--edition=2021")
  (setq rustic-lsp-client 'eglot))

(use-package projectile
  :ensure
  :bind
  ("M-s s" . projectile-replace)
  ("M-s j" . projectile-find-other-file)
  ("M-s c" . projectile-compile-project)
  ("M-s f" . projectile-find-file)
  ("M-s t" . projectile-regenerate-tags)
  ("M-s x" . projectile-run-project))

(use-package visual-regexp-steroids
  :ensure
  :bind
  ("C-c q" . vr/query-replace)
  ("C-r" . vr/isearch-backward)
  ("C-s" . vr/isearch-forward))

(use-package org :ensure)
(use-package magit :ensure)
(use-package deadgrep
  :defer t
  :ensure
  :bind ("M-s r" . deadgrep))
(use-package auto-package-update
  :ensure
  :config (setq auto-package-update-delete-old-versions t))

(use-package typescript-mode
  :ensure
  :init (define-derived-mode typescript-tsx-mode typescript-mode "tsx")
  :config
  (setq typescript-indent-level 2)
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-tsx-mode)))

(use-package tree-sitter
  :ensure
  :hook ((rustic typescript-mode typescript-tsx-mode) . tree-sitter-hl-mode)
  :config
  (add-to-list 'tree-sitter-major-mode-language-alist '(rustic-mode . rust))
  (add-to-list 'tree-sitter-major-mode-language-alist '(typescript-tsx-mode . tsx)))

(use-package tree-sitter-langs
  :ensure
  :after tree-sitter
  :config
  (tree-sitter-require 'rust)
  (tree-sitter-require 'tsx))

(use-package eglot
  :ensure
  :hook ((c-mode c++-mode python-mode typescript-tsx-mode) . eglot-ensure)
  :bind (:map eglot-mode-map
              ("M-s a" . eglot-code-actions))
  :config
  ;; disable visual actions
  (put 'eglot-note 'flymake-overlay-control nil)
  (put 'eglot-warning 'flymake-overlay-control nil)
  (put 'eglot-error 'flymake-overlay-control nil)
  (add-to-list 'eglot-server-programs
               '(typescript-tsx-mode . ("typescript-language-server" "--stdio"))))

;; if we have specific configs on another machine, load them up
(if (file-exists-p "~/.emacs.d/extras.el")
    (load "~/.emacs.d/extras.el"))
