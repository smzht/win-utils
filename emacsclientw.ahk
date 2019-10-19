; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

argCount = %0%

; 外部からオプション -c を指定される可能性があるため、オプション -d も
; デフォルトの設定に追加している
options := "-q -d localhost:0.0"

wait_flg = 1
create_flg = 0

Loop, %argCount%
{
        arg := %A_Index%
        args := args . " '" . arg . "'"

        If arg = -n
                wait_flg = 0
        Else If arg = -c
                create_flg = 1
}

IfWinActive, emacs ahk_exe vcxsrv.exe
{
        RunWait, wsl emacsclient %options% %args%,, Hide
        If ErrorLevel <> 0
        {
                MsgBox, Emacs を開くことができません！
                Exit
        }
}
Else
{
        IfWinNotExist, emacs ahk_exe vcxsrv.exe
                options .= " -c"

        If wait_flg = 0
        {
                RunWait, wsl emacsclient %options% %args%,, Hide
                If ErrorLevel <> 0
                {
                        MsgBox, Emacs を開くことができません！
                        Exit
                }

                WinActivate, emacs ahk_exe vcxsrv.exe
        }
        Else
        {
                WinGet, active_id, ID, A

                IfWinExist, emacs ahk_exe vcxsrv.exe
                {
                        If create_flg = 0
                        {
                                WinActivate, emacs ahk_exe vcxsrv.exe
                                RunWait, wsl emacsclient %options% %args%,, Hide
                                If ErrorLevel <> 0
                                {
                                        MsgBox, Emacs を開くことができません！
                                        Exit
                                }
                        }
                        Else
                        {
                                Run, wsl emacsclient %options% %args%,, Hide, pid
                                Sleep, 1000
                                WinActivate, emacs ahk_exe vcxsrv.exe
                                Process, WaitClose, %pid%
                        }
                }
                Else
                {
                        Run, wsl emacsclient %options% %args%,, Hide, pid
                        WinWait, emacs ahk_exe vcxsrv.exe,, 3
                        If ErrorLevel <> 0
                        {
                                MsgBox, Emacs を開くことができません！
                                Exit
                        }
                        WinActivate
                        Process, WaitClose, %pid%
                }

                WinActivate, ahk_id %active_id%
        }
}
