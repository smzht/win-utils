; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

arg_count = %0%

RunWait, wsl bash -c "wsl.exe -l -v 2> /dev/null | tr -d '\0' | tr -d '\r' | grep '^*' | grep -q '2$'",, Hide
If (ErrorLevel = 0)
        options := "-d $(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}'):0.0"
Else
        options := "-d localhost:0.0"

tty_flg = 0
nowait_flg = 0
create_flg = 0

Loop, %arg_count%
{
        arg := %A_Index%

        If RegExMatch(arg, "^--")
        {
                If (arg = "--tty")
                        tty_flg = 1
                Else If (arg = "--no-wait")
                        nowait_flg = 1
                Else If (arg = "--create-frame")
                        create_flg = 1
        }
        Else If RegExMatch(arg, "^-")
        {
                If (arg = "-nw")
                        tty_flg = 1
                Else
                {
                        If RegExMatch(arg, "t")
                                tty_flg = 1
                        If RegExMatch(arg, "n")
                                nowait_flg = 1
                        If RegExMatch(arg, "c")
                                create_flg = 1
                }
        }

        ; シングルコーテーションをエスケープする
        arg := RegExReplace(arg, "'", "'\''")
        ; 引数をシングルコーテーションで括って連結する
        args .= " '" . arg . "'"
}

If (tty_flg = 1 && nowait_flg = 0)
        GoSub, Emacsclient
Else
{
        IfWinActive, emacs ahk_exe vcxsrv.exe
                GoSub, Emacsclient
        Else
        {
                If (create_flg = 0)
                {
                        ; Emacs のフレームが開いていなければ、create-frame のオプションを追加する
                        ; （この設定は、素の emacsclient とは異なる仕様のものとなる）
                        IfWinNotExist, emacs ahk_exe vcxsrv.exe
                        {
                                options .= " -c"
                                create_flg = 1
                        }
                }

                If (nowait_flg = 1)
                {
                        GoSub, Emacsclient
                        WinActivate, emacs ahk_exe vcxsrv.exe
                }
                Else
                {
                        WinGet, active_id, ID, A

                        period = -100
                        If (create_flg = 1)
                        {
                                IfWinExist, emacs ahk_exe vcxsrv.exe
                                        period = -1000
                        }

                        SetTimer, WinActivate, %period%
                        GoSub, Emacsclient
                        WinActivate, ahk_id %active_id%
                }
        }
}

Exit, %exit_code%

Emacsclient:
        args := RegExReplace(args, "\\", "\$0")
        args := RegExReplace(args, """", "\$0")

        EnvGet, pid, EMACSCLIENTW_PID
        If (pid = "")
                RunWait, wsl bash -c "emacsclient %options% %args%",, Hide
        Else
                RunWait, wsl bash -c "emacsclient %options% %args% > /proc/%pid%/fd/1 2> /proc/%pid%/fd/2",, Hide

        exit_code := ErrorLevel
        Return

WinActivate:
        WinWait, emacs ahk_exe vcxsrv.exe,, 5
        If (ErrorLevel = 0)
                WinActivate
        Return
