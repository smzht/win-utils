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
        If option <>
                options .= " " . option

        Loop, %arg_count%
        {
                arg := %A_Index%
                arg := RegExReplace(arg, "'", "'\''")
                args := args . " '" . arg . "'"
        }
        GoSub, Emacsclient
}

Exit

Emacsclient:
        ; 引数のエスケープ処理をうまく対処するために、wsl.exe 経由で exe コマンドを実行している
        RunWait, wsl "$(wslpath -u '%A_ScriptDir%')"/emacsclientw.exe %options% %args%,, Hide
        If ErrorLevel <> 0
                MsgBox, Emacs を開くことができません！
