/*  Core string functions and hotkeys.

This module contains core string functions and hotkeys. The functions defined
here are used by other modules. This file should also be loaded as other files
may fail to load without it.
*/

; Functions
; ==============================================================================
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


; Hotstrings
; ==============================================================================
; X=Execute, ?=Within word, *=terminating char not required, B0=no backspace


; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
^!u::  ; Ctrl-Alt-U to uppercase any highlighted text
    KeyWait, ctrl, L
    KeyWait, alt, L
    clip_func("string_upper")
Return

^!l::  ; Ctrl-Alt-L to lowercase all highlighted text
    KeyWait, ctrl, L
    KeyWait, alt, L
    clip_func("string_lower")
Return

^!-:: ; Ctrl-Alt-Hyphen to Hyphenate all text
    KeyWait, ctrl, L
    KeyWait, alt, L
    clip_func("string_hyphenate")
Return

^!+_:: ; Ctrl-Alt-Shift-Underscore to underscore all text
    KeyWait, ctrl, L
    KeyWait, alt, L
    KeyWait, shift, L
    clip_func("string_underscore")
Return
