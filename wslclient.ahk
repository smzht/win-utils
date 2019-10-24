; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

arg_count = %0%

IfWinExist, emacs ahk_exe vcxsrv.exe
{
        If arg_count = 0
        {
                WinActivate
                Exit
        }
}

options := "-q -n"

Loop, %arg_count%
{
        arg := %A_Index%
        arg := RegExReplace(arg, """", "\$0")
        arg := RegExReplace(arg, "\\$", "\$0")
        args .= " """ . arg . """"
}

RunWait, emacsclientw.exe %options% %args%,, Hide
If ErrorLevel <> 0
        MsgBox, Emacs を開くことができません！
