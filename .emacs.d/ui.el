;; -*- lexical-binding: t; -*-
;;(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;'(custom-safe-themes
;;   '("34985c0179ff3898b65dd2c8e6c3e9b8aed458336be298f65e355c83574bbac1"
 ;;    default))
 ;;'(package-selected-packages
;;   '(company corfu ebdb exec-path-from-shell flycheck gtags-mode popon
;;	     rust-mode slime)))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;;)

;; 行番号表示
;;(global-display-line-numbers-mode 1)  ;; グローバル
(add-hook 'prog-mode-hook 'display-line-numbers-mode)  ;; プログラミングモードのみ

;; 絶対行番号（デフォルト）
;;(setq display-line-numbers-type t)

;; 相対行番号
(setq display-line-numbers-type 'relative)
