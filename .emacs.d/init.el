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
;; https://www.reddit.com/r/emacs/comments/d0k7jj/undotree065el_bad_request_when_trying_to_access/
(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")
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
(load "~/.emacs.d/my-modes/my-c-mode.el")

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(add-hook 'after-init-hook #'global-flycheck-mode)

(global-set-key (kbd "C-c c") 'comment-region)
(global-set-key (kbd "C-c v") 'uncomment-region)
(global-set-key (kbd "C-c C-f") 'projectile-find-file)
(global-set-key (kbd "C-f") 'go-to-char-forward)
(global-set-key [f11] 'smerge-keep-lower)
(global-set-key [f12] 'smerge-keep-upper)

(dumb-jump-mode)
(windmove-default-keybindings)

(require 'visual-regexp-steroids)
;; (define-key global-map (kbd "C-c r") 'vr/replace)
(define-key global-map (kbd "C-c q") 'vr/query-replace)
;; if you use multiple-cursors, this is for you:
(define-key global-map (kbd "C-c m") 'vr/mc-mark)
;; to use visual-regexp-steroids's isearch instead of the built-in regexp isearch, also include the following lines:
(define-key esc-map (kbd "C-r") 'vr/isearch-backward) ;; C-M-r
(define-key esc-map (kbd "C-s") 'vr/isearch-forward) ;; C-M-s

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(rustic whitespace-cleanup-mode visual-regexp-steroids yaml-mode toml-mode rust-auto-use rtags projectile-ripgrep nix-haskell-mode magit lua-mode json-mode jedi irony-eldoc hydandata-light-theme goto-chg fullframe flymake-rust flymake-python-pyflakes flymake-cppcheck flycheck-rust flycheck-irony flycheck-clangcheck flycheck-clang-tidy flycheck-clang-analyzer find-file-in-project elpy dumb-jump company-racer company-irony-c-headers company-irony company-glsl company-c-headers cmake-mode cmake-ide cargo auto-complete-clang apel ac-racer)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq mode-require-final-newline 1)

;; https://www.gnu.org/software/emacs/manual/html_node/efaq/Indenting-switch-statements.html
(c-set-offset 'case-label '+)
