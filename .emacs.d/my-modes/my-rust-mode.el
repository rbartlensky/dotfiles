;; RUST
;; rust mode
;; (add-to-list 'load-path "~/.emacs.d/rust/rust-mode")
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))

(defun my-rust-mode-hook ()
  ;; cargo
  (require 'cargo)
  (cargo-minor-mode)
  (local-set-key (kbd "C-c <tab>") #'rust-format-buffer)

  ;; rust completion
  (require 'racer)
  (setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
  (racer-mode)
  (eval-after-load 'company
    (add-hook 'racer-mode-hook #'company-mode))
  (define-key rust-mode-map (kbd "TAB") #'company-indent-or-complete-common)
  (setq company-tooltip-align-annotations t)

  ;; flycheck-rust
  (require 'flycheck-rust)
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

  (define-key rust-mode-map (kbd "C-c C-f") #'projectile-find-file)
)
(add-hook 'rust-mode-hook 'my-rust-mode-hook)
