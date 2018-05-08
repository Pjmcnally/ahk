#IfWinActive, ahk_exe PathOfExile_x64Steam.exe

attack_in_place(pressed_key) {
    keybind := "F10"

    Send {%keybind% down}
    if (key = "rbutton") {
        Click, right
    } else {
        Send, % pressed_key
    }
    Send, {%keybind% Up}
}

rbutton::
t::
r::
e::
w::
q::
    attack_in_place(A_ThisHotKey)
Return

#IfWinActive
