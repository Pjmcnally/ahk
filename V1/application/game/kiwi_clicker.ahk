#IfWinActive ahk_exe Kiwi Clicker.exe

upgrade_all(loop_count:=1, loop_delay:=1000, send_delay:=25) {
    keys := ["q", "w", "e", "r", "t"]
    upgrade_max = "4"

    loop, % loop_count {
        for i, key in keys {
            SendWait(key, send_delay)  ; Open upgrade window
            SendWait(upgrade_max, send_delay)  ; By max upgrade
            SendWait(key, send_delay)  ; Close upgrade window
        }

        ; Rotate list
        last_key := keys.Pop()
        keys.InsertAt(1, last_key)

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
    Return
}

auto_play(is_archery, loop_size) {
    if (!is_archery) {
        repeat_keys()
    }


    loop {
        WinActivate, ahk_exe Kiwi Clicker.exe
        WinWaitActive, , , , 5,
        ; MouseMove, 2050, 1035, 1  ; Speed Up Target
        upgrade_all(loop_size)

        WinActivate, ahk_exe Kiwi Clicker.exe
        WinWaitActive, , , , 5,
        MouseMove, 1500, 475, 1
        MoveMouseSlowly(2250, 475, 100000)

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

fast_key(key) {
    Send, % key
}

repeat_keys() {
    fast_space := Func("Fast_Key").Bind("{Space}")
    SetTimer, % fast_space, 10

    fast_s := Func("Fast_Key").Bind("s")
    SetTimer, % fast_s, 10

    ; fast_click := Func("Fast_Key").Bind("{LButton}")
    ; SetTimer, % fast_click, 10
}

MButton::Reload
XButton1::auto_play(true, 60)
XButton2::upgrade_all(60)

#IfWinActive
