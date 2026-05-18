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
#Requires AutoHotkey v1
#SingleInstance, Force              ; Automatically replaces old script with new if the same script file is rune twice
#NoEnv                              ; Avoids checking empty variables to see if they are environment variables (recommended for all new scripts).
#Warn                               ; Enable warnings to assist with detecting common errors. (More explicit)
#Hotstring EndChars `n `t           ; Limits hotstring ending characters to {Enter}{Tab}{Space}

; Auto-Execute Section (Any system specific Auto-Execute commands go here)
; ==============================================================================
;windowManager := New WindowManagerInterface([pandora, New WindowInterface("ahk_exe Signal.exe"), New WindowInterface("Microsoft To Do"), New WindowInterface("Pocket Casts Desktop")])

; Include Section
; ==============================================================================
; Include Classes
#Include %A_ScriptDir%\..\classes\bigA.ahk
#Include %A_ScriptDir%\..\classes\button.ahk
#Include %A_ScriptDir%\..\classes\screen.ahk
#Include %A_ScriptDir%\..\classes\setting.ahk
#Include %A_ScriptDir%\..\classes\logger.ahk

; Include Core Modules (core.ahk must be first for the Auto-Execute to work)
#Include %A_ScriptDir%\..\core\core.ahk
#Include %A_ScriptDir%\..\core\clipboard.ahk
#Include %A_ScriptDir%\..\core\files.ahk
#Include %A_ScriptDir%\..\core\strings.ahk
#Include %A_ScriptDir%\..\core\time.ahk


; Import Application specific Module(s)
#Include %A_ScriptDir%\..\application\game\rocky_idle\rocky_idle.ahk

; Debug Section
; ==============================================================================
; Add any commands you are debugging here. Then Run AutoHotkey.ahk in debug mode.
