#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
setWorkingDir, ahk  ; Ensures a consistent starting directory.

#Include %A_ScriptDir%/ahk/general.ahk ; Always load this one first
#Include %A_ScriptDir%/ahk/playground.ahk
#Include %A_ScriptDir%/ahk/hearthstone.ahk
; #Include %A_ScriptDir%/ahk/borderlands2.ahk  ; Not currently playing.
; #Include %A_ScriptDir%/ahk/diablo3.ahk  ; No longer needed.
; #Include %A_ScriptDir%/ahk/kings_bounty.ahk  ; Not currently playing.
; #Include %A_ScriptDir%/ahk/lol_chars.ahk  ; Needs more development.
