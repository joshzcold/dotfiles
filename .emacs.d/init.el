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
(straight-use-package 'evil)               ;; vim mode
(straight-use-package 'better-defaults)    ;; https://git.sr.ht/~technomancy/better-defaults
(straight-use-package 'company)            ;; completion
(straight-use-package 'flycheck)           ;; syntax error highlight
(straight-use-package 'undo-fu)            ;; undo handler
(straight-use-package 'undo-fu-session)    ;; persistent undo
(straight-use-package 'use-package)        ;; package config organization
(straight-use-package 'helm)               ;; workspace manager and file finder
(straight-use-package 'helm-ls-git)        ;; search on files in git
(straight-use-package 'smart-mode-line)    ;; better bottom bar
(straight-use-package 'doom-themes)        ;; collection of themes
(straight-use-package 'doom-modeline)
(straight-use-package 'all-the-icons)
(straight-use-package 'minions)
(straight-use-package 'org)          
(straight-use-package 'org-bullets)
(straight-use-package 'org-superstar)
(straight-use-package 'org-tree-slide)
(straight-use-package 'visual-fill-column)
(straight-use-package 'unicode-fonts)
(straight-use-package 'diminish)
;; Programming ---------------
(straight-use-package 'magit)              ;; git handler
(straight-use-package 'evil-nerd-commenter) ;; comment out code
(straight-use-package 'lsp-mode)           ;; language server protcol
(straight-use-package 'lsp-ui)             ;; provides ui tips during lsp
(straight-use-package 'json-mode)
(straight-use-package 'yaml-mode)
(straight-use-package 'svelte-mode)
(straight-use-package 'jenkinsfile-mode)
(straight-use-package 'groovy-mode)
(straight-use-package 'yasnippet)          ;; snippet engine
(straight-use-package 'yasnippet-snippets) ;; collection of snippets
;; =======================================================

;; GLOBAL Config =================================================
(setq inhibit-startup-message t)                               ;; Hide the startup message
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq auto-save-file-name-transforms                           ;;
  `((".*" "~/.emacs-saves/" t)))                               ;; divert auto save files to one location
(setq backup-directory-alist                                   ;;
          `(("." . ,(concat user-emacs-directory "backups")))) ;; divert backups to one location
(electric-pair-mode 1)                                         ;; complete common pairs {} [] ()
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
 (add-to-list 'default-frame-alist '(alpha . (90 . 90)))

(column-number-mode)
(dolist (mode '(text-mode-hook
                prog-mode-hook
                conf-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 1))))

(dolist (mode '(org-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq display-line-numbers-type 'relative)                     ;; line numbers are relative 
(global-undo-fu-session-mode)                                  ;; actiavte undo fu session mode
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)         ;; map escapte to keyboard escape for getting out of menus
(global-set-key (kbd "C-S-v") 'paste)
(global-set-key (kbd "C-S-c") 'copy)
                                                              ;; disable menu bar in terminal mode
(unless (display-graphic-p)                                    ;; unless in graphic mode remove menu bar
(menu-bar-mode -1))

;; Unicode font config
(defun dw/replace-unicode-font-mapping (block-name old-font new-font)
  (let* ((block-idx (cl-position-if
                         (lambda (i) (string-equal (car i) block-name))
                         unicode-fonts-block-font-mapping))
         (block-fonts (cadr (nth block-idx unicode-fonts-block-font-mapping)))
         (updated-block (cl-substitute new-font old-font block-fonts :test 'string-equal)))
    (setf (cdr (nth block-idx unicode-fonts-block-font-mapping))
          `(,updated-block))))

(use-package unicode-fonts
  :straight t
  :custom
  (unicode-fonts-skip-font-groups '(low-quality-glyphs))
  :config
  ;; Fix the font mappings to use the right emoji font
  (mapcar
    (lambda (block-name)
      (dw/replace-unicode-font-mapping block-name "Apple Color Emoji" "Noto Color Emoji"))
    '("Dingbats"
      "Emoticons"
      "Miscellaneous Symbols and Pictographs"
      "Transport and Map Symbols"))
  (unicode-fonts-setup))


;; ===============================================================

;; USER Functions ================================================

(defun Term()
  (interactive)
  (shell)
  )
;; ===============================================================

(use-package better-defaults)
(use-package evil-nerd-commenter
  :bind ("M-/" . evilnc-comment-or-uncomment-lines))

(use-package minions
  :hook (doom-modeline-mode . minions-mode)
  :custom
  (minions-mode-line-lighter ""))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :custom    
  (doom-modeline-height 25)
  (doom-modeline-bar-width 1)
  (doom-modeline-icon nil)
  (doom-modeline-major-mode-icon nil)
  (doom-modeline-major-mode-color-icon t)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-unicode-fallback nil)
  (doom-modeline-buffer-file-name-style 'truncate-upto-project)
  (doom-modeline-buffer-state-icon t)
  (doom-modeline-buffer-modification-icon t)
  (doom-modeline-minor-modes nil)
  (doom-modeline-enable-word-count nil)
  (doom-modeline-buffer-encoding nil)
  (setq doom-modeline-lsp t)
  (doom-modeline-indent-info nil)
  (doom-modeline-checker-simple-format t)
  (doom-modeline-vcs-max-length 12)
  (doom-modeline-env-version t)
  (doom-modeline-irc-stylize 'identity)
  (doom-modeline-github-timer nil)
  (doom-modeline-gnus-timer nil))

;; Turn on indentation and auto-fill mode for Org files
(defun dw/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1)
  (diminish org-indent-mode))

(use-package org
  :defer t
  :hook (org-mode . dw/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-edit-src-content-indentation 2
        org-hide-block-startup nil
        org-src-preserve-indentation nil
        org-startup-folded 'content
        org-cycle-separator-lines 2)

  (setq org-refile-targets '((nil :maxlevel . 2)
                             (org-agenda-files :maxlevel . 2)))

  (setq org-outline-path-complete-in-steps nil)
  (setq org-refile-use-outline-path t)

  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-j") 'org-next-visible-heading)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "C-k") 'org-previous-visible-heading)

  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-j") 'org-metadown)
  (evil-define-key '(normal insert visual) org-mode-map (kbd "M-k") 'org-metaup)

(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("\u200b"))
  )

;; Replace list hyphen with dot
;; (font-lock-add-keywords 'org-mode
;;                         '(("^ *\\([-]\\) "
;;                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; Increase the size of various headings
;;(set-face-attribute 'org-document-title nil :font "Cantarell" :weight 'bold :height 1.3)
(dolist (face '((org-level-1 . 1.5)
                (org-level-2 . 1.3)
                (org-level-3 . 1.2)
                (org-level-4 . 1.0)
                (org-level-5 . 1.0)
                (org-level-6 . 1.0)
                (org-level-7 . 1.0)
                (org-level-8 . 1.0)))
  (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

;; Make sure org-indent face is available
(require 'org-indent)

;; Ensure that anything that should be fixed-pitch in Org files appears that way
(set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
(set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
(set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
(set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
(set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
(set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

)

;; add left padding on org mode
(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ;; if nil, bold is universally disabled
        doom-themes-enable-italic t) ;; if nil, italics is universally disabled
  (load-theme 'doom-one t)         ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config) ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package helm
  :config
  (global-set-key (kbd "M-SPC") 'helm-ls-git-ls)
  (global-set-key (kbd "M-d") 'helm-grep-do-git-grep)
  )

(use-package yasnippet                  ;; Snippets
  :config
  (define-key yas-minor-mode-map (kbd "C-j") 'yas-next-field)
  (define-key yas-minor-mode-map (kbd "C-k") 'yas-prev-field)
  (yas-reload-all)
  (yas-global-mode))

(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-cross-lines t)
  (setq evil-search-module "evil-search")
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
	 (javascript-mode . lsp)
   )
  :config
  (define-key lsp-mode-map (kbd "gd") 'lsp-find-definition)
  (define-key lsp-mode-map (kbd "gD") 'lsp-find-references)
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
  (setq company-minimum-prefix-length 2 company-idle-delay 0.0) 
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
