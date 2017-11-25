; -*- coding: utf-8-with-signature-dos -*-

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce
SetTitleMatchMode, 2 ; 中間一致
WinActivate, emacs ahk_exe vcxsrv.exe

; RunWait, wsl emacsclient '%1%',, Hide
RunWait, wsl emacsclient -q -n '%1%',, Hide
