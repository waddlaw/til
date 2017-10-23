(add-to-list 'load-path "~/.emacs.d/liquid-tip.el/")

(require 'cask "~/.cask/cask.el")
(cask-initialize)
(require 'pallet)
(pallet-mode t)

;; ----------------------- Configure Flycheck ------------------

(require 'flycheck)

;; Global Flycheck
(global-flycheck-mode)

;; Rerun check on idle and save
(setq flycheck-check-syntax-automatically
'(mode-enabled idle-change save))

;; ----------------------- Configure LiquidHaskell -------------

;; Configure flycheck-liquidhs, if you haven't already
(add-hook 'haskell-mode-hook
          '(lambda () (flycheck-select-checker 'haskell-liquid)))

(add-hook 'literate-haskell-mode-hook
          '(lambda () (flycheck-select-checker 'haskell-liquid)))

(require 'liquid-types)

;; Toggle minor mode on entering Haskell mode.
(add-hook 'haskell-mode-hook
          '(lambda () (liquid-types-mode)))
(add-hook 'literate-haskell-mode-hook
	  '(lambda () (liquid-types-mode)))
