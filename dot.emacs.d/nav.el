;; Nav seems good.  ECB is old and heavy.
(require 'nav)
(nav-disable-overeager-window-splitting)
;; Optional: set up a quick key to toggle nav
(global-set-key [f8] 'nav-toggle)

;; This is an experiment. Always enable nav.
;; NO, it messes up with sudo.   When running "sudo emacs /etc/hosts" for example
;;(nav-toggle)
