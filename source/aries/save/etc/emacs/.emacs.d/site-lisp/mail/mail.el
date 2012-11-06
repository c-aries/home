(setq starttls-use-gnutls t)
(setq user-mail-address "babyaries2@gmail.com")
(setq rmail-file-name "~/.emacs.d/data/mail/RMAIL")
(setq rmail-default-rmail-file "~/.emacs.d/data/mail/XMAIL")

(setq send-mail-function 'smtpmail-send-it

   message-send-mail-function 'smtpmail-send-it
   smtpmail-starttls-credentials
   '(("smtp.gmail.com" 587 nil nil))
   smtpmail-auth-credentials
   (expand-file-name "~/.smtp-authinfo")

   smtpmail-default-smtp-server "smtp.gmail.com"
   smtpmail-smtp-server "smtp.gmail.com"
   smtpmail-smtp-service 587
   smtpmail-debug-info t

   starttls-extra-arguments nil
   smtpmail-warn-about-unknown-extensions t
   starttls-use-gnutls nil
   smtpmail-queue-mail t
   smtpmail-queue-dir "~/.emacs.d/data/mail/queue/")
