; -*- Mode: Emacs-Lisp ; Coding: utf-8 -*-
;; ------------------------------------------------------------------------
;; @ load-path
;; load-pathの追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))
;; load-pathに追加するフォルダ
;; 2つ以上フォルダを指定する場合の引数 => (add-to-load-path "elisp" "xxx" "xxx")
(add-to-load-path "elisp")
;; ------------------------------------------------------------------------
;; @ package
(require 'package)
; Add package-archives
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
; Initialize
(package-initialize)
; melpa.el
(require 'melpa)
;; redo+.el
;; (when (require 'redo+ nil t)
;;   (define-key global-map (kbd "C-_") 'redo)
;;   (define-key global-map (kbd "C-\\") 'undo))
;; http://www.emacswiki.org/emacs/multi-term.el
(require 'undo-tree)
(global-undo-tree-mode t)
(global-set-key (kbd "M-/") 'undo-tree-redo)
;; (when (require 'multi-term nil t)
;;   (setq multi-term-program "/bin/zsh"))
;; 自動補完機能
;; https://github.com/m2ym/auto-complete
(when (require 'auto-complete-config nil t)
  (add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
  (setq ac-ignore-case t)
  (ac-config-default))
;; バッファの検索結果をリストアップ(複数バッファ可)
;; http://www.emacswiki.org/emacs/color-moccur.el
;; http://www.emacswiki.org/emacs/moccur-edit.el
(when (and (require 'color-moccur nil t)
           (require 'moccur-edit nil t))
  ;; AND検索
  (setq moccur-split-word t))
;;grepから検索結果を直接編集
;; https://raw.github.com/mhayashi1120/Emacs-wgrep/master/wgrep.el
(require 'wgrep nil t)
;; 総合インタフェース
;; http://d.hatena.ne.jp/rubikitch/20100718/anything
(require 'anything-startup nil t)
;; JavaScriptのメジャーモード
;; https://raw.github.com/mooz/js2-mode/master/js2-mode.el
(when (autoload 'js2-mode "js2-mode" nil t)
  (add-to-list 'auto-mode-alist '("\\.js$" . js2-mode)))
(setq-default c-basic-offset 2)
;; ------------------------------------------------------------------------
;; @ general
;; common lisp
(require 'cl)
;; hide menu bar
(menu-bar-mode -1)
;; coding system
(set-language-environment "Japanese")
(let ((ws window-system))
  (cond ((eq ws 'w32)
         (prefer-coding-system 'utf-8-unix)
         (set-default-coding-systems 'utf-8-unix)
         (setq file-name-coding-system 'sjis)
         (setq locale-coding-system 'utf-8))
        ((eq ws 'ns)
         (require 'ucs-normalize)
         (prefer-coding-system 'utf-8-hfs)
         (setq file-name-coding-system 'utf-8-hfs)
         (setq locale-coding-system 'utf-8-hfs))))
;; hide startup
(setq inhibit-startup-screen t)
;; show full path on title bar
(setq frame-title-format
      (format "%%f - Emacs@%s" (system-name)))
;; line number
(global-linum-mode t)
(set-face-attribute 'linum nil
                    :foreground "#800"
                    :height 0.9)
;; paren
(show-paren-mode t)
(setq show-paren-delay 0)
(setq show-paren-style 'expression)
;; color of paren area
(set-face-background 'show-paren-match-face "#500")
;; color of selected area
(set-face-background 'region "#077")
;; highlight end of line
(setq-default show-trailing-whitespace t)
(set-face-background 'trailing-whitespace "#b14770")
;; use space as tab
(setq-default indent-tabs-mode nil)
;; tab width
(custom-set-variables '(tab-width 2))
;; yes or no -> y or n
(fset 'yes-or-no-p 'y-or-n-p)
;; recent file
(recentf-mode t)
(setq recentf-max-saved-items 3000)
;; save history of mini buffer
(savehist-mode 1)
(setq history-length 3000)
;; not make backup
(setq make-backup-files nil)
(setq backup-inhibited t)
(setq delete-auto-save-files t)
;; line space
(setq-default line-spacing 0)
;; scroll 1 line by 1 line
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
(setq comint-scroll-show-maximum-output t) ;; shell-mode
;; モードラインに行番号表示
(line-number-mode t)
;; モードラインに列番号表示
(column-number-mode t)
;; C-Ret で矩形選択
(cua-mode t)
(setq cua-enable-cua-keys nil)
;;; 現在行を目立たせる
(global-hl-line-mode)
;;; 行の先頭でC-kを一回押すだけで行全体を消去する
(setq kill-whole-line t)
;;; 最終行に必ず一行挿入する
(setq require-final-newline t)
;;; 補完時に大文字小文字を区別しない
(setq completion-ignore-case t)
(setq read-file-name-completion-ignore-case t)
;;; 補完可能なものを随時表示
(icomplete-mode 1)
;;; diredを便利にする
(require 'dired-x)
;;; diredから"r"でファイル名をインライン編集する
(require 'wdired)
;; (define-key dired-mode-map "r" 'wdired-change-to-wdired-mode)
;;; 現在の関数名をウィンドウ上部に表示する。
;; 2011-03-15
(which-function-mode 1)
;; ruby-mode
(require 'ruby-mode nil 'noerror)
(autoload 'ruby-mode "ruby-mode"
  "Major mode for ruby files" nil t)
(add-to-list 'auto-mode-alist
             '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist
             '("\\.rake$" . ruby-mode))
(add-to-list 'auto-mode-alist
             '("\\.ru$" . ruby-mode))
(add-to-list 'auto-mode-alist
             '("Rakefile" . ruby-mode))
(add-to-list 'auto-mode-alist
             '("Gemfile" . ruby-mode))
(add-to-list 'auto-mode-alist
             '("Capfile" . ruby-mode))
(add-to-list 'interpreter-mode-alist
             '("ruby" . ruby-mode))

(server-start)
;; ------------------------------------------------------------------------
;; @ modeline
;; モードラインの割合表示を総行数表示
(defvar my-lines-page-mode t)
(defvar my-mode-line-format)
(when my-lines-page-mode
  (setq my-mode-line-format "%d")
  (if size-indication-mode
      (setq my-mode-line-format (concat my-mode-line-format " of %%I")))
  (cond ((and (eq line-number-mode t) (eq column-number-mode t))
         (setq my-mode-line-format (concat my-mode-line-format " (%%l,%%c)")))
        ((eq line-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " L%%l")))
        ((eq column-number-mode t)
         (setq my-mode-line-format (concat my-mode-line-format " C%%c"))))

  (setq mode-line-position
        '(:eval (format my-mode-line-format
                        (count-lines (point-max) (point-min))))))
;;; ファイル名が重複していたらディレクトリ名を追加する。
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)
;; ------------------------------------------------------------------------
;; @ key bind
;; バックスラッシュ
(define-key global-map (kbd "M-|") "\\")
;; globalなC-zを無効化
(global-unset-key "\C-z")
;; delete
(define-key global-map (kbd "C-h") 'delete-backward-char) ; 削除
;; 次のウィンドウへ移動
(define-key global-map (kbd "C-M-n") 'next-multiframe-window)
;; 前のウィンドウへ移動
(define-key global-map (kbd "C-M-p") 'previous-multiframe-window)

(setq my-keyjack-mode-map (make-sparse-keymap))
(mapcar (lambda (x)
          (define-key my-keyjack-mode-map (car x) (cdr x))
          (global-set-key (car x) (cdr x)))
        '(
          ("\C-\M-n" . next-multiframe-window)
          ("\C-\M-p" . previous-multiframe-window)
          ([(home)] . beginning-of-buffer)
          ([(end)] . end-of-buffer)
          ([(meta backspace)] . (lambda (arg)
                                  (interactive "p")
                                  (delete-region (point) (progn (forward-word (- arg)) (point)))))
          ))
(easy-mmode-define-minor-mode my-keyjack-mode "Grab keys"
                              t " Keyjack" my-keyjack-mode-map)

(define-key global-map (kbd "C-x b") 'anything)

(set-frame-font "ricty-12")
