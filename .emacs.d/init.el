;;; init.el --- starts here
;;; Commentary:
;;; Code:

(eval-when-compile (require 'use-package))

(require 'use-package)
(package-initialize)

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(server-start)

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

;; toggle dark theme
(setq current-theme "day")
(defun rb/darkmode ()
  (interactive)
  (if (eq current-theme "night")
      (progn
        (setq current-theme "day")
        (load-theme 'tomorrow-day t))
    (progn
      (setq current-theme "night")
      (load-theme 'tomorrow-night t))
    ))
(global-set-key [f5] 'rb/darkmode)

;; extra hooks
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(use-package helm
  :ensure
  :config
  (helm-mode))
(use-package helm-xref :ensure :after (helm))

(use-package which-key
  :ensure
  :config
  (which-key-mode))

(use-package flycheck :ensure)

(use-package company
  :ensure
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.5)
  :hook (after-init . global-company-mode))

(defun rb/c-mode ()
  (c-set-offset 'substatement-open 0)
  (setq-default c-default-style "linux"))
(add-hook 'c-mode-hook 'rb/c-mode)

(defun rb/c++-mode ()
  (c-set-offset 'substatement-open 0)
  (setq-default c-basic-offset 4)
  (setq-default c-indent-level 4))
(add-hook 'c++-mode-hook 'rb/c++-mode)

(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  (lsp-eldoc-render-all t)
  (lsp-enable-file-watchers t)
  (lsp-file-watch-threshold 8000)
  (lsp-enable-symbol-highlighting nil)
  (lsp-modeline-diagnostics-enable nil)
  (lsp-idle-delay 0.6)
  :hook ((c-mode . lsp) (c++-mode . lsp) (python-mode . lsp))
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode)
  (add-hook 'lsp-mode-hook 'lsp-enable-which-key-integration))

(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-sideline-show-diagnostics nil)
  (lsp-ui-sideline-enable nil)
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

(use-package yasnippet
  :ensure
  :config
  (yas-reload-all)
  (add-hook 'prog-mode-hook 'yas-minor-mode))

(use-package tomorrow-day-theme
  :load-path "~/.emacs.d/themes"
  :config (load-theme 'tomorrow-day t))

(use-package go-to-char
  :bind (("C-f" . go-to-char-forward))
  :load-path "~/.emacs.d/go-to-char")

(use-package rustic
  :init
  ;; to use rustic-mode even if rust-mode also installed
  (setq auto-mode-alist (delete '("\\.rs\\'" . rust-mode) auto-mode-alist))
  :ensure
  :custom
  (lsp-eldoc-hook nil)
  (lsp-signature-auto-activate nil)
  (lsp-rust-analyzer-server-display-inlay-hints nil))

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
(use-package deadgrep :ensure
  :bind
  ("M-s r" . deadgrep))
(use-package auto-package-update :ensure)
