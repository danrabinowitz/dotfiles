(when (string= system-type "darwin")       
  (setq dired-use-ls-dired nil))


(use-package treemacs
  :bind
  (("C-c t" . treemacs)
   ("s-a" . treemacs)))


(use-package buffer-flip
  :bind
  (("M-o" . buffer-flip)
   :map buffer-flip-map
   ("M-o" . buffer-flip-forward)
   ("M-O" . buffer-flip-backward)
   ("C-g" . buffer-flip-abort)))
