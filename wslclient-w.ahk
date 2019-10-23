; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

arg_count = %0%

If arg_count > 0
{
        options := "-q -c"

        Loop, %arg_count%
        {
                arg := %A_Index%
                args := args . " '" . arg . "'"
        }

        ; 引数のエスケープ処理をうまく対処するために、wsl.exe 経由で exe コマンドを実行している
        RunWait, wsl "$(wslpath -u '%A_ScriptDir%')"/emacsclientw.exe %options% %args%,, Hide
        If ErrorLevel <> 0
                MsgBox, Emacs を開くことができません！
}
