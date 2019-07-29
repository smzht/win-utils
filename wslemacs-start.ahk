; -*- coding: utf-8-with-signature-dos -*-

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#InstallKeybdHook
#UseHook
SetWorkingDir %A_ScriptDir%

OnExit, ExitSub

RunWait, wsl bash -l -i -c "cd ~; exec emacs --fg-daemon",, Hide
ExitApp

ExitSub:
        If A_ExitReason <> Exit
                Run, wsl emacsclient -e "(kill-emacs)",, Hide
        ExitApp

!e::
        IfWinActive, emacs ahk_exe vcxsrv.exe
                Send, %A_ThisHotkey%
        Else
                Run, wslclient.exe,, Hide
        Return
