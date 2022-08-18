merchantRpgLoop(loops := 0) {


    wait := 250

    task_x := 605
    task_y_array_1 := [215, 365, 515, 665, 815]
    task_y_array_2 := [285, 435, 585, 735, 885]
    task_y_array_3 := [220, 370, 520, 670, 820]


    i := 0
    while (WinActive("ahk_exe Merchant.exe") AND (loops = 0 OR (loops > 0 AND i < loops))) {
        resetUi(wait)
        for index, task_y in task_y_array_1 {
            checkAndCompleteTask(task_x, task_y, wait)
        }

        scrollDown(5, wait)
        for index, task_y in task_y_array_2 {
            checkAndCompleteTask(task_x, task_y, wait)
        }

        scrollDown(6, wait)
        for index, task_y in task_y_array_3 {
            checkAndCompleteTask(task_x, task_y, wait)
        }

        i += 1
    }
}

checkAndCompleteTask(x, y, wait) {
    conf_x := 620
    conf_y := 200

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

scrollDown(num, wait) {
    ; Center mouse or scroll doesn't work
    MouseMove 275, 425

    i := 0
    while i < num {
        SendWait("{WheelDown}", 100)
        i += 1
    }
}

resetUi(wait) {
    ; Reset UI to proper size and location
    WinMove, ahk_exe Merchant.exe, , -1930, 0, 690, 1050

    ; Center mouse or scroll doesn't work
    MouseMove 275, 425

    i := 0
    while i < 12 {
        SendWait("{WheelUp}", 100)
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
        ClickWait("", "", 1, 10)

        i += 1
    }
}



#IfWinActive, ahk_exe Merchant.exe
^1::merchantRpgLoop()
^2::clickFast(502)
#IfWinActive ; End #IfWinActive
