(setq doom-theme 'doom-tokyo-night)
(setq display-line-numbers-type t)
(setq doom-font (font-spec :family "JetBrains Mono" :size 20)
      doom-variable-pitch-font (font-spec :family "FiraCode Nerd Font" :size 20)
      doom-big-font (font-spec :family "JetBrains Mono" :size 28))
(after! doom-themes
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t))
(custom-set-faces!
  '(font-lock-comment-face :family "FantasqueSansMono" :slant italic)
  '(font-lock-keyword-face :family "FantasqueSansMono" :slant italic))
(setq display-line-numbers-type 'relative)
(setq doom-modeline-major-mode-icon t)
;; (customize-set-variable 'doom-themes-treemacs-theme "doom-dracula")
(beacon-mode 1)

(setq company-idle-delay 0
      company-tooltip-limit 20
      company-dabbrev-downcase nil
      company-minimum-prefix-length 1
      company-dabbrev-ignore-case nil
      company-selection-wrap-around t
      company-selection-default 0)

(setq org-directory "~/Documents/org/"
      org-ellipsis " ▼ "
      visual-fill-column-center-text t
      )
(after! org
  (set-face-attribute 'org-link nil
                      :family "FantasqueSansMono"
                      :weight 'normal
                      :background nil)
  (set-face-attribute 'org-code nil
                      :family "FiraCode Nerd Font Mono"
                      :foreground "#a9a1e1"
                      :background nil)
  (set-face-attribute 'org-date nil
                      :family "FantasqueSansMono"
                      :foreground "#5B6268"
                      :background nil)
  (set-face-attribute 'org-level-1 nil
                      :family "FiraCode Nerd Font Mono"
                      :foreground "steelblue2"
                      :background nil
                      :height 1.5
                      :weight 'normal)
  (set-face-attribute 'org-level-2 nil
                      :family "FantasqueSansMono"
                      :foreground "slategray2"
                      :background nil
                      :height 1.4
                      :weight 'normal)
  (set-face-attribute 'org-level-3 nil
                      :family "FantasqueSansMono"
                      :foreground "SkyBlue2"
                      :background nil
                      :height 1.3
                      :weight 'normal)
  (set-face-attribute 'org-level-4 nil
                      :family "FantasqueSansMono"
                      :foreground "DodgerBlue2"
                      :background nil
                      :height 1.2
                      :weight 'normal)
  (set-face-attribute 'org-level-5 nil
                      :family "FantasqueSansMono"
                      :height 1.15
                      :weight 'normal)
  (set-face-attribute 'org-level-6 nil
                      :family "FantasqueSansMono"
                      :height 1.1
                      :weight 'normal)
  (set-face-attribute 'org-document-title nil
                      :family "FantasqueSansMono"
                      :foreground "SlateGray1"
                      :background nil
                      :height 1.75
                      :weight 'bold))

(setq read-process-output-max (* 4 1024 1024)
      lsp-idle-delay 0.0
      gc-cons-threshold 100000000)
(setq python-shell-interpreter "python3")
(after! lsp-ui
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-sideline-enable t)
  (setq lsp-ui-sideline-enable t)
  (setq lsp-completion-show-detail t)
  (setq lsp-completion-show-kind t)
                )

;; (require 'dap-python)
;; (global-set-key [f10] 'dap-debug)
;; (global-set-key [f8]  'dap-breakpoint-toggle)
;; (global-set-key [f2]  'dap-step-in)
;; (global-set-key [f3]  'dap-step-out)

(add-hook 'c++-mode-hook 'lsp)
(add-hook 'org-mode-hook 'ispell-minor-mode)
(add-hook 'org-mode-hook 'flyspell-mode)
(add-hook 'org-mode-hook 'org-bullets-mode)
(add-hook 'org-mode-hook '+org/close-all-folds)
(add-hook 'org-mode-hook #'icomplete-mode)
(add-hook 'org-mode-hook 'visual-fill-column-mode)
(add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
;; (add-hook 'python-mode-hook 'py-autopep8-enable-on-save)
;; (add-hook 'js2-mode-hook 'skewer-mode)
;; (add-hook 'css-mode-hook #'lsp)
;; (add-hook 'html-mode-hook 'skewer-html-mode)
;; (add-hook 'web-mode-hook #'lsp)
(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'python-mode-hook 'lsp)

(defun suphal/org-babel-tangle-config ()
  (when (string-equal (file-name-directory (buffer-file-name))
                      (expand-file-name "~/.xmonad/"))
    ;; Dynamic scoping to the rescue
    (let ((org-confirm-babel-evaluate nil))
      (org-babel-tangle))))
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'suphal/org-babel-tangle-config)))

(setq evil-escape-unordered-key-sequence t)
(general-define-key :keymaps 'evil-insert-state-map
                    (general-chord "jk") 'evil-normal-state
                    (general-chord "kj") 'evil-normal-state)
(setq-default evil-escape-key-sequence "ii")
(evil-define-key 'normal dired-mode-map
  (kbd "h") 'dired-up-directory
  (kbd "l") 'dired-find-file)

(with-eval-after-load 'company
  (define-key company-active-map
              (kbd "TAB")
              #'company-complete-selection)
  (define-key company-active-map
              [tab]
              #'company-complete-selection)
  )
(setq vterm-shell 'fish)

(setq user-full-name "Suphal Bhattarai"
      user-mail-address "suphalbhattarai4@gmail.com")
(setq  auto-save-default t
      make-backup-files t
      confirm-kill-emacs nil)
