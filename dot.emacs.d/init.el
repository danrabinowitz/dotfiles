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
(add-to-list 'load-path (concat user-emacs-directory "lib/company"))
(load "~/.emacs.d/lib/company/company.el")

(add-to-list 'load-path (concat user-emacs-directory "lib/tide"))
(load "~/.emacs.d/lib/tide/tide.el")

(load "~/.emacs.d/lib/exec-path-from-shell/exec-path-from-shell.el")

;; From https://github.com/ananthakumaran/tide
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)


;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'typescript-mode)



(setq flycheck-eslintrc "~/.eslintrc.json")
;(setq flycheck-javascript-eslint-executable "/usr/local/bin/eslint")
