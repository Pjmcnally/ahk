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
#Requires AutoHotkey v2
#SingleInstance, Force              ; Automatically replaces old script with new if the same script file is rune twice
#NoEnv                              ; Avoids checking empty variables to see if they are environment variables (recommended for all new scripts).
#Warn All                           ; Enable warnings to assist with detecting common errors. (More explicit)
#Hotstring EndChars `n `t           ; Limits hotstring ending characters to {Enter}{Tab}{Space}

; Auto-Execute Section (Any system specific Auto-Execute commands go here)
; ==============================================================================
SendMode Input                      ; Recommended for new scripts due to its superior speed and reliability.
CoordMode, Mouse, Client            ; Uses consistent CoordMode across all scripts
CoordMode, Pixel, Client            ; Uses consistent CoordMode across all scripts
CoordMode, ToolTip, Client          ; Uses consistent CoordMode across all scripts
SetBatchLines -1                    ; Remove default 10 ms pause from script execution.
SetTitleMatchMode, 2                ; 2: A window's title can contain WinTitle anywhere inside it to be a match.
SetWorkingDir, %A_ScriptDir%\..     ; Ensures a consistent starting directory. Relative path to AHK folder from core.ahk.

; Include Section
; ==============================================================================
; Include Core Modules (core.ahk must be first for the Auto-Execute to work)

; Include Application specific Modules
#Include "%A_ScriptDir%\..\application\game\scratch_inc\scratch_inc.ahk

; Include Programming Modules

; Include Work Modules

; Include External Modules
#Include "%A_ScriptDir%\..\external\OCR\Lib\OCR.ahk"

; Include Classes

; Debug Section
; ==============================================================================
; Add any commands you are debugging here. Then Run AutoHotkey.ahk in debug mode.
