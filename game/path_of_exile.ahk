#IfWinActive, ahk_exe PathOfExile_x64Steam.exe

attack_in_place(input_hotkey) {
    ; Keybind in game to attack in place
    keybind := "F10"

    ; Trim $ off of hotkey input. Also, stupid 1 indexed strings....
    pressed_key := SubStr(input_hotkey, 2)

    Send {%keybind% down}
    if (pressed_key = "rbutton") {
        Click, right
    } else {
        Send, % pressed_key
    }
    Send, {%keybind% Up}
}

; $ is required for each of these to prevent them from triggering themselves.
$rbutton::
$t::
$r::
$e::
$w::
$q::
    attack_in_place(A_ThisHotKey)
Return

#IfWinActive
