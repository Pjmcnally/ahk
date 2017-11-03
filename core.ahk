/*
core.ahk is my core ahk script.

All content in this file should be usable/desired on all systems.

The top part of this file is a continuation of the Auto-Execute section

The next two sections are universal functions and hotstrings
*/


; Auto-Execute Section (All Auto-Execute commands must go here)
; ==============================================================================
#SingleInstance, Force          ; Automatically replaces old script with new if the same script file is rune twice
#NoEnv                          ; Avoids checking empty variables to see if they are environment variables (recommended for all new scripts).
#Warn                           ; Enable warnings to assist with detecting common errors. (More explicit - like Python Yay!)
#Hotstring EndChars `n `t       ; Limits Hotstring EndChars to {Enter}{Tab}{Space}
SendMode Input                  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir, %A_ScriptDir%    ; Ensures a consistent starting directory.
SetTitleMatchMode, 2            ; 2: A window's title can contain WinTitle anywhere inside it to be a match.

; Create group of consoles for git commands
GroupAdd, consoles, ahk_exe powershell.exe
GroupAdd, consoles, ahk_exe powershell_ise.exe
GroupAdd, consoles, ahk_exe mintty.exe

Return                          ; End of Auto-Execute Section


; Universal Functions:
; ==============================================================================
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


; Universal Hostrings:
; ==============================================================================
; Hotkey to reload script as I frequently save and edit it.
^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.

; Hotkey to uppercase all highlighted text
^!u::
    clip_func("stringUpper", True)
Return

; Hotkey to lowercase all hightlighted text
^!l::
    clip_func("stringLower", True)
Return

; Temp Function (for one-offs)
^!t::
Return
