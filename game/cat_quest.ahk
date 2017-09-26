; This hotkey pastes a list of golden chest locations into wonderlist
; so I can easily track them

; This should never really be used again.

^!q::
str := Clipboard
Loop, parse, str, `n, `r                ; Loop over each line on the clipboard
    {
        SendRaw, % A_LoopField
        Send {Enter}                        ; Send newline to end line
        sleep 1000
    }
Return
