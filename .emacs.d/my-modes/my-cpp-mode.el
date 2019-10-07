(defun my-c++-mode-hook ()
  ;; (c-set-style "java")

  ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
  (global-set-key [3 6] (quote find-file-in-project))
  (global-set-key "\C-c\C-v" 'uncomment-region)
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
  (setq cmake-ide-flags-c++ '("-std=c++11" "-I/usr/include" "/usr/include/c++/6"
                              "/usr/include/x86_64-linux-gnu/c++/6"
                              "/usr/include/c++/6/backward"
                              "/usr/lib/gcc/x86_64-linux-gnu/6/include"
                              "/usr/local/include"
                              "/usr/lib/gcc/x86_64-linux-gnu/6/include-fixed"
                              "/usr/include/x86_64-linux-gnu"))
  (setq cmake-ide-flags-c '("-I/usr/include"))
)

(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
