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


; Code to initialize PandoraInterface Object
pandora := new PandoraInterface

; Set timer to check that I am not leaving Pandora running after I go home
SetTimer, PandoraCheck, % pandora.IdleCheckFrequency,

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


; Testing Section:
; ==============================================================================
test_func() {
    Return
}

^!t::  ; Ctrl-Alt-T for temp function/hotkeys (one-offs uses or testing)
    MsgBox, % test_func()
Return
