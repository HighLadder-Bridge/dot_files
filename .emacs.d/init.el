;;; -*- lexical-binding: t -*-

;; setting langauge environment
(set-language-environment 'English)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

;; Custom emacs ui
(load "~/.emacs.d/ui.el")

;;;; --- パッケージマネージャーの設定 ---

(use-package package
  :ensure nil
  :config
  (setq package-archives
        '(("melpa" . "https://melpa.org/packages/")
          ("melpa-stable" . "https://stable.melpa.org/packages/")
          ("gnu" . "https://elpa.gnu.org/packages/")
          ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

  (setq package-archive-priorities
        '(("gnu" . 1)
          ("nongnu" . 0)
          ("melpa-stable" . 3)
          ("melpa" . 2)))

  (setq use-package-always-ensure t
        use-package-expand-minimally t
        use-package-always-defer t))

;; 必要なパッケージがなければ自動インストール
(unless (package-installed-p 'use-package)
    (package-refresh-contents)
      (package-install 'use-package)
(eval-when-compile (require 'use-package)))

(use-package emacs
  :custom
  (context-menu-mode t)
  (enable-recursive-minibuffers t)
  (read-extended-command-predicate #'command-completion-default-include-p)
  (minibuffer-prompt-properties
   '(read-only t cursol-intangible t face minibuffer-prompt)))

(use-package which-key
  :ensure nil
  :demand t
  :config
  (which-key-mode)
  (which-key-setup-side-window-right))  

;; See https://github.com/minad/marginalia
(use-package marginalia
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

;; See https://github.com/minad/vertico
(use-package vertico
  :custom
  ;; (vertico-scroll-margin 0) ;; Different scroll margin
  ;; (vertico-count 20) ;; Show more candidates
  ;; (vertico-resize t) ;; Grow and shrink the Vertico minibuffer
  ((vertico-cycle t)) ;; Enable cycling for `vertico-next/previous'
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion))))
  (completion-category-defaults nil) ;; Disable defaults, use our settings
  (completion-pcm-leading-wildcard t)) ;; Emacs 31: partial-completion behaves like substring

;; Option 1: Additional bindings
;;(keymap-set vertico-map "M-?" #'minibuffer-completion-help)
;;(keymap-set vertico-map "M-RET" #'minibuffer-force-complete-and-exit)
;;(keymap-set vertico-map "M-TAB" #'minibuffer-complete)

;; Option 2: Replace `vertico-insert' to enable TAB prefix expansion.
;; (keymap-set vertico-map "TAB" #'minibuffer-complete)

;;--------------------------------------------------------------------
;; テキスト中のURLをクリックまたはキー操作で開けるようにする
(progn
(add-hook 'prog-mode-hook 'goto-address-prog-mode)
(add-hook 'text-mode-hook 'goto-address-mode))

;; makeing backup file y/n. and Autosaving y/n
(setq make-backup-files nil)
(setq auto-save-default nil)

;; answer yes/no --> y/n
(setopt use-short-answers t)

;; Source from >> https://zenn.dev/mirablue/books/20260501-emacs30-sre/viewer/02-basics
;;(menu-bar-mode 0)
;;(column-number-mode t)
;;(line-number-mode t)
;;(global-display-line-numbers-mode 1)
(show-paren-mode 1)
(electric-indent-mode -1)
;;(set-face-background 'trailing-whitespace "red")
;;:hook
;;((prog-mode . (lambda () (setq show-trailing-whitespace t)))
 ;;(text-mode . (lambda () (setq show-trailing-whitespace t))))

(setq display-line-numbers-width 4)
(setq-default display-line-numbers-width 4)

;; TAB mode (SOURCE From:https://ayatakesi.github.io/emacs/27.1/html/Tab-Bars.html)
(use-package tab-bar
  :ensure nil
  :init
  (tab-bar-mode)
  (tab-bar-history-mode))

;; SKK
(require 'skk)
(add-to-list 'load-path "~/.emacs.d/ddskk")
 (setq skk-large-jisyo "~/.skk/SKK-JISYO.L")
 (global-set-key (kbd "C-x j") 'skk-mode)
(with-eval-after-load 'skk
  (define-key global-map (kbd "C-x C-j") 'skk-mode))

;; aspell
(setq-default ispell-program-name "aspell")
(with-eval-after-load "ispell"
(setq ispell-local-dictionary "en_US")
(add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))

;; corfu
(use-package corfu
  :bind ( :map corfu-map
          ("RET" . nil)
          ("<return>" . nil)
          ("SPC" . corfu-insert-or-escape-separator))
  :init
  (setopt corfu-cycle t
          corfu-auto t
          corfu-auto-prefix 1
          corfu-auto-delay 0.0
          corfu-preselect 'directory
          corfu-quit-no-match t
          corfu-on-exact-match 'show)

  (defun corfu-insert-or-escape-separator ()

    (interactive)
    (if (char-equal (char-before) corfu-separator)
        (if (char-equal (char-before (1- (point))) ?\\)

            (save-excursion (delete-char -2))                   ;; Case 3
          (save-excursion (backward-char 1) (insert-char ?\\))) ;; Case 2
      (call-interactively #'corfu-insert-separator)))           ;; Case 1

  (global-corfu-mode))

;;
(use-package corfu-popupinfo
  :ensure nil
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode))

;; パッケージ管理から rustic をインストールする設定例
(use-package rustic
  :ensure t
  :bind (:map rustic-mode-map
              ("M-j" . lsp-ui-imenu)
              ("M-?" . lsp-find-references)
              ("C-c C-c l" . flycheck-list-errors)
              ("C-c C-c a" . lsp-execute-code-action))
  :config

;;保存時に自動フォーマット（rustfmt）を有効にする場合
(setq rustic-format-on-save t)
;;
;; elgotの有効化
(add-hook 'rust-mode-hook 'elgot-ensure))

;;
;; Eglot の基本設定
(use-package eglot
  :hook (python-mode . eglot-ensure)
  :config
  ;; 必要に応じてサーバーを変更する場合（例: pylsp を使う場合）
  (add-to-list 'eglot-server-programs
               '(python-mode . ("pylsp"))))

;; Rainbow-delimiters — 括弧の色分け
(require 'color)
(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)
         (emacs-startup . rainbow-delimiters-using-stronger-colors))
  :config
  (defun rainbow-delimiters-using-stronger-colors ()
    (interactive)
    (cl-loop
     for index from 1 to rainbow-delimiters-max-face-count
     do
     (let ((face (intern (format "rainbow-delimiters-depth-%d-face" index))))
;;
;;
       (cl-callf color-saturate-name (face-foreground face) 30)))))

(when (memq window-system '(mac ns x pgtk))
  (exec-path-from-shell-initialize))

;; Eglot を Cモードで自動起動する場合
(add-hook 'c-mode-hook 'eglot-ensure)

 '(package-selected-packages
   '(company corfu ddskk-posframe ebdb exec-path-from-shell flycheck
	     gtags-mode marginalia popon rust-mode
	     slime vertico))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(corfu ddskk-posframe exec-path-from-shell gtags-mode inheritenv
	   kanagawa-themes magit-gh marginalia orderless posframe
	   slime vertico)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; パッケージマネージャーがインストールした kanagawa-wave をロードする
(load-theme 'kanagawa-wave t)
(setq custom-enabled-themes '(kanagawa-wave))
