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
#Warn All                           ; Enable warnings to assist with detecting common errors. (More explicit)
#Hotstring EndChars `n `t           ; Limits hotstring ending characters to {Enter}{Tab}{Space}

; Auto-Execute Section (Any system specific Auto-Execute commands go here)
; ==============================================================================
pandora := New PandoraInterface()
windowManager := New WindowManagerInterface([pandora, New WindowInterface("ahk_exe slack.exe"), New WindowInterface("ahk_exe Teams.exe")])

; Include Section
; ==============================================================================
; Include Core Modules (core.ahk must be first for the Auto-Execute to work)
#Include %A_ScriptDir%\..\core\core.ahk
#Include %A_ScriptDir%\..\core\clipboard.ahk
#Include %A_ScriptDir%\..\core\files.ahk
#Include %A_ScriptDir%\..\core\logging.ahk
#Include %A_ScriptDir%\..\core\strings.ahk
#Include %A_ScriptDir%\..\core\time.ahk

; Include Application specific Modules
#Include %A_ScriptDir%\..\application\misc\pandora.ahk

; Include Programming Modules
#Include %A_ScriptDir%\..\programming\core.ahk
#Include %A_ScriptDir%\..\programming\python.ahk
#Include %A_ScriptDir%\..\programming\powershell.ahk

; Include Work Modules
#Include %A_ScriptDir%\..\work\bhip\local.ahk
#Include %A_ScriptDir%\..\work\bhip\core.ahk
#Include %A_ScriptDir%\..\work\bhip\devops.ahk
#Include %A_ScriptDir%\..\work\bhip\fip.ahk
#Include %A_ScriptDir%\..\work\bhip\flexicapture.ahk
#Include %A_ScriptDir%\..\work\bhip\iptools.ahk
#Include %A_ScriptDir%\..\work\bhip\jira.ahk
#Include %A_ScriptDir%\..\work\bhip\sql.ahk
#Include %A_ScriptDir%\..\work\bhip\visualStudio.ahk

; Include External Modules

; Include Classes

; Debug Section
; ==============================================================================
; Add any commands you are debugging here. Then Run AutoHotkey.ahk in debug mode.
