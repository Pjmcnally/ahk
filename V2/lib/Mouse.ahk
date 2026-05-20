#Requires AutoHotkey v2.0

ClickWait(x, y, num, wait) {
    Click(x, y, num)
    Sleep(wait)
}
