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
; brotatoSaveArchive := New SaveArchive("Brotato", A_AppData . "\Brotato\76561197989542288\")
d3 := New diabloInterface("Diablo III")
hadesSaveArchive := New SaveArchive("Hades", A_MyDocuments . "\Saved Games\Hades\")
melvor := New MelvorInterface()
pandora := New PandoraInterface()
windowManager := New WindowManagerInterface([pandora, New WindowInterface("ahk_exe Signal.exe"), New WindowInterface("Microsoft To Do"), New WindowInterface("Pocket Casts Desktop")])

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
#Include %A_ScriptDir%\..\application\game\diablo3.ahk
#Include %A_ScriptDir%\..\application\game\diabloInterface.ahk
#Include %A_ScriptDir%\..\application\game\hades.ahk
#Include %A_ScriptDir%\..\application\game\hexcells.ahk
#Include %A_ScriptDir%\..\application\game\last_epoch.ahk
#Include %A_ScriptDir%\..\application\game\melvor.ahk
#Include %A_ScriptDir%\..\application\misc\firefox.ahk
#Include %A_ScriptDir%\..\application\misc\pandora.ahk

; Include Programming Modules
#Include %A_ScriptDir%\..\programming\core.ahk
#Include %A_ScriptDir%\..\programming\python.ahk
#Include %A_ScriptDir%\..\programming\powershell.ahk

; Include Work Modules

; Include External Modules
; #Include %A_ScriptDir%\..\external\json.ahk

; Include Classes
#Include %A_ScriptDir%\..\classes\save_archive.ahk

; Debug Section
; ==============================================================================
; Add any commands you are debugging here. Then Run AutoHotkey.ahk in debug mode.
