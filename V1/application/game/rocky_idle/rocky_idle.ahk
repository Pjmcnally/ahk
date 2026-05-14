#IfWinActive ahk_exe Rocky Idle.exe

autoPlay(taskList, maxTaskCount := 0) {
    static rockyObj := New rockyIdle
    taskCount := 0

    while WinActive("Rocky Idle") and (taskCount < maxTaskCount or maxTaskCount = 0) {
        rockyObj.ActivateBoosts()

        if BigA.Includes(taskList, "Slayer") {
            ToolTip, % "Running AutoSlayer - Navigating to Slayer Page", 10, 10
            rockyObj.GoToSlayerPage()

            ToolTip, % "Running AutoSlayer - Checking for new task", 10, 10
            newTaskInfo := rockyObj.NewTaskAvailable()
            if (newTaskInfo.found) {
                ToolTip, % "Running AutoSlayer - Getting New Task", 10, 10
                rockyObj.GetNewTask(newTaskInfo)
                ToolTip, % "Running AutoSlayer - Getting New Minion", 10, 10
                rockyObj.GetTaskMinion()
                taskCount += 1
            }

            ToolTip, % "Running AutoSlayer - Waiting for task completion - Task: " . taskCount, 10, 10
            Sleep, 2000
        }

        if BigA.Includes(taskList, "Farming") {
            ToolTip, % "Running Farming Loop - Activating Screen", 10, 10
            rockyObj.GoToFarmingPage()

            ToolTip, % "Running Farming Loop - Farming Bushes", 10, 10
            rockyObj.FarmBushes()

            ToolTip, % "Running Farming Loop - Farming Trees", 10, 10
            rockyObj.FarmTrees()
        }
    }

    ToolTip ; Clear ToolTip
}

test() {
    static rockyObj := New rockyIdle

    rockyObj.ActivateBoosts()
}

class rockyIdle {
    temp() {
        ;     this.screens := {main: New Screen({name: "Main"
        ;         , activateButton: "" ; New Button({<FILL IN>})
        ;         , buttonList: ""})} ; { New Button ({<FILL IN>}) }
        ;     this.buttons := {skillBoostButton: New Button({ name: "SkillBoostButton"
        ;         , leftX: 2225
        ;         , rightX: 2270
        ;         , topY: 10
        ;         , botY: 55
        ;         , clickLocation: [2250, 25]
        ;         , searchColor: "0x2F53A8"})
        ;     , slayerBoostButton: New Button({ name: "SlayerBoostButton"
        ;         , leftX: 2225
        ;         , rightX: 2270
        ;         , topY: 60
        ;         , botY: 105
        ;         , clickLocation: [2250, 75]
        ;         , searchColor: "0x2F53A8"})
        ;     , newTaskButton: New Button({ name: "newTaskButton"
        ;         , leftX: 535
        ;         , rightX: 835
        ;         , topY: 1255
        ;         , botY: 1315
        ;         , clickLocation: [675, 1285]
        ;         , searchColor: "0x3D8015"})
        ;     , slayerButton: New Button({ name: "SlayerButton"
        ;         , leftX: 10
        ;         , rightX: 120
        ;         , topY: 655
        ;         , botY: 690
        ;         , clickLocation: [70, 670]
        ;         , searchColor: ""})
        ;     , slayerCurrentTaskButton: New Button({ name: "SlayerCurrentTaskButton"
        ;         , leftX: 740
        ;         , rightX: 780
        ;         , topY: 225
        ;         , botY: 255
        ;         , clickLocation: [760, 240]
        ;         , searchColor: ""})
        ;     , slayerSelectEnemyButton: New Button({ name: "SlayerSelectEnemyButton"
        ;         , leftX: 550
        ;         , rightX: 1270
        ;         , topY: 1330
        ;         , botY: 225
        ;         , clickLocation: []
        ;         , showToolTip: false
        ;         , searchColor: "0x3D8015"})}

        ;     ; Set time for Rocky Idle Window active check
        ;     This.CheckWindowActiveFreq := 100 ; .1 seconds

        ;     ; Set timer attribute / Start timer
        ;     This.Timer := ObjBindMethod(this, "CheckWindowActive")
        ;     timer := this.Timer  ; Not sure why this line is necessary but it is.
        ;     SetTimer, % timer, % this.CheckWindowActiveFreq,

        ; displayToolTips() {
        ;     for key, val in this.buttons {
        ;         val.displayToolTip()
        ;     }
        ; }

        ; hideToolTips() {
        ;     for key, val in this.buttons {
        ;         val.hideToolTip()
        ;     }
        ; }
    }

