;;; This is the initial emacs lisp file, which is loaded by emacs on startup.

(add-to-list 'load-path (concat user-emacs-directory "personal"))
(load "package-config")
(package-initialize)


(load "general-config")
(load "typescript-config")
(load "golang-config")
(load "nav-and-search-config")

(load "keys-config")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (buffer-flip treemacs which-key yasnippet company-lsp company lsp-ui lsp-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
