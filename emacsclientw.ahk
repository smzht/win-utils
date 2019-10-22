﻿; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

arg_count = %0%

; 外部からオプション -c を指定される可能性があるため、オプション -d も
; デフォルトの設定に追加している
options := "-q -d localhost:0.0"

wait_flg = 1
create_flg = 0
exit_code = 0

Loop, %arg_count%
{
        arg := %A_Index%
        args := args . " '" . arg . "'"

        If arg = -n
                wait_flg = 0
        Else If arg = -c
                create_flg = 1
}

IfWinActive, emacs ahk_exe vcxsrv.exe
        GoSub, Emacsclient
Else
{
        IfWinNotExist, emacs ahk_exe vcxsrv.exe
                options .= " -c"

        If wait_flg = 0
        {
                GoSub, Emacsclient
                WinActivate, emacs ahk_exe vcxsrv.exe
        }
        Else
        {
                WinGet, active_id, ID, A

                period = -100
                If create_flg = 1
                {
                        IfWinExist, emacs ahk_exe vcxsrv.exe
                                period = -1000
                }

                SetTimer, WinActivate, %period%
                GoSub, Emacsclient
                WinActivate, ahk_id %active_id%
        }
}

Exit, exit_code

Emacsclient:
        RunWait, wsl emacsclient %options% %args%,, Hide
        If ErrorLevel <> 0
                exit_code = ErrorLevel
        Return

WinActivate:
        WinWait, emacs ahk_exe vcxsrv.exe,, 5
        If ErrorLevel = 0
                WinActivate
        Return
