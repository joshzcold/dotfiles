;; .emacs.d/init.el

;; Package Support via straight package manager
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


;; Packages ==============================================
(straight-use-package 'evil) ;; vim mode
(straight-use-package 'better-defaults) ;; https://git.sr.ht/~technomancy/better-defaults
(straight-use-package 'company) ;; completion
(straight-use-package 'flycheck) ;; completion
(straight-use-package 'undo-fu) ;; undo handler
(straight-use-package 'undo-fu-session);; persistent undo
(straight-use-package 'use-package) ;; package config organization
(straight-use-package 'smart-mode-line) ;; better bottom bar
;; Programming ---------------
(straight-use-package 'magit) ;; git handler
(straight-use-package 'lsp-mode)
(straight-use-package 'lsp-ui)
(straight-use-package 'json-mode)
(straight-use-package 'yaml-mode)
(straight-use-package 'svelte-mode)
(straight-use-package 'jenkinsfile-mode)
(straight-use-package 'groovy-mode)
(straight-use-package 'yasnippet)
(straight-use-package 'yasnippet-snippets)
;; =======================================================

;; GLOBAL Config =================================================
(setq inhibit-startup-message t)    ;; Hide the startup message
(setq auto-save-file-name-transforms
  `((".*" "~/.emacs-saves/" t)))
(setq backup-directory-alist
          `(("." . ,(concat user-emacs-directory "backups"))))
(electric-pair-mode 1)
(global-display-line-numbers-mode)  ;; Line numbers globally
(setq display-line-numbers-type 'relative)
(global-undo-fu-session-mode)
;; disable menu bar in terminal mode
(unless (display-graphic-p)
   (menu-bar-mode -1))


;; ===============================================================

(use-package better-defaults)

(use-package yasnippet                  ; Snippets
  :config
  (define-key yas-minor-mode-map (kbd "C-j") 'yas-next-field)
  (define-key yas-minor-mode-map (kbd "C-k") 'yas-prev-field)

  (yas-reload-all)
  (yas-global-mode))

(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-cross-lines t)
  (setq evil-undo-system 'undo-fu)
  (setq evil-search-highlight-background-colour "purple1")
  (setq-default evil-cross-lines t)
  :config
  (evil-mode 1)
  (define-key evil-normal-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
  (define-key evil-motion-state-map (kbd "<remap> <evil-next-line>") 'evil-next-visual-line)
  (define-key evil-motion-state-map (kbd "<remap> <evil-previous-line>") 'evil-previous-visual-line)
  (define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
  (define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
  (define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
  (define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
  (define-key evil-insert-state-map (kbd "C-k") nil)

  )

(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook (
         ;; launch lsp when using these modes
	 (python-mode . lsp)
	 (json-mode . lsp)
	 (svelte-mode . lsp)
	 (yaml-mode . lsp)
	 (bash-mode . lsp)
   )
  :commands lsp)

(use-package company
  :config
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  (define-key company-active-map (kbd "C-j") #'company-select-next)
  (define-key company-active-map (kbd "C-k") #'company-select-previous)
  (add-hook 'after-init-hook 'global-company-mode)
  (defun mars/company-backend-with-yas (backends)
      (if (and (listp backends) (memq 'company-yasnippet backends))
	  backends
	(append (if (consp backends)
		    backends
		  (list backends))
		'(:with company-yasnippet))))

    ;; add yasnippet to all backends
  (setq company-backends (mapcar #'mars/company-backend-with-yas company-backends))
  :init
  (setq company-minimum-prefix-length 1 company-idle-delay 0.0) 
)

(use-package smart-mode-line
  :init
  (setq sml/no-confirm-load-theme t)
  (setq sml/theme 'dark)
  (sml/setup)
)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default))
 '(package-selected-packages '(material-theme better-defaults evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
