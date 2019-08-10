; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

ArgCount=%0%

IfWinExist, emacs ahk_exe vcxsrv.exe
{
        WinActivate
        If ArgCount <> 0
                RunWait, wsl emacsclient -q -n '%1%',, Hide
}
Else
{
        If ArgCount <> 0
                Run, wsl emacsclient -c -q -n -d localhost:0.0 '%1%',, Hide
        Else
                Run, wsl emacsclient -c -q -n -d localhost:0.0,, Hide

        WinWait, emacs ahk_exe vcxsrv.exe,, 4
        If ErrorLevel = 0
                WinActivate
        Else
                MsgBox, emacs が起動していません！
}
