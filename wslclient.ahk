; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

argCount = %0%

IfWinExist, emacs ahk_exe vcxsrv.exe
{
        If argCount = 0
        {
                WinActivate
                Exit
        }
}

; wait しない
options := "-n"

Loop, %argCount%
{
        arg := %A_Index%
        args := args . " '" . arg . "'"
}

; 引数のエスケープ処理をうまく対処するために、wsl.exe 経由で exe コマンドを実行している
RunWait, wsl "$(wslpath -u '%A_ScriptDir%')"/emacsclientw.exe %options% %args%,, Hide
