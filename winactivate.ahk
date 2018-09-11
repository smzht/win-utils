; -*- coding: utf-8-with-signature-dos -*-

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

filename1 = %1%
filename2 := RegExReplace(filename1, "\.[^.]+$", "")

; http://ahkwiki.net/RegEx
filename1 := RegExReplace(filename1, "[.*?+[{|()^$\\]", "\$0")
filename2 := RegExReplace(filename2, "[.*?+[{|()^$\\]", "\$0")

#WinActivateForce
SetTitleMatchMode, RegEx

IfWinExist, (^| )(%filename1%|%filename2%)( |$)
{
  WinActivate
  Exit, 0
}

Exit, 1
