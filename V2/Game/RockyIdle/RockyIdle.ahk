; Directives
#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\..\..\Lib\Internal"
#Include "Keyboard.ahk"
#Include "Logger.ahk"
#Include "Mouse.ahk"
#Include "System.ahk"
#Include "%A_LineFile%\..\..\..\Lib\External"
#Include "UIA.ahk"

; Hotkeys
#HotIf WinActive("ahk_exe Rocky Idle.exe")
F1::RunRockyIdle(["Boosts"])
F2::RunRockyIdle(["Boosts", "Slayer"])
F3::RunRockyIdle(["Boosts", "Farming"])
F4::RunRockyIdle(["Boosts", "Slayer", "Farming"])
F5::Reload() ; Stop all automation
#HotIf ; Clear HotIf

; Functions
RunRockyIdle(taskList) {
    static rockyObj := RockyIdle()

    try {
        rockyObj.Run(taskList)
    } catch Error as e {
        throw e
    } finally {
        if(IsSet(rockyObj) and IsObject(rockyObj)) {
            rockyObj.Dispose()
        }
    }
}

; Classes
class RockyIdle {
    __New() {
        this.TaskList := []
        this.SlayerTaskCount := 0
        this.SlayerTaskStartTick := 0
        this.SlayerTaskTimeout := 2 * 60 * 1000 ; 2 minutes (in milliseconds)
        this.BaseImagePath := A_WorkingDir . "\Game\RockyIdle\Images"
    }

    Run(TaskList) {
        this.TaskList := TaskList
        Logger.WriteInfo("Initializing Rocky Idle automation with tasks: [" . TaskList.Join(", ") . "]")

        TaskArray := Map(
            "Boosts", this.ActivateBoosts.Bind(this),
            "Slayer", this.RunSlayer.Bind(this),
            "Farming", this.RunFarm.Bind(this)
        )

        while (WinActive("ahk_exe Rocky Idle.exe")) {
            for (task in TaskList) {
                if (TaskArray.Has(task)) {
                    TaskArray[task]()
                } else {
                    Logger.WriteWarn("No function mapped for task: " . task)
                }
            }

            this.DisplayToolTip("Paused")
            Sleep(2000)
        }
    }

    DisplayToolTip(Status) {
        ToolTip("Automation Active with mode(s): [" . this.TaskList.Join(", ") . "]. Current Status: [" . Status . "]", 10, 10)
    }

    HideToolTip() {
        ToolTip()
    }

    GetRandomFile(directoryPath) {
        Logger.WriteDebug("Getting random file from: " . directoryPath)
        fileList := []
        Loop Files, directoryPath "\*.*"
        {
            fileList.Push(A_LoopFilePath)
        }

        count := fileList.Length
        Logger.WriteDebug("Total Files Found: " . count)

        randomIndex := Random(1, count)
        selectedFile := fileList[randomIndex]
        Logger.WriteDebug("Selected file: " . selectedFile)

        return selectedFile
    }

    RunFarm() {
        this.DisplayToolTip("Running AutoFarm")
        Logger.WriteInfo("AutoFarm process started")
        this.HarvestFarm()
        this.CheckInactiveFarm()
        Logger.WriteInfo("AutoFarm process complete")
    }

    HarvestFarm() {
        Logger.WriteInfo("Checking for available harvests.")

        this.GoToFarmingPage("Bush")
        Logger.WriteInfo("Checking for harvestable bushes.")
        harvestBushesResults := this.ClickImageByName(775, 550, 1150, 780, "claimAll.png", 1500)
        if (harvestBushesResults.Success) {
            this.PlantFarm("Bush")
        }

        this.GoToFarmingPage("Tree")
        Logger.WriteInfo("Checking for harvestable trees.")
        harvestTreesResults := this.ClickImageByName(775, 550, 1150, 780, "claimAll.png", 1500)
        if (harvestTreesResults.Success) {
            this.PlantFarm("Tree")
        }
    }

    PlantFarm(type := "") {
        if (type = "") {
            Logger.WriteDebug("Type unknown. Finding active type.")
        }

        if (type = "Bush" or this.FindImageByName(500, 150, 1430, 250, "bushPageActive.png").Success) {
            this.PlantBushes()
        } else if (type = "Tree" or this.FindImageByName(500, 150, 1430, 250, "treePageActive.png").Success) {
            this.PlantTrees()
        } else {
            Logger.WriteError("No type specified or found")
        }
    }

    CheckInactiveFarm(type := "Both") {
        if (type = "Both") {
            this.CheckInactiveFarm("Bush")
            this.CheckInactiveFarm("Tree")
            return
        }

        Logger.WriteInfo("Checking sidebar for missing type: " . type)
        findResults := this.FindImageByName(2310, 160, 2550, 1005, type . "SidebarActive.png")

        if (findResults.Success) {
            Logger.WriteDebug("Type " . type . " found in sidebar. No action needed.")
        } else {
            Logger.WriteWarn("Type " . type . " not found in sidebar. Planting " . type)
            this.GoToFarmingPage(type)
            this.PlantFarm(type)
        }
    }


