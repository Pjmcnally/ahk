#IfWinActive, ahk_exe Hades2.exe

; Joy10::hadesSaveArchive.restoreMostRecentSave()
; Joy3::gunReload()  ; Hestia - Shoot and reload
; Joy4::gunReload()  ; Other guns - Special and reload
Joy10::hades.copyCurrentSaveToBackup()
Space::hades.copyCurrentSaveToBackup()

#IfWinActive  ; Reset IfWinActive

^!+b::hades.restoreMostRecentSave()
