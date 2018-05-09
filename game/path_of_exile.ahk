#IfWinExist, ahk_exe PathOfExile_x64Steam.exe

attack_in_place() {
    keybind := get_aip_keybind()
    gui_name := "AipGui"
    word_status := {0: "Off", 1: "On"}
    game := "ahk_exe PathOfExile_x64Steam.exe"

    if GetKeyState(keybind) {
        Send {%keybind% up}
    } else {
        Send {%keybind% down}
    }

    gui_id := get_gui_id(gui_name)
    if (gui_id = "0x0") {  ; "0x0" is returned if gui doesn't exist
        build_aip_gui(word_status[GetKeyState(keybind)])
    } else {
        update_aip_gui(word_status[GetKeyState(keybind)])
    }

    winActivate, % game
}

get_aip_keybind() {
    return "F10"
}

build_aip_gui(state) {
    Gui, AipGui:New, ,
    Gui, AipGui:Color, green
    Gui, AipGui:+AlwaysOnTop
    Gui, AipGui:+Border
    Gui, AipGui:-SysMenu
    Gui, AipGui:Show, h0 w25, % state
}

update_aip_gui(state) {
    Gui, AipGui:Show, , % state
}

get_gui_id(gui_name) {
    Gui, %gui_name%:+LastFoundExist
    return WinExist()  ; return ID of the lastfound window or "0x0" if not found
}

destroy_gui(gui_name) {
    Gui, %gui_name%:Destroy
    return
}

$F10::
    attack_in_place()
return

#IfWinExist

; This is outside of #IfWinExist so I can kill this after I close the game
+F10::
    destroy_gui("AipGui")
    Send, {get_aip_keybind() Up}
return
