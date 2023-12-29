; -*- coding: utf-8-with-signature-dos -*-

#NoTrayIcon
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

#WinActivateForce

DetectHiddenWindows, On
SetTitleMatchMode, RegEx

arg_count = %0%

tty_flg = 0
nowait_flg = 0
create_flg = 0

GroupAdd, emacs, emacs- ahk_exe vcxsrv\.exe
GroupAdd, emacs, emacs- ahk_exe GWSL_vcxsrv\.exe
GroupAdd, emacs, emacs- ahk_exe GWSL_vcxsrv_lowdpi\.exe
GroupAdd, emacs, emacs- ahk_exe XWin\.exe
GroupAdd, emacs, emacs- ahk_exe XWin_MobaX.*\.exe
GroupAdd, emacs, emacs- ahk_exe XWin_Cygwin.*\.exe
GroupAdd, emacs, emacs- ahk_exe Xming\.exe
GroupAdd, emacs, emacs- ahk_exe X410\.exe
GroupAdd, emacs, emacs- ahk_exe Xpra-Launcher\.exe
GroupAdd, emacs, emacs- ahk_exe mstsc\.exe

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
        IfWinActive, ahk_group emacs
                GoSub, Emacsclient
        Else
        {
                If (create_flg = 0)
                {
                        ; Emacs のフレームが開いていなければ、create-frame のオプションを追加する
                        ; （この設定は、素の emacsclient とは異なる仕様のものとなる）
                        IfWinNotExist, ahk_group emacs
                        {
                                options .= " -c"
                                create_flg = 1
                        }
                }

                If (nowait_flg = 1)
                {
                        GoSub, Emacsclient
                        WinActivate, ahk_group emacs
                }
                Else
                {
                        ; emacsclient を起動したウィンドウのウィンドウハンドルを退避する
                        WinGet, active_id, ID, A

                        ; Emacs のウィンドウのアクティベート待ちを開始するまでの待ち時間を設定する
                        ; （マイナスは一度だけ実行する場合の指定方法）
                        period = -100
                        If (create_flg = 1)
                        {
                                ; 既に emacs が起動している場合は、新しく開く Emacs のウィンドウをアクティベート
                                ; したいので、待ち時間を長くする設定する
                                IfWinExist, ahk_group emacs
                                        period = -1000
                        }

                        ; Emacs のウィンドウをアクティベートするためのタイマーを起動する
                        SetTimer, WinActivate, %period%

                        ; emacsclient を起動する
                        GoSub, Emacsclient

                        ; emacsclient が終了したら、emacsclient を起動したウィンドウをアクティブに戻す
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
                RunWait, wsl bash -i -c "emacsclient %options% %args%",, Hide
        Else
                RunWait, wsl bash -i -c "emacsclient %options% %args% > /proc/%pid%/fd/1 2> /proc/%pid%/fd/2",, Hide

        exit_code := ErrorLevel
        Return

WinActivate:
        WinWait, ahk_group emacs,, 5
        If (ErrorLevel = 0)
                WinActivate
        Return
