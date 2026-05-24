#Requires AutoHotkey v2.0
#Include <Array>
#Include <Keyboard>
#Include <Logger>
#Include <Mouse>
#Include <System>

#HotIf WinActive("ahk_exe Rocky Idle.exe")

autoPlay(taskList) {
    try {
        rockyObj := rockyIdle(taskList )
        rockyObj.Run()
    } catch Error as e {
        throw e
    } finally {
        if(IsSet(rockyObj) and IsObject(rockyObj)) {
            rockyObj.Dispose()
        }
    }
}

class rockyIdle {
    __New(taskList) {
        try {
            this.Logger := Logger(System.DownloadsPath . "\RockyIdle_logs\" . FormatTime(A_Now, "yyyy-MM-dd") . ".log", "INFO")
        } catch Error as e {
            MsgBox("Failed to initialize.Logger. Error: " . e.Message)
            throw e
        }

        this.TaskList := taskList
        this.Logger.WriteInfo("Initializing Rocky Idle automation with tasks: [" . this.TaskList.Join(", ") . "]")
        this.SlayerTaskCount := 0
        this.SlayerTaskStartTick := 0
        this.SlayerTaskTimeout := 2 * 60 * 1000 ; 2 minutes (in milliseconds)
        this.BaseImagePath := A_WorkingDir . "\Game\RockyIdle\Images"
    }

    DisplayToolTip(mode:= "") {
        ToolTip("Automation Active in mode(s): [" . mode . "]. See log file for full detail: " . this.Logger.Path, 10, 10)
    }

    HideToolTip() {
        ToolTip()
    }

    Run() {
        this.DisplayToolTip(this.TaskList.Join(", "))
        this.SlayerTaskCount := 0

        while WinActive("Rocky Idle") {
            this.ActivateBoosts()

            if this.TaskList.Includes("Slayer") {
                this.RunSlayer()
            }

            if this.TaskList.Includes("Farming") {
                this.RunFarm()
            }
        }
    }

    GetRandomFile(directoryPath) {
        this.Logger.WriteDebug("Getting random file from: " . directoryPath)
        fileList := []
        Loop Files, directoryPath "\*.*"
        {
            fileList.Push(A_LoopFilePath)
        }

        count := fileList.Length
        this.Logger.WriteDebug("Total Files Found: " . count)

        randomIndex := Random(1, count)
        selectedFile := fileList[randomIndex]
        this.Logger.WriteDebug("Selected file: " . selectedFile)

        return selectedFile
    }

    RunFarm() {
        this.Logger.WriteInfo("AutoFarm process started")
        this.HarvestFarm()
        this.CheckInactiveFarm()
        this.Logger.WriteInfo("AutoFarm process complete")
    }

    HarvestFarm() {
        this.Logger.WriteInfo("Checking for available harvests.")

        this.GoToFarmingPage("Bush")
        this.Logger.WriteInfo("Checking for harvestable bushes.")
        harvestBushesResults := this.ClickImageByName(775, 550, 1150, 780, "claimAll.png", 1500)
        if (harvestBushesResults.Success) {
            this.PlantFarm("Bush")
        }

        this.GoToFarmingPage("Tree")
        this.Logger.WriteInfo("Checking for harvestable trees.")
        harvestTreesResults := this.ClickImageByName(775, 550, 1150, 780, "claimAll.png", 1500)
        if (harvestTreesResults.Success) {
            this.PlantFarm("Tree")
        }
    }

    PlantFarm(type := "") {
        if (type = "") {
            this.Logger.WriteDebug("Type unknown. Finding active type.")
        }

        if (type = "Bush" or this.FindImageByName(500, 150, 1430, 250, "bushPageActive.png").Success) {
            this.PlantBushes()
        } else if (type = "Tree" or this.FindImageByName(500, 150, 1430, 250, "treePageActive.png").Success) {
            this.PlantTrees()
        } else {
            this.Logger.WriteError("No type specified or found")
        }
    }

    CheckInactiveFarm(type := "Both") {
        if (type = "Both") {
            this.CheckInactiveFarm("Bush")
            this.CheckInactiveFarm("Tree")
            return
        }

        this.Logger.WriteInfo("Checking sidebar for missing type: " . type)
        findResults := this.FindImageByName(2310, 160, 2550, 1005, type . "SidebarActive.png")

        if (findResults.Success) {
            this.Logger.WriteInfo("Type " . type . " found in sidebar. No action needed.")
        } else {
            this.Logger.WriteInfo("Type " . type . " not found in sidebar. Planting " . type)
            this.GoToFarmingPage(type)
            this.PlantFarm(type)
        }
    }


    GoToFarmingPage(type := "") {
        this.Logger.WriteInfo("Activating farming page")
        Mouse.ClickWait(55, 545, 1, 1000)     ; Activate farming screen

        this.Logger.WriteDebug("Scrolling to top of page")
        Mouse.ClickWait(1250, 685, 0, 1000)   ; Activate scrollable section of screen
        Keyboard.SendWait("{WheelUp 15}", 1000) ; Scroll to top of screen (otherwise all click positions will be wrong.)

        if (type = "bush") {
            this.Logger.WriteDebug("Access page for type: " . type)
            Mouse.ClickWait(760, 200, 1, 1000)
        } else if (type = "tree") {
            this.Logger.WriteDebug("Access page for type: " . type)
            Mouse.ClickWait(1225, 200, 1, 1000)
        }
    }

    PlantBushes() {
        this.Logger.WriteInfo("Planting Bushes.")
        randomBush := this.GetRandomFile(this.BaseImagePath . "\Bushes\Active")
        this.ClickImage(525, 800, 1425, 1365, randomBush)
    }

    PlantTrees() {
        this.Logger.WriteInfo("Planting Trees.")
        randomTree := this.GetRandomFile(this.BaseImagePath . "\Trees\Active")
        this.ClickImage(525, 800, 1425, 1365, randomTree)
    }


    RunSlayer() {
        this.Logger.WriteInfo("Starting AutoSlayer process")
        this.GoToSlayerPage()

        newTaskInfo := this.NewTaskAvailable()
        if (newTaskInfo.success) {
            this.GetNewSlayerTask(newTaskInfo)
            this.AccessSlayerTask()
            this.GetSlayerTaskMinion()
        } else {
            this.CheckForStaleSlayerTask()
        }
        Sleep(2000)
        this.Logger.WriteInfo("AutoSlayer process complete")
    }

    CheckForStaleSlayerTask() {
        currentTick := A_TickCount
        currentTaskDuration := A_TickCount - this.SlayerTaskStartTick

        this.Logger.WriteDebug("Checking For Stale Task")
        this.Logger.WriteDebug("Current tick: " . currentTick)
        this.Logger.WriteDebug("Slayer task start tick: " . this.SlayerTaskStartTick)
        this.Logger.WriteDebug("Current task duration: " . currentTaskDuration)
        this.Logger.WriteDebug("Slayer task timeout: " . this.SlayerTaskTimeout)

        if (currentTaskDuration > this.SlayerTaskTimeout) {
            this.Logger.WriteWarn("Current task running longer than timeout. Replacing Stale Minion")
            this.GoToSlayerPage()
            this.GetSlayerTaskMinion()
        }
    }

    GetNewSlayerTask(newTaskInfo) {
        this.Logger.WriteInfo("Getting new slayer task.")
        Mouse.ClickWait(newTaskInfo.x, newTaskInfo.y, 1, 100)
        this.SlayerTaskCount += 1
        this.Logger.WriteDebug("Slayer task count: " . this.SlayerTaskCount)
        Sleep(1000)
    }

    GoToSlayerPage() {
        this.Logger.WriteInfo("Accessing slayer page")
        Mouse.ClickWait(100, 675, 1, 100)
        Sleep(100)
    }

    GetSlayerTaskMinion() {
        this.Logger.WriteInfo("Selecting slayer minion to fight.")
        Send("{WheelDown 15}")
        Sleep(1000) ; Wait for scrolling to complete
        this.ClickImageByName(500, 1, 2035, 1360, "fight.png")
        this.SlayerTaskStartTic := A_TickCount
        this.Logger.WriteDebug("Slayer task started at tick: " . A_TickCount)
    }

    AccessSlayerTask() {
        this.Logger.WriteDebug("Clicking 'Get Task'")
        taskX := 765
        taskY := 235
        Mouse.ClickWait(taskX, taskY, 1, 100)
        Sleep(250)
    }

    NewTaskAvailable() {
        this.Logger.WriteInfo("Checking if new slayer task available")
        return this.FindImageByName(530, 1250, 840, 1350, "getTask.png")
    }

    ActivateCombatBoost() {
        this.Logger.WriteInfo("Checking Combat Boost")
        result := this.ClickImageByName(2205, 0, 2280, 110, "combatBoost.png")
        if (result.success) {
            this.Logger.WriteInfo("Activating combat boost")
            Mouse.ClickWait(2185, 30, 1, 1000) ; Move mouse to neutral position to not block next action
        } else {
            this.Logger.WriteInfo("Combat boost not found. It may already be active or unavailable.")
        }
    }

    ActivateSkillBoost() {
        this.Logger.WriteInfo("Checking Skill Boost")
        result := this.ClickImageByName(2205, 0, 2280, 110, "skillBoost.png")
        if (result.success) {
            this.Logger.WriteInfo("Activating skill boost")
            Mouse.ClickWait(2185, 30, 1, 1000) ; Move mouse to neutral position to not block next action
        } else {
            this.Logger.WriteInfo("Skill boost not found. It may already be active or unavailable.")
        }
    }

    ActivateBoosts() {
        this.ActivateCombatBoost()
        this.ActivateSkillBoost()
    }

    ClickImage(x1, y1, x2, y2, imagePath, delay := 100, attemptCount := 1, throwError := false) {
        results := this.FindImage(x1, y1, x2, y2, imagePath, attemptCount, throwError)
        if (results.success) {
            this.Logger.WriteDebug("Clicking image at X: " . results.x . " Y: " . results.y)
            Mouse.ClickWait(results.x, results.y, 1, 100)
        }

        return results
    }

    ClickImageByName(x1, y1, x2, y2, imageName, delay := 100, attemptCount := 1, throwError := false) {
        results := this.FindImageByName(x1, y1, x2, y2, imageName, attemptCount, throwError)
        if (results.success) {
            this.Logger.WriteDebug("Clicking image at X: " . results.x . " Y: " . results.y)
            Mouse.ClickWait(results.x, results.y, 1, delay)
        }

        return results
    }

    FindImage(x1, y1, x2, y2, imagePath, maxTryCount := 1, mustFind := false) {
        ; Check for valid and existing image path before attempting search
        if (!FileExist(imagePath)) {
            this.Logger.WriteFatal("Image path does not exist: " . imagePath)
            throw Error("Image path does not exist: " . imagePath)
        }

        this.Logger.WriteDebug("Searching for image by path: " . imagePath)
        this.Logger.WriteDebug("Searching area X1: " . x1 . " Y1: " . y1 . " X2: " . x2 . " Y2: " . y2)

        outX := unset
        outY := unset
        success := false

        attemptCount := 1
        errorRetryCount := 0
        while ((attemptCount <= maxTryCount) and !success) {
            this.Logger.WriteDebug("Attempt: " . attemptCount)

            try {
                if (ImageSearch(&outX, &outY, x1, y1, x2, y2, "*5 " . imagePath)) {
                    this.Logger.WriteDebug("Image found at X: " . outX . " Y: " . outY)
                    success := true
                } else {
                    attemptCount += 1
                    this.Logger.WriteDebug("Image not found")
                }
            } catch OSError as e {
                if (errorRetryCount < 3) {
                    errorRetryCount += 1
                    this.Logger.WriteDebug("Retrying image search after error. Retry count: " . errorRetryCount)
                    Sleep(1000 * errorRetryCount) ; Wait before retrying in case of transient error
                } else {
                    this.Logger.WriteError("Max retry attempts reached for image search. Aborting search for: " . imagePath)
                    this.Logger.WriteError("Final error: " . e.Message, e)
                    throw e
                }
            }

            Sleep(250)
        }

        if (!success and mustFind) {
            this.Logger.WriteError("Image not found after [" . attemptCount . "] attempts. " . imagePath)
            throw Error("Image not found after [" . attemptCount . "] attempts. " . imagePath)
        }

        return {success: success, x: outX, y: outY}
    }

    FindImageByName(x1, y1, x2, y2, imageName, attemptCount := 1, throwError := false) {
        this.Logger.WriteDebug("Searching for image by name: " . imageName)
        fullImagePath := this.BaseImagePath . "\" . imageName

        return this.FindImage(x1, y1, x2, y2, fullImagePath, attemptCount, throwError)
    }

    Dispose() {
        this.HideToolTip()

        if (isobject(this.Logger)) {
            this.Logger.Dispose()
            this.Logger := ""
        }
    }
}

F1::autoPlay([])
F2::autoPlay(["Slayer"])
F3::autoPlay(["Farming"])
F4::autoPlay(["Slayer", "Farming"])

#HotIf ; Clear HotIf
