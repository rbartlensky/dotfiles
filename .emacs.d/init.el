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

(setq major-mode-remap-alist
 '((yaml-mode . yaml-ts-mode)
   (bash-mode . bash-ts-mode)
   (js2-mode . js-ts-mode)
   (typescript-mode . typescript-ts-mode)
   (json-mode . json-ts-mode)
   (python-mode . python-ts-mode)
   (rust-mode . rust-ts-mode)))

(use-package helm
  :ensure
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files)
  :hook ((after-init . helm-mode)))

(use-package avy
  :ensure
  :bind (("C-c j" . avy-goto-line)
         ("C-:"   . avy-goto-char-timer)))

(use-package helm-xref :ensure :after (helm))
(use-package which-key :ensure :config (which-key-mode))
(use-package modus-themes :ensure :config (load-theme 'modus-operandi-tinted t))
(use-package org :mode "\\.org$")
(use-package rust-ts-mode :mode "\\.rs$")

(use-package magit
  :ensure
  :config
  ;;(setq magit-refresh-verbose t)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-pushremote)
  (remove-hook 'magit-status-sections-hook 'magit-insert-unpulled-from-upstream))

(use-package company
  :ensure
  :hook (after-init . global-company-mode)
  :bind (("M-<tab>" . company-complete-common-or-cycle))
  :custom (company-idle-delay nil))

(use-package yasnippet
  :ensure
  :hook (prog-mode . yas-minor-mode)
  :commands yas-reload-all
  :config
  (yas-reload-all))

(use-package go-to-char
  :bind (("C-f" . go-to-char-forward))
  :load-path "~/.emacs.d/go-to-char")

(use-package visual-regexp-steroids
  :ensure
  :bind ("C-c q" . vr/query-replace))

(use-package deadgrep
  :ensure
  :bind ("M-s r" . deadgrep))

(use-package auto-package-update
  :ensure
  :config
  (setq auto-package-update-delete-old-versions t)
  (setq auto-package-update-hide-results t))

(use-package typescript-mode
  :init (define-derived-mode typescript-tsx-mode typescript-ts-mode "tsx")
  :config
  (add-to-list 'auto-mode-alist '("\\.tsx?\\'" . typescript-tsx-mode)))

(use-package flycheck
  :ensure
  :init (global-flycheck-mode))

(use-package eglot
  :hook (((c-mode c++-mode python-mode rust-ts-mode typescript-tsx-mode go-mode) . eglot-ensure)
         (eglot-managed-mode . (lambda () (eldoc-mode -1)))
         (eglot-managed-mode . (lambda () (flymake-mode -1))))
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
  (add-to-list 'eglot-server-programs
               '(typescript-tsx-mode . ("typescript-language-server" "--stdio"))))

(use-package flycheck-eglot
  :ensure
  :after (flycheck eglot)
  :config
  (global-flycheck-eglot-mode 1))

;;; init.el ends here
