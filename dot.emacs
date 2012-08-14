;; From: http://www.emacswiki.org/emacs/InitFile#init_file
;; Your init file contains personal EmacsLisp code that you want to execute when you start Emacs.
;; * For GnuEmacs, it is ~/.emacs or _emacs or ~/.emacs.d/init.el.
;; * For XEmacs, it is ~/.xemacs or ~/.xemacs/init.el.
;; * For AquamacsEmacs, it is ~/.emacs or ~/Library/Preferences/Aquamacs Emacs/Preferences.el

;; Thanks to @avdi for some of the code here

;; TODO: Get emacs configs sent to remote server along with dotfiles repo. .emacs is handled but not the .emacs.d directory
;; TODO: Check out https://github.com/purcell/emacs.d
;; TODO: In 99-Archive/physics.rutgers.edu/Main.Feb98.tgz there is a folder called Main/Computer/Programming/Emacs .  Check it out to see if there is anything of value there.
;; I've done most of this that's relevant: http://www.ysiad.com/2011/emacs-setup-for-ruby-on-rails/
;; TODO: Anything to do with this? http://www.emacswiki.org/emacs/CategoryDotEmacs

(load "~/.emacs.d/main.el")

;; TODO: In this essay, JWZ suggests creating a function called on save which ensures there are no tabs saved. I should do this, for ruby at least.
;; http://www.jwz.org/doc/tabs-vs-spaces.html

;; The following textmate code doesn't seem to work for me at this time -- 6/13/2012. Keybinding issue.
;;(add-to-list 'load-path "~/.emacs.d/vendor/textmate.el")
;;(require 'textmate)
;;(textmate-mode)

;; Cool. This enables Easy PG which allows me to edit a .gpg file by auto-decrypting it. It re-encrypts it on save.
;; Update: This seems to be enabled by default, at least on Emacs24 on OS X
;;(require 'epa-file)
;;(epa-file-enable)

;;(add-to-list 'load-path "~/.emacs.d/vendor/git-emacs")
;;(require 'git-emacs)

