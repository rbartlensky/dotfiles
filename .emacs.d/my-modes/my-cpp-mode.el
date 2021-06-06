(defun my-c++-mode-hook ()
  (c-set-offset 'substatement-open 0)
  ;; other customizations can go here
  (setq c-basic-offset 4)                  ;; Default is 2
  (setq c-indent-level 4)                  ;; Default is 2
)
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'c++-mode-hook 'lsp)
