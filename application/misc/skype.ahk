/* Skype functions, hotstrings, and hotkeys used at BHIP.
    This module makes Skype respond to Enter and Ctrl-Enter as I am used to in
    other programs like JIRA and VsCode
*/

#IfWinActive ahk_exe lync.exe  ; lync.exe is Skype. cspell: ignore lync

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
/*  The default use of the ctrl-enter hotkey in Skype is to call the person you
    are typing to. This is an issue for me as I will accidentally use that
    command. This disables that hotkey and converts it to a simple "Enter".
*/
^Enter::Send, {Enter}

#IfWinActive
