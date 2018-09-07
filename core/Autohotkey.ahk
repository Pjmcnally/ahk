#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir, %A_ScriptDir%\programming\ahk  ; Ensures a consistent starting directory. Set this to path of AHK folder.
a := "this is a test"

run core\autohotkey_main.ahk
ExitApp
