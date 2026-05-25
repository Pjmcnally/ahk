/*
Main ahk script.

This script functions as a hub to include other AHK files and runs any system
specific Auto-Execute commands. Core/Universal Auto-Execute commands should
be added to core.ahk.

To run this file on system Start add it to your "Startup" folder.
    Press Window+R
    Enter "shell:startup"
    Click "OK"
    Copy shortcut of this file to the opened folder

System description: Personal Desktop
*/

; Directives
; ==============================================================================
#Requires AutoHotkey v2.0
#SingleInstance Force               ; Automatically replaces old script with new if the same script file is rune twice
#Warn All                           ; Enable warnings to assist with detecting common errors. (More explicit)
#HotString EndChars `n `t           ; Limits hotstring ending characters to {Enter}{Tab}{Space}
FileEncoding "UTF-8-RAW"            ; Set default file encoding to UTF-8 (without BOM)

; Auto-Execute Section (Any system specific Auto-Execute commands go here)
; ==============================================================================
;windowManager := New WindowManagerInterface([pandora, New WindowInterface("ahk_exe Signal.exe"), New WindowInterface("Microsoft To Do"), New WindowInterface("Pocket Casts Desktop")])

; Include Section
; ==============================================================================
; Include Classes
; #Include <Logger>

; Include Core Module(s) (core.ahk must be first for the Auto-Execute to work)
#Include "%A_ScriptDir%\Hotkeys\Universal.ahk"
; #Include "%A_ScriptDir%\..\core\core.ahk"
; #Include "%A_ScriptDir%\..\core\clipboard.ahk"
; #Include "%A_ScriptDir%\..\core\files.ahk"
; #Include "%A_ScriptDir%\..\core\strings.ahk"
; #Include "%A_ScriptDir%\..\core\time.ahk"


; Import Game specific Module(s)
#Include "%A_ScriptDir%\Game\RockyIdle\RockyIdle.ahk"

; Import Application specific Module(s)


; Debug Section
; ==============================================================================
; Add any commands you are debugging here. Then Run AutoHotkey.ahk in debug mode.
