﻿; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

ArgCount=%0%

IfWinNotExist, emacs ahk_exe vcxsrv.exe
{
        RunWait, wsl emacsclient -c -q -n -d localhost:0.0,, Hide
        If ErrorLevel <> 0
        {
                MsgBox, emacs が起動していません！
                Exit
        }

        WinMaximize, emacs ahk_exe vcxsrv.exe
}

WinActivate, emacs ahk_exe vcxsrv.exe

If ArgCount <> 0
        RunWait, wsl emacsclient -q -n '%1%',, Hide
