/*  Core Clipboard functions.

This module contains core clipboard functions that are used by other modules.
This file should also be loaded as other files may fail to load without it.
*/

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

check_rcpclip() {
    /*  Test whether rdpclip is running and alerts user.

        This function tests whether rcpclip (the Windows utility that controls the
        clipboard) is running. If not it displays a window and asks the user if they
        want to restart it.

        Args:
            None
        Returns:
            None
    */

    name := "rdpclip.exe"
    path := "C:\Windows\System32\rdpclip.exe"

    if (!WinExist("rdpclip Tracker") and !process_exists(name)) {
        SoundBeep, 500, 500
        MsgBox, 4, % "rdpclip Tracker", % "RdpClip is not running`n`nWould you like to restart it?"
        IfMsgBox, Yes
            Run, % path
    }
}
