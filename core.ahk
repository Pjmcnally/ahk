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

Return  ; End of Auto-Execute Section

; Universal Functions:
; ==============================================================================
get_highlighted(){
    /*  Return whatever text is currently highlighted in the active window.

        Args:
            None
        Returns:
            str: Higligted text
    */
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

    ; Save new Clipboard contents to temp variable
    res := Clipboard

    ; Restore original contents and clear Clipsaved variable
    Clipboard := ClipSaved
    ClipSaved =

    Return res
}

paste_contents(str){
    /*  Paste a string without disuturing contents of clipboard.

    Args:
        str (str): The text to be pasted
    Returns:
        None
    */
    ; Save the Clipboard to temp variable, Overwrite clipboard, paste command
    ClipSaved := ClipboardAll
    Clipboard := str
    Send, ^v

    ; This sleep is a bit weird. Without it, Authotkey will send a paste
    ; command to the OS and then immedialy restore the clipboard.
    ; This happens so fast that the old contents get pasted instead of new.
    Sleep, 100

    ; Restore original contents and clear Clipsaved variable
    Clipboard := ClipSaved
    ClipSaved =

    Return
}

clip_func(func){
    /*  Run func on highlighted text and replace text.

        This function takes in a func name. That function is run on whatever
        text is currently higlighted. The results are pasted over the
        highlighted text.

        Args:
            func (str): Name of function to be run on highlighted text
        Returns:
            None
    */
    str := get_highlighted()
    if (str){
        res := %func%(str)
        paste_contents(res)
    }

    Return
}

string_upper(string){
    /*  Call stringUpper as a function (not command) */
    StringUpper, res, string
    Return res
}

string_lower(string){
    /*  Call stringLower as a function (not command) */
    StringLower, res, string
    Return res
}

f_date(date:="", format:="MM-dd-yyyy") {
    /*  Function to return formatted date.

        Args:
            date (str): Optional. If not provided will default to current date & time. Otherwise, specify all or the leading part of a timestamp in the YYYYMMDDHH24MISS format
            format (str): Optional. If not provided will default to MM-dd-yyyy. Provide any format (as string)  https://autohotkey.com/docs/commands/FormatTime.html
        Returns:
            str: Date in specified format
    */
    FormatTime, res, %date%, %format%
    Return res
}

send_outlook_email(subject, body, recipients := "") {
    /*  Fill content into Outlook email. */
    if (recipients) {
        Send, %recipients%{Tab 2}
    }
    Send, %subject%{Tab}
    Send, % body

    Return
}

click_and_return(x_dest, y_dest, speed:=0){
    /*  Click a specified location and returns pointer to original location. */
    MouseGetPos,  x_orig, y_orig
    MouseMove, % x_dest, y_dest, 0
    Click Down
    Sleep 10  ; For stabiltiy and consistent results, increase if issues occur.
    Click Up
    MouseMove, % x_orig, y_orig, 0
    Return
}

; Universal Hostrings:
; ==============================================================================
^!r::  ; Assign Ctrl-Alt-R as a hotkey to reload active script.
    Reload
Return

^!u::  ; Ctrl-Alt-U to uppercase any hightlighted text
    clip_func("string_upper")
Return

^!l::  ; Ctrl-Alt-L to lowercase all highlighted text
    clip_func("string_lower")
Return

^!t::  ; Ctrl-Alt-T for temp function/hotkeys (one-offs uses or testing)
Return
