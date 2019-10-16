; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

argCount = %0%

; 外部からオプション -c を指定される可能性があるため、オプション -d も
; デフォルトの設定としている
options := "-q -n -d localhost:0.0"

IfWinExist, emacs ahk_exe vcxsrv.exe
{
        WinActivate
        if argCount = 0
                Exit
}
Else
        options .= " -c"

Loop, %argCount%
{
        arg := %A_Index%
        args := args . "'" . arg . "' "
}

RunWait, wsl emacsclient %options% %args%,, Hide
If ErrorLevel = 0
        WinActivate, emacs ahk_exe vcxsrv.exe
Else
        MsgBox, Emacs を開くことができません！
