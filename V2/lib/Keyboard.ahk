#Requires AutoHotkey v2.0

SendWait(msg, wait, literal:=false) {
    if literal {
        SendText(msg)
    } else {
        Send(msg)
    }

    Sleep(wait)
}
