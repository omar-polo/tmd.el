;;; tmd.el --- The Most Dangerous minor mode.  -*- lexical-binding: t; -*-

;; Copyright (C) 2020 Omar Polo

;; Author: Omar Polo
;; Created: 08 Nov 2020
;; Keywords: useless
;; URL: https://git.omarpolo.com/tmd

;; This file is not part of GNU Emacs.

;;; License:

;; Permission to use, copy, modify, and distribute this software for any
;; purpose with or without fee is hereby granted, provided that the above
;; copyright notice and this permission notice appear in all copies.

;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

;;; Commentary:

;; The most dangerous minor mode will delete all the text in the
;; buffer (respecting narrowing) if you don't insert at least one
;; character every `tmd-timeout'.

;;; Code:

(defvar tmd-timeout "5 seconds"
  "Timeout before deleting the document.")

(defvar tmd--timer nil
  "The timer.")

(defvar tmd--buffer nil
  "The buffer.")

;;;###autoload
(define-minor-mode tmd-minor-mode
  "The Most Dangerous Minor Mode."
  :lighter " tmd"
  (make-local-variable 'tmd--timer)
  (make-local-variable 'tmd--buffer)
  (setq tmd--buffer (current-buffer))
  (add-hook 'post-self-insert-hook 'tmd--timer-reset))

(defun tmd--delete ()
  "Delete the whole buffer if the timer is expired."
  (when tmd--buffer
    (with-current-buffer tmd--buffer
      (delete-region (point-min) (point-max))
      (message "SLOW! MUAHAHAHAHAH"))))

(defun tmd--run-timer ()
  "Start the timer."
  (setq tmd--timer (run-with-timer tmd-timeout nil 'tmd--delete)))

(defun tmd--timer-reset ()
  "Reset the timer."
  (when tmd-minor-mode
    (when tmd--timer
      (cancel-timer tmd--timer))
    (tmd--run-timer)))

(provide 'tmd)
;;; tmd.el ends here
