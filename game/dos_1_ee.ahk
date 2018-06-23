/*  This was an attempt to always show dropped loot in Divinity OS 1. It didn't
    work as indended due to the way the game works. However, it was an
    interesting experiment with GUI creation and use so I want to archive the
    file.
*/

#IfWinActive, ahk_exe ahk_exe EoCApp.exe

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

get_gui_id(gui_name) {
    Gui, %gui_name%:+LastFoundExist
    return WinExist()  ; return ID of the lastfound window or "0x0" if not found
}

destroy_gui(gui_name) {
    Gui, %gui_name%:Destroy
    return
}

update_gui(gui_name, state) {
    Gui, %gui_name%:Show, NoActivate, % state
}

#IfWinActive
