; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce
SetTitleMatchMode, 2 ; 中間一致

ArgCount=%0%

IfWinExist, emacs ahk_exe vcxsrv.exe
{
        If ArgCount <> 0
                RunWait, wsl emacsclient -q -n '%1%',, Hide
}
Else
{
        If ArgCount = 0
                RunWait, wsl DISPLAY=localhost:0.0 emacsclient -c -q -n,, Hide
        Else
                RunWait, wsl DISPLAY=localhost:0.0 emacsclient -c -q -n '%1%',, Hide

        If ErrorLevel <> 0
        {
                MsgBox, emacs が起動していません！
                Exit
        }

        WinMaximize, emacs ahk_exe vcxsrv.exe
}

WinActivate, emacs ahk_exe vcxsrv.exe
