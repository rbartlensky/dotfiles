(setq required-packages
      (list
       'ac-racer ;
       'apel ;
       'async ;
       'auto-complete ;
       'auto-complete-clang ;
       'cargo ;
       'cmake-ide ;
       'company ;
       'company-c-headers ;
       'company-glsl ;
       'company-irony ;
       'company-irony-c-headers ;
       'company-racer ;
       'concurrent ;
       'ctable ;
       'dash ;
       'deferred ;
       'elpy ;
       'epc ;
       'epl ;
       'f ;
       'find-file-in-project ;
       'flycheck ;
       'flycheck-clang-analyzer ;
       'flycheck-clangcheck ;
       'flycheck-clang-tidy ;
       'flycheck-irony ;
       'flycheck-rust ;
       'flymake-cppcheck ;
       'flymake-easy ;
       'flymake-python-pyflakes ;
       'flymake-rust ;
       'fullframe ;
       'git-commit ;
       'glsl-mode ;
       'goto-chg ;
       'highlight-indentation ;
       'hydandata-light-theme ;
       'irony ;
       'irony-eldoc ;
       'ivy ;
       'jedi ;
       'jedi-core ;
       'levenshtein ;
       'lua-mode ;
       'magit ;
       'markdown-mode ;
       'pkg-info ;
       'popup ;
       'pos-tip ;
       'projectile ;
       'projectile-ripgrep ;
       'python-environment ;
       'pyvenv ;
       'racer ;
       'ripgrep ;
       'rtags ;
       'rust-auto-use ;
       'rust-mode ;
       's ;
       'seq ;
       'toml-mode ;
       'transient ;
       'with-editor ;
       'yaml-mode ;
       'yasnippet ;
       ))

(defun install-all-packages ()
  (interactive)
  ;; check for new packages (package versions)
  (message "%s" "Emacs is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p required-packages)
    (when (not (package-installed-p p))
      (package-install p))))

(provide 'package-updater)
