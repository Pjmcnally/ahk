; This file is for core hotstrings (Hotstrings used across several modules)

; The line below this one is literal (the ; does not count as a comment indicator). I have removed /\[] as end chars
#Hotstring EndChars -(){}:;'",.?!`n `t


; Implementation Functions/Hotstrings
; ------------------------------------------------------------------------------
; Hotkey to reload script as I frequently save and edit it.
^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.


; Misc String Functions/Hotstrings
; ------------------------------------------------------------------------------
stringUpper(string){
    ; Allow me to call stringUpper as a function (not command)
    StringUpper, res, string
    Return res
}

stringLower(string){
     ; Allow me to call stringLower as a function (not command)
    StringLower, res, string
    Return res
}

^!u::
    ; Hotkey to uppercase all highlighted text
    clip_func("stringUpper", True)
Return

^!l::
    ; Hotkey to lowercase all hightlighted text
    clip_func("stringLower", True)
Return


; Date Functions
; ------------------------------------------------------------------------------
f_date(date:="", format:="MM-dd-yyyy") {
    /* Function to return formatted date.
     * ARGS:
     *     date (int): Optional.  If not provided will default to current date & time.  Otherwise, specify all or the leading part of a timestamp in the YYYYMMDDHH24MISS format
     *     format (str): Optional. If not provided will default to MM-dd-yyyy.  Provide any format (as string)  https://autohotkey.com/docs/commands/FormatTime.html
    */

    FormatTime, res, %date%, %format%
    Return res
}


; Email Functions
; ------------------------------------------------------------------------------
send_outlook_email(subject, body, recipients := "") {
    if (recipients) {
        Send, %recipients%{Tab 2}
    }
    Send, %subject%{Tab}
    Send, % body

    Return
}


; Clipboard Functions
; ------------------------------------------------------------------------------
clip_swap(str){
    ; This function allows me to paste a string but not disrupt the clipboard
    ClipSaved := ClipboardAll           ; Save the entire clipboard to a variable of your choice.
    Clipboard := str                    ; Assign text to clipboard
    ClipWait, 1                         ; Wait 1 second for clipboard to contain text
    if ErrorLevel {
        MsgBox, % "No text selected.`r`n`r`nPlease select text and try again."
        Return
    }

    Send, ^v

    Clipboard := ClipSaved              ; Restore the original clipboard.
    ClipSaved =                         ; Free the memory in case the clipboard was very large.
}

clip_func(func, send_res:=False){
    ; This function takes in a func name and runs it on whatever text is currently higlighted and "Sends" the result
    ClipSaved := ClipboardAll           ; Save the entire clipboard to a variable of your choice.
    Clipboard =                         ; Empty clipboard

    Send ^c                             ; Copy highlight text to clipboard
    ClipWait, 1                         ; Wait 1 second for clipboard to contain text
    if ErrorLevel {
        MsgBox, % "No text selected.`r`n`r`nPlease select text and try again."
        Return
    }
    res := %func%(Clipboard)            ; Run passed in func on contents of clipboard

    if (send_res){                      ; if send_res is True
        Send, %res%                     ; Send results string
    }

    Clipboard := ClipSaved              ; Restore the original clipboard.
    ClipSaved =                         ; Free the memory in case the clipboard was very large.
}
