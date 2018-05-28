#IfWinExist, ahk_exe ahk_exe EoCApp.exe

always_show_loot() {
    keybind := get_asl_keybind()
    gui_name := "AslGui"
    word_status := {0: "Off", 1: "On"}
    game := "ahk_exe EoCApp.exe"

    if GetKeyState(keybind) {
        Send {%keybind% up}
    } else {
        Send {%keybind% down}
    }

    gui_id := get_gui_id(gui_name)
    if (gui_id = "0x0") {  ; "0x0" is returned if gui doesn't exist
        build_aip_gui(word_status[GetKeyState(keybind)])
    } else {
        update_gui(gui_name, word_status[GetKeyState(keybind)])
    }

    winActivate, % game
}

get_asl_keybind() {
    return "F10"
}

build_asl_gui(state) {
    Gui, AslGui:New, ,
    Gui, AslGui:Color, green
    Gui, AslGui:+AlwaysOnTop
    Gui, AslGui:+Border
    Gui, AslGui:-SysMenu
    Gui, AslGui:+ToolWindow
    Gui, AslGui:Show, h0 w25 NoActivate, % state
}

$F10::
    attack_in_place()
return

#IfWinExist
