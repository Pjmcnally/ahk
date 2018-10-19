/*  This is an experiment I am doing with building a gui for a log viewer that
will be part of another project.

This test uses the Edit box to display the text.

The result of this test is that it works. However, I had issues scrolling the
text to the bottom after adding text. To solve that issue I am using EditPaste
to add the text to the edit window. this means that if anyone clicks in the
window while it is adding content issues will occur.
*/

#SingleInstance force ; Adding this prevented me getting the "You're already running that script " prompt.

; Setup Gui

Gui, Add, Edit, ReadOnly x10 y10 w500 h500 vConsole
Gui, Show, , test window

; Fill content box
i := 0
While (i <= 1000) {
    i += 1
    log("Number is :`r`n                  " . i)
}

Gui, Destroy ; Close the logging window
ExitApp

;Function that writes to the logs. This is where the magic happens.
log(msg) {
    Control, EditPaste, % msg . "`r`n", Edit1, test window
}

Return
