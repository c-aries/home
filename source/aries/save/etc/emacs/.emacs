(global-set-key [f2] 'shell)
(global-set-key [f3] 'w3m)
(global-set-key [f4] 'rmail)
(global-set-key [f8] 'rename-buffer)
(global-set-key [f9] 'rename-uniquely)
(global-set-key [f11] 'battery)

(transient-mark-mode)
(ansi-color-for-comint-mode-on)
(display-time)

(require 'w3m)
(setq w3m-home-page "http://www.google.com")

(load-file "~/.emacs.d/site-lisp/emms/emms.el")

(load-file "~/.emacs.d/site-lisp/mail/mail.el")
(load-file "~/.emacs.d/site-lisp/mail/etach.el")

(add-to-list 'load-path "~/.emacs.d/site-lisp/wubi/")
(require 'wubi)
(setq default-input-method "chinese-wubi")
(set 'wubi-phrases-file "~/.emacs.d/data/wubi/phrases")
(wubi-load-local-phrases)

(add-to-list 'load-path "~/.emacs.d/site-lisp/sdcv/")
(require 'sdcv-mode)
(global-set-key (kbd "C-c d") 'sdcv-search)
