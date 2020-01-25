;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;(package-initialize)




(load "~/.emacs.d/lib/better-defaults/better-defaults.el")
(load "~/.emacs.d/lib/typescript/typescript-mode.el")
(load "~/.emacs.d/lib/dash/dash.el")
(load "~/.emacs.d/lib/s/s.el")
(load "~/.emacs.d/lib/flycheck/flycheck.el")

(add-to-list 'load-path (concat user-emacs-directory "lib/tide"))
(load "~/.emacs.d/lib/tide/tide.el")
