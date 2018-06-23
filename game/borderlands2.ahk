/*  This is my script for auto run in borderlands 2.  Honestly, I just got tired
    of holding down Shift all the time to run so I made this.
*/

;#IfWinActive ahk_class BigHugeClass
;#IfWinActive ahk_class Borderlands 2 (32-bit`, DX9)
#IfWinActive ahk_exe Borderlands2.exe  ; Only run in Borderlands 2

~$w::  ; Start running.
    varint = 0
    Send {shift up}
    Send {shift down}
    Send {shift up}
return


~$s::  ; Stop running.
    if varint {
        varint = 0
        Send {w up}
        Send {shift up}
    }
return


; ~$a::
; if varint {
;     varint = 0
;     Send {w up}
;     Send {shift up}
; }
; return


; ~$d::
; if varint {
;     varint = 0
;     Send {w up}
;     Send {shift up}
; }
; return


t::  ; Stop running.
    if varint {
        varint = 0
        Send {w up}
        Send {shift up}
    } else {
        varint = 1
        Send {w down}
        Send {shift down}
    }
return

; This should always be at the bottom
#IfWinActive ; End #IfWinActive for Borderlands