    GoToFarmingPage(type := "") {
        Logger.WriteDebug("Activating farming page")
        Mouse.ClickWait(55, 545, 1, 1000)     ; Activate farming screen

        Logger.WriteDebug("Scrolling to top of page")
        Mouse.ClickWait(1250, 685, 0, 1000)   ; Activate scrollable section of screen
        Keyboard.SendWait("{WheelUp 15}", 1000) ; Scroll to top of screen (otherwise all click positions will be wrong.)

        if (type = "bush") {
            Logger.WriteDebug("Access page for type: " . type)
            Mouse.ClickWait(760, 200, 1, 1000)
        } else if (type = "tree") {
            Logger.WriteDebug("Access page for type: " . type)
            Mouse.ClickWait(1225, 200, 1, 1000)
        }
    }

    PlantBushes() {
        Logger.WriteInfo("Planting Bushes.")
        randomBush := this.GetRandomFile(this.BaseImagePath . "\Bushes\Active")
        this.ClickImage(525, 800, 1425, 1365, randomBush)
    }

    PlantTrees() {
        Logger.WriteInfo("Planting Trees.")
        randomTree := this.GetRandomFile(this.BaseImagePath . "\Trees\Active")
        this.ClickImage(525, 800, 1425, 1365, randomTree)
    }


    RunSlayer() {
        this.DisplayToolTip("Running AutoSlayer - Tasks Completed: [" . this.SlayerTaskCount . "]")
        Logger.WriteInfo("Starting AutoSlayer process")
        this.GoToSlayerPage()

        newTaskInfo := this.NewTaskAvailable()
        if (newTaskInfo.success) {
            this.GetNewSlayerTask(newTaskInfo)
            this.StartSlayerTaskCombat()
        } else {
            this.CheckForStaleSlayerTask()
        }
        Logger.WriteInfo("AutoSlayer process complete")
    }

    CheckForStaleSlayerTask() {
        currentTick := A_TickCount
        currentTaskDuration := A_TickCount - this.SlayerTaskStartTick

        Logger.WriteInfo("Checking For Stale Slayer Task")
        Logger.WriteDebug("Current tick: " . currentTick)
        Logger.WriteDebug("Slayer task start tick: " . this.SlayerTaskStartTick)
        Logger.WriteDebug("Current task duration: " . currentTaskDuration)
        Logger.WriteDebug("Slayer task timeout: " . this.SlayerTaskTimeout)

        if (currentTaskDuration > this.SlayerTaskTimeout) {
            Logger.WriteWarn("Current task running longer than timeout. Replacing Stale Minion")
            ; On way a task can fail is if no combat is active at all. This moves the button necessary to select the correct minion.
            ; By going to the monster page and starting combat it ensure that the button for the correct task is in the correct place.
            this.GoToMonsterPage()
            this.StartCombat()
            ; Select the correct task minion and start combat.
            this.StartSlayerTaskCombat()
        }
    }

    GetNewSlayerTask(newTaskInfo) {
        Logger.WriteInfo("Getting new slayer task.")
        Mouse.ClickWait(newTaskInfo.x, newTaskInfo.y, 1, 1000)
        if (this.SlayerTaskCount > 0) {
            durationString := Format("{1:i}", (A_TickCount - this.SlayerTaskStartTick) / 1000)
            Logger.WriteInfo("Slayer task completed. Count: [" . this.SlayerTaskCount . "] Completed After: [" . durationString . "] seconds.")
        }

        this.SlayerTaskCount += 1
    }

    GoToMonsterPage() {
        Logger.WriteDebug("Accessing monster page")
        Mouse.ClickWait(250, 750, 1, 1000)
    }

    GoToSlayerPage() {
        Logger.WriteDebug("Accessing slayer page")
        Mouse.ClickWait(100, 675, 1, 1000)
    }

    StartCombat() {
        success := false
        maxAttempts := 3
        currentAttempt := 1

        while (!success and currentAttempt <= maxAttempts) {
            Logger.WriteDebug("Attempting to start combat. Attempt: " . currentAttempt)
            Mouse.ClickWait(1275, 985, 0, 1000)  ; Activate scrollable section of screen
            Keyboard.SendWait("{WheelDown 15}", 1000)
            result := this.ClickImageByName(500, 1, 2035, 1360, "fight.png")

            success := result.success
            currentAttempt += 1
        }

        if (!success) {
            Logger.WriteError("Failed to start combat after " . maxAttempts . " attempts.")
            throw Error("Failed to start combat after " . maxAttempts . " attempts.")
        }

        return success
    }

    StartSlayerTaskCombat() {
        Logger.WriteInfo("Starting slayer task combat")
        this.AccessSlayerTaskMinionList()
        if (this.StartCombat()) {
            this.SlayerTaskStartTick := A_TickCount
            Logger.WriteDebug("Slayer task started at tick: " . A_TickCount)
        }
    }

