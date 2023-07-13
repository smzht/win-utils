; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

DetectHiddenWindows, On

filename1 = %1%
filename2 := RegExReplace(filename1, "(.)\.[^.]+$", "$1")

; http://ahkwiki.net/RegEx
filename1 := RegExReplace(filename1, "[.*?+[{|()^$\\]", "\$0")
filename2 := RegExReplace(filename2, "[.*?+[{|()^$\\]", "\$0")

#WinActivateForce
SetTitleMatchMode, RegEx

WinGet, ids, list, (^| - )(%filename1%|%filename2%)( .*- |$)
Loop, %ids%
{
        this_id := ids%A_Index%

        result := DllCall("IsWindowVisible", "Ptr", this_id)
        if (result = 1)
        {
                IfWinNotActive, ahk_id %this_id%
                        WinActivate, ahk_id %this_id%
                Exit, 0
        }
}

Exit, 1
