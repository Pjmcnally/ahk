#IfWinActive ahk_exe Rocky Idle.exe

autoPlay(taskList) {
    static rockyObj := New rockyIdle
    rockyObj.slayerTaskCount := 0

    while WinActive("Rocky Idle") {
        rockyObj.ActivateBoosts()

        if BigA.Includes(taskList, "Slayer") {
            rockyObj.RunSlayer()
        }

        if BigA.Includes(taskList, "Farming") {
            rockyObj.RunFarm()
        }
    }

    ToolTip ; Clear ToolTip
}

test() {
    static rockyObj := New rockyIdle

    rockyObj.ActivateBoosts()
}

class rockyIdle {
    __New() {
        this.slayerTaskCount := 0
    }

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

    GetRandomFile(directoryPath) {
        fileList := []
        Loop, Files, %directoryPath%\*.*
        {
            fileList.Push(A_LoopFileFullPath)
        }
        Random, randomIndex, 1, fileList.Length
        return fileList[randomIndex]
    }

    RunFarm() {
        ToolTip, % "Farming: Harvesting Crops", 10, 10
        this.HarvestFarm()

        ; ToolTip, % "Farming: Planting Bushes", 10, 10
        ; this.PlantBushes()

        ; ToolTip, % "Farming: Planting Trees", 10, 10
        ; this.PlantTrees()
    }

    HarvestFarm() {
        readyResults := this.ClickImageByName(2320, 250, 2550, 765, "done.png")
        if (readyResults.Success) {
            this.GoToFarmingPage()
            ; claimResults := this.ClickImageByName(775, 550, 1150, 780, "claimAll.png")
        }
    }

    PlantBushes() {
        ; Check if Bushes already planted
        findResults := this.FindImageByName(2310, 160, 2550, 1005, "bushes.png")
        if (!findResults.Success) {
            this.GoToFarmingPage()
            randomBush := this.GetRandomFile("%A_ScriptDir%\..\application\game\rocky_idle\images\Bushes\Active")
            this.clickImage(525, 800, 1425, 1365, randomBush)
        }
    }

    PlantTrees() {
        ; Check if Bushes already planted
        findResults := this.FindImageByName(2310, 160, 2550, 1005, "treess.png")
        if (!findResults.Success) {
            this.GoToFarmingPage()
            randomBush := this.GetRandomFile("%A_ScriptDir%\..\application\game\rocky_idle\images\Trees\Active")
            this.clickImage(525, 800, 1425, 1365, randomTree)
        }
    }

    GoToFarmingPage() {
        ClickWait(55, 545, 1, 1000)     ; Activate farming screen
        ClickWait(1250, 685, 0, 1000)   ; Activate scrollable section of screen
        SendWait("{WheelUp 15}", 1000) ; Scroll to top of screen (otherwise all click positions will be wrong.)
    }

    RunSlayer() {
        ToolTip, % "AutoSlayer: Navigating to Slayer Page", 10, 10
        this.GoToSlayerPage()

        ToolTip, % "AutoSlayer: Checking for new task", 10, 10
        newTaskInfo := this.NewTaskAvailable()
        if (newTaskInfo.found) {
            ToolTip, % "AutoSlayer: Getting New Task", 10, 10
            this.GetNewTask(newTaskInfo)
            ToolTip, % "AutoSlayer: Getting New Minion", 10, 10
            this.GetTaskMinion()
            this.slayerTaskCount += 1
        }

        ToolTip, % "AutoSlayer: Waiting for task completion - Task: " . this.slayerTaskCount, 10, 10
        Sleep, 2000
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
        return this.findImageByName(530, 1250, 840, 1350, "getTask.png")
    }

    ActivateCombatBoost() {
        result := this.ClickImageByName(2205, 0, 2280, 110, "combatBoost.png")
        if (result.success) {
            ClickWait(2185, 30, 1, 1000) ; Move mouse to neutral position to not block next action
        }
    }

    ActivateSkillBoost() {
        result := this.ClickImageByName(2205, 0, 2280, 110, "skillBoost.png")
        if (result.success) {
            ClickWait(2185, 30, 1, 1000) ; Move mouse to neutral position to not block next action
        }
    }

    ActivateBoosts() {
        ToolTip, % "Activating combat boost if available", 10, 10
        this.ActivateCombatBoost()

        ToolTip, % "Activating skill boost if available", 10, 10
        this.ActivateSkillBoost()
    }

    ClickImage(x1, y1, x2, y2, imagePath, retryCount := 0, throwError := false) {
        results := this.FindImage(x1, y1, x2, y2, imagePath, retryCount, throwError)
        if (results.found) {
            ClickWait(results.x, results.y, 1, 100)
        }

        return results
    }

    ClickImageByName(x1, y1, x2, y2, imageName, retryCount := 0, throwError := false) {
        results := this.FindImageByName(x1, y1, x2, y2, imageName, retryCount, throwError)
        if (results.found) {
            ClickWait(results.x, results.y, 1, 100)
        }

        return results
    }

    FindImage(x1, y1, x2, y2, imagePath, retryCount := 0, throwError := false) {
        outX :=
        outY :=
        success := false

        errorCount := 0
        while errorCount <= retryCount and !success {
            ImageSearch, outX, outY, x1, y1, x2, y2, *5 %imagePath%
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
            MsgBox, % "ERROR: Image not found: " . imagePath
        }

        return {found: success, x: outX, y: outY}
    }

    FindImageByName(x1, y1, x2, y2, imageName, retryCount := 0, throwError := false) {
        baseImagePath := A_ScriptDir . "\..\application\game\rocky_idle\images"
        fullImagePath := baseImagePath . "\" . imageName

        return this.FindImage(x1, y1, x2, y2, fullImagePath, retryCount, throwError)
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