    AccessSlayerTaskMinionList() {
        Logger.WriteDebug("Clicking task type to get list of task minions")
        taskX := 2525
        taskY := 205
        Mouse.ClickWait(taskX, taskY, 1, 1000)
    }

    NewTaskAvailable() {
        Logger.WriteInfo("Checking if new slayer task available")
        return this.FindImageByName(530, 1250, 840, 1350, "getTask.png")
    }

    ActivateCombatBoost() {
        Logger.WriteInfo("Activating Combat Boost")
        result := this.ClickImageByName(2205, 0, 2280, 110, "combatBoost.png")
        if (result.success) {
            Logger.WriteDebug("Combat boost available. Activating boost.")
            Mouse.ClickWait(2185, 30, 1, 1000) ; Move mouse to neutral position to not block next action
        } else {
            Logger.WriteDebug("Combat boost not found. It may already be active or unavailable.")
        }
    }

    ActivateSkillBoost() {
        Logger.WriteInfo("Activating Skill Boost")
        result := this.ClickImageByName(2205, 0, 2280, 110, "skillBoost.png")
        if (result.success) {
            Logger.WriteDebug("Skill boost available. Activating boost.")
            Mouse.ClickWait(2185, 30, 1, 1000) ; Move mouse to neutral position to not block next action
        } else {
            Logger.WriteDebug("Skill boost not found. It may already be active or unavailable.")
        }
    }

    ActivateBoosts() {
        this.DisplayToolTip("Activating Boosts")
        this.ActivateCombatBoost()
        this.ActivateSkillBoost()
    }

    ClickImage(x1, y1, x2, y2, imagePath, delay := 100, attemptCount := 1, throwError := false) {
        results := this.FindImage(x1, y1, x2, y2, imagePath, attemptCount, throwError)
        if (results.success) {
            Logger.WriteDebug("Clicking image at X: " . results.x . " Y: " . results.y)
            Mouse.ClickWait(results.x, results.y, 1, 100)
        }

        return results
    }

    ClickImageByName(x1, y1, x2, y2, imageName, delay := 100, attemptCount := 1, throwError := false) {
        results := this.FindImageByName(x1, y1, x2, y2, imageName, attemptCount, throwError)
        if (results.success) {
            Logger.WriteDebug("Clicking image at X: " . results.x . " Y: " . results.y)
            Mouse.ClickWait(results.x, results.y, 1, delay)
        }

        return results
    }

    FindImage(x1, y1, x2, y2, imagePath, maxTryCount := 1, mustFind := false) {
        ; Check for valid and existing image path before attempting search
        if (!FileExist(imagePath)) {
            Logger.WriteFatal("Image path does not exist: " . imagePath)
            throw Error("Image path does not exist: " . imagePath)
        }

        Logger.WriteDebug("Searching for image by path: " . imagePath)
        Logger.WriteDebug("Searching area X1: " . x1 . " Y1: " . y1 . " X2: " . x2 . " Y2: " . y2)

        outX := unset
        outY := unset
        success := false

        attemptCount := 1
        errorRetryCount := 0
        while ((attemptCount <= maxTryCount) and !success) {
            Logger.WriteDebug("Attempt: " . attemptCount)

            try {
                if (ImageSearch(&outX, &outY, x1, y1, x2, y2, "*50 " . imagePath)) {
                    Logger.WriteDebug("Image found at X: " . outX . " Y: " . outY)
                    success := true
                } else {
                    attemptCount += 1
                    Logger.WriteDebug("Image not found")
                }
            } catch OSError as e {
                if (errorRetryCount < 3) {
                    errorRetryCount += 1
                    Logger.WriteDebug("Retrying image search after error. Retry count: " . errorRetryCount)
                    Sleep(1000 * errorRetryCount) ; Wait before retrying in case of transient error
                } else {
                    Logger.WriteError("Max retry attempts reached for image search. Aborting search for: " . imagePath)
                    Logger.WriteError("Final error: " . e.Message, e)
                    throw e
                }
            }

            Sleep(250 * attemptCount) ; Wait before next attempt, increasing with each try to allow for any transient issues to resolve
        }

        if (!success and mustFind) {
            Logger.WriteError("Image not found after [" . attemptCount . "] attempts. " . imagePath)
            throw Error("Image not found after [" . attemptCount . "] attempts. " . imagePath)
        }

        return {success: success, x: outX, y: outY}
    }

    FindImageByName(x1, y1, x2, y2, imageName, attemptCount := 1, throwError := false) {
        Logger.WriteDebug("Searching for image by name: " . imageName)
        fullImagePath := this.BaseImagePath . "\" . imageName

        return this.FindImage(x1, y1, x2, y2, fullImagePath, attemptCount, throwError)
    }

    Dispose() {
        this.HideToolTip()
    }
}
