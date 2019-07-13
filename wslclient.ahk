; -*- coding: utf-8-with-signature-dos -*-

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce
SetTitleMatchMode, 2 ; 中間一致

IfWinExist, emacs ahk_exe vcxsrv.exe
{
        WinActivate

        ; for Anniversary Update or Creators Update
        ; RunWait, bash -c "emacsclient -q -n '%1%'",, Hide

        ; for Fall Creators Update and later
        RunWait, wsl emacsclient -q -n '%1%',, Hide
}
Else
{
        ; for Anniversary Update or Creators Update
        ; RunWait, bash -c "DISPLAY=localhost:0.0 emacsclient -c -q -n '%1%'",, Hide

        ; for Fall Creators Update and later
        RunWait, wsl DISPLAY=localhost:0.0 emacsclient -c -q -n '%1%',, Hide
}
