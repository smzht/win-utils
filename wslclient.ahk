; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

arg_count = %0%
options := "-q"

GroupAdd, emacs, emacs ahk_exe vcxsrv.exe
GroupAdd, emacs, emacs ahk_exe XWin_MobaX.exe
GroupAdd, emacs, emacs ahk_exe Xpra-Launcher.exe

If (arg_count = 0)
{
        IfWinExist, ahk_group emacs
                WinActivate
        Else
        {
                options .= " -c -n"
                GoSub, Emacsclient
        }
}
Else
{
        ; サフィックスを除くファイル名のハイフン以降をオプションとして取り込む
        option := RegExReplace(A_ScriptName, "[^-]*([^.]*).*", "$1")
        If (option <> "")
                options .= " " . option

        Loop, %arg_count%
        {
                arg := %A_Index%
                ; ダブルコーテーションの前もしくは引数最後の￥サインの並びを全て二重化する
                arg := RegExReplace(arg, "(\\+)(""|$)", "$1$0")
                ; ダブルコーテーションをエスケープする
                arg := RegExReplace(arg, """", "\$0")
                ; 引数をダブルコーテーションで括って連結する
                args .= " """ . arg . """"
        }
        GoSub, Emacsclient
}

Exit

Emacsclient:
        RunWait, emacsclientw.exe %options% %args%,, Hide
        If (ErrorLevel <> 0)
                MsgBox, Emacs を開くことができません！
