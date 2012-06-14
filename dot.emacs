; TODO: Get emacs configs sent to remote server along with dotfiles repo. .emacs is handled but not the .emacs.d directory
; TODO: Check out https://github.com/purcell/emacs.d
; TODO: In 99-Archive/physics.rutgers.edu/Main.Feb98.tgz there is a folder called Main/Computer/Programming/Emacs .  Check it out to see if there is anything of value there.
; I've done most of this that's relevant: http://www.ysiad.com/2011/emacs-setup-for-ruby-on-rails/


(define-key esc-map "G" 'goto-line) 
(global-font-lock-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp/")

; Ruby Electric: I'm using a fork from here: https://github.com/qoobaa/ruby-electric
(add-to-list 'load-path "~/.emacs.d/vendor/ruby-electric")
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
        (require 'ruby-electric)
        (ruby-electric-mode t)
        ))


; TODO: http://www.jwz.org/doc/tabs-vs-spaces.html


;; Nav seems good.  ECB is old and heavy.
(require 'nav)
(nav-disable-overeager-window-splitting)
;; Optional: set up a quick key to toggle nav
(global-set-key [f8] 'nav-toggle)


;; The following textmate code doesn't seem to work for me at this time -- 6/13/2012. Keybinding issue.
;(add-to-list 'load-path "~/.emacs.d/vendor/textmate.el")
;(require 'textmate)
;(textmate-mode)

;; The following lines allow me to click with my mouse and have the cursor move there. Also allow scrolling!
;; This is a DEFINITE plus on my local machine. I still need to check how it works via ssh to a Linux box
(unless window-system
  (require 'mouse)
;  (xterm-mouse-mode t)
  (global-set-key [mouse-4] '(lambda ()
                              (interactive)
                              (scroll-down 1)))
  (global-set-key [mouse-5] '(lambda ()
                              (interactive)
                              (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)
)

;; Cool. This enables Easy PG which allows me to edit a .gpg file by auto-decrypting it. It re-encrypts it on save.
(require 'epa-file)
(epa-file-enable)


;; From: http://jblevins.org/projects/markdown-mode/
(add-to-list 'load-path "~/.emacs.d/vendor/markdown-mode")
(autoload 'markdown-mode "markdown-mode.el"
   "Major mode for editing Markdown files" t)
(setq auto-mode-alist
   (cons '("\\.markdown" . markdown-mode) auto-mode-alist))
