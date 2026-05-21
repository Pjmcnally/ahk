#Requires AutoHotkey v2.0
#Include <Array>
#Include <Keyboard>
#Include <Logger>
#Include <Mouse>

#HotIf WinActive("ahk_exe Rocky Idle.exe", )

autoPlay(taskList) {
    try {
        static rockyObj := rockyIdle()
        rockyObj.displayToolTip()
        rockyObj.slayerTaskCount := 0

        while WinActive("Rocky Idle") {
            rockyObj.ActivateBoosts()

            if taskList.Includes("Slayer") {
                rockyObj.RunSlayer()
            }

            if taskList.Includes("Farming") {
                rockyObj.RunFarm()
            }
        }
    } catch {
        throw
    } finally {
        if(isobject(rockyObj)) {
            rockyObj.Dispose()
        }
    }
}

test() {
    static rockyObj := rockyIdle()

    rockyObj.ActivateBoosts()
}

class rockyIdle {
    __New() {
        try {
            this.logger := Logger("C:\Users\Patrick\Downloads\RockyIdle_logs\" . FormatTime(A_Now, "yyyy-MM-dd") . ".log", "INFO")
        } catch {
            MsgBox("Failed to initialize logger. Error: " . Error.Message)
            throw
        }

        this.slayerTaskCount := 0
        this.slayerTaskStartTick := 0
        this.slayerTaskTimeout := 2 * 60 * 1000 ; 2 minutes (in milliseconds)
        this.baseImagePath := A_WorkingDir . "\lib\Game\RockyIdle\Images"
    }

    displayToolTip() {
        ToolTip("Automation Active. See log file for full detail: " . this.logger.Path, 10, 10)
    }

    hideToolTip() {
        ToolTip()
    }

    GetRandomFile(directoryPath) {
        this.logger.WriteDebug("Getting random file from: " . directoryPath)
        fileList := []
        Loop Files, directoryPath "\*.*"
        {
            fileList.Push(A_LoopFilePath)
        }

        count := fileList.Length
        this.logger.WriteDebug("Total Files Found: " . count)

        randomIndex := Random(1, count)
        selectedFile := fileList[randomIndex]
        this.logger.WriteDebug("Selected file: " . selectedFile)

        return selectedFile
    }

    RunFarm() {
        this.logger.WriteInfo("AutoFarm process started")
        this.HarvestFarm()
        this.CheckInactiveFarm()
        this.logger.WriteInfo("AutoFarm process complete")
    }

    HarvestFarm() {
        this.logger.WriteInfo("Checking for available harvests.")
        Loop{
            readyResults := this.ClickImageByName(2320, 250, 2550, 765, "done.png")
            if (readyResults.Success) {
                this.logger.WriteInfo("Claiming available harvest.")
                claimResults := this.ClickImageByName(775, 550, 1150, 780, "claimAll.png", 1500)

                this.plantFarm()
            }
        } until (!readyResults.success)
    }

    PlantFarm(type := "") {
        if (type = "") {
            this.logger.WriteDebug("Type unknown. Finding active type.")
        }

        if (type = "Bush" or this.FindImageByName(500, 150, 1430, 250, "bushPageActive.png").Success) {
            this.PlantBushes()
        } else if (type = "Tree" or this.FindImageByName(500, 150, 1430, 250, "treePageActive.png").Success) {
            this.PlantTrees()
        } else {
            this.logger.WriteError("No type specified or found")
        }
    }

    CheckInactiveFarm(type := "Both") {
        if (type = "Both") {
            this.CheckInactiveFarm("Bush")
            this.CheckInactiveFarm("Tree")
            return
        }

        this.logger.WriteDebug("Checking sidebar for missing type: " . type)
        findResults := this.FindImageByName(2310, 160, 2550, 1005, type . "SidebarActive.png")

        if (findResults.Success) {
            this.logger.WriteDebug("Type " . type . " found in sidebar. No action needed.")
        } else {
            this.logger.WriteDebug("Type " . type . " not found in sidebar. Planting " . type)
            this.GoToFarmingPage(type)
            this.PlantFarm(type)
        }
    }


    GoToFarmingPage(type := "") {
        this.logger.WriteInfo("Activating farming page")
        ClickWait(55, 545, 1, 1000)     ; Activate farming screen

        this.logger.WriteDebug("Scrolling to top of page")
        ClickWait(1250, 685, 0, 1000)   ; Activate scrollable section of screen
        SendWait("{WheelUp 15}", 1000) ; Scroll to top of screen (otherwise all click positions will be wrong.)

        if (type = "bush") {
            this.logger.WriteDebug("Access page for type: " . type)
            clickWait(760, 200, 1, 1000)
        } else if (type = "tree") {
            this.logger.WriteDebug("Access page for type: " . type)
            clickWait(1225, 200, 1, 1000)
        }
    }

    PlantBushes() {
        this.logger.WriteInfo("Planting Bushes.")
        randomBush := this.GetRandomFile(this.baseImagePath . "\Bushes\Active")
        this.clickImage(525, 800, 1425, 1365, randomBush)
    }

    PlantTrees() {
        this.logger.WriteInfo("Planting Trees.")
        randomTree := this.GetRandomFile(this.baseImagePath . "\Trees\Active")
        this.clickImage(525, 800, 1425, 1365, randomTree)
    }


    RunSlayer() {
        this.logger.WriteInfo("Starting AutoSlayer process")
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
        this.logger.WriteInfo("AutoSlayer process complete")
    }

    CheckForStaleSlayerTask() {
        currentTick := A_TickCount
        currentTaskDuration := A_TickCount - this.slayerTaskStartTick

        this.logger.WriteDebug("Checking For Stale Task")
        this.logger.WriteDebug("Current tick: " . currentTick)
        this.logger.WriteDebug("Slayer task start tick: " . this.slayerTaskStartTick)
        this.logger.WriteDebug("Current task duration: " . currentTaskDuration)
        this.logger.WriteDebug("Slayer task timeout: " . this.slayerTaskTimeout)

        if (currentTaskDuration > this.slayerTaskTimeout) {
            this.logger.WriteWarn("Current task running longer than timeout. Replacing Stale Minion")
            this.GoToSlayerPage()
            this.GetSlayerTaskMinion()
        }
    }

    GetNewSlayerTask(newTaskInfo) {
        this.logger.WriteInfo("Getting new slayer task.")
        ClickWait(newTaskInfo.x, newTaskInfo.y, 1, 100)
        this.slayerTaskCount += 1
        this.logger.WriteDebug("Slayer task count: " . this.slayerTaskCount)
        Sleep(1000)
    }

    GoToSlayerPage() {
        this.logger.WriteInfo("Accessing slayer page")
        ClickWait(100, 675, 1, 100)
        Sleep(100)
    }

    GetSlayerTaskMinion() {
        this.logger.WriteInfo("Selecting slayer minion to fight.")
        Send("{WheelDown 15}")
        Sleep(1000) ; Wait for scrolling to complete
        this.ClickImageByName(500, 1, 2035, 1360, "fight.png")
        this.slayerTaskStartTic := A_TickCount
        this.logger.WriteDebug("Slayer task started at tick: " . A_TickCount)
    }

    AccessSlayerTask() {
        this.logger.WriteDebug("Clicking 'Get Task'")
        taskX := 765
        taskY := 235
        ClickWait(taskX, taskY, 1, 100)
        Sleep(250)
    }

    NewTaskAvailable() {
        this.logger.WriteInfo("Checking if new slayer task available")
        return this.findImageByName(530, 1250, 840, 1350, "getTask.png")
    }

    ActivateCombatBoost() {
        this.logger.WriteInfo("Activating combat boost")
        result := this.ClickImageByName(2205, 0, 2280, 110, "combatBoost.png")
        if (result.success) {
            ClickWait(2185, 30, 1, 1000) ; Move mouse to neutral position to not block next action
        }
    }

    ActivateSkillBoost() {
        this.logger.WriteInfo("Activating skill boost")
        result := this.ClickImageByName(2205, 0, 2280, 110, "skillBoost.png")
        if (result.success) {
            ClickWait(2185, 30, 1, 1000) ; Move mouse to neutral position to not block next action
        }
    }

    ActivateBoosts() {
        this.ActivateCombatBoost()
        this.ActivateSkillBoost()
    }

    ClickImage(x1, y1, x2, y2, imagePath, delay := 100, attemptCount := 1, throwError := false) {
        results := this.FindImage(x1, y1, x2, y2, imagePath, attemptCount, throwError)
        if (results.success) {
            this.logger.WriteDebug("Clicking image at X: " . results.x . " Y: " . results.y)
            ClickWait(results.x, results.y, 1, 100)
        }

        return results
    }

    ClickImageByName(x1, y1, x2, y2, imageName, delay := 100, attemptCount := 1, throwError := false) {
        results := this.FindImageByName(x1, y1, x2, y2, imageName, attemptCount, throwError)
        if (results.success) {
            this.logger.WriteDebug("Clicking image at X: " . results.x . " Y: " . results.y)
            ClickWait(results.x, results.y, 1, delay)
        }

        return results
    }

    FindImage(x1, y1, x2, y2, imagePath, maxTryCount := 1, throwError := false) {
        this.logger.WriteInfo("Searching for image by path: " . imagePath)
        this.logger.WriteDebug("Searching area X1: " . x1 . " Y1: " . y1 . " X2: " . x2 . " Y2: " . y2)

        outX := unset
        outY := unset
        success := false

        attemptCount := 1
        while ((attemptCount <= maxTryCount) and !success) {
            this.logger.WriteDebug("Attempt: " . attemptCount)

            if (ImageSearch(&outX, &outY, x1, y1, x2, y2, "*5 " . imagePath)) {
                this.logger.WriteDebug("Image found at X: " . outX . " Y: " . outY)
                success := true
            } else {
                attemptCount += 1
                this.logger.WriteWarn("Image not found")
            }

            Sleep(250)
        }

        if (!success and throwError) {
            this.logger.WriteError("Image not found after [ " . attemptCount . " ] attempts")
        }

        return {success: success, x: outX, y: outY}
    }

    FindImageByName(x1, y1, x2, y2, imageName, attemptCount := 1, throwError := false) {
        this.logger.WriteDebug("Searching for image by name: " . imageName)
        fullImagePath := this.baseImagePath . "\" . imageName

        return this.FindImage(x1, y1, x2, y2, fullImagePath, attemptCount, throwError)
    }

    Dispose() {
        this.hideToolTip()

        if (isobject(this.logger)) {
            this.logger.Dispose()
        }
    }
}

F1::autoPlay([])
F2::autoPlay(["Slayer"])
F3::autoPlay(["Farming"])
F4::autoPlay(["Slayer", "Farming"])

#HotIf ; Clear HotIf
