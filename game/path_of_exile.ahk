#IfWinActive, ahk_exe PathOfExile_x64Steam.exe

attack_in_place(key) {
    Send {F10 down}
    if (key = "rbutton") {
        Click, right
    } else {
        Send, % key
    }
    Send, {F10 Up}
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
