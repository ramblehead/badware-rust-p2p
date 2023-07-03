;; -*- coding: utf-8 -*-

(require 'lsp-mode)
(require 'lsp-rust)
(require 'flycheck)

;;; rust-p2p-badware/graphql-server
;;; /b/{

(defvar rust-p2p-badware/graphql-server-build-buffer-name
  "*rust-p2p-badware/graphql-server-build*")

(defun rust-p2p-badware/graphql-server-lint ()
  (interactive)
  (rh-project-compile
   "yarn-run lint graphql-server"
   rust-p2p-badware/graphql-server-build-buffer-name))

(defun rust-p2p-badware/graphql-server-build ()
  (interactive)
  (rh-project-compile
   "yarn-run build graphql-server"
   rust-p2p-badware/graphql-server-build-buffer-name))

(defun rust-p2p-badware/graphql-server-clean ()
  (interactive)
  (rh-project-compile
   "yarn-run clean graphql-server"
   rust-p2p-badware/graphql-server-build-buffer-name))

(defun rust-p2p-badware/graphql-server-clean ()
  (interactive)
  (rh-project-compile
   "yarn-run clean graphql-server"
   rust-p2p-badware/graphql-server-build-buffer-name))

(defvar rust-p2p-badware/graphql-server-buffer-name
  "*rust-p2p-badware/graphql-server*")

(defun rust-p2p-badware/graphql-server-hydra-define ()
  (defhydra rust-p2p-badware/graphql-server-hydra (:color blue :columns 4)
    "@rust-p2p-badware/graphql-server project commands"
    ("u" rust-p2p-badware-hydra/body "@rust-p2p-badware/")
    ("l" rust-p2p-badware/graphql-server-lint "lint")
    ("b" rust-p2p-badware/graphql-server-build "build")
    ("c" rust-p2p-badware/graphql-server-clean "clean")))

(rust-p2p-badware/graphql-server-hydra-define)

;;; /b/}

;;; rust-p2p-badware common command
;;; /b/{

(defvar rust-p2p-badware/build-buffer-name
  "*rust-p2p-badware-build*")

(defun rust-p2p-badware/auto-code ()
  (interactive)
  (rh-project-compile
   "auto-code-groups"
   rust-p2p-badware/build-buffer-name))

(defun rust-p2p-badware/lint ()
  (interactive)
  (rh-project-compile
   "yarn-run app:lint"
   rust-p2p-badware/build-buffer-name))

(defun rust-p2p-badware/build ()
  (interactive)
  (rh-project-compile
   "yarn-run app:build"
   rust-p2p-badware/build-buffer-name))

(defun rust-p2p-badware/clean ()
  (interactive)
  (rh-project-compile
   "yarn-run app:clean"
   rust-p2p-badware/build-buffer-name))

(defun rust-p2p-badware/remote-yarn-install ()
  (interactive)
  (rh-project-compile
   "remote-yarn-install"
   rust-p2p-badware/build-buffer-name))

(defun rust-p2p-badware/remote-sync ()
  (interactive)
  (rh-project-compile
   "remote-sync"
   rust-p2p-badware/build-buffer-name))

(defun rust-p2p-badware/remote-redis-flushall ()
  (interactive)
  (rh-project-compile
   "remote-redis-flushall"
   rust-p2p-badware/build-buffer-name))

;;; /b/}

;;; rust-p2p-badware
;;; /b/{

(defcustom rust-p2p-badware/js-back-end 'lsp-mode
  "Recognised input languages."
  :group 'js-interaction
  :type '(choice (const
                  :tag "lsp-mode"
                  'lsp-mode)
                 (const
                  :tag "tide-mode"
                  'tide-mode)))

(cond
 ((eq rust-p2p-badware/js-back-end 'lsp-mode)
  (require 'lsp-javascript))
 ((eq rust-p2p-badware/js-back-end 'tide-mode)
  (require 'tide-mode)))

(defun rust-p2p-badware/hydra-define ()
  (defhydra rust-p2p-badware-hydra (:color blue :columns 5)
    "@rust-p2p-badware workspace commands"
    ("a" rust-p2p-badware/auto-code "auto-code")
    ("l" rust-p2p-badware/lint "lint")
    ("b" rust-p2p-badware/build "build")
    ("c" rust-p2p-badware/clean "clean")
    ("y" rust-p2p-badware/remote-sync "remote-sync")
    ("Y" rust-p2p-badware/remote-yarn-install "remote-yarn-install")
    ("r" rust-p2p-badware/remote-redis-flushall "remote-redis-flushall")
    ("h" rust-p2p-badware/resolve-s50-host-mDNS "resolve-s50-host-mDNS")
    ("s" rust-p2p-badware/graphql-server-hydra/body "graphql-server/")
    ("g" rust-p2p-badware/wui-hydra/body "wui/")))

(rust-p2p-badware/hydra-define)

(define-minor-mode rust-p2p-badware-mode
  "rust-p2p-badware project-specific minor mode."
  :lighter " rust-p2p-badware"
  :keymap (let ((map (make-sparse-keymap)))
            (define-key map (kbd "<f9>") #'rust-p2p-badware-hydra/body)
            map))

(add-to-list 'rm-blacklist " rust-p2p-badware")

(defun rust-p2p-badware/setup-tide ()
  (let ((project-root (expand-file-name (rh-project-get-root))))
    (setq-local tide-tsserver-executable
                (concat project-root
                        "node_modules/.bin/tsserver"))
    (setq-local tide-tscompiler-executable
                (concat project-root
                        "node_modules/.bin/tsc"))
    (setq-local flycheck-javascript-eslint-executable
                (concat project-root
                        "node_modules/.bin/eslint"))
    (tide-setup)
    (prettier-mode 1)
    (tide-hl-identifier-mode 1)))

(defun rust-p2p-badware/lsp-deps-providers-path (path)
  (concat (expand-file-name (rh-project-get-root))
          "node_modules/.bin/"
          path))

(defun rust-p2p-badware/lsp-javascript-setup ()
  ;; (setq-local lsp-deps-providers (copy-tree lsp-deps-providers))

  (plist-put
   lsp-deps-providers
   :local (list :path #'rust-p2p-badware/lsp-deps-providers-path))

  (lsp-dependency 'typescript-language-server
                  '(:local "typescript-language-server"))

  (lsp--require-packages)

  (lsp-dependency 'typescript '(:local "tsserver"))

  (add-hook
   'lsp-after-initialize-hook
   #'rust-p2p-badware/flycheck-add-eslint-next-to-lsp))

(defun rust-p2p-badware/flycheck-add-eslint-next-to-lsp ()
  (when (seq-contains-p '(js2-mode typescript-mode web-mode) major-mode)
    (flycheck-add-next-checker 'lsp 'javascript-eslint)))

(defun rust-p2p-badware/flycheck-after-syntax-check-hook-once ()
  (remove-hook
   'flycheck-after-syntax-check-hook
   #'rust-p2p-badware/flycheck-after-syntax-check-hook-once
   t)
  (flycheck-buffer))

(eval-after-load 'lsp-javascript #'rust-p2p-badware/lsp-javascript-setup)

(defun rust-p2p-badware-setup ()
  (when buffer-file-name
    (let ((project-root (expand-file-name (rh-project-get-root)))
          file-rpath ext-js)
      (when project-root
        (setq file-rpath (expand-file-name buffer-file-name project-root))
        (cond
         ((setq ext-js (string-match-p "\\.rs\\'" file-rpath))

          ;;; /b/; rust-format
          ;;; /b/{

          (setq-local rust-format-on-save t)

          ;;; /b/}

          (setq-local lsp-enabled-clients '(rust-analyzer))
          (setq-local lsp-before-save-edits nil)
          (setq-local lsp-modeline-diagnostics-enable nil)

          (run-with-idle-timer 0 nil #'lsp)))))))

;;; /b/}
