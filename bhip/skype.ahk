/* Skype functions, hotstrings, and hotkeys used at BHIP.

    This module makes Skype respond to Enter and Ctrl-Enter as I am used to in
    other programs like JIRA and VsCode
*/

#IfWinActive ahk_exe lync.exe  ; lync.exe is Skype. cspell: ignore lync

; Hotkeys || ^ = Ctrl, ! = Alt, + = Shift
; ==============================================================================
Enter::Send, {ShiftDown}{Enter}{ShiftUp}  ; Enter to add newline to message
^Enter::Send, {Enter}  ; Ctrl-Enter to send message

#IfWinActive
