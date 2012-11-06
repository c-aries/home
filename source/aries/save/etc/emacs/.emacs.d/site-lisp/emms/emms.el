(require 'emms-setup)
(require 'emms-volume)
(emms-standard)
(emms-default-players)

(setq emms-source-file-default-directory "~/audio")

(setq emms-playlist-buffer-name "*Music*")

(global-set-key (kbd "C-c m m") 'emms-playlist-mode-go)
(global-set-key (kbd "C-c m a f") 'emms-add-file)
(global-set-key (kbd "C-c m a d") 'emms-add-directory)
(global-set-key (kbd "C-c m a t") 'emms-add-directory-tree)
(global-set-key (kbd "C-c m a l") 'emms-add-playlist)
(global-set-key (kbd "C-c m SPC") 'emms-pause)
(global-set-key (kbd "C-c m h") 'emms-shuffle)
(global-set-key (kbd "C-c m v") 'emms-show)
(global-set-key (kbd "C-c m r") 'emms-toggle-repeat-track)
(global-set-key (kbd "C-c m R") 'emms-toggle-repeat-playlist)
(define-key emms-playlist-mode-map (kbd "+") 'emms-volume-raise)
(define-key emms-playlist-mode-map (kbd "-") 'emms-volume-lower)

(setq emms-cache-file "~/.emacs.d/data/emms/emms-cache"
      emms-history-file "~/.emacs.d/data/emms/emms-history")

(setq emms-info-functions 'emms-info-libtag)
