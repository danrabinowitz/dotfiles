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

