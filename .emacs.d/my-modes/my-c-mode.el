(defun my-c-mode-hook ()
  ;; (c-set-style "java")

  ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
  (global-set-key [3 6] (quote find-file-in-project))
  (global-set-key "\C-c\C-v" 'uncomment-region)
  (c-set-offset 'substatement-open 0)
  (setq c-default-style "linux")
)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c-mode))
(add-hook 'c-mode-hook 'my-c-mode-hook)
