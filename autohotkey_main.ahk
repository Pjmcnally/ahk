#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir, %A_ScriptDir%  ; Ensures a consistent starting directory.


; Below this line at imports to include ahk modules in this file
; ==============================================================================
; This is the authohtokey_main file I use on my gigabyte laptop.

#Include core.ahk           	; Always load this one first
#Include misc/git.ahk		; Git scripts
#Include misc/playground.ahk 	; Place to experiment
#Include game/hearthstone.ahk 	; Hearthstone Scripts

