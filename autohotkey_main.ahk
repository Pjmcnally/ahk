#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir, %A_ScriptDir%  ; Ensures a consistent starting directory.


; Below this line at imports to include ahk modules in this file
; ==============================================================================
; This is the authohtokey_main file I use on my gigabyte laptop.

#Include core.ahk           	; Always load this one first
#Include misc/playground.ahk 	; Place to experiment
#Include game/hearthstone.ahk 	; Hearthstone Scripts
; #Include borderlands2.ahk  	; Borderlands Scripts
; #Include diablo3.ahk  		; Diablo 3 scripts (Now obsolete)
; #Include kings_bounty.ahk  	; Kings bounty scripts
; #Include lol_chars.ahk  		; LoL champ screeen scripts (Needs more development)
