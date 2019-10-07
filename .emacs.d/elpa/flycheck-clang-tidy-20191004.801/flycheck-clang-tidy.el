;;; flycheck-clang-tidy.el --- Flycheck syntax checker using clang-tidy

;; Author: Sebastian Nagel<sebastian.nagel@ncoding.at>
;; Maintainer: tastytea <tastytea@tastytea.de>
;; URL: https://github.com/ch1bo/flycheck-clang-tidy
;; Keywords: convenience languages tools
;; Package-Version: 20191004.801
;; Package-X-Original-Version: 0.2.0
;; Package-Requires: ((flycheck "0.30"))

;; This file is NOT part of GNU Emacs.
;; See LICENSE

;;; Commentary:

;; Adds a Flycheck syntax checker for C/C++ based on clang-tidy.

;;; Usage:

;;     (eval-after-load 'flycheck
;;       '(add-hook 'flycheck-mode-hook #'flycheck-clang-tidy-setup))


;;; Code:

(require 'flycheck)

;; To keep variable names consistent.
(defvaralias 'flycheck-clang-tidy-executable 'flycheck-c/c++-clang-tidy-executable)

(flycheck-def-config-file-var flycheck-clang-tidy c/c++-clang-tidy ".clang-tidy"
  :type 'string
  :safe #'stringp)

(flycheck-def-option-var flycheck-clang-tidy-build-path "build" c/c++-clang-tidy
  "Build path to read a compile command database.

For example, it can be a CMake build directory in which a file named
compile_commands.json exists (use -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
CMake option to get this output)."
  :type 'string
  :safe #'stringp)

(flycheck-def-option-var flycheck-clang-tidy-extra-options nil c/c++-clang-tidy
  "Extra options to pass to clang-tidy. Set to `nil' to disable."
  :type 'string
  :safe #'stringp)

(defun flycheck-clang-tidy-find-project-root (checker)
  "Find the project root using projectile, vc or the .clang-tidy file."
  (let ((project-root nil))
    (if (member 'projectile-mode minor-mode-list)
        (setq project-root (projectile-project-root)))
    (unless project-root
      (setq project-root (vc-root-dir)))
    (unless project-root
      (let ((config_file_location (flycheck-locate-config-file flycheck-clang-tidy checker)))
        (if config_file_location
            (setq project-root (file-name-directory config_file_location)))))
    (unless project-root
      (message "Could not determine project root, trying current directory.")
      (setq project-root (file-name-directory (buffer-file-name))))
    project-root))

(defun flycheck-clang-tidy-current-source-dir ()
  "Directory of current source file."
  (concat "-I" (file-name-directory (buffer-file-name))))

(defun flycheck-clang-tidy-get-config ()
  "Find and read .clang-tidy."
  (let ((config-file (flycheck-locate-config-file flycheck-clang-tidy 0)))
    (when config-file
      (with-temp-buffer
        (insert-file-contents config-file)
        (buffer-string)))))

(flycheck-define-checker c/c++-clang-tidy
  "A C/C++ syntax checker using clang-tidy.

See URL `https://github.com/ch1bo/flycheck-clang-tidy'."
  :command ("clang-tidy"
            (option "-p" flycheck-clang-tidy-build-path)
            (eval (concat "-extra-arg=" (flycheck-clang-tidy-current-source-dir)))
            (eval (concat "-config=" (flycheck-clang-tidy-get-config)))
            (eval flycheck-clang-tidy-extra-options)
            source)
  :error-patterns
  ((error line-start (file-name) ":" line ":" column ": error: "
          (message) line-end)
   (warning line-start (file-name) ":" line ":" column ": warning: "
            (message) line-end)
   (info line-start (file-name) ":" line ":" column ": note: "
         (message) line-end))
  :modes (c-mode c++-mode)
  :working-directory flycheck-clang-tidy-find-project-root
  :predicate (lambda () (buffer-file-name))
  :next-checkers ((error . c/c++-cppcheck))
  )

;;;###autoload
(defun flycheck-clang-tidy-setup ()
  "Setup Flycheck clang-tidy."
  (add-to-list 'flycheck-checkers 'c/c++-clang-tidy))

(provide 'flycheck-clang-tidy)
;;; flycheck-clang-tidy.el ends here
