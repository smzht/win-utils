; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

ArgCount=%0%

If ArgCount <> 0
{
        IfWinActive, emacs ahk_exe vcxsrv.exe
        {
                RunWait, wsl emacsclient -q '%1%',, Hide
                If ErrorLevel <> 0
                        MsgBox, emacs が起動していません！
        }
        Else
        {
                WinGet, active_id, ID, A
                Run, wsl emacsclient -c -q -d localhost:0.0 '%1%',, Hide, pid

                Sleep, 1000
                WinWait, emacs ahk_exe vcxsrv.exe,, 3
                If ErrorLevel = 0
                {
                        WinActivate
                        Process, WaitClose, %pid%
                        WinActivate, ahk_id %active_id%
                }
                Else
                        MsgBox, emacs が起動していません！
        }
}
