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
clip_func(func){
    ; This function takes in a func name and runs it on whatever text is currently higlighted and "Sends" the result

    ; Save the Clipboard to temp variable and empty Clipboard
    ClipSaved := ClipboardAll
    Clipboard =

    ; Copy hightlighted text to Clipboard. Wait for clipboard to contain text.
    Send ^c
    ClipWait, .5
    if ErrorLevel {
        MsgBox, % "No text selected.`r`n`r`nPlease select text and try again."
        Return
    }

    ; Process contents of Clipboard and overwrite Clipboard with results
    Clipboard := %func%(Clipboard)
    Send, ^v

    ; This sleep is a bit weird. Without it, Authotkey will send a paste
    ; command to the OS and then immedialy restore the clipboard.
    ; This happens so fast that the old contents get pasted instead of new.
    Sleep, 100

    ; Restore original contents and clear Clipsaved variable
    Clipboard := ClipSaved
    ClipSaved =
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

click_and_return(x_dest, y_dest, speed:=0){
    MouseGetPos,  x_orig, y_orig
    MouseMove, % x_dest, y_dest, 0
    Click Down
    Sleep 10 ; For stabiltiy and consistent results, increase if issues occur.
    Click Up
    MouseMove, % x_orig, y_orig, 0
    Return
}

; Universal Hostrings:
; ==============================================================================
; Hotkey to reload script as I frequently save and edit it.
^!r::Reload  ; Assign Ctrl-Alt-R as a hotkey to restart the script.

; Hotkey to uppercase all highlighted text
^!u::
    clip_func("stringUpper")
Return

; Hotkey to lowercase all hightlighted text
^!l::
    clip_func("stringLower")
Return

; Temp Function (for one-offs)
^!t::
Return
