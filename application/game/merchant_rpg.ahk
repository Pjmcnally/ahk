; Auto-Execute Section (All core Auto-Execute commands should go here)
; ==============================================================================
#SingleInstance, Force              ; Automatically replaces old script with new if the same script file is rune twice
#NoEnv                              ; Avoids checking empty variables to see if they are environment variables (recommended for all new scripts).
#Warn                               ; Enable warnings to assist with detecting common errors. (More explicit)
#Hotstring EndChars `n `t           ; Limits hotstring ending characters to {Enter}{Tab}{Space}
SendMode Input                      ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir, %A_ScriptDir%\..     ; Ensures a consistent starting directory. Relative path to AHK folder from core.ahk.
SetTitleMatchMode, 2                ; 2: A window's title can contain WinTitle anywhere inside it to be a match.

enableHeroLoop(delay) {
    delay := delay * 1000
    SetTimer, heroLoop, % delay

    heroLoop()  ; Execute immediately
}

heroLoop() {
    wait := 250

    ; Advance and reset time
    advanceTime("23:00:00")
    Sleep, % wait
    resetTime()

    scrollUi("Up", 20)
    task_x_offSet := 260
    task_x := task_x_offSet + getMiddleX()

    ; These values all assume app is 1020 px high
    task_y_array_1 := [215, 365, 515, 665, 815]
    for index, task_y in task_y_array_1 {
        checkAndCompleteTask(task_x, task_y, wait)
    }

    task_y_array_2 := [285, 435, 585, 735, 885]
    scrollUi("Down", 5)
    for index, task_y in task_y_array_2 {
        checkAndCompleteTask(task_x, task_y, wait)
    }

    ; task_y_array_3 := [220, 370, 520, 670, 820]
    ; scrollUi("Down", 6)
    ; for index, task_y in task_y_array_3 {
    ;     checkAndCompleteTask(task_x, task_y, wait)
    ; }

    ; task_y_array_4 := [555, 695, 845]
    ; scrollUi("Down", 5)
    ; for index, task_y in task_y_array_4 {
    ;     checkAndCompleteTask(task_x, task_y, wait)
    ; }
}

checkAndCompleteTask(x, y, wait) {
    conf_x := 275 + getMiddleX()
    conf_y := 200  ; To Do base off GetMiddleY()

    if (checkTaskComplete(x, y)) {
        ClickWait(x, y, 1, wait)

        if (checkTaskRestart(conf_x, conf_y)) {
            Sleep, % wait
            ClickWait(conf_x, conf_y, 1, wait)
        } else {
            Sleep, % wait
            Send {Escape}
        }

    } else {
        Sleep, % wait
    }
}

scrollUi(mode, num) {
    ; Center mouse or scroll doesn't work
    MouseMove getMiddleX(), getMiddleY()

    i := 0
    while i < num {
        cmd := "{Wheel" . mode . "}"
        SendWait(cmd, 100)
        i += 1
    }
}

checkTaskComplete(x, y) {
    PixelGetColor, c_val, x, y
    return (c_val = 0x171761)
}

checkTaskRestart(x, y) {
    PixelGetColor, c_val, x, y
    return c_val = 0x7088A5 OR c_val = 0x3998CA
}

clickFast(num) {
    i := 1
    while i < num {
        ClickWait("", "", 1, 5)

        i += 1
    }
}

stockShop(itemCount) {
    wait := 100
    MouseGetPos , x, y

    conf_x := 245 + GetMiddleX()
    conf_y := 1000  ; To Do base off GetMiddleY()

    i := 0
    While (i < itemCount) {
        ClickWait(x, y, 1, wait)
        ClickWait(conf_x, conf_y, 2, wait)

        i += 1
    }
}

clearShop() {
    wait := 100
    yVals := [250, 435, 625]  ; To Do base off GetMiddleY()
    xOffsetVals := [-210, -70, 80, 230]

    for i, y in yVals {
        for j, x in xOffsetVals {
            ClickWait(GetMiddleX() + x, y, 2, wait)
        }
    }
}

stockSellLoop(loopCount) {
    wait := 100
    MouseGetPos , x, y ; Get original x,y

    i := 0
    while (i < loopCount) {
        MouseMove, % x, % y
        stockShop(12)

        ; Advance and reset time
        advanceTime("23:00:00")
        Sleep, % wait
        resetTime()
        Sleep, 2500

        ; Clear shop
        SendWait("{Escape}", wait)
        ClickWait(1050, 975, 1, wait)
        clearShop()

        ; Navigate back to Stock
        SendWait("{Escape}", wait)
        ClickWait(875, 975, 1, wait)

        i += 1
    }

}

craftBasic(itemArray, loops := 1) {
    wait := 100

    x := GetMiddleX()
    conf_x := (260 + getMiddleX())
    yVals := [220, 370, 520, 670]

    loopCount := 0
    while (loopCount < loops) {
        ; Clear previously completed
        for i, y in yVals {
            if (checkTaskComplete(conf_x, y)) {
                clickWait(conf_x, y, 1, wait)
                clickWait(conf_x, y, 1, wait)
            }
        }

        ; Start new crafts
        for i, item in itemArray {
            y := yVals[item]

            clickWait(conf_x, y, 1, wait)
            clickWait(x, 500, 1, wait)  ; Select item to craft (2nd item in list)
            clickWait(conf_x, 1000, 1, wait)  ; Click "confirm" button
        }

        advanceTime("00:15:00")
        Sleep, % wait
        resetTime()
        Sleep, 2500

        loopCount += 1
    }
}

advanceTime(duration) {
    Run *RunAs Powershell.exe -NoProfile -NoLogo -Command "& {Set-Date -Adjust %duration% }", , hide
}

resetTime() {
    Run *RunAs Powershell.exe -NoProfile -NoLogo -Command "& {W32tm /resync /force}", , hide
}

getMiddleX() {
    WinGetPos, x, y, width, height, ahk_exe Merchant.exe
    return Floor(width/2)
}

getMiddleY() {
    WinGetPos, x, y, width, height, ahk_exe Merchant.exe
    return Floor(height/2)
}

ClickWait(x, y, num, wait) {
    Click, %x%, %y%, %num%
    Sleep, % wait
}

SendWait(msg, wait) {
    Send % msg
    Sleep % wait
}

#IfWinActive, ahk_exe Merchant.exe
*1::enableHeroLoop(10)
*2::clickFast(502)
*3::craftBasic([1, 2, 3, 4], 16)  ; 16 x 4 = current max
*4::stockShop(6)
*5::clearShop()
*6::advanceTime("23:59:00")
*7::advanceTime("02:00:00")
*8::advanceTime("00:30:00")
*9::advanceTime("00:05:00")
*0::resetTime()
*-::stockSellLoop(5)

#IfWinActive ; End #IfWinActive

^!r::Reload  ; Reload all scripts.