    CheckWindowActive() {
        if !(WinActive("Rocky Idle")) {
            this.hideToolTips()
        }
    }

    GoToFarmingPage() {
        ClickWait(55, 545, 1, 1000)     ; Activate farming screen
        ClickWait(1250, 685, 0, 1000)   ; Activate scrollable section of screen
        SendWait("{WheelUp 15}", 1000) ; Scroll to top of screen (otherwise all click positions will be wrong.)
    }

    FarmBushes() {
        ; Farm bushes
        ; findResults := this.FindImage(x1, y1, x2, y2, )
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
    }

    FarmTrees() {
        ; Farm Trees
        ClickWait(1215, 195, 1, 1000)   ; Activate Bushes
        ClickWait(965, 576, 1, 2000)    ; Claim All

        ; Pick one. Comment out all others.
        /* Unused trees
              [770, 775, 1, 1000]           ; Plant Pine Tree
            , [1075, 775, 1, 1000]          ; Plant Ebony Tree
            , [1365, 775, 1, 1000]          ; Plant Eucalyptus Tree
            , [770, 1160, 1, 1000]          ; Plant Baobab Tree
        */
        treeList := [[1075, 1160, 1, 1000]]        ; Plant Canary Tree
        Random, RandTree, 1, % treeList.Length()

        ClickWait(treeList[randTree]*)
    }

    GetNewTask(newTaskInfo) {
        ClickWait(newTaskInfo.x, newTaskInfo.y, 1, 100)
        Sleep, 1000

        if this.GetScreenshot {
            ; Take screenshot to capture count of minions and difficulty
            Send, #{PrintScreen}
        }
    }

    GoToSlayerPage() {
        ClickWait(100, 675, 1, 100)
        Sleep, 100
    }

    getTaskMinion() {
        this.AccessSlayerTask()

        Send, {WheelDown 15}
        Sleep, 500 ; Wait for scrolling to complete
        this.ClickImage(500, 1, 2035, 1360, "fight.png")
    }

    AccessSlayerTask() {
        taskX := 765
        taskY := 235
        ClickWait(taskX, taskY, 1, 100)
        Sleep, 250
    }

    NewTaskAvailable() {
        return this.findImage(530, 1250, 840, 1350, "getTask.png")
    }

    ActivateCombatBoost() {
        this.ClickImage(2205, 0, 2280, 110, "combatBoost.png")
        this.ClickWait(0, 0, 0, 1000) ; Move mouse to neutral position to not block next action
    }

    ActivateSkillBoost() {
        this.ClickImage(2205, 0, 2280, 110, "skillBoost.png")
        this.ClickWait(0, 0, 0, 1000) ; Move mouse to neutral position to not block next action
    }

    ActivateBoosts() {
        ToolTip, % "Activating combat boost if available", 10, 10
        this.ActivateCombatBoost()

        ToolTip, % "Activating skill boost if available", 10, 10
        this.ActivateSkillBoost()
    }

    ClickImage(x1, y1, x2, y2, imageName, retryCount := 0, throwError := false) {
        results := this.FindImage(x1, y1, x2, y2, imageName, retryCount, throwError)
        if (results.found) {
            ClickWait(results.x, results.y, 1, 100)
        }
    }

    FindImage(x1, y1, x2, y2, imageName, retryCount := 0, throwError := false) {
        outX :=
        outY :=

        baseImagePath := "%A_ScriptDir%\..\application\game\rocky_idle\"
        fullImagePath := baseImagePath . imageName

        errorCount := 0
        success := false
        while errorCount <= retryCount and !success {
            ImageSearch, outX, outY, x1, y1, x2, y2, *5 %fullImagePath%
            if ErrorLevel {
                errorCount += 1
            }
            else {
                success := true
            }

            Sleep, 250
        }

        if (errorCount >= retryCount and throwError ) {
            SoundBeep
            MsgBox, % "ERROR: Image not found: " . imageName
        }

        return {found: success, x: outX, y: outY}
    }
}

t::test()
; Alt-t
!t::autoPlay(["Slayer"])
; Shift-Alt-t
!+t::autoPlay(["Farming"])
; Shift-Alt-Ctrl-t
!+^t::autoPlay(["Slayer", "Farming"])

#IfWinActive ; Clear IfWinActive
