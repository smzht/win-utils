; -*- coding: utf-8-with-signature-dos -*-

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#InstallKeybdHook
#UseHook
SetWorkingDir %A_ScriptDir%

OnExit, ExitSub

Menu, Tray, NoStandard
Menu, Tray, Add, Open Emacs, OpenEmacs
Menu, Tray, Add
Menu, Tray, Add, Show Console, ShowConsole
Menu, Tray, Add, Hide Console, HideConsole
Menu, Tray, Add
Menu, Tray, Add, Kill Emacs, KillEmacs

Menu, Tray, Check, Hide Console

RunWait, wsl bash -l -i -c "cd ~; exec emacs --fg-daemon",, Hide, pid
ExitApp

OpenEmacs:
        Run, wslclient.exe,, Hide
        Return

ShowConsole:
        WinShow, ahk_pid %pid%
        WinActivate, ahk_pid %pid%
        Menu, Tray, Check, Show Console
        Menu, Tray, UnCheck, Hide Console
        Return

HideConsole:
        WinHide ahk_pid %pid%
        WinActivate, ahk_pid %pid%
        Menu, Tray, UnCheck, Show Console
        Menu, Tray, Check, Hide Console
        Return

KillEmacs:
        RunWait, wsl emacsclient -e "(kill-emacs)",, Hide
        If ErrorLevel <> 0
                MsgBox, Emacs が起動していません！
        Return

ExitSub:
        If A_ExitReason <> Exit
                Run, wsl emacsclient -e "(kill-emacs)",, Hide
        Else
                ExitApp

!e::
        IfWinActive, emacs ahk_exe vcxsrv.exe
                Send, %A_ThisHotkey%
        Else
                Run, wslclient.exe,, Hide
        Return
