gunReload() {
    ; This used the keyboard binding instead of gamepad. Both work at the same time.
    KeyWait, Joy3

    Send, {r down}
    sleep 50
    Send, {r up}
}

^!+b::hadesSaveArchive.restoreMostRecentSave()
; Joy10::hadesSaveArchive.restoreMostRecentSave()

#IfWinActive, ahk_exe Hades.exe
; Joy3::gunReload()  ; Hestia - Shoot and reload
; Joy4::gunReload()  ; Other guns - Special and reload
Joy10::hadesSaveArchive.copyCurrentSaveToBackup()
Space::hadesSaveArchive.copyCurrentSaveToBackup()

#IfWinActive  ; Reset IfWinActive
