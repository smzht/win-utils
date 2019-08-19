; -*- coding: utf-8-with-signature-dos -*-

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#InstallKeybdHook
#UseHook
SetWorkingDir %A_ScriptDir%

OnExit, ExitSub

Menu, Tray, NoStandard
Menu, Tray, Add, EmacsClient
Menu, Tray, Add
Menu, Tray, Add, ShowConsole
Menu, Tray, Add, HideConsole
Menu, Tray, Add
Menu, Tray, Add, SendKillEmacs

Menu, Tray, Check, HideConsole

RunWait, wsl bash -l -i -c "cd ~; exec emacs --fg-daemon",, Hide, pid
ExitApp

EmacsClient:
        Run, wslclient.exe,, Hide
        Return

ShowConsole:
        WinShow, ahk_pid %pid%
        WinActivate, ahk_pid %pid%
        Menu, Tray, Check, ShowConsole
        Menu, Tray, UnCheck, HideConsole
        Return

HideConsole:
        WinHide ahk_pid %pid%
        WinActivate, ahk_pid %pid%
        Menu, Tray, UnCheck, ShowConsole
        Menu, Tray, Check, HideConsole
        Return

SendKillEmacs:
        Run, wsl emacsclient -e "(kill-emacs)",, Hide
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
