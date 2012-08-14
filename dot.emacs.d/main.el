;; Show trailing whitespace
(setq-default show-trailing-whitespace t)

;; I frequently go to a specfic line of code
(define-key esc-map "G" 'goto-line)

;; This appears to be needed to ensure proper colors
(global-font-lock-mode 1)

;; Enable ido mode. Thanks to: http://www.masteringemacs.org/articles/2010/10/10/introduction-to-ido-mode/
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

;; Set up config dir variables
(setq djr-emacs-init-file load-file-name)
(setq djr-emacs-config-dir
      (file-name-directory djr-emacs-init-file))
(setq user-emacs-directory djr-emacs-config-dir)

;; Save emacs backup files to a specific directory
(setq backup-directory-alist
      (list (cons "." (expand-file-name "backup" user-emacs-directory))))

(add-hook 'djr-code-modes-hook
          (lambda () (linum-mode 1)))

(add-hook 'ruby-mode-hook
          (lambda () (run-hooks 'djr-code-modes-hook)))

;; This directory has emacs lisp files. As opposed to vendor which has directories of emacs lisp files. Should I keep them separate?
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Load code related to editing ruby files
(load "~/.emacs.d/ruby.el")

;; Load nav
(load "~/.emacs.d/nav.el")

;; Load mouse code
(load "~/.emacs.d/mouse.el")

;; Load markdown code
(load "~/.emacs.d/markdown.el")

;; Load javascript code
(load "~/.emacs.d/javascript.el")
