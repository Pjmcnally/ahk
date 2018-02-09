; This is a hotstring to automatically open packs in Hearthstone
; Designed to work on 1920 x 1080 interface

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
    num_packs := getNumPacks()
    sleep, % 1000  ; wait for dialog to fully close.
    while num_packs > 0 {
        openPack()
        num_packs -= 1
    }
}


getNumPacks() {
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

; This should always be at the bottom
#IfWinActive ; End #IfWinActive for Hearthstone
