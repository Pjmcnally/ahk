/*
Main ahk script executed on this computer.

This module functions as a hub to include other AHK files and runs any system
specific Auto-Execute commands.  Core/Universal Auto-Execute commands should
be added to core.ahk.

To run this file add it to your "Startup" folder.
    Press Window+R
    Enter "shell:startup"
    Click "OK"
    Copy shortcut of this file to the opened folder

System description: <Change as needed>
*/

; Directives
; ==============================================================================
#Requires AutoHotkey v1
#SingleInstance, Force              ; Automatically replaces old script with new if the same script file is rune twice
#NoEnv                              ; Avoids checking empty variables to see if they are environment variables (recommended for all new scripts).
#Warn All                           ; Enable warnings to assist with detecting common errors. (More explicit)
#Hotstring EndChars `n `t           ; Limits hotstring ending characters to {Enter}{Tab}{Space}

; Auto-Execute Section (Any system specific Auto-Execute commands go here)
; ==============================================================================

; Include Section
; ==============================================================================
; Include Core Module(s) (core.ahk must be first for the Auto-Execute to work)
#Include %A_ScriptDir%\..\core\core.ahk
#Include %A_ScriptDir%\..\core\clipboard.ahk
#Include %A_ScriptDir%\..\core\files.ahk
#Include %A_ScriptDir%\..\core\logging.ahk
#Include %A_ScriptDir%\..\core\strings.ahk
#include %A_ScriptDir%\..\core\time.ahk

; Import Application specific Module(s)

; Include Programming Modules

; Include Work Modules

; Include External Modules

; Debug Section
; ==============================================================================
; Add any commands you are debugging here. Then Run AutoHotkey.ahk in debug mode.
