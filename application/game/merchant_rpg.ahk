enableHeroLoop() {
    delay := 12000 ; 12 seconds
    SetTimer, heroLoop, % delay

    heroLoop()  ; Execute immediately
}

heroLoop() {
    wait := 250

    task_x_offSet := 260
    task_x := task_x_offSet + getMiddleX()

    ; These values all assume app is 1020 px high
    task_y_array_1 := [215, 365, 515, 665, 815]
    task_y_array_2 := [285, 435, 585, 735, 885]
    task_y_array_3 := [220, 370, 520, 670, 820]
    task_y_array_4 := [555, 695, 845]

    scrollUi("Up", 20, wait)
    for index, task_y in task_y_array_1 {
        checkAndCompleteTask(task_x, task_y, wait)
    }

    scrollUi("Down", 5, wait)
    for index, task_y in task_y_array_2 {
        checkAndCompleteTask(task_x, task_y, wait)
    }

    scrollUi("Down", 6, wait)
    for index, task_y in task_y_array_3 {
        checkAndCompleteTask(task_x, task_y, wait)
    }

    scrollUi("Down", 5, wait)
    for index, task_y in task_y_array_4 {
        checkAndCompleteTask(task_x, task_y, wait)
    }
}

checkAndCompleteTask(x, y, wait) {
    conf_x := 275 + getMiddleX()
    conf_y := 200  ; To Do base off GetMiddleY()

    if (checkTaskComplete(x, y)) {
        ClickWait(x, y, 1, wait)

        if (checkTaskRestart(conf_x, conf_y)) {
            ClickWait(conf_x, conf_y, 1, wait)
        } else {
            Send {Escape}
        }

    } else {
        Sleep, % wait
    }
}

scrollUi(mode, num, wait) {
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
    While (i <= itemCount) {
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

craftBasic(itemArray) {
    wait := 100

    x := GetMiddleX()
    yVals := [220, 370, 520, 670]

    ; Clear previously completed
    for i, y in yVals {
        if (checkTaskComplete(x, y)) {
            clickWait(x, y, 1, wait)
            clickWait(x, y, 1, wait)
        }
    }

    ; Start new crafts
    for i, item in itemArray {
        y := yVals[item]

        clickWait(x, y, 1, wait)
        clickWait(350, 500, 1, wait)  ; Select item to craft (2nd item in list)
        clickWait(600, 1000, 1, wait)  ; Click "confirm" button
    }

    advanceTime("00:05:00")
}

advanceTime(duration) {
    RunWait *RunAs Powershell.exe -NoProfile -NoLogo -Command "& {Set-Date -Adjust %duration% }", , hide
}

resetTime() {
    RunWait *RunAs Powershell.exe -NoProfile -NoLogo -Command "& {W32tm /resync /force}", , hide
}

getMiddleX() {
    WinGetPos, x, y, width, height, ahk_exe Merchant.exe
    return Floor(width/2)
}

getMiddleY() {
    WinGetPos, x, y, width, height, ahk_exe Merchant.exe
    return Floor(height/2)
}

powerLevel() {
    wait := 250
    longWait := 1000

    task_x_offSet := 260
    task_x := task_x_offSet + getMiddleX()
    task_y_array := [255, 400, 555, 700, 850]

    while (true) {
        resetTime()
        sleep, % longWait

        for index, task_y in task_y_array {
            checkAndCompleteTask(task_x, task_y, wait)
        }

        advanceTime("01:00:00")
        sleep, % longWait
    }
}

#IfWinActive, ahk_exe Merchant.exe
*1::enableHeroLoop()
*2::clickFast(502)
*3::craftBasic([1, 2, 3, 4])
*4::stockShop(12)
*5::clearShop()
*6::advanceTime("23:59:00")
*7::advanceTime("02:00:00")
*8::advanceTime("00:30:00")
*9::advanceTime("00:05:00")
*0::resetTime()
*-::powerLevel()

#IfWinActive ; End #IfWinActive
