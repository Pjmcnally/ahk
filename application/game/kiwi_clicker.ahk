#IfWinActive ahk_exe Kiwi Clicker.exe

; ##Standard 1cook 1raw queue
upgrade_all(loop_count:=1, loop_delay:=5000) {
    keys := ["q", "w", "e", "r", "t"]
    upgrade_max = "4"

    loop, % loop_count {
        keys := shuffle(keys)
        for i, key in keys {
            SendWait(key, 50)
            SendWait(upgrade_max, 50)
        }

        Send, % keys[keys.Count()] ; Resend last element to close open tab
        Sleep, % loop_delay
    }

    Return
}

shuffle(a) {
    ; This is an implementation of the Fischer-Yates shuffle (in place)
    i := a.length()  ; Arrays are 1-indexed so I don't need to -1 here.
    while (i > 1) {  ; Don't need to swap the last element with itself.
        Random, rand, 0.0, 1.0  ; Get random float between 0 and 1
        j := Ceil(rand * i)  ; Turn float to int between 1 and i.
        temp := a[i], a[i] := a[j], a[j] := temp  ; swap values at i and j in array
        i -= 1
    }
    Return a
}

auto_play() {
    loop {
        WinActivate, ahk_exe Kiwi Clicker.exe
        WinWaitActive, , , , 5,
        MouseMove, 2060, 980, 1  ; Speed Up Target
        upgrade_all(75, 1000)

        WinActivate, ahk_exe Kiwi Clicker.exe
        WinWaitActive, , , , 5,
        MouseMove, 1500, 450, 1
        MoveMouseSlowly(2250, 450, 100000)

        WinActivate, ahk_exe Kiwi Clicker.exe
        WinWaitActive, , , , 5,
        transcend()
    }
}

MoveMouseSlowly(end_x, end_y, speed) {
    MouseGetPos, start_x, start_y

    x_distance := end_x - start_x
    y_distance := end_y - start_y

    x_add := x_distance / speed
    y_add := y_distance / speed

    StartTime := A_TickCount

    MouseMove, start_x, start_y, 0

    Loop, % speed
        MouseMove, start_x += x_add, start_y += y_add, 0

    MouseMove, end_x, end_y, 0
}

transcend() {
    SendWait("g", 100)
    SendWait("g", 100)
}

F5::upgrade_all(75, 1000)
F6::auto_play()

#IfWinActive
