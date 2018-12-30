
;;;;;;;;;;; Please note the color theme's name is "molokai"

(when (or (display-graphic-p)
          (string-match-p "256color"(getenv "TERM")))
  (load-theme 'molokai t))
 ; (load-theme 'sanityinc-solarized-dark t))

;;;;;;;;;;; resize window
;; https://www.emacswiki.org/emacs/WindowResize
; (global-set-key (kbd "C-w <left>") 'shrink-window-horizontally)
; (global-set-key (kbd "C-w <right>") 'enlarge-window-horizontally)
; (global-set-key (kbd "C-w <down>") 'shrink-window)
; (global-set-key (kbd "C-w <up>") 'enlarge-window)

;; create the locap mirror of elpa
;; (setq elpamr-default-output-directory "~/.local/config/myelpa")
;; myelpa is the ONLY repository now, dont forget trailing slash in the directory
;; (setq package-archives '(("myelpa" . "~/.local/config/myelpa/")))