#IfWinActive ahk_exe Rocky Idle.exe

autoSlayer(maxTaskCount:=0) {
    static rockyObj := New rockyIdle
    taskCount := 0

    rockyObj.displayToolTips()

    ; while WinActive("Rocky Idle") and (taskCount < maxTaskCount or maxTaskCount = 0) {
    ;     ToolTip, % "Running AutoSlayer - Navigating to Slayer Page"
    ;     slayerObj.GoToPage()

    ;     ToolTip, % "Running AutoSlayer - Checking for new task"
    ;     if (slayerObj.NewTaskAvailable) {
    ;         ToolTip, % "Running AutoSlayer - Getting New Task"
    ;         slayerObj.GetNewTask()
    ;         ToolTip, % "Running AutoSlayer - Getting New Minion"
    ;         slayerObj.GetTaskMinion()
    ;         taskCount += 1
    ;     }

    ;     ToolTip, % "Running AutoSlayer - Activating combat boost if available"
    ;     slayerObj.ActivateCombatBoost()
    ;     Sleep, 2000

    ;     ToolTip, % "Running AutoSlayer - Waiting for task completion - Task: " . taskCount
    ;     Sleep, 2000
    ; }

    ; ToolTip ; Clear ToolTip
}

class rockyIdle {
    __New() {
        this.screens := {main: New Screen({name: "Main"
            , activateButton: "" ; New Button({<FILL IN>})
            , buttonList: ""})} ; { New Button ({<FILL IN>}) }
        this.buttons := {skillBoostButton: New Button({ name: "SkillBoostButton"
            , leftX: 2225
            , rightX: 2270
            , topY: 10
            , botY: 55
            , clickLocation: [2250, 25]
            , searchColor: "0x2F53A8"})
        , slayerBoostButton: New Button({ name: "SlayerBoostButton"
            , leftX: 2225
            , rightX: 2270
            , topY: 60
            , botY: 105
            , clickLocation: [2250, 75]
            , searchColor: "0x2F53A8"})
        , newTaskButton: New Button({ name: "newTaskButton"
            , leftX: 535
            , rightX: 835
            , topY: 1255
            , botY: 1315
            , clickLocation: [675, 1285]
            , searchColor: "0x3D8015"})
        , slayerButton: New Button({ name: "SlayerButton"
            , leftX: 10
            , rightX: 120
            , topY: 655
            , botY: 690
            , clickLocation: [70, 670]
            , searchColor: ""})
        , slayerCurrentTaskButton: New Button({ name: "SlayerCurrentTaskButton"
            , leftX: 740
            , rightX: 780
            , topY: 225
            , botY: 255
            , clickLocation: [760, 240]
            , searchColor: ""})
        , slayerSelectEnemyButton: New Button({ name: "SlayerSelectEnemyButton"
            , leftX: 550
            , rightX: 1270
            , topY: 1330
            , botY: 225
            , clickLocation: []
            , showToolTip: false
            , searchColor: "0x3D8015"})}

        ; Set time for Rocky Idle Window active check
        This.CheckWindowActiveFreq := 100 ; .1 seconds

        ; Set timer attribute / Start timer
        This.Timer := ObjBindMethod(this, "CheckWindowActive")
        timer := this.Timer  ; Not sure why this line is necessary but it is.
        SetTimer, % timer, % this.CheckWindowActiveFreq,
    }

    CheckWindowActive() {
        if !(WinActive("Rocky Idle")) {
            this.hideToolTips()
        }
    }


    GetNewTask() {

    }

    displayToolTips() {
        for key, val in this.buttons {
            val.displayToolTip()
        }
    }

    hideToolTips() {
        for key, val in this.buttons {
            val.hideToolTip()
        }
    }

    GoToPage() {
        ClickWait(100, 675, 1, 100)
        Sleep, 100
    }

    getTaskMinion() {
        this.AccessCurrentTask()
        errorCount := 0
        success := false

        while errorCount < 5 and !success {
            Send, {WheelDown 10}
            sleep, 500 ; Wait for scrolling to complete

            PixelSearch, xPos, yPos, 550, 225, 1270, 1330, % this.ActiveColor, 0, fast
            if ErrorLevel {
                errorCount+= 1
            }
            else {
                ClickWait(xPos, yPos, 1, 100)
                success := true
            }

            Sleep, 250
        }

        if (errorCount >= 5) {
            SoundBeep
            MsgBox, % "ERROR: Color not found"
        }
    }

    AccessCurrentTask() {
        taskX := 765
        taskY := 235
        ClickWait(taskX, taskY, 1, 100)
        Sleep, 250
    }

    ActivateCombatBoost() {
        boostX := 2235
        boostY := 90
        boostAvailableColor := "0x2F53A8"

        PixelGetColor currentButtonColor, % boostX, % boostY
        if (currentButtonColor = boostAvailableColor) {
            ClickWait(boostX, boostY, 1, 100)
        }
    }
}



; t::autoSlayer(1)
!t::
    autoSlayer(0)
return

!+t::
    While (True) {
        ; Setup
        ClickWait(55, 545, 1, 1000)     ; Activate farming screen
        ClickWait(1250, 685, 0, 1000)   ; Activate scrollable section of screen
        SendWait("{WheelUp 15}", 1000) ; Scroll to top of screen (otherwise all click positions will be wrong.)

        ; Farm bushes
        ClickWait(735, 195, 1, 1000)    ; Activate Bushes View
        ClickWait(965, 760, 1, 2000)    ; Claim All
        ; Randomly select and click bush
        bushList := [[1065, 955, 1, 1000]     ; Plant Gooseberries
            , [1365, 955, 1, 1000]          ; Plant Blueberries
            , [770, 1335, 1, 1000]          ; Plant Strawberries
            , [1065, 1335, 1, 1000]         ; Plant Blackberries
            , [1365, 1335, 1, 1000]]        ; Plant Salmonberry
        Random, RandBush, 1, % bushList.Length()
        ClickWait(bushList[randBush]*)

        ; Farm Trees
        ClickWait(1215, 195, 1, 1000)   ; Activate Bushes
        ClickWait(965, 576, 1, 2000)    ; Claim All
        ; Pick one. Comment out all others.
        treeList := [[770, 775, 1, 1000]    ; Plant Pine Tree
            , [1075, 775, 1, 1000]          ; Plant Ebony Tree
            , [1365, 775, 1, 1000]          ; Plant Eucalyptus Tree
            , [770, 1160, 1, 1000]]         ; Plant Baobab Tree
        Random, RandTree, 1, % treeList.Length()
        ClickWait(treeList[randTree]*)

        ; Activate boosts
        ClickWait(2250, 25, 1, 1000)    ; Activate skill boost
        ClickWait(2250, 25, 1, 1000)    ; Activate skill boost
        ClickWait(2250, 80, 1, 1000)    ; Activate combat boost
        ClickWait(2250, 80, 1, 1000)    ; Activate combat boost
    }
return

#IfWinActive ; Clear IfWinActive
