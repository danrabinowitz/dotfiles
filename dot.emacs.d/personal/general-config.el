; Doing this for https://github.com/emacs-lsp/lsp-mode#performance
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb

; cthulhu has 193k files as of Feb 2020. This *seems* ok.
(setq lsp-file-watch-threshold 200000)
