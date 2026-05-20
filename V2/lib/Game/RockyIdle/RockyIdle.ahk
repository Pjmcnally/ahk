#Requires AutoHotkey v2.0
#Include <Array>
#Include <Keyboard>
#Include <Logger>
#Include <Mouse>

#HotIf WinActive("ahk_exe Rocky Idle.exe", )

autoPlay(taskList) {
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

    rockyObj.hideToolTip()
}

test() {
    static rockyObj := rockyIdle()

    rockyObj.ActivateBoosts()
}

class rockyIdle {
    __New() {
        this.logger := Logger("C:\Users\Patrick\Downloads\RockyIdle_logs\" . FormatTime("yyyy-MM-dd") . ".log")
        this.slayerTaskCount := 0
        this.slayerTaskStartTick := 0
        this.slayerTaskTimeout := 2 * 60 * 1000 ; 2 minutes (in milliseconds)
    }

    displayToolTip() {
        ToolTip("Automation Active. See log file for full detail: " . this.logger.Path, 10, 10)
    }

    hideToolTip() {
        ToolTip()
    }

    GetRandomFile(directoryPath) {
        this.logger.Write("Getting random file from: " . directoryPath)
        fileList := []
        Loop Files, directoryPath "\*.*"
        {
            fileList.Push(A_LoopFilePath)
        }

        count := fileList.Length
        this.logger.Write("Total Files Found: " . count)

        randomIndex := Random(1, count)
        selectedFile := fileList[randomIndex]
        this.logger.Write("Selected file: " . selectedFile)

        return selectedFile
    }

    RunFarm() {
        this.logger.write("AutoFarm process started")
        this.HarvestFarm()
        this.PlantBushes()
        this.PlantTrees()
        this.logger.Write("AutoFarm process complete")
    }

    HarvestFarm() {
        this.logger.write("Checking for available harvests.")
        Loop{
            readyResults := this.ClickImageByName(2320, 250, 2550, 765, "done.png")
            if (readyResults.Success) {
                this.logger.Write("Claiming available harvest.")
                claimResults := this.ClickImageByName(775, 550, 1150, 780, "claimAll.png")

                this.plantFarm()
            }
        } until (!readyResults.success)
    }

    PlantFarm(type := "") {
        if (type = "") {
            this.logger.Write("Type unknown. Finding active type.")
            bushPageActive := this.FindImageByName(500, 150, 1430, 250, "bushPageActive.png")
            treePageActive := this.FindImageByName(500, 150, 1430, 250, "treePageActive.png")
        }

        if (type = "Bush" or bushPageActive.Success) {
            this.PlantBushes()
        } else if (type = "Tree" or treePageActive.Success) {
            this.PlantTrees()
        } else {
            this.logger.WriteError("No type specified or found")
        }
    }

    CheckInactiveFarm(type) {
        this.logger.Write("Checking sidebar for missing type: " . type)
        findResults := this.FindImageByName(2310, 160, 2550, 1005, type . ".png")

        this.logger.Write("Type " . type . " not found in sidebar. Planting " . type)
        this.GoToFarmingPage(type)
        this.PlantFarm(type)
    }


    GoToFarmingPage(type := "") {
        this.logger.Write("Activating farming page")
        ClickWait(55, 545, 1, 1000)     ; Activate farming screen

        this.logger.Write("Scrolling to top of page")
        ClickWait(1250, 685, 0, 1000)   ; Activate scrollable section of screen
        SendWait("{WheelUp 15}", 1000) ; Scroll to top of screen (otherwise all click positions will be wrong.)

        if (type = "bush") {
            this.logger.WriteLog("Access page for type: " . type)
            clickWait(760, 200, 1, 1000)
        } else if (type = "tree") {
            this.logger.WriteLog("Access page for type: " . type)
            clickWait(1225, 200, 1, 1000)
        }
    }

    PlantBushes() {
        this.logger.Write("Planting Bushes.")
        randomBush := this.GetRandomFile("%A_ScriptDir%\..\application\game\rocky_idle\images\Bushes\Active")
        this.clickImage(525, 800, 1425, 1365, randomBush)
    }

    PlantTrees() {
        this.logger.Write("Planting Trees.")
        randomTree := this.GetRandomFile("%A_ScriptDir%\..\application\game\rocky_idle\images\Trees\Active")
        this.clickImage(525, 800, 1425, 1365, randomTree)
    }


    RunSlayer() {
        this.logger.Write("Starting AutoSlayer process")
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
        this.logger.Write("AutoSlayer process complete")
    }

    CheckForStaleSlayerTask() {
        currentTick := A_TickCount
        currentTaskDuration := A_TickCount - this.slayerTaskStartTick

        this.logger.Write("Checking For Stale Task")
        this.logger.Write("Current tick: " . currentTick)
        this.logger.Write("Slayer task start tick: " . this.slayerTaskStartTick)
        this.logger.Write("Current task duration: " . currentTaskDuration)
        this.logger.Write("Slayer task timeout: " . this.slayerTaskTimeout)

        if (currentTaskDuration > this.slayerTaskTimeout) {
            this.logger.WriteWarn("Current task running longer than timeout. Replacing Stale Minion")
            this.GoToSlayerPage()
            this.GetSlayerTaskMinion()
        }
    }

    GetNewSlayerTask(newTaskInfo) {
        this.logger.Write("Getting new slayer task.")
        ClickWait(newTaskInfo.x, newTaskInfo.y, 1, 100)
        this.slayerTaskCount += 1
        this.logger.Write("Slayer task count: " . this.slayerTaskCount)
        Sleep(1000)
    }

    GoToSlayerPage() {
        this.logger.Write("Accessing slayer page")
        ClickWait(100, 675, 1, 100)
        Sleep(100)
    }

    GetSlayerTaskMinion() {
        this.logger.Write("Selecting slayer minion to fight.")
        Send("{WheelDown 15}")
        Sleep(1000) ; Wait for scrolling to complete
        this.ClickImageByName(500, 1, 2035, 1360, "fight.png")
        this.slayerTaskStartTic := A_TickCount
        this.logger.Write("Slayer task started at tick: " . A_TickCount)
    }

    AccessSlayerTask() {
        this.logger.Write("Clicking 'Get Task'")
        taskX := 765
        taskY := 235
        ClickWait(taskX, taskY, 1, 100)
        Sleep(250)
    }

    NewTaskAvailable() {
        this.logger.Write("Checking if new slayer task available")
        return this.findImageByName(530, 1250, 840, 1350, "getTask.png")
    }

    ActivateCombatBoost() {
        this.logger.Write("Activating combat boost")
        result := this.ClickImageByName(2205, 0, 2280, 110, "combatBoost.png")
        if (result.success) {
            ClickWait(2185, 30, 1, 1000) ; Move mouse to neutral position to not block next action
        }
    }

    ActivateSkillBoost() {
        this.logger.Write("Activating skill boost")
        result := this.ClickImageByName(2205, 0, 2280, 110, "skillBoost.png")
        if (result.success) {
            ClickWait(2185, 30, 1, 1000) ; Move mouse to neutral position to not block next action
        }
    }

    ActivateBoosts() {
        this.ActivateCombatBoost()
        this.ActivateSkillBoost()
    }

    ClickImage(x1, y1, x2, y2, imagePath, attemptCount := 1, throwError := false) {
        results := this.FindImage(x1, y1, x2, y2, imagePath, attemptCount, throwError)
        if (results.success) {
            this.logger.Write("Clicking image at X: " . results.x . " Y: " . results.y)
            ClickWait(results.x, results.y, 1, 100)
        }

        return results
    }

    ClickImageByName(x1, y1, x2, y2, imageName, attemptCount := 1, throwError := false) {
        results := this.FindImageByName(x1, y1, x2, y2, imageName, attemptCount, throwError)
        if (results.success) {
            this.logger.Write("Clicking image at X: " . results.x . " Y: " . results.y)
            ClickWait(results.x, results.y, 1, 100)
        }

        return results
    }

    FindImage(x1, y1, x2, y2, imagePath, maxTryCount := 1, throwError := false) {
        this.logger.Write("Searching for image by path: " . imagePath)
        this.logger.Write("Searching area X1: " . x1 . " Y1: " . y1 . " X2: " . x2 . " Y2: " . y2)

        outX := ""
        outY := ""
        success := false

        attemptCount := 1
        while ((attemptCount <= maxTryCount) and !success) {
            this.logger.Write("Attempt: " . attemptCount)
            ErrorLevel := !ImageSearch(&outX, &outY, x1, y1, x2, y2, "*5 " imagePath)
            if ErrorLevel {
                attemptCount += 1
                this.logger.WriteWarn("Image not found")
            }
            else {
                this.logger.Write("Image found at X: " . outX . " Y: " . outY)
                success := true
            }

            Sleep(250)
        }

        if (!success and throwError) {
            this.logger.WriteError("Image not found after [ " . attemptCount . " ] attempts")
        }

        return {success: success, x: outX, y: outY}
    }

    FindImageByName(x1, y1, x2, y2, imageName, attemptCount := 1, throwError := false) {
        this.logger.Write("Searching for image by name: " . imageName)
        baseImagePath := A_ScriptDir . "\..\application\game\rocky_idle\images"
        fullImagePath := baseImagePath . "\" . imageName

        return this.FindImage(x1, y1, x2, y2, fullImagePath, attemptCount, throwError)
    }
}

F1::autoPlay([])
F2::autoPlay(["Slayer"])
F3::autoPlay(["Farming"])
F4::autoPlay(["Slayer", "Farming"])

#HotIf ; Clear HotIf
