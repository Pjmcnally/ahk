; This is a hotstring to automatically open packs in Hearthstone
; Designed to work on 1920 x 1080 interface

#IfWinActive, Hearthstone

^!h::
; wait for hotkey keys to be released
KeyWait Control
KeyWait Alt
KeyWait h

; run main function
main()
Return


main() {
    num_packs := getNumPacks()
    sleep, % 500  ; wait for dialog to fully close.
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
    ; Set variables for function (I want to OOP this so I dont have to re-create these very time I run the function)
    pick_x := 375, pick_y := 500
    drop_x := 1100, drop_y := 525
    done_x := 1125, done_y := 570

    cards := {1: {"x": 1125, "y": 250}, 2: {"x": 1500, "y": 375}, 3: {"x": 1325, "y": 825}, 4: {"x": 950, "y": 825}, 5: {"x": 800, "y": 350}}
    card_list := [1, 2, 3, 4, 5]
    shuffle(card_list)

    SendEvent {Click, %pick_x%, %pick_y%, down}{Click, %drop_x%, %drop_y%, up}  ; Pickup and drop pack to open.
    sleep, % 3500  ; wait for pack to open
    for key, value in card_list {  ; Click all cards in random order
        x := cards[value]["x"]
        y := cards[value]["y"]
        SendEvent {Click, %x%, %y%}
        delay()
    }
    Sleep, % 1000  ; wait of OK to appear
    SendEvent {Click, %done_x%, %done_y%}
    Sleep, % 1000  ; wait for OK to go away
}


delay() {
    delay := 100 ; base delay for all moves.
    t_v := 500  ; variance for modification of time/sleep

    Random, rand, 0.0, .9999999  ; Get random float between 0 and 1
    Sleep, % delay + floor(rand * t_v)
}
