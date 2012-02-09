; TODO: Install http://jblevins.org/projects/markdown-mode/
; TODO: Get emacs configs sent to remote server along with dotfiles repo
; TODO: Check out https://github.com/purcell/emacs.d

(define-key esc-map "G" 'goto-line) 
(global-font-lock-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp/")

; loads ruby mode when a .rb file is opened.
(autoload 'ruby-mode "ruby-mode" "Major mode for editing ruby scripts." t)
(setq auto-mode-alist  (cons '(".rb$" . ruby-mode) auto-mode-alist))


(add-hook 'ruby-mode-hook
      (lambda()
        (add-hook 'local-write-file-hooks
                  '(lambda()
                     (save-excursion
                       (untabify (point-min) (point-max))
                       (delete-trailing-whitespace)
                       )))
        (set (make-local-variable 'indent-tabs-mode) 'nil)
        (set (make-local-variable 'tab-width) 2)
        (imenu-add-to-menubar "IMENU")
        (define-key ruby-mode-map "\C-m" 'newline-and-indent) ;Not sure if this line is 100% right!
     ;   (require 'ruby-electric)
     ;   (ruby-electric-mode t)
        ))
