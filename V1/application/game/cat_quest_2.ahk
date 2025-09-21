#IfWinActive, ahk_exe Cat Quest II.exe
/*
Joy1 = B
Joy2 = A
Joy3 = X
Joy4 = Y
*/

repeatFire() {
    SendInput, {Joy3 Up}
    while GetKeyState("Joy3", "P")
    {
        SendInput, {Click}
        Sleep, 100
        SoundBeep, 750, 500
    }
}

Joy3::repeatFire()

#IfWinActive ; Clear "IfWinActive"
