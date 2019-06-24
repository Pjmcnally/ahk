getItemName(str) {
    /*  Items can be copied in PoE by mousing over and pressing ctrl-c. The
        items name is always on the second line.

        This function extracts the items name to be used in certain websites.
    */

    Array := StrSplit(str, "`r", "`n")
    Return Array[2]
}

checkPoePrice() {
    name := getItemName(clipboard)
    ; link := buildPoeNinjaLink(name)

    Send, ^a
    Send, % name
    Send, {Enter}
}

checkPoeMap() {
    item := get_highlighted()
    map_properties := StrSplit(item, "`r", "`n")

    bad_statuses := ["Players are Cursed with Temporal Chains", "Players cannot Regenerate Life, Mana or Energy Shield"]
    bad_results := ""

    for index, elem in map_properties {
        if (HasVal(bad_statuses, elem)) {
            bad_results := bad_results . elem . "`r`n"
        }
    }

    if (StrLen(bad_results) > 0) {
        MsgBox, % "Re-Roll map:`r`n" . bad_results
    } else {
        MsgBox, , % "Run", % "Good to Go." , .5
    }
}

#IfWinActive, ahk_exe PathOfExile_x64Steam.exe
^+c::  ; Ctrl-Alt-C Check Map statuses
    checkPoeMap()
Return
#IfWinActive

#IfWinActive, poe.ninja - Mozilla Firefox
^v::  ; Override ctrl-v for just this website only in Firefox
    checkPoePrice()
Return
#IfWinActive

#IfWinActive, PoE Goods - Mozilla firefox
^v::  ; Override ctrl-v for just this website only in Firefox
    checkPoePrice()
Return
#IfWinActive
