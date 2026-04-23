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
; global A := New bigA()
d3 := New diabloInterface("Diablo III")
;d4 := New diabloInterface("Diablo IV")
pandora := New PandoraInterface()
;windowManager := New WindowManagerInterface([pandora, New WindowInterface("ahk_exe Signal.exe"), New WindowInterface("Microsoft To Do"), New WindowInterface("Pocket Casts Desktop")])
quickClick := New MiscClickInterface()

; Include Section
; ==============================================================================
; Include Classes
#Include %A_ScriptDir%\..\classes\bigA.ahk
#Include %A_ScriptDir%\..\classes\button.ahk
#Include %A_ScriptDir%\..\classes\diabloInterface.ahk
#Include %A_ScriptDir%\..\classes\miscClickInterface.ahk
#Include %A_ScriptDir%\..\classes\save_archive.ahk
#Include %A_ScriptDir%\..\classes\screen.ahk
#Include %A_ScriptDir%\..\classes\setting.ahk

; Include Core Modules (core.ahk must be first for the Auto-Execute to work)
#Include %A_ScriptDir%\..\core\core.ahk
#Include %A_ScriptDir%\..\core\clipboard.ahk
#Include %A_ScriptDir%\..\core\files.ahk
#Include %A_ScriptDir%\..\core\logging.ahk
#Include %A_ScriptDir%\..\core\strings.ahk
#Include %A_ScriptDir%\..\core\time.ahk

; Import Application specific Module(s)
#Include %A_ScriptDir%\..\application\game\child_of_light.ahk
#Include %A_ScriptDir%\..\application\game\cyberpunk_2077.ahk
#Include %A_ScriptDir%\..\application\game\diablo3.ahk
#Include %A_ScriptDir%\..\application\game\hexcells.ahk
#Include %A_ScriptDir%\..\application\game\rocky_idle.ahk
#Include %A_ScriptDir%\..\application\game\yet_another_incremental_game_about_coding.ahk
#Include %A_ScriptDir%\..\application\misc\firefox.ahk
#Include %A_ScriptDir%\..\application\misc\pandora.ahk
#Include %A_ScriptDir%\..\application\misc\vlc.ahk

; Include Programming Modules
#Include %A_ScriptDir%\..\programming\core.ahk
#Include %A_ScriptDir%\..\programming\python.ahk
#Include %A_ScriptDir%\..\programming\powershell.ahk

; Include Work Modules

; Include External Modules
; #Include %A_ScriptDir%\..\external\json.ahk
; #Include %A_ScriptDir%\..\external\FindText.ahk
; #Include %A_ScriptDir%\..\external\OCR.ahk

; Debug Section
; ==============================================================================
; Add any commands you are debugging here. Then Run AutoHotkey.ahk in debug mode.
