; TODO: Install http://jblevins.org/projects/markdown-mode/
; TODO: Get emacs configs sent to remote server along with dotfiles repo. .emacs is handled but not the .emacs.d directory
; TODO: Check out https://github.com/purcell/emacs.d
; TODO: In 99-Archive/physics.rutgers.edu/Main.Feb98.tgz there is a folder called Main/Computer/Programming/Emacs .  Check it out to see if there is anything of value there.

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
