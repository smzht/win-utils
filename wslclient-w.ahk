; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

ArgCount=%0%

WinGet, active_id, ID, A

If ArgCount <> 0
{
        IfWinActive, emacs ahk_exe vcxsrv.exe
        {
                RunWait, wsl emacsclient -q -d localhost:0.0 '%1%',, Hide
                If ErrorLevel <> 0
                        MsgBox, emacs が起動していません！
                Else
                        WinActivate, ahk_id %active_id%
        }
        Else
        {
                Run, wsl emacsclient -c -q -d localhost:0.0 '%1%',, Hide, pid

                Loop, 4
                {
                        Sleep, 1000
                        IfWinExist, emacs ahk_exe vcxsrv.exe
                        {
                                WinActivate
                                Process, WaitClose, %pid%
                                WinActivate, ahk_id %active_id%
                                Exit
                        }
                }

                MsgBox, emacs が起動していません！
        }
}
