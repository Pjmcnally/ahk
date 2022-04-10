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
GroupAdd, consoles, ahk_exe WindowsTerminal.exe

check_update_ahk()

Return  ; End of Auto-Execute Section

; Functions
; ==============================================================================
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

SendWait(msg, wait) {
    Send % msg
    Sleep % wait
}

ClickWait(x, y, num, wait) {
    Click, %x%, %y%, %num%
    Sleep, % wait
}

SendLines(iter, wait:=0) {
    For index, value in iter {
        SendWait(value, wait)
        SendWait("{Enter}", wait)
    }
}

stop_double_space() {
    Send, {BackSpace}
    SoundBeep, 750, 500
}

get_current_ahk_version_web() {
    endpoint := "https://autohotkey.com/download/1.1/version.txt"

    Try {
        client := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        client.Open("GET", endpoint, true)
        client.Send()
        client.WaitForResponse()

        return client.ResponseText
    }
    Catch {
        return ""
    }
}

download_current_ahk() {
    endpoint := "https://www.autohotkey.com/download/ahk-install.exe"
    Run, % endpoint
}

check_update_ahk() {
    local_version := A_AhkVersion
    web_version := SubStr(get_current_ahk_version_web(), 1, 100)

    if (web_version and (web_version != local_version)) {
        template =
        (
            A new version of AHK may be available:

            Web version: %web_version%
            Your version: %local_version%

            Would you like to download the new version?
        )
        msg_string := dedent(template, 12)

        SoundBeep, 750, 500
        MsgBox, 4, % "Update available", % msg_string
        IfMsgBox, % "yes"
            download_current_ahk()
    }
}

clear_and_send(str) {
    Send, ^a
    Send, % str
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
^!w::Run AutoHotkey "C:\Program Files\AutoHotkey\WindowSpy.ahk"
^!b::Run ms-settings:bluetooth
^!c::Run "calc"  ; Windows calculator


; Testing Section:
; ==============================================================================
test_func() {
    Return
}

^!t::  ; Ctrl-Alt-T for temp function/hotkeys (one-offs uses or testing)
    MsgBox, % test_func()
Return
