; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

arg_count = %0%
options := "-q"

If arg_count = 0
{
        IfWinExist, emacs ahk_exe vcxsrv.exe
                WinActivate
        Else
        {
                options .= " -c -n"
                GoSub, Emacsclient
        }
}
Else
{
        option := RegExReplace(A_ScriptName, "[^-]*([^.]*).*", "$1")
        if option <>
                options .= " " . option

        Loop, %arg_count%
        {
                arg := %A_Index%
                arg := RegExReplace(arg, """", "\$0")
                arg := RegExReplace(arg, "\\$", "\$0")
                args .= " """ . arg . """"
        }
        GoSub, Emacsclient
}

Exit

Emacsclient:
        RunWait, emacsclientw.exe %options% %args%,, Hide
        If ErrorLevel <> 0
                MsgBox, Emacs を開くことができません！
