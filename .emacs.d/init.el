(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu-devel" . "https://elpa.gnu.org/devel/"))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile (require 'use-package))
(require 'bind-key)

;; misc things
(tool-bar-mode -1) ;; no more toolbar
(menu-bar-mode -1) ;; no more menu bar
(scroll-bar-mode -1) ;; no more scroll bar
(global-display-line-numbers-mode) ;; line numbers
(delete-selection-mode) ;; when copying over a selected text, delete it
(global-hl-line-mode 1) ;; highlight current line
(show-paren-mode 1) ;; show matching parenthesis
(electric-pair-mode 1) ;; closes brackets when opening one
(windmove-default-keybindings) ;; shit + arrow-key to move around windows
(setq column-number-mode t) ;; column numbers in modeline
(setq-default indent-tabs-mode nil) ;; no tabs
(setq inhibit-startup-message t)
(setq mode-require-final-newline 1)
(blink-cursor-mode -1) ;; steady cursor
(pixel-scroll-precision-mode) ;; smooth scrolling

;; improves completion performance
(setq gc-cons-threshold (* 100 1024 1024))
(setq read-process-output-max (* 1024 1024))

;; keybinds
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c v") 'uncomment-region)
(global-set-key [f11] 'smerge-keep-lower)
(global-set-key [f12] 'smerge-keep-upper)

;; extra hooks
(add-hook 'before-save-hook
          (lambda ()
            (unless (derived-mode-p 'markdown-mode)
              (delete-trailing-whitespace))))

(add-hook 'latex-mode-hook
          (lambda ()
            (setq latex-run-command "pdflatex")))

(use-package helm
  :ensure
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  :hook ((after-init . helm-mode)))

(use-package avy
  :ensure t
  :bind (("C-c j" . avy-goto-line)
         ("C-:"   . avy-goto-char-timer)))

(use-package helm-xref :ensure :after (helm))
(use-package which-key :ensure :config (which-key-mode))
;; (use-package zenburn-theme :ensure :config (load-theme 'zenburn t))
(use-package modus-themes :ensure :config (load-theme 'modus-operandi-tinted t))
(use-package org :mode "\\.org$")

(use-package magit
  :ensure
  :config
  ;;(setq magit-refresh-verbose t)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream))

;; (use-package mood-line :ensure :config (mood-line-mode))

(use-package company
  :ensure
  :hook (after-init . global-company-mode)
  :bind (("M-<tab>" . company-complete-common-or-cycle))
  :custom (company-idle-delay nil))

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
  :hook (prog-mode . yas-minor-mode)
  :commands yas-reload-all
  :config
  (yas-reload-all))

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
  :bind ("C-c q" . vr/query-replace))

(use-package deadgrep
  :ensure
  :bind ("M-s r" . deadgrep))

(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t))

(use-package typescript-mode
  :ensure
  :init (define-derived-mode typescript-tsx-mode typescript-mode "tsx")
  :config
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-tsx-mode)))

(use-package treesit-auto
  :ensure)

(use-package flycheck
  :ensure
  :init (global-flycheck-mode))

(use-package eglot
  :ensure
  :pin gnu-devel
  :hook (((c-mode c++-mode python-mode typescript-tsx-mode go-mode) . eglot-ensure)
         (eglot-managed-mode . (lambda () (eldoc-mode -1))))
  :bind (:map eglot-mode-map
              ("C-c a" . eglot-code-actions)
              ("C-c r" . eglot-rename)
              ("C-c f" . eglot-format-buffer)
              ("C-c M-f" . eglot-format))
  :config
  ;; disable visual actions
  (put 'eglot-note 'flymake-overlay-control nil)
  (put 'eglot-warning 'flymake-overlay-control nil)
  (put 'eglot-error 'flymake-overlay-control nil)
  (setq eglot-ignored-server-capabilities '(:inlayHintProvider :documentOnTypeFormattingProvider))
  (add-hook 'eglot--managed-mode-hook (lambda () (flymake-mode -1)))
  (add-to-list 'eglot-server-programs
               '(typescript-tsx-mode . ("typescript-language-server" "--stdio"))))

(use-package esup
  :ensure
  ;; To use MELPA Stable use ":pin melpa-stable",
  :pin melpa
  :config
  (setq esup-depth 0))

(use-package flycheck-eglot
  :ensure
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

;; if we have specific configs on another machine, load them up
(if (file-exists-p "~/.emacs.d/extras.el")
    (load "~/.emacs.d/extras.el"))
