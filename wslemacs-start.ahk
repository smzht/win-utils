﻿; -*- coding: utf-8-with-signature-dos -*-

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

; for Anniversary Update or Creators Update
; RunWait, bash -l -i -c "emacs --daemon",, Hide

; for Fall Creators Update and later
RunWait, wsl bash -l -i -c "emacs --daemon",, Hide
