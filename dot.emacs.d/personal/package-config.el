;;; This file contains emacs lisp code which sets up package management and loads some packages.

;; The next line loads the "package.el" package manager library for ELPA, the Emacs Lisp Package Archive
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
This version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  ;; (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

(load "~/.emacs.d/lib/better-defaults/better-defaults.el")
(load "~/.emacs.d/lib/typescript/typescript-mode.el")
(load "~/.emacs.d/lib/dash/dash.el")
(load "~/.emacs.d/lib/s/s.el")
(load "~/.emacs.d/lib/flycheck/flycheck.el")
(add-to-list 'load-path (concat user-emacs-directory "lib/company"))
(load "~/.emacs.d/lib/company/company.el")
(load "~/.emacs.d/lib/go-mode.el/go-mode.el")

(add-to-list 'load-path (concat user-emacs-directory "lib/tide"))
(load "~/.emacs.d/lib/tide/tide.el")

(load "~/.emacs.d/lib/exec-path-from-shell/exec-path-from-shell.el")
