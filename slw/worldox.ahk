; navigates through workdox save UI and fills in blanks
worldoxSave(desc, doc_type) {
    num := splitMatterNum(clipboard)
    SendInput % num["raw"] " " desc
    SendInput {Tab}{Tab}
    SendInput % doc_type
    SendInput {Tab}
    SendInput % num["client_num"]
    SendInput {Tab}
    SendInput % num["family_num"]
    SendInput {Tab}
    SendInput % num["c_code"]
    SendInput {Tab}
    SendInput % num["cont_num"]
    SendInput {Tab}{Tab}{Tab}{Enter}
}

; Splits matter number and returns parts.
splitMatterNum(str) {
    ; Matter numbers exist is a format of CCCC.FFFIIN or CCC.FFFIIN
    ; They infrequently appear as CCCC.FFFINN, CCC.FFFINN
    ; where CCCC or CCC = client number, FFF = family number, I or II = country code
    ; and N or NN = continuation number.

    ; test to ensure string has 11 digits cancel if not.
    len := StrLen(str)
    if (len != 11 and len != 10) {
        MsgBox Invalid Matter Number
        Exit
    }

    ; break string into client number and remainder.
    num_array := StrSplit(str, ".")
    client_num := num_array[1]

    remainder := num_array[2]
    family_num := SubStr(remainder, 1, 3)

    ; extract c_temp and check for char "U"
    ; for this purpose US should always be the right answer
    c_temp := SubStr(remainder, 4, 2)
    if InStr(c_temp, "U") {
        c_code := "US"
    } else {
        MsgBox Invald country
        Exit
    }

    ; check if c_temp contains digits.  If no grab 1 digit.  If yes grab both
    if c_temp is alpha
        cont_num := SubStr(remainder, 6, 1)
    if c_temp is not alpha
        cont_num := SubStr(remainder, 5, 2)

    num := {"raw": str, "client_num": client_num, "family_num": family_num, "c_code": c_code, "cont_num": cont_num}
    return num
}


; ------------------------------------------------------------------------------
; ------------------------------------------------------------------------------
; Hotstrings

; Worldox save hotstrings
:co:wcomm::
    worldoxSave("IDS Comm", "ids")
return

:co:wccca::
    worldoxSave("IDS CCCA", "comm")
return

:co:wxmit::
    worldoxSave("IDS Xmit", "xmit")
return

:co:w1449::
    worldoxSave("IDS 1449", "ids")
return

:co:wnum::
    num := splitMatterNum(clipboard)
    Send, {Tab}
    SendInput % num["client_num"]
    SendInput {Tab}
    SendInput % num["family_num"]
    SendInput {Tab}
    SendInput % num["c_code"]
    SendInput {Tab}
    SendInput % num["cont_num"]
    SendInput {Enter}
return
