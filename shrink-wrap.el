;;; shrink-wrap.el --- fight the power and indent yourself -*- lexical-binding: t -*-

;; Author: Danny McClanahan
;; Version: 0.1
;; URL: https://github.com/cosmicexplorer/shrink-wrap
;; Package-Requires: ()
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


;; Customization
(defgroup shrink-wrap nil
  "Group for `shrink-wrap' customizations.")

(defcustom shrink-wrap-desired-indentation "  "
  "The indentation specification for the `shrink-wrap-mode' minor mode to emulate!"
  :type 'string
  :group 'shrink-wrap)


;; Logic
()


;; Keymaps
(defconst shrink-wrap-map
  (let ((map (make-sparse-keymap)))
    map)
  "Keymap for `shrink-wrap-mode'.")


;; Minor modes
(defun shrink-wrap-mode--turn-on ()
  "Turn on `shrink-wrap-mode'."
  (shrink-wrap-mode 1))

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
  :keymap shrink-wrap-map)

;;;###autoload
(define-globalized-minor-mode global-shrink-wrap-mode shrink-wrap-mode shrink-wrap-mode--turn-on)

;;; shrink-wrap.el ends here
