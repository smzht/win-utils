; -*- coding: utf-8-with-signature-dos -*-

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#Persistent
OnExit, WatchExit

RunWait, wsl bash -l -i -c "cd ~; emacs --fg-daemon",, Hide
ExitApp, 1

WatchExit:
        Run, wsl emacsclient -e "(kill-emacs)",, Hide
        ExitApp, 0
