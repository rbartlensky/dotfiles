(defun my-c++-mode-hook ()
  (c-set-offset 'substatement-open 0)
  ;; other customizations can go here
  (setq c-basic-offset 4)                  ;; Default is 2
  (setq c-indent-level 4)                  ;; Default is 2

  (add-hook 'c++-mode-hook 'irony-mode)
  ;; replace the `completion-at-point' and `complete-symbol' bindings in
  ;; irony-mode's buffers by irony-mode's function
  (defun my-irony-mode-hook ()
    (define-key irony-mode-map [remap completion-at-point]
      'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol]
      'irony-completion-at-point-async))
  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)

  (require 'company-irony-c-headers)
  (eval-after-load 'company
    '(add-to-list
      'company-backends '(company-irony-c-headers company-irony)))
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))
  ;; (require 'rtags) ;; optional, must have rtags installed
  (add-to-list 'company-backends 'company-c-headers)
  (cmake-ide-setup)
  (setq cmake-ide-flags-c++ '("-std=c++17" "-I/usr/include"
                              "-I/usr/local/include"))
  (setq cmake-ide-flags-c '("-I/usr/include"))
)
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
