; -*- coding: utf-8-with-signature-dos -*-

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

; for Anniversary Update or Creators Update
; RunWait, bash -c "emacsclient -e '(kill-emacs)'",, Hide

; for Fall Creators Update and later
RunWait, wsl emacsclient -e "(kill-emacs)",, Hide
