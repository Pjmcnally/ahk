/*  This is an experiment I am doing with building a gui for a log viewer that
will be part of another project.

The result of this test is that it works. However, the output ignores newlines.
In order to properly display the text you have to split it on newlines manually.

The other issue is that it is impossible to select multiple lines of text.
*/

#SingleInstance force ; Adding this prevented me getting the "You're already running that script " prompt.

; Setup Gui
Gui, Add, ListView, x10 y10 w500 h500 vConsole, Log
Gui, Show, , Log Viewer

; Generate arbitrary content to fill log viewer
i := 0
While (i <= 1000) {
    i += 1
    log("Number is :`r`n                  " . i)
}

Gui, Destroy ; Close the logging window
ExitApp

;Function that writes to the log viewer.
log(msg) {
    Loop, parse, msg, `n, `r
    {
        LV_Modify(LV_Add(, A_LoopField), "Vis")
        ; Sleep, 10
    }
}

Return
