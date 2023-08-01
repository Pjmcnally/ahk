; ^!+b::brotatoSaveArchive.restoreMostRecentSave()
; Joy10::brotatoSaveArchive.restoreMostRecentSave()

#IfWinActive, ahk_exe Brotato.exe
Joy10::brotatoSaveArchive.copyCurrentSaveToBackup()
Space::brotatoSaveArchive.copyCurrentSaveToBackup()

#IfWinActive  ; Reset IfWinActive
