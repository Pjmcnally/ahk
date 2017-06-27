#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir, %A_ScriptDir%\ahk  ; Ensures a consistent starting directory. Set this to path of AHK folder.

run Autohotkey_main.ahk
ExitApp
