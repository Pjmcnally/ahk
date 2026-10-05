#Requires AutoHotkey v1
#SingleInstance, Force              ; Automatically replaces old script with new if the same script file is rune twice
#NoEnv                              ; Avoids checking empty variables to see if they are environment variables (recommended for all new scripts).
#Warn All                           ; Enable warnings to assist with detecting common errors. (More explicit)
#Hotstring EndChars `n `t           ; Limits hotstring ending characters to {Enter}{Tab}{Space}

; Auto-Execute Section (All core Auto-Execute commands should go here)
; ==============================================================================
SendMode Input                      ; Recommended for new scripts due to its superior speed and reliability.
CoordMode, Mouse, Client            ; Uses consistent CoordMode across all scripts
CoordMode, Pixel, Client            ; Uses consistent CoordMode across all scripts
CoordMode, ToolTip, Client          ; Uses consistent CoordMode across all scripts
SetBatchLines -1                    ; Remove default 10 ms pause from script execution.
SetTitleMatchMode, 2                ; 2: A window's title can contain WinTitle anywhere inside it to be a match.
SetWorkingDir, %A_ScriptDir%\..     ; Ensures a consistent starting directory. Relative path to AHK folder from core.ahk.

/*  The following is for the mini-game associated with the spaceversery event.

To make this work access the "Accessibility settings for the event and set both "Good"
and "Special" settings to "White". This means we only have to search for 1 color.
*/

RunEvent() {
    maxGameCount := 10 ; Max number of games to run before stopping
    startDelay := 250 ; Wait time in milliseconds between checking for new game
    start_x := 1890
    start_y := 275


    while True
    {
        ; Display tooltip with game info.
        ToolTip, % "Waiting for new game`nHold Escape To Stop", 1580, 400

        if (CheckEndGame()) {
            ToolTip  ; Clear tooltip
            Return ; End process
        }

        ; If game not active start game
        If CheckStartButton(start_x, start_y)
        {
            ; Click start button
            Click %start_x%, %start_y%
            RunGame()
        }

        Sleep, % startDelay
    }

    ToolTip  ; Clear tooltip
    Return
}

RunGame() {
    gameActionDelay := 25 ; delay between actions in milliseconds
    maxActionDelay := 3500 ; max time between successful actions before game is over

    ToolTip, "Running Game`nHold Escape To Stop", 1580, 400

    lastAction := A_TickCount
    while (A_TickCount - LastAction < maxActionDelay) {
        if (CheckEndGame()) {
            ToolTip ; Clear ToolTip
            Return ; End process
        }

        ; Search for and click on good clouds
        PixelSearch, FoundX, FoundY, 10, 40, 775, 1150, 0x543F80, 0, Fast RGB
        if ErrorLevel = 0
        {
            Click %FoundX%, %FoundY%
            lastAction := A_TickCount
        }

        Sleep, % gameDelay
    }

    ToolTip ; Clear ToolTip
}

CheckStartButton(start_x, start_y) {
    ; notReadyColor := "0x3A3C3B"
    readyColor := "0x665C22"
    readyColorHover := "0x193C42"

    PixelGetColor, FoundColor, %start_x%, %start_y%
    return (FoundColor = readyColor or FoundColor = readyColorHover)
}

CheckEndGame() {
    GetKeyState, EndCheck, Escape, P
    Return (EndCheck = "D")
}

#IfWinActive ahk_exe SpaceIdle.exe
^!+r::  ; Ctrl-Alt-Shift-R To run the event
    RunEvent()
Return
#IfWinActive
