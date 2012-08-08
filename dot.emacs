;; From: http://www.emacswiki.org/emacs/InitFile#init_file
;; Your init file contains personal EmacsLisp code that you want to execute when you start Emacs.
;; * For GnuEmacs, it is ~/.emacs or _emacs or ~/.emacs.d/init.el.
;; * For XEmacs, it is ~/.xemacs or ~/.xemacs/init.el.
;; * For AquamacsEmacs, it is ~/.emacs or ~/Library/Preferences/Aquamacs Emacs/Preferences.el

;; TODO: Get emacs configs sent to remote server along with dotfiles repo. .emacs is handled but not the .emacs.d directory
;; TODO: Check out https://github.com/purcell/emacs.d
;; TODO: In 99-Archive/physics.rutgers.edu/Main.Feb98.tgz there is a folder called Main/Computer/Programming/Emacs .  Check it out to see if there is anything of value there.
;; I've done most of this that's relevant: http://www.ysiad.com/2011/emacs-setup-for-ruby-on-rails/
;; TODO: Anything to do with this? http://www.emacswiki.org/emacs/CategoryDotEmacs

(define-key esc-map "G" 'goto-line)
(global-font-lock-mode 1)

(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Ruby Electric: I'm using a fork from here: https://github.com/qoobaa/ruby-electric
(add-to-list 'load-path "~/.emacs.d/vendor/ruby-electric")
;; loads ruby mode when a .rb file is opened.
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

;; From: http://www.emacswiki.org/emacs/FlymakeRuby
;; Enable syntax checking in ruby
(require 'flymake)

;; Someone doesn't like the default colors
(set-face-background 'flymake-errline "red4")
(set-face-background 'flymake-warnline "dark slate blue")

;; Invoke ruby with '-c' to get syntax checking
(defun flymake-ruby-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
	 (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))

(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

(push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)

(add-hook 'ruby-mode-hook
          '(lambda ()
	     ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
	     (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
		 (flymake-mode))
	     ))

;; TODO: http://www.jwz.org/doc/tabs-vs-spaces.html

;; Nav seems good.  ECB is old and heavy.
(require 'nav)
(nav-disable-overeager-window-splitting)
;; Optional: set up a quick key to toggle nav
(global-set-key [f8] 'nav-toggle)

;; This is an experiment. Always enable nav.
;; NO, it messes up with sudo.   When running "sudo emacs /etc/hosts" for example
;;(nav-toggle)

;; The following textmate code doesn't seem to work for me at this time -- 6/13/2012. Keybinding issue.
;;(add-to-list 'load-path "~/.emacs.d/vendor/textmate.el")
;;(require 'textmate)
;;(textmate-mode)

;; The following lines allow me to click with my mouse and have the cursor move there. Also allow scrolling!
;; This is a DEFINITE plus on my local machine. I still need to check how it works via ssh to a Linux box

;; ************* Here is the key: To use OS X select, hold down the alt (option) key
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
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
;; Update: This seems to be enabled by default, at least on Emacs24 on OS X
;;(require 'epa-file)
;;(epa-file-enable)

;; From: http://jblevins.org/projects/markdown-mode/
(add-to-list 'load-path "~/.emacs.d/vendor/markdown-mode")
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.markdown" . markdown-mode) auto-mode-alist))

;;(add-to-list 'load-path "~/.emacs.d/vendor/git-emacs")
;;(require 'git-emacs)

;; Set indentation for javascript to 2 spaces
(setq js-indent-level 2)
