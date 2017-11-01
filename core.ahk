; This file is for core hotstrings

; The line below this one is literal (the ; does not count as a comment indicator). I have removed /\[] as end chars
#Hotstring EndChars -(){}:;'",.?!`n `t

; Hotkey to reload script as I frequently save and edit it.
^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.


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

f_date(date:="", format:="MM-dd-yyyy") {
    /* Function to return formatted date.
     * ARGS:
     *     date (int): Optional.  If not provided will default to current date & time.  Otherwise, specify all or the leading part of a timestamp in the YYYYMMDDHH24MISS format
     *     format (str): Optional. If not provided will default to MM-dd-yyyy.  Provide any format (as string)  https://autohotkey.com/docs/commands/FormatTime.html
    */

    FormatTime, res, %date%, %format%
    Return res
}

send_outlook_email(subject, body, recipients := "") {
    if (recipients) {
        Send, %recipients%{Tab 2}
    }
    Send, %subject%{Tab}
    Send, % body

    Return
}
