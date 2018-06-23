getItemName(str) {
    /*  Items can be copied in PoE by mousing over and pressing ctrl-c. The
        items name is alwasy on the second line.

        This function extracts the items name to be used in certain websites.
    */

    Array := StrSplit(str, "`r", "`n")
    return Array[2]
}

checkPoePrice() {
    name := getItemName(clipboard)
    ; link := buildPoeNinjaLink(name)

    Send, ^a
    Send, % name
    Send, {Enter}
}

#IfWinActive, poe.ninja - Google Chrome

^v::  ; Override ctrl-v for just this website only in Chrome
    checkPoePrice()
return

#IfWinActive
