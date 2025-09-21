/*  The following is for the mini-game associated with the spaceversery event.

To make this work access the "Accessibility settings for the event and set both "Good"
and "Special" settings to "White". This means we only have to search for 1 color.
*/

RunEvent() {
    WaitTime := 100 ; Wait time in milliseconds
    start_x := 1950
    start_y := 350
    gameCount := 0

    while True
    {
        ; Display tooltip with game info.
        ToolTip, % "Automation Running`nGame: " . gameCount, 1580, 400

        ; If game not active start game
        If CheckStartButton(start_x, start_y)
        {
            ; Click start button
            Click %start_x%, %start_y%
            gameCount += 1
        }

        ; Search for and click on good clouds
        PixelSearch, FoundX, FoundY, 10, 40, 775, 1000, 0xCEBBD1, 3, Fast RGB
        if ErrorLevel = 0
        {
            Click %FoundX%, %FoundY%
        }

        Sleep, % WaitTime
    }
    Return
}

CheckStartButton(x, y) {
    notReadyColor := "0x3A3C3A"
    ; readyColor := "0x665C22"
    ; readyColorHover := "0x193C42"

    PixelGetColor, FoundColor, %x%, %y%
    return (FoundColor != notReadyColor)
}

#IfWinActive ahk_exe SpaceIdle.exe
^!+r::  ; Ctrl-Alt-Shift-R To run the event
    RunEvent()
Return
#IfWinActive
