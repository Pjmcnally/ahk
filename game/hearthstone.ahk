/*  This is a hotstring to automatically open packs in Hearthstone
    Designed to work on 1920 x 1080 interface
*/

#IfWinActive, Hearthstone

^!h::
    ; With these updated timings this script takes longer but is much more consistent (<.5% failure rate)
    ; wait for hotkey keys to be released
    KeyWait Control
    KeyWait Alt
    KeyWait h

    ; run main function
    SetMouseDelay 50  ; To be modified for this script
    main()
    SetMouseDelay 10  ; Return to default value
return


main() {
    WinActivate Hearthstone
    WinWaitActive Hearthstone

    num_packs := getNumPacks()
    sleep, % 1000  ; wait for dialog to fully close.
    while num_packs > 0 {
        openPack()
        num_packs -= 1
    }
}


getNumPacks() {
    num = 0
    while num <= 0 {
        InputBox, num, How many packs?, Please enter the number of packs you wish to open.
        if ErrorLevel
            Exit
    }
    return num
}


openPack() {
    cards := {1: {"x": 1125, "y": 250}, 2: {"x": 1500, "y": 375}, 3: {"x": 1325, "y": 825}, 4: {"x": 950, "y": 825}, 5: {"x": 800, "y": 350}}
    card_list := [1, 2, 3, 4, 5]
    shuffle(card_list)

    SendEvent {Space}  ; Open Pack
    sleep, % 5000  ; wait for pack to open
    for key, value in card_list {  ; Click all cards in random order
        x := cards[value]["x"]
        y := cards[value]["y"]
        SendEvent {Click, %x%, %y%}
    }
    Sleep, % 2500  ; wait of OK to appear
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
    return a
}

; This should always be at the bottom
#IfWinActive ; End #IfWinActive for Hearthstone
