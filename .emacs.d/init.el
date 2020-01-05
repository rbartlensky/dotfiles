;;; init.el --- starts here
;;; Commentary:
;;; Code:

;; buffer settings
(global-linum-mode 1) ; line numbers
(delete-selection-mode) ; when copying over a selected text, delete it
(setq column-number-mode t) ; column numbers
(setq-default indent-tabs-mode nil) ; no tabs
(setq inhibit-startup-message t) ; no more startup message
(global-hl-line-mode 1)

(which-function-mode 1) ;;
(show-paren-mode 1) ;; show matching parenthesis
(electric-pair-mode 1) ;; closes brackets when opening one

;; package.el
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/package-updater")
(require 'package-updater)

(global-set-key (kbd "C-c r") 'projectile-ripgrep)

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

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'after-init-hook #'global-flycheck-mode)

(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c v") 'uncomment-region)
(global-set-key (kbd "C-c C-f") 'projectile-find-file)
(global-set-key (kbd "C-f") 'go-to-char-forward)

(provide 'init)
;;; init.el ends here
