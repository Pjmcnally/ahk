#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\..\Lib\Internal"
#Include "Mouse.ahk"
#Include "Keyboard.ahk"

; TODO: Document and clean up this file
;@region Obsolete functions
/*
    ; This is now obsolete as I have an official function within the game that covers it.
UpgradeDilation(activeArray := [1, 2, 3, 4, 5, 6, 7, 8, 9]) {
    wait := 100

    buttonArray := [
        () => Mouse.ClickWait(350, 875, 1, wait),
        () => Mouse.ClickWait(1090, 875, 1, wait),
        () => Mouse.ClickWait(1800, 875, 1, wait),
        () => Mouse.ClickWait(350, 1095, 1, wait),
        () => Mouse.ClickWait(1090, 1095, 1, wait),
        () => Mouse.ClickWait(1800, 1095, 1, wait),
        () => Mouse.ClickWait(350, 1300, 1, wait),
        () => Mouse.ClickWait(1090, 1300, 1, wait),
        () => Mouse.ClickWait(1800, 1300, 1, wait)
    ]

    ToggleDilation()
    for key, value in activeArray {
        buttonArray[key]()
    }
}

ToggleDilation(duration := 10, force := false) {
    if (Mod(A_Sec, duration) = 0 or force) {
        Mouse.ClickWait(375, 335, 1, 100) ; click Dilation button
    }
}

RotateZodiacs() {
    wait := 100
    keyDelay := 3
    mouseMode := "Left"
    originalSendMode := A_SendMode

    ; Set SendMode to "Event" to work in game
    SendMode "Event"

    funcArgs := [
        [mouseMode, 1565, 720, 100, 1290, keyDelay],
        [mouseMode, 1665, 720, 280, 1290, keyDelay],
        [mouseMode, 1765, 720, 460, 1290, keyDelay],
        [mouseMode, 1865, 720, 640, 1290, keyDelay],
        [mouseMode, 1965, 720, 820, 1290, keyDelay],
        [mouseMode, 2065, 720, 1000, 1290, keyDelay],
        [mouseMode, 1565, 820, 1180, 1290, keyDelay],
        [mouseMode, 1665, 820, 1360, 1290, keyDelay],
        [mouseMode, 1765, 820, 1540, 1290, keyDelay],
        [mouseMode, 1865, 820, 1720, 1290, keyDelay],
        [mouseMode, 1965, 820, 1900, 1290, keyDelay],
        [mouseMode, 2065, 820, 2080, 1290, keyDelay]
    ]

    ; Activate "Main" Screen
    Mouse.ClickWait(2315, 185, 1, wait)
    Send("S") ; Send "S" to Stop Macro

    ; Activate "Unity" screen
    Mouse.ClickWait(2315, 285, 1, wait)
    ; Click "Astrology" panel
    Mouse.ClickWait(129, 190, 1, wait)
    ; Close "Planet Shop" (if open)
    Mouse.ClickWait(60, 315, 1, wait)

    ; Swap Zodiac by position.
    for index, val in funcArgs {
        MouseClickDrag(val*)
        Sleep(wait)
    }

    ; Activate "Main" Screen
    Mouse.ClickWait(2315, 185, 1, wait)
    Send("M") ; Send "M" to Start Macro

    ; Restore SendMode to default for consistency.

*/
;@endregion

;@region Functions to move to utility class
; TO DO: Migrate this to a different module.
ToggleFunc(function, name, timer:=1000) {
    static statusMap := Map()
    statusMap.Default := false

    ; Flip Toggle Status
    statusMap[name] := !statusMap[name]

    if (statusMap[name]) {
        SetTimer(function, timer) ; Set time to repeat execution of the function.
        ToolTip("Running: " . name, 0, 0)
        function() ; Execution function immediately or it will need to wait for the time to expire first.
    } else {
        ; Clear Timer and ToolTip.
        SetTimer(function, 0)
        ToolTip()
    }
}

/**
 * Displays a countdown timer inside a ToolTip.
 * @param seconds - Total duration of the countdown in seconds.
 * @param message - Optional text to display alongside the timer.
 */
