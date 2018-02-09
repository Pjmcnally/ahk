; This is a gear switcher I made for Diable 3.  It allows be to quickly switch
; from 1 set of gear to another.

; As of Diablo patch 2.5 (season 10) This will be obsolete. As they are
; introducing this functionality in game with a better interface.

#IfWinActive, Diablo III
F1:: ;Gear Switcher
    BlockInput, On
    SetMouseDelay, 20
    ; Rings
    Click 261, 587, down
    Click 1644, 388, up
    Click 268, 646, down
    Click 1831, 384, up
    ; Amulet
    Click 320, 593, down
    Click 1812, 231, up
    ; Belt
    Click 324, 657, down
    Click 1742, 348, up
    ; Main hand
    Click 377, 622, down
    Click 1641, 477, up
    ; Off hand
    Click 434, 621, down
    Click 1836, 473, up
    ; Return off-hand
    Click 1428, 610, down
    Click 434, 621, up
    ; Helm
    Click 91, 738, down
    Click 1737, 198, up
    ; Shoulders
    Click 148, 738, down
    Click 1661, 225, up
    ; Chest
    Click 205, 738, down
    Click 1736, 280, up
    ; Gloves
    Click 262, 738, down
    Click 1638, 316, up
    ; Bracers
    Click 319, 738, down
    Click 1836, 317, up
    ; Pants
    Click 376, 738, down
    Click 1737, 411, up
    ; Boots
    Click 433, 738, down
    Click 1739, 483, up
    send, {space}
    BlockInput, Off
return

; This should always be at the bottom
#IfWinActive ; End #IfWinActive for Diablo 3
