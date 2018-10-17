/*  Core settings, hotstrings, and functions.

This module contains three parts: Auto-Execute, Universal Functions, and
Universal hotstrings.

It is key to note that autohotkey_main.ahk is system specific where core.ahk is
universal. Core.ahk contains settings, hotstrings, and functions that are
desired across all other modules and used across all systems.

The Auto-Execute section sets global parameters across all other modules
imported by autohotkey_main. These settings are essentially universal. If
there are system specific Auto-Execute commands those should be added to
the Auto-Execute section of autohotkey_main.ahk.

The other sections are Universal Functions and Universal Hotstrings. These are
core hotstrings and functions that are needed on all systems. These functions
are sometimes required by other modules/functions. It is assumed by other
modules that this module is imported.
*/

; Auto-Execute Section (All core Auto-Execute commands should go here)
; ==============================================================================
#SingleInstance, Force              ; Automatically replaces old script with new if the same script file is rune twice
#NoEnv                              ; Avoids checking empty variables to see if they are environment variables (recommended for all new scripts).
#Warn                               ; Enable warnings to assist with detecting common errors. (More explicit)
#Hotstring EndChars `n `t           ; Limits hotstring ending characters to {Enter}{Tab}{Space}
SendMode Input                      ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir, %A_ScriptDir%\..     ; Ensures a consistent starting directory. Relative path to AHK folder from core.ahk.
SetTitleMatchMode, 2                ; 2: A window's title can contain WinTitle anywhere inside it to be a match.

; Create group of consoles for git commands
GroupAdd, consoles, ahk_exe pwsh.exe
GroupAdd, consoles, ahk_exe powershell.exe
GroupAdd, consoles, ahk_exe powershell_ise.exe
GroupAdd, consoles, ahk_exe RDCMan.exe
GroupAdd, consoles, ahk_exe Code.exe

; Code to initialize PandoraInterface Object
; This requires pandora.ahk or will error. I may need to fix this...
pandora := new PandoraInterface

Return  ; End of Auto-Execute Section

; Functions
; ==============================================================================
get_highlighted(persist=True, e=True) {
    /*  Return whatever text is currently highlighted in the active window.

        Args:
            None
        Returns:
            str: Highlighted text
    */

    if (persist) {
        ClipSaved := ClipboardAll
    }
    Clipboard =
    Sleep, 100

    Send ^c
    ClipWait, 2, 1
    if (ErrorLevel and e) {
        MsgBox, % "No text selected.`r`n`r`nPlease select text and try again."
        Return ""
    } else if (ErrorLevel and not e) {
        res :=
    } else {
        res := Clipboard
    }

    if (persist) {
        Clipboard := ClipSaved
        ClipSaved =
    }

    Return res
}

paste_contents(str) {
    /*  Paste a string without disturbing contents of clipboard.

    Args:
        str (str): The text to be pasted
    Returns:
        None
    */
    ClipSaved := ClipboardAll
    Clipboard := str
    Send, ^v

    ; This sleep is a bit weird. Without it, AutoHotkey will send a paste
    ; command to the OS and then immediately restore the clipboard.
    ; This happens so fast that the old contents get pasted instead of new.
    Sleep, 100

    Clipboard := ClipSaved
    ClipSaved =

    Return
}

clip_func(func) {
    /*  Run func on highlighted text and replace text.

        This function takes in a func name. That function is run on whatever
        text is currently highlighted. The results are pasted over the
        highlighted text.

        Args:
            func (str): Name of function to be run on highlighted text
        Returns:
            None
    */
    str := get_highlighted()
    if (str) {
        paste_contents(%func%(str))
    }

    Return
}

timer_wrapper(func, args:="") {
    /*  A wrapper function to time the wrapped function

        This function takes in a func name and list of arguments (optional).
        That provided function is run with the provided arguments. That
        process is timed which is displayed at the end.

        Args:
            func (str): Name of function to be run on highlighted text
            args (str): Optional. Args for internal function
        Returns:
            None
    */
    start_time := A_TickCount

    %func%(args)

    end_time := A_TickCount
    t_diff := end_time - start_time
    MsgBox, % milli_to_hhmmss(t_diff)
}

