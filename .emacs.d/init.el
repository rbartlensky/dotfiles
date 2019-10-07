;;; init.el --- starts here

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

(global-set-key (kbd "C-c r") 'projectile-ripgrep)

(add-to-list 'load-path "~/.emacs.d/yasnippet")
(require 'yasnippet)
(yas-global-mode 1)

(add-to-list 'load-path "~/.emacs.d/company-mode")
(require 'company)
(global-company-mode t)

;; theme
;; (load-theme 'hydandata-light t)
(add-to-list 'load-path "/home/robert/.emacs.d/themes")
(require 'tomorrow-day-theme)
(load-theme 'tomorrow-day t)

(add-to-list 'load-path "/home/robert/.emacs.d/go-to-char")
(require 'go-to-char)

(add-to-list 'load-path "~/.emacs.d/my-modes")
(load "~/.emacs.d/my-modes/my-python-mode.el")
(load "~/.emacs.d/my-modes/my-cpp-mode.el")
(load "~/.emacs.d/my-modes/my-rust-mode.el")

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'after-init-hook #'global-flycheck-mode)

(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c v") 'uncomment-region)
(global-set-key (kbd "C-c C-f") 'projectile-find-file)
(global-set-key (kbd "C-f") 'go-to-char-forward)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (ac-racer cargo company-racer flycheck-rust flymake-rust racer rust-auto-use rust-mode s yaml-mode toml-mode rtags projectile-ripgrep pos-tip markdown-mode magit lua-mode jedi irony-eldoc hydandata-light-theme goto-chg fullframe flymake-python-pyflakes flymake-cppcheck flycheck-irony flycheck-clangcheck flycheck-clang-tidy flycheck-clang-analyzer f elpy company-irony-c-headers company-irony company-glsl company-c-headers cmake-ide auto-complete-clang apel))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
