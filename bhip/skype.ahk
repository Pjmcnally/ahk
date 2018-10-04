/* This module makes Skype respond to Enter and Ctrl-Enter as I am used to in
other programs like JIRA and VsCode
*/

#IfWinActive ahk_exe lync.exe  ; lync.exe is Skype. cspell: ignore lync

^Enter:: ; Ctrl-Enter to send message
    Send, {Enter}
Return

Enter::  ; Enter to add newline to message
    Send, {ShiftDown}{Enter}{ShiftUp}
Return

#IfWinActive
