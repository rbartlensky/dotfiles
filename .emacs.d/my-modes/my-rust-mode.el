;; RUST
;; rust mode
;; (add-to-list 'load-path "~/.emacs.d/rust/rust-mode")
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

(defun my-rust-mode-hook ()
  ;; cargo
  ;; (add-to-list 'load-path "~/.emacs.d/rust/cargo")
  (require 'cargo)
  (cargo-minor-mode)
  (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)

  ;; rust completion
  ;; (add-to-list 'load-path "~/.emacs.d/rust/emacs-racer")
  (require 'racer)
  (setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
  (setq racer-rust-src-path "~/.rust_sc/src") ;; Rust source code PATH
  (racer-mode)
  (eval-after-load 'company
    (add-hook 'racer-mode-hook #'company-mode))
  (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
  (setq company-tooltip-align-annotations t)

  ;; flycheck-rust
  ;; (add-to-list 'load-path "~/.emacs.d/rust/flycheck-rust")
  (require 'flycheck-rust)
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

  (define-key rust-mode-map (kbd "C-c C-f") #'projectile-find-file))

(add-hook 'rust-mode-hook 'my-rust-mode-hook)
