/*
Main ahk script executed on this computer.

This module functions as a hub to include other AHK files and runs any system
specific Auto-Execute commands.  Core/Universal Auto-Execute commands should
be added to core.ahk.

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
#Include core\core.ahk
#Include core\clipboard.ahk
#Include core\files.ahk
#Include core\strings.ahk
#include core\time.ahk

; Include Example
; #Include the_thing_I_want
; #Include misc\the_other_thing_I_want