milli_to_hhmmss(milli) {
    /*  A function to convert milliseconds to readable time.

        Args:
            milli (int): number of milliseconds
        Returns:
            Str: The formatted string in hh:mm:ss.mil
    */
    mil := mod(milli, 1000)
    sec := mod(milli //= 1000, 60)
    min := mod(milli //= 60, 60)
    hou := milli // 60
    Return Format("{1:02d}:{2:02d}:{3:02d}.{4:03d}", hou, min, sec, mil)
}

string_upper(string) {
    /*  Call stringUpper as a function (not command)
    */
    StringUpper, res, string
    Return res
}

string_lower(string) {
    /*  Call stringLower as a function (not command)
    */
    StringLower, res, string
    Return res
}

string_hyphenate(string) {
    /*  Function to replace all spaces with hyphens '-'
    */
    res := StrReplace(string, " ", "-")
    Return res
}

string_underscore(string) {
    /*  Function to replace all spaces with underscore '_'
    */
    res := StrReplace(string, " ", "_")
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
    /*  Fill content into Outlook email.

        Args:
            subject (str): The subject of the email
            body (str): The body of the email
            recipients (str): Optional. Recipients of email.
        Return:
            None
    */
    if (recipients) {
        Send, %recipients%{Tab 2}
    }
    Send, %subject%{Tab}
    Send, % body

    Return
}

click_and_return(x_dest, y_dest, speed:=0) {
    /*  Click a specified location and returns pointer to original location.
    */
    MouseGetPos,  x_orig, y_orig
    MouseMove, % x_dest, y_dest, 0
    Click Down
    Sleep 10  ; For stability and consistent results, increase if issues occur.
    Click Up
    MouseMove, % x_orig, y_orig, 0
    Return
}

HasVal(haystack, needle) {
    if !(IsObject(haystack)) || (haystack.Length() = 0)
        Return 0
    for index, value in haystack
        if (value = needle)
        Return index
    Return 0
}

SendWait(msg, wait:=0) {
    Send % msg
    if (wait) {
        Sleep % wait
    }
}

SendLines(iter, wait:=0) {
    For index, value in iter {
        SendWait(value, wait)
        SendWait("{Enter}", wait)
    }
}

dedent(str, spaces) {
    /*  Removes a specified number of spaces from the beginning of each line.

        Used to de-indent block strings. for example:
        a :=
        (
            This string shouldn't have 12 spaces in front of it
        )
        a := dedent(a, 12)
    */
    pattern := "`am)^ {" . spaces . "}(.*)$"
    res := RegExReplace(str, pattern, "$1")

    return res
}

sort_files() {
    /*  Sorts files into a "left" and "right" folder.

        Source, Left and Right folder are provided through input boxes. Each
        file in the Source folder will be run. Press the left or right arrow
        key to move into the corresponding folder.
    */
    InputBox, rev_dir, % "Run folder", % "Please enter the folder location to sort:"
    if ErrorLevel
        Exit
    IfNotExist, % rev_dir
        Exit  ; TODO: Add error message here.

    InputBox, left_fold, % "Left Folder", % "Please enter the LEFT folder:"
    if ErrorLevel
        Exit
    IfNotExist, % left_fold
        Exit  ; TODO: Add error message here.

    InputBox, right_fold, % "Right Folder", % "Please enter the RIGHT folder:"
    if ErrorLevel
        Exit
    IfNotExist, % right_fold
        Exit  ; TODO: Add error message here.


    total_count := ComObjCreate("Scripting.FileSystemObject").GetFolder(rev_dir).Files.Count
    Progress, M2 R0-%total_count%, % "Files Done:`r`n0", % "Total Files: " . total_count, "Sorting Files"

    Loop, Files, % rev_dir "\*.*"
    {
        Progress, %A_Index%, % "Sorting File: " . A_Index "`r`n" . A_LoopFileName

        Run, % A_LoopFileFullPath
        Sleep, 150

        dest := ""
        while (not dest) {
            Sleep, 10
            if (GetKeyState("Left") = 1) {
                dest := left_fold
                break
            }
            if (GetKeyState("Right") = 1) {
                dest := right_fold
                break
            }
        }

        Send, ^w
        Sleep, 150

        FileMove, % A_LoopFileFullPath, % dest
    }

    Progress, Off

    Return
}

stop_double_space() {
    Send, {BackSpace}
    SoundBeep, 750, 500
}

; Hotstrings
; ==============================================================================
; X=Execute, ?=Within word, *=terminating char not required, B0=no backspace
:X?*B0:!  ::stop_double_space()  ; Beep after double space after !
:X?*B0:?  ::stop_double_space()  ; Beep after double space after ?
:X?*B0:.  ::stop_double_space()  ; Beep after double space after .


; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^+Space::Pause, Toggle  ; Pause all active ahk processes
^!Space::Suspend, Toggle  ; Suspend all hotkeys
^!r::Reload  ; Reload all scripts.
^!+s::sort_files()  ; Sort files into left and right folder

^!u::  ; Ctrl-Alt-U to uppercase any highlighted text
    KeyWait ctrl
    KeyWait alt
    clip_func("string_upper")
Return

^!l::  ; Ctrl-Alt-L to lowercase all highlighted text
    KeyWait ctrl
    KeyWait alt
    clip_func("string_lower")
Return

^!-:: ; Ctrl-Alt-Hyphen to Hyphenate all text
    KeyWait ctrl
    KeyWait alt
    clip_func("string_hyphenate")
Return

^!+_:: ; Ctrl-Alt-Shift-Underscore to underscore all text
    KeyWait ctrl
    KeyWait alt
    KeyWait shift
    clip_func("string_underscore")
Return


; Testing Section:
; ==============================================================================
test_func() {
    Return
}

^!t::  ; Ctrl-Alt-T for temp function/hotkeys (one-offs uses or testing)
    test_func()
Return
