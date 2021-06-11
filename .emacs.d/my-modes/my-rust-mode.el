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

  ;; flycheck-rust
  (require 'flycheck-rust)
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

  (define-key rust-mode-map (kbd "C-c C-f") #'projectile-find-file)

  (setq lsp-enable-file-watchers t
        lsp-file-watch-threshold 8000
        lsp-modeline-code-actions-enable nil
        lsp-enable-symbol-highlighting nil
        lsp-modeline-diagnostics-enable nil
        lsp-ui-sideline-show-diagnostics nil
        lsp-rust-show-hover-context nil
        lsp-rust-analyzer-inlay-hints-mode nil)
)
(add-hook 'rust-mode-hook 'lsp)
(add-hook 'rust-mode-hook 'my-rust-mode-hook)
