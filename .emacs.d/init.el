;;;; Emacs Init File
;;; Nicholas Huber
;;; 20210529

;;; Repos
;; Initialize Packages

(require 'package)
(setq package-archives '(("melpa" . "http://melpa.org/packages/")
			 ("melpa-stable" . "http://stable.melpa.org/packages/")
			 ("org" . "http://orgmode.org/elpa/")
			 ("elpa" . "http://elpa.gnu.org/packages/")))

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;; Set default coding system
;;  Set to UTF-8

(set-default-coding-systems 'utf-8)

;;; Start the Emacs Server

(server-start)

;;; Themes
;;  Install themes

(use-package spacegray-theme :defer t)
(use-package doom-themes :defer t)

;;  Load theme

(load-theme 'doom-moonlight t)
(doom-themes-visual-bell-config)

;;; GUI options
;;  Customize the GUI interface
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Turn off line numbers for some modes
(dolist (mode '(term-mode-hook
		shell-mode-hook
		eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Rainbow delimiters
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Which key
(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

;; Ivy

;; Install swiper
(use-package swiper)

;; Configure Ivy
(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("C-l" . ivy-alt-done)
	 ("C-j" . ivy-next-line)
	 ("C-k" . ivy-previous-line)
	 :map ivy-switch-buffer-map
	 ("C-k" . ivy-previous-line)
	 ("C-l" . ivy-done)
	 ("C-d" . ivy-switch-buffer-kill)
	 :map ivy-reverse-i-search-map
	 ("C-k" . ivy-previous-line)
	 ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

;; Ivy Rich
(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

;;; UI Config
;;  Prettify Mode
(global-prettify-symbols-mode 1)

;; Custom Prettify Functions
(defun nh/add-pretty-haskell ()
  "Replace strings with unicode chars"
  (setq prettify-symbols-alist
	'(
	  ("->" . 8594)
	  ("=>" . 8658)
	  ("map" . 8614))))
(add-hook 'haskell-mode-hook 'nh/add-pretty-haskell)

;; Counsel

(use-package counsel
  :bind (("C-M-j" . counsel-switch-buffer)
	 ("M-x" . counsel-M-x)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history))
  :config
  (counsel-mode 1))

;; Helpful

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

;;; Key Bindings
;;  Global Key Bindings

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Evil Mode!!

;; Define what modes need to begin in emacs mode
(defun nh/evil-hook ()
  (dolist (mode '(eshell-mode
		  term-mode
		  shell-mode))
    (add-to-list 'evil-emacs-state-modes mode)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (add-hook 'evil-mode-hook 'nh/evil-hook)
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

;; Evil Collection
;; Collection of evil mode configs for different modes
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; General

(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer nh/leader-keys
			  :keymaps '(normal insert visual emacs)
			  :prefix "SPC"
			  :global-prefix "C-SPC"))

;; Leader Keys
;; Files

(nh/leader-keys
  "f"   '(:ignore t :which-key "Files")
  "ff"  '(find-file :which-key "Find file")
  "fd"  '(:ignore t :which-key "Dotfiles")
  "fdE" '((lambda () (interactive) (find-file "~/.dotfiles/emacs.org")) :which-key "Open init file")
  "fdF" '((lambda () (interactive) (find-file "~/Documents/Finance/finance.org")) :which-key "Open finance file")
  "fdS" '((lambda () (interactive) (find-file "~/.dotfiles/ssh.org")) :which-key "Open SSH file")
  "fdN" '((lambda () (interactive) (find-file "~/Documents/Network/network.org")) :which-key "Open network file"))

;; Buffers

(nh/leader-keys
  "b" '(:ignore t :which-key "buffers")
  "bk" '(kill-buffer :which-key "Kill buffer")
  "bK" '(kill-current-buffer :which-key "Kill current buffer")
  "bs" '(swiper :which-key "Swiper")
  "br" '(revert-buffer :which-key "Revert Buffer")
  "be" '(eval-buffer :which-key "Eval Buffer")
  "bS" '(counsel-switch-buffer :which-key "Switch Buffer"))

;; Leader Keys Org

(nh/leader-keys
  "o"  '(:ignore t :which-key "Org Mode")
  "ot" '(org-babel-tangle :which-key "OB tangle")
  "oe" '(org-edit-special :which-key "Edit source")
  "oa" '(org-agenda :which-key "Org Agenda"))

;; Leader Keys Misc

(nh/leader-keys
  ":" '(execute-extended-command :which-key "M-x"))

;;; Unicode Glyph Support

(defun nh/replace-unicode-font-mapping (block-name old-font new-font)
  (let* ((block-idx (cl-position-if
		     (lambda (i) (string-equal (car i) block-name))
		     unicode-fonts-block-font-mapping))
	 (block-fonts (cadr (nth block-idx unicode-fonts-block-font-mapping)))
	 (updated-block (cl-substitute new-font old-font block-fonts :test 'string-equal)))
    (setf (cdr (nth block-idx unicode-fonts-block-font-mapping))
	  `(,updated-block))))

(use-package unicode-fonts
  :custom (unicode-fonts-skip-font-groups '(low-quality-glyphs))
  :config (mapcar
	   (lambda (block-name)
	     (nh/replace-unicode-font-mapping block-name "Apple Color Emoji" "Noto Color Emoji"))
	   '("Dingbats"
	     "Emoticons"
	     "Miscellaneous Symbols and Pictographs"
	     "Transport and Map Symbols"))
  (unicode-fonts-setup))

;;; Emojis in buffers

(use-package emojify
  :hook (erc-mode . emojify-mode)
  :commands emojify-mode)

;;; Mode Line
;;  Basic Customization

(setq display-time-format "%k:%M %Y%m%d" ; format: 24h year month day
      display-time-default-load-average nil)

;; Enable mode diminishing

(use-package diminish) ; Hides minor mode from modeline

;; Smart Mode Line
;; Prettifies modeline

(use-package smart-mode-line
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup)
  (sml/apply-theme 'respectful) ; Respects the themes colors
  (setq sml/mode-width 'right
	sml/name-width 60)

  (setq-default mode-line-format
		`("%e"
		  mode-line-front-space
		  evil-mode-line-tage
		  ;mode-line-mule-info
		  mode-line-client
		  mode-line-modified
		  mode-line-remote
		  mode-line-frame-identification
		  mode-line-buffer-identification
		  sml/pos-id-separator
		  (vc-mode vc-mode)
		  " "
		  ;mode-line-position
		  sml/pre-mode-separator
		  mode-line-modes
		  " "
		  mode-line-misc-info)))
(smart-mode-line-enable 1)

;; Doom Modeline
;; Install all the icons
(use-package all-the-icons)

;; Hook minons to doom-modeline
(use-package minions
  :hook (doom-modeline-mode . minions-mode))

;;Setup doom modeline
(use-package doom-modeline
  :after eshell
  :hook (after-init . doom-modeline-init)
  :custom-face
  (mode-line ((t (:height 0.85))))
  (mode-line-inactive ((t (:height 0.85))))
  :custom
  (doom-modeline-height 15)
  (doom-modeline-bar-width 6)
  (doom-modeline-lsp t)
  (doom-modeline-github nil)
  (doom-modeline-mu4e nil)
  (doom-modeline-irc nil)
  (doom-modeline-minor-modes t)
  (doom-modeline-persp-name nil)
  (doom-modeline-buffer-file-name-style 'truncate-except-project)
  (doom-modeline-major-mode-icon nil))
(doom-modeline-mode 1)

;; Org mode

(use-package org
  :mode ("\\.org\\'" . org-mode)
  :config
  (add-hook 'org-mode-hook 'nh/after-org-mode-load)
  (setq org-ellipsis " ???")
  (variable-pitch-mode 1))

;; Hook for after org mode loads
(defun nh/after-org-mode-load ()
  "Set these after org mode loads"
  (visual-line-mode)
  (require 'org-indent)
  (org-indent-mode))

(setq table-cell-horizontal-chars "\u2501")
(setq table-cell-vertical-char ?\u2503)
(setq table-cell-intersection-char ?\u2533)

;; Org Superstar

;; Download org-bullets
(use-package org-bullets)

;; Config Superstar
(use-package org-superstar
  :after org
  :hook (org-mode . org-superstar-mode)
  :custom
  (org-superstar-remove-leading-stars t)
  (org-superstar-headline-bullets-list '("???" "???" "???" "???" "???" "???" "???")))

;; Org Tempo

(use-package org-tempo
  :ensure nil
  :config (setq org-structure-template-alist '(("sh" . "src shell")
                                               ("el" . "src emacs-lisp")
                                               ("lgr" . "src ledger")
                                               ("lisp" . "src lisp")
                                               ("tmux" . "src tmux")
                                               ("hs" . "src haskell"))))

;; Install tmux

(use-package ob-tmux)

;; Org Babel

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (lisp . t)
   (emacs-lisp . t)
   (gnuplot . t)
   (haskell . t)
   (latex . t)
   (ledger . t)
   (python . t)
   (sql . nil)
   (sqlite . t)
   (tmux . t)))

;; Evil Org

(use-package evil-org
  :hook (org-mode . evil-org-mode))

;; Org Export SSH

(use-package ox-ssh)

;;; Ledger Mode

(use-package ledger-mode
  :mode ("\\.lgr\\'" . ledger-mode))

;; Evil Ledger Mode

(use-package evil-ledger
  :hook (ledger-mode . evil-ledger-mode))

;;; Custom Set Variable

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(mode-line ((t (:height 0.85))))
 '(mode-line-inactive ((t (:height 0.85))))
 ;; M-x customize-group RET org-faces RET
 ;;'(org-block-begin-line ((t (:background :foreground))))
 '(org-block ((t (:background "#2d3452")))))
 ;;'(org-block-end-line ((t (:background :foreground))))
(custom-set-variables
 '(ledger-reports
   '(("Budget Monthly" "ledger -p \"this year\" --monthly --average -f /home/nick/Documents/Finance/budget.lgr register ^expenses")
     ("bal" "%(binary) -f %(ledger-file) bal")
     ("reg" "%(binary) -f %(ledger-file) reg")
     ("payee" "%(binary) -f %(ledger-file) reg @%(payee)")
     ("account" "%(binary) -f %(ledger-file) reg %(account)"))))
