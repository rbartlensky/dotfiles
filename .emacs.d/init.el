;;; init.el --- starts here
;;; Commentary:
;;; Code:

;; buffer settings
;; package.el
(require 'package)
(package-initialize)
;; https://www.reddit.com/r/emacs/comments/d0k7jj/undotree065el_bad_request_when_trying_to_access/
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(add-to-list 'load-path "~/.emacs.d/package-updater")
(require 'package-updater)
;; (install-all-packages)

(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode)
  (setq lsp-enable-file-watchers t
      lsp-file-watch-threshold 8000
      lsp-modeline-code-actions-enable nil
      lsp-enable-symbol-highlighting nil
      lsp-modeline-diagnostics-enable nil
      lsp-ui-sideline-show-diagnostics nil
      lsp-ui-sideline-enable nil)
)
(setq lsp-keymap-prefix "M-d")

(global-linum-mode 1) ; line numbers
(delete-selection-mode) ; when copying over a selected text, delete it
(setq column-number-mode t) ; column numbers
(setq-default indent-tabs-mode nil) ; no tabs
(setq inhibit-startup-message t) ; no more startup message
(global-hl-line-mode 1)

(which-function-mode 1) ;;
(show-paren-mode 1) ;; show matching parenthesis
(electric-pair-mode 1) ;; closes brackets when opening one
(windmove-default-keybindings) ;; shit-arrow to move around windows

(require 'yasnippet)
(yas-global-mode 1)

(require 'company)
(global-company-mode t)

;; theme
(add-to-list 'load-path "~/.emacs.d/themes")
(require 'tomorrow-day-theme)
(load-theme 'tomorrow-day t)

(add-to-list 'load-path "~/.emacs.d/go-to-char")
(require 'go-to-char)

(load "~/.emacs.d/my-modes/my-python-mode.el")
(load "~/.emacs.d/my-modes/my-cpp-mode.el")
(load "~/.emacs.d/my-modes/my-rust-mode.el")
(load "~/.emacs.d/my-modes/my-c-mode.el")

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'after-init-hook #'global-flycheck-mode)

(projectile-mode)
(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c v") 'uncomment-region)
(global-set-key (kbd "M-s s") 'projectile-replace)
(global-set-key (kbd "M-s j") 'projectile-find-other-file)
(global-set-key (kbd "M-s r") 'projectile-ripgrep)
(global-set-key (kbd "M-s c") 'projectile-compile-project)
(global-set-key (kbd "M-s f") 'projectile-find-file)
(global-set-key (kbd "M-s t") 'projectile-regenerate-tags)
(global-set-key (kbd "M-s x") 'projectile-run-project)
(global-set-key (kbd "C-f") 'go-to-char-forward)
(global-set-key [f11] 'smerge-keep-lower)
(global-set-key [f12] 'smerge-keep-upper)

(require 'visual-regexp-steroids)
;; (define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
;; if you use multiple-cursors, this is for you:
(define-key global-map (kbd "C-c m") 'vr/mc-mark)
;; to use visual-regexp-steroids's isearch instead of the built-in regexp isearch, also include the following lines:
(define-key esc-map (kbd "C-r") 'vr/isearch-backward) ;; C-M-r
(define-key esc-map (kbd "C-s") 'vr/isearch-forward) ;; C-M-s

(provide 'init)

(setq mode-require-final-newline 1)
