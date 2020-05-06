;;; shrink-wrap.el --- fight the power and indent yourself -*- lexical-binding: t -*-

;; Author: Danny McClanahan
;; Version: 0.1
;; URL: https://github.com/cosmicexplorer/shrink-wrap
;; Package-Requires: ((emacs "25") (cl-lib "0.5") (dash "2.13.0"))
;; Keywords: indent, indentation, offset, tab, space, view, shrink, minor-mode, visual

;; This file is not part of GNU Emacs.

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:
;; TODO!


;;; License:

;;; GPL 3.0 (or any later version) (./LICENSE)

;; End Commentary


;;; Code:

(require 'cl-lib)
(require 'rx)


;; Customization helpers
(defun shrink-wrap--always-safe-local (_)
  "Use as a :safe predicate in a `defcustom' form to accept any local override."
  t)


;; Customization
(defgroup shrink-wrap nil
  "Group for `shrink-wrap' customizations.")

(defcustom shrink-wrap-desired-indentation " "
  "The indentation specification for the `shrink-wrap-mode' minor mode to emulate!"
  :type 'string
  :group 'shrink-wrap)

(defcustom shrink-wrap-explicit-indentation nil
  "An explicit indentation schema for the current file. Can be set as a dir-local."
  :type 'string
  :safe #'shrink-wrap--always-safe-local
  :group 'shrink-wrap)


;; Buffer-local variables
(defvar-local shrink-wrap--canonical-space-for-file nil
  "The guessed indentation schema of the current file. Can be set explicitly if guessing fails.")


;; Constants
(defconst shrink-wrap--leading-space-regexp
  (rx (+ blank)))

(defconst shrink-wrap--atomic-indent-widths
  `((? . 2)
    (?	. 1))
  "Given a single char, describe how long the expected indent widths are.

For example, a single tab character produces a single indentation. But in general most people using
spaces will move in increments of 2.")


;; Logic
(defun shrink-wrap--get-leading-spaces ()
  (beginning-of-line)
  (looking-at shrink-wrap--leading-space-regexp))

(defun shrink-wrap--calculate-corrected-indentation (leading-spaces)
  (cl-check-type leading-spaces string)
  (cl-assert (> (length leading-spaces) 0))
  (let* ((space-char (aref leading-spaces 0))
         (atomic-width (alist-get space-char shrink-wrap--atomic-indent-widths)))
    (--> (/ (length leading-spaces) atomic-width)
         (+ it (% (length leading-spaces) atomic-width))
         `(space :relative-width ,it))))

(defun shrink-wrap--invisify-buffer ()
  (with-silent-modifications
    (setq shrink-wrap--canonical-space-for-file shrink-wrap-explicit-indentation)
    (goto-char (point-min))
    (cl-loop until (eobp)
             do (progn
                  (when (shrink-wrap--get-leading-spaces)
                    (let ((leading-spaces (match-string 0)))
                      (put-text-property
                       (match-beginning 0) (match-end 0)
                       'display
                       (shrink-wrap--calculate-corrected-indentation leading-spaces))))
                  (forward-line 1)))))

(defun shrink-wrap--strip-display-properties-from-buffer ()
  "Clean up the modifications we've made to the buffer."
  ;; TODO: This should probably try to look up the text we've added in some buffer-local table
  ;; instead of just deleting all the display properties, which may break some major modes.
  (with-silent-modifications
    (put-text-property
     (point-min)
     (point-max)
     'display nil)))


;; Keymaps
(defconst shrink-wrap-map
  (let ((map (make-sparse-keymap)))
    map)
  "Keymap for `shrink-wrap-mode'.")


;; Minor modes
(defun shrink-wrap-mode--turn-on ()
  "Turn on `shrink-wrap-mode'."
  (when (and (derived-mode-p 'prog-mode)
             (not buffer-read-only))
    (shrink-wrap-mode 1)))

;;;###autoload
(define-minor-mode shrink-wrap-mode
  "Modifies the presentation of leading space characters on each line.

Each line should emulate the desired number and type of space characters per indent depth, specified
via `shrink-wrap-desired-indentation'.

All code in a monospace font should still line up 100% cleanly, unless the code is indented with
more than one constant indentation level across the file. The behavior is currently undefined for
files with multiple indentation levels, but we should make a good effort to support it."
  :global t
  :group 'shrink-wrap
  :lighter " >|<"
  :keymap shrink-wrap-map

  (if shrink-wrap-mode
      (shrink-wrap--strip-display-properties-from-buffer)
    (save-excursion (shrink-wrap--invisify-buffer))))

;;;###autoload
(define-globalized-minor-mode global-shrink-wrap-mode shrink-wrap-mode shrink-wrap-mode--turn-on)

;;; shrink-wrap.el ends here