TooltipCountdown(seconds, message := "Time remaining: {:d}s", callback := (*) => "") {
    ; Create a static variable to keep track of the remaining time across function calls
    static timeLeft := 0
    timeLeft := seconds

    ; Define the nested function that updates the tooltip every second
    UpdateTooltip() {
        if (timeLeft > 0) {
            toolTipMessage := Format(message, timeLeft)
            ToolTip(toolTipMessage, 0, 0)
            timeLeft -= 1 ; hard coded for 1 second
        } else {
            ToolTip() ; Turn off the tooltip when finished
            SetTimer(UpdateTooltip, 0) ; Turn off this timer
            callback()
        }
    }

    ; Run the first update immediately, then set a 1-second interval timer
    UpdateTooltip()
    SetTimer(UpdateTooltip, 1000) ; hard coded for 1 seconds (1000 milliseconds)
}

;@endregion

;@region Zodiac
RefineZodiac() {
    wait := 100
    keyDelay := 4
    mouseMode := "Left"
    originalSendMode := A_SendMode

    ; Set SendMode to "Event" to work in game
    SendMode "Event"

    ; Move item from "Results" to "Redistribute"
    MouseClickDrag(mouseMode, 535, 1275, 535, 905, keyDelay)

    ; Click "Redistribute"
    Mouse.ClickWait(545, 1145, 1, wait)

    ; Mouse over result
    Mouse.ClickWait(535, 1275, 0, wait)

    ; Restore SendMode to default for consistency.
    SendMode originalSendMode
}

RefineZodiacLoop(loopCount) {
    i := 0
    while (i < loopCount) {
        RefineZodiac()
        i += 1
    }
}
;@endregion

;@region Minerals
UpgradePolish(wait) {
    ;@region HelperFunctions
    ClickPolish(wait) {
        Mouse.ClickWait(1880, 1100, 1, wait)
    }

    ClickPrestige(wait) {
        Mouse.ClickWait(1425, 475, 1, wait)
    }

    SpendPrestige(wait) {
        Mouse.ClickWait(1875, 1245, 1, wait)
    }

    ExitPolish(wait) {
        Mouse.ClickWait(2100, 350, 1, wait)
    }

    ClickWeapon(weapon, wait) {
        y := 900

        switch weapon {
            case "Sword":
                x := 200
            case "Axe":
                x := 525
            case "Spear":
                x := 865
            case "Bow":
                x := 1195
            case "Knuckles":
                x := 1520
        }

        Mouse.ClickWait(x, y, 1, wait)
    }
    ;@endregion

    ClickPolish(wait)
    ; ClickWeapon("Sword", wait)
    Loop 3 {
        ClickPrestige(wait)
        ; SpendPrestige(wait)
    }

    ; weaponArray := ["Axe", "Spear", "Bow", "Knuckles"]
    ; for i, val in weaponArray {
    ;     ClickWeapon(val, wait)
    ;     SpendPrestige(wait)
    ; }

    ExitPolish(wait)
}

RefineMinerals(wait) {
    ;@region HelperFunctions
    ClickRefine(wait) {
        Mouse.ClickWait(1880, 1190, 1, wait)
    }

    ClickRefinePrestige(wait) {
        Mouse.ClickWait(1945, 545, 1, wait)
    }

    ConfirmRefine(wait) {
        Mouse.ClickWait(1575, 835, 1, wait)
    }

    ExitRefine(wait) {
        Mouse.ClickWait(75, 315, 1, wait)
    }
    ;@endregion

    ClickRefine(wait)
    ClickRefinePrestige(wait)
    ConfirmRefine(wait)
    ExitRefine(wait)
}

AutoRefine(refineDelay, wait) {
    UpgradePolish(wait)

    ToolTipCountDown(refineDelay, "Time until Refine: {:d}s", () => RefineMinerals(wait))
}

AutoRefineLoop(refineDelay := 0, wait := 250) {
    while true {
        UpgradePolish(wait)

        startTime := A_TickCount
        duration := refineDelay * 1000

        while (A_TickCount - startTime < duration) {
            elapsed := A_TickCount - startTime
            remaining := Round((duration - elapsed) / 1000)

            ToolTip(Format("Time until Refine: {:d}s", remaining), 0, 0)
            Sleep(100)
        }

        ToolTip()
        RefineMinerals(wait)
        Sleep(500) ; Extra sleep for stability to allow changing screens before looping.
    }
}
;@endregion

;@region Hotkeys
#HotIf WinActive("ahk_exe Revolution Idle.exe")

; space::AutoRefineLoop()
space::RefineZodiac()
; space::RefineZodiacLoop(100)
; F2::ToggleFunc(() => UpgradeDilation([1, 2]), "Upgrade Dilation (1 & 2)", 250)

F1::SendEvent("SM") ; Reset Macro.

#HotIf
;@endRegion
