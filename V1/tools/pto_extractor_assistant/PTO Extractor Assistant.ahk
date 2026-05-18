/*  Automate process of importing the UPDB
*/

; AutoExecute Section (When not imported)
; ==============================================================================
#SingleInstance, force  ; Set Single instance to prevent concurrent execution
#Persistent
New PtoExtractorInterface

; Classes
; ==============================================================================

Class PtoExtractorInterface {
    __New() {
        This.PtoExtractor := "PTO Extractor"
        This.FinishedPopUp := "PTOExtractor Finished"
        This.ErrorPopUp := "Clear Errors"
        This.LoopCount := 0
        This.ToolTipString := "AHK PTO Extractor Assistant`r`n`r`nLoop Count: {1}`r`n`r`nRight Click AHK in taskbar to exit"
        This.CheckFrequency := 100

        ; Set timer attribute / Start timer
        This.Timer := ObjBindMethod(this, "Run")
        timer := this.Timer  ; Not sure why this line is necessary but it is.
        SetTimer, % timer, % this.CheckFrequency,
    }

    run() {
        ToolTip, % Format(This.ToolTipString, This.LoopCount), 25, 25

        ; Check if process finished
        if (WinExist(This.FinishedPopUp)) {
            This.LoopCount += 1

            ; Close popup window
            WinActivate, % This.FinishedPopUp
            WinWaitActive, % This.FinishedPopUp
            Send {Enter}

            ; Update CoordMode for relative clicks
            CoordMode, Mouse, Window

            ; Reset Xml Errors
            WinActivate, % This.PtoExtractor
            WinWaitActive, % This.PtoExtractor
            Click 775, 835

            ; Clear pop up
            WinWaitActive, % This.ErrorPopUp
            Click 275, 125

            ; Restart process
            WinWaitActive, % This.PtoExtractor
            Click 75, 835

            ; Reset CoordMode to default
            CoordMode, Mouse, Screen
        }
    }
}
