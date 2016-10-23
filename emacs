; -*- mode: emacs-lisp -*-

;; jun's_emacs_file --- Summary
;; Jun Go gojun077@gmail.com
;; Last Updated 2016-09-22

;;; Commentary:
;;  I have defined a custom function 'gojun-pkglist-installed-p' that
;;  will check if certain Emacs packages are installed.  If not found
;;  Emacs will automatically download them from melpa/marmalade and
;;  install them.  This conf file also includes some tweaks for Korean
;;  language support.

;;; Code:
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'load-path "~/.emacs.d/elpa") ;;personal elisp libs

(require 'cl)
(defvar gojun-pkglist
  '(ansible
    color-theme-sanityinc-solarized
    edit-server
    fill-column-indicator
    flycheck
    markdown-mode
    org-trello
    paredit
    racket-mode
    rw-hunspell
    rw-ispell
    rw-language-and-country-codes
    yaml-mode)
  "List of packages to ensure are installed at launch.")

(defun gojun-pkglist-installed-p ()
  (loop for p in gojun-pkglist
        when (not (package-installed-p p)) do (return nil)
        finally (return t)))

(unless (gojun-pkglist-installed-p)
  ;; check for new packages (package versions)
  (message "%s" "Emacs is now refreshing its package database...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; install the missing packages
  (dolist (p gojun-pkglist)
    (when (not (package-installed-p p))
      (package-install p))))

(provide 'gojun-pkglist)

(require 'flycheck)
(require 'rw-hunspell)
(require 'rw-language-and-country-codes)
(require 'rw-ispell)

;; turn on flychecking globally
(add-hook 'after-init-hook #'global-flycheck-mode)

;; make #! script files executable on save (chmod +x)
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;; mode settings
; show col and line numbers
(column-number-mode 1)
; don't show menu bar
(menu-bar-mode 0)
; don't show scrollbar
(scroll-bar-mode 0)
; highlight parens
(show-paren-mode t)
; don't show toolbar
(tool-bar-mode 0)

;; Font settings
(defun xftp (&optional frame)
  "Return t if FRAME support XFT font backend."
  (let ((xft-supported))
    (mapc (lambda (x) (if (eq x 'xft) (setq xft-supported t)))
          (frame-parameter frame 'font-backend))
    xft-supported))
(when (xftp)
  (let ((fontset "fontset-default"))
    (set-fontset-font fontset 'latin
                      '("monospace" . "unicode-bmp"))
    (set-fontset-font fontset 'hangul
                      '("NanumGothic" . "unicode-bmp"))
    (set-face-attribute 'default nil
                        :font fontset
                        :height 110)))


;;======================
;;   GLOBAL VARIABLES
;;======================

; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
; formatting for C code
(setq c-default-style "linux" c-basic-offset 4)
; shell script mode formatting
(setq sh-basic-offset 2)
(setq sh-indentation 2)
; python settings
(setq python-shell-interpreter "ipython3")
(setq python-shell-interpreter-args "-i")

; C-\ language toggle
(setq default-input-method "korean-hangul")
; Start emacs maximized
(setq initial-frame-alist (quote ((fullscreen . maximized))))
; create backups in $HOME/tmp
; bkup files will have '!' in place of directory separator '/'
(setq backup-directory-alist '(("" . "~/tmp")))
; Enable temp files and autosaving
(setq make-backup-files t)
(setq auto-save-default t)
; dictionary settings
(setq ispell-program-name "hunspell")      ;; specify dictionary binary
(setq ispell-dictionary "en_US_hunspell")  ;; specify dictionary
(setq rw-hunspell-default-dictionary "en_US_hunspell")
(setq rw-hunspell-dicpath-list (quote ("/usr/share/hunspell")))
(setq rw-hunspell-make-dictionary-menu t)
(setq rw-hunspell-use-rw-ispell t)
; Enable C-l, C-u change region to lower/upper case
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
; Enable ido-mode
(ido-mode 1)
; enable ido flex matching
(setq ido-enable-flex-matching t)
; enable ido everywhere
(setq ido-everywhere t)
; use xetex to render pdf from LaTeX
(setq TeX-engine 'xetex)

; org-trello-mode formatting
(setq org-todo-keyword-faces
 (quote
  (("Backlog" . "black")
   ("Queue" . "blue")
   ("WIP" . "red")
   ("Done" . "green")
   ("Cancelled" . "gray"))))
; org-trello-mode keywords
(setq org-todo-keywords
 (quote
  ((sequence "Backlog" "Queue" "WIP" "DONE" "Cancelled"))))
; org-trello-mode keybinding
(setq org-trello-current-prefix-keybinding "C-c o")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("4cf3221feff536e2b3385209e9b9dc4c2e0818a69a1cdb4b522756bcdf4e00a4" default)))
 '(org-trello-current-prefix-keybinding "C-c o")
 '(package-selected-packages
   (quote
    (yaml-mode rw-language-and-country-codes rw-ispell rw-hunspell racket-mode paredit oz org-trello markdown-mode flycheck fill-column-indicator edit-server color-theme-sanityinc-solarized ansible))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; Commands to run when Emacs launched in graphical mode
(when (display-graphic-p)
  ; start edit-server (to enable Emacs editing with Chrome plug-in)
  (require 'edit-server)
  (edit-server-start)
; only run whitespace mode in graphical session
  (global-whitespace-mode 1)
  (load-theme 'sanityinc-solarized-light)
  (load "auctex.el" nil t t)
  (load "preview-latex.el" nil t t)
  ;; AUCTEX preview-latex font
  (set-default 'preview-scale-function 1.2))

;; Commands to run when Emacs launched in terminal mode
(unless (display-graphic-p)
  (load-theme 'adwaita))

(provide 'emacs)
;;; emacs ends here
