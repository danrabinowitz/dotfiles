;;; This file contains emacs lisp code which sets up package management and loads some packages.

;; The next line loads the "package.el" package manager library for ELPA, the Emacs Lisp Package Archive
(require 'package)

(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa-stb" . "https://stable.melpa.org/packages/")
        ("melpa" . "https://melpa.org/packages/"))
      tls-checktrust t
      tls-program '("gnutls-cli --x509cafile %t -p %p %h")
      gnutls-verify-error t)

(package-initialize)
(setq use-package-always-ensure nil)

(unless (require 'use-package nil t)
  (if (not (yes-or-no-p (concat "Refresh packages, install use-package and"
                                " other packages used by init file? ")))
      (error "you need to install use-package first")
    (package-refresh-contents)
    (package-install 'use-package)
    (require 'use-package)
    (setq use-package-always-ensure t)))


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
