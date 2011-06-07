;;; init.el --- Where all the magic begins
;;
;; Part of the Emacs Starter Kit
;;
;; This is the first thing to get loaded.
;;
;; "Emacs outshines all other editing software in approximately the
;; same way that the noonday sun does the stars. It is not just bigger
;; and brighter; it simply makes everything else vanish."
;; -Neal Stephenson, "In the Beginning was the Command Line"

;; Turn off mouse interface early in startup to avoid momentary display
;; You really don't need these; trust me.
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Load path etc.

(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) load-file-name)))

;; Load up ELPA, the package manager

(add-to-list 'load-path dotfiles-dir)

(add-to-list 'load-path (concat dotfiles-dir "/elpa-to-submit"))

(setq autoload-file (concat dotfiles-dir "loaddefs.el"))
(setq package-user-dir (concat dotfiles-dir "elpa"))
(setq custom-file (concat dotfiles-dir "custom.el"))

(require 'package)
(package-initialize)
(require 'starter-kit-elpa)

;; These should be loaded on startup rather than autoloaded on demand
;; since they are likely to be used in every session

(require 'cl)
(require 'saveplace)
(require 'ffap)
(require 'uniquify)
(require 'ansi-color)
(require 'recentf)

;; backport some functionality to Emacs 22 if needed
(require 'dominating-file)

;; Load up starter kit customizations

(require 'starter-kit-defuns)
(require 'starter-kit-bindings)
(require 'starter-kit-misc)
(require 'starter-kit-registers)
(require 'starter-kit-eshell)
(require 'starter-kit-lisp)
(require 'starter-kit-perl)
(require 'starter-kit-ruby)
(require 'starter-kit-js)

(regen-autoloads)
(load custom-file 'noerror)

;; You can keep system- or user-specific customizations here
(setq system-specific-config (concat dotfiles-dir system-name ".el")
      user-specific-config (concat dotfiles-dir user-login-name ".el")
      user-specific-dir (concat dotfiles-dir user-login-name))
(add-to-list 'load-path user-specific-dir)
(add-to-list 'load-path "~/emacsPackages/")
(load-file "~/emacsPackages/cedet-1.0/common/cedet.el")
(load-file "~/emacsPackages/window-numbering.el")
(add-to-list 'load-path "~/emacsPackages/ecb-2.40")
(require 'ecb)

(setq rsense-home "/usr/local/rsense-0.3")
(add-to-list 'load-path (concat rsense-home "/etc"))
(require 'rsense)

(add-to-list 'load-path "/Users/Zangetsu/emacsPackages/")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "/Users/Zangetsu/emacsPackages//ac-dict")
(ac-config-default)
(setq make-backup-files nil)
(setq auto-save-default nil)

;;rvm
(add-to-list 'load-path "~/emacsPackages/rvmel")
(require 'rvm)
(rvm-use-default)

;;; cucumber
;;(load-file "/Users/Zangetsu/emacsPackages/pezra-rspec-mode-ccc1f28/rspec-mode.el")
(add-to-list 'load-path "~/emacsPackages/feature-mode")
(require 'feature-mode)
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

;;duplicate line
(global-set-key "\C-x\C-a" "\C-a\C- \C-n\M-w\C-y")

;;aspell
(setq-default ispell-program-name "aspell")

(if (file-exists-p system-specific-config) (load system-specific-config))
(if (file-exists-p user-specific-config) (load user-specific-config))
(if (file-exists-p user-specific-dir)
    (mapc #'load (directory-files user-specific-dir nil ".*el$")))

;; python-mode
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
                                   interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)


;;pymacs
(setenv "PYMACS_PYTHON" "python2.6") 
(autoload 'pymacs-apply "pymacs")
(autoload 'pymacs-call "pymacs")
(autoload 'pymacs-eval "pymacs" nil t)
(autoload 'pymacs-exec "pymacs" nil t)
(autoload 'pymacs-load "pymacs" nil t)
;;(eval-after-load "pymacs"
;;  '(add-to-list 'pymacs-load-path YOUR-PYMACS-DIRECTORY"))

;;ropemacs
(pymacs-load "ropemacs" "rope-")
(setq ropemacs-enable-autoimport t)
(require 'auto-complete)
(global-auto-complete-mode t)


;;pep 8
(add-hook 'before-save-hook, 'delete-trailing-whitespace)

;;pep 8 for flymake
(when(load "flymake" t)
(defun flymake-pyflakes-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
             'flymake-create-temp-inplace))
     (local-file (file-relative-name
          temp-file
          (file-name-directory buffer-file-name))))
    (list "pycheckers"  (list local-file))))
 (add-to-list 'flymake-allowed-file-name-masks
              '("\\.py\\'" flymake-pyflakes-init)))


;;templates
(add-to-list 'load-path "~/emacsPackages/template/lisp")
(require 'template)
(template-initialize)

(require 'autoinsert)
(auto-insert-mode)  ;;; Adds hook to find-files-hook
(setq auto-insert-directory "~/emacspackages/template/templates/")
;;; Or use custom, *NOTE* Trailing slash important
(setq auto-insert-query nil) ;;; If you don't want to be prompted before insertion
(define-auto-insert "\.py" "naas_template.tpl")

(defun flymake-display-next-error ()
  (interactive)
  (flymake-goto-next-error)
  (flymake-display-err-menu-for-current-line))

(global-set-key (kbd "C-x /") 'flymake-display-next-error)


;;(setq minor-mode-alist (cons '("\\.py$" . flymake-mode) minor-mode-alist))

;;; init.el ends here
(put 'upcase-region 'disabled nil)
