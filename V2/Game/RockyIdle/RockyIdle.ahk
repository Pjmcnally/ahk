; Directives
#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\..\..\Lib\Internal"
#Include "Array.ahk"
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
        this.UiaElement := UIA.ElementFromChromium("ahk_exe Rocky Idle.exe")
        this.TaskList := []
        this.SlayerTaskCount := 0
        this.SlayerTaskStartTick := 0
        this.SlayerTaskTimeout := 2 * 60 * 1000 ; 2 minutes (in milliseconds)
        this.BaseImagePath := A_WorkingDir . "\Game\RockyIdle\Images"
    }

    Run(TaskList) {
        this.TaskList := TaskList
        GlobalLogger.WriteInfo("Initializing Rocky Idle automation with tasks: [" . TaskList.Join(", ") . "]")

        TaskArray := Map(
            "Boosts", this.ActivateBoosts.Bind(this),
            "Slayer", this.RunSlayer.Bind(this),
            "Farming", this.RunFarm.Bind(this)
        )

        while (WinExist("ahk_exe Rocky Idle.exe")) {
            for (task in TaskList) {
                if (TaskArray.Has(task)) {
                    TaskArray[task]()
                } else {
                    GlobalLogger.WriteWarn("No function mapped for task: " . task)
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
        GlobalLogger.WriteDebug("Getting random file from: " . directoryPath)
        fileList := []
        Loop Files, directoryPath "\*.*"
        {
            fileList.Push(A_LoopFilePath)
        }

        count := fileList.Length
        GlobalLogger.WriteDebug("Total Files Found: " . count)

        randomIndex := Random(1, count)
        selectedFile := fileList[randomIndex]
        GlobalLogger.WriteDebug("Selected file: " . selectedFile)

        return selectedFile
    }

    RunFarm() {
        this.DisplayToolTip("Running AutoFarm")
        GlobalLogger.WriteInfo("AutoFarm process started")
        this.HarvestFarm()
        this.CheckInactiveFarm()
        GlobalLogger.WriteInfo("AutoFarm process complete")
    }

    HarvestFarm() {
        GlobalLogger.WriteInfo("Checking for available harvests.")

        this.GoToFarmingPage("Bush")
        GlobalLogger.WriteInfo("Checking for harvestable bushes.")
        harvestBushesResults := this.ClickImageByName(775, 550, 1150, 780, "claimAll.png", 1500)
        if (harvestBushesResults.Success) {
            this.PlantFarm("Bush")
        }

        this.GoToFarmingPage("Tree")
        GlobalLogger.WriteInfo("Checking for harvestable trees.")
        harvestTreesResults := this.ClickImageByName(775, 550, 1150, 780, "claimAll.png", 1500)
        if (harvestTreesResults.Success) {
            this.PlantFarm("Tree")
        }
    }

    PlantFarm(type := "") {
        if (type = "") {
            GlobalLogger.WriteDebug("Type unknown. Finding active type.")
        }

        if (type = "Bush" or this.FindImageByName(500, 150, 1430, 250, "bushPageActive.png").Success) {
            this.PlantBushes()
        } else if (type = "Tree" or this.FindImageByName(500, 150, 1430, 250, "treePageActive.png").Success) {
            this.PlantTrees()
        } else {
            GlobalLogger.WriteError("No type specified or found")
        }
    }

    CheckInactiveFarm(type := "Both") {
        if (type = "Both") {
            this.CheckInactiveFarm("Bush")
            this.CheckInactiveFarm("Tree")
            return
        }

        GlobalLogger.WriteInfo("Checking sidebar for missing type: " . type)
        findResults := this.FindImageByName(2310, 160, 2550, 1005, type . "SidebarActive.png")

        if (findResults.Success) {
            GlobalLogger.WriteDebug("Type " . type . " found in sidebar. No action needed.")
        } else {
            GlobalLogger.WriteWarn("Type " . type . " not found in sidebar. Planting " . type)
            this.GoToFarmingPage(type)
            this.PlantFarm(type)
        }
    }


    GoToFarmingPage(type := "") {
        GlobalLogger.WriteDebug("Activating farming page")
        Mouse.ClickWait(55, 545, 1, 1000)     ; Activate farming screen

        GlobalLogger.WriteDebug("Scrolling to top of page")
        Mouse.ClickWait(1250, 685, 0, 1000)   ; Activate scrollable section of screen
        Keyboard.SendWait("{WheelUp 15}", 1000) ; Scroll to top of screen (otherwise all click positions will be wrong.)

        if (type = "bush") {
            GlobalLogger.WriteDebug("Access page for type: " . type)
            Mouse.ClickWait(760, 200, 1, 1000)
        } else if (type = "tree") {
            GlobalLogger.WriteDebug("Access page for type: " . type)
            Mouse.ClickWait(1225, 200, 1, 1000)
        }
    }

    PlantBushes() {
        GlobalLogger.WriteInfo("Planting Bushes.")
        randomBush := this.GetRandomFile(this.BaseImagePath . "\Bushes\Active")
        this.ClickImage(525, 800, 1425, 1365, randomBush)
    }

    PlantTrees() {
        GlobalLogger.WriteInfo("Planting Trees.")
        randomTree := this.GetRandomFile(this.BaseImagePath . "\Trees\Active")
        this.ClickImage(525, 800, 1425, 1365, randomTree)
    }


    RunSlayer() {
        this.DisplayToolTip("Running AutoSlayer - Tasks Completed: [" . this.SlayerTaskCount . "]")
        GlobalLogger.WriteInfo("Starting AutoSlayer process")
        this.GoToSlayerPage()

        newTaskInfo := this.NewTaskAvailable()
        if (newTaskInfo.success) {
            this.GetNewSlayerTask(newTaskInfo)
            this.StartSlayerTaskCombat()
        } else {
            this.CheckForStaleSlayerTask()
        }
        GlobalLogger.WriteInfo("AutoSlayer process complete")
    CheckSlayerActive() {
        GlobalLogger.WriteDebug("Checking if Slayer is active")
        slayerActive := this.UiaElement.ElementExist({Name:"Slayer Monster Category"})

        if (slayerActive) {
            GlobalLogger.WriteDebug("Slayer is active.")
        } else {
            GlobalLogger.WriteDebug("Slayer is not active.")
        }

        return slayerActive
    }

    CheckForStaleSlayerTask() {
        currentTick := A_TickCount
        currentTaskDuration := A_TickCount - this.SlayerTaskStartTick

        GlobalLogger.WriteInfo("Checking For Stale Slayer Task")
        GlobalLogger.WriteDebug("Current tick: " . currentTick)
        GlobalLogger.WriteDebug("Slayer task start tick: " . this.SlayerTaskStartTick)
        GlobalLogger.WriteDebug("Current task duration: " . currentTaskDuration)
        GlobalLogger.WriteDebug("Slayer task timeout: " . this.SlayerTaskTimeout)

        if (currentTaskDuration > this.SlayerTaskTimeout) {
            GlobalLogger.WriteWarn("Current task running longer than timeout. Replacing Stale Minion")
            ; On way a task can fail is if no combat is active at all. This moves the button necessary to select the correct minion.
            ; By going to the monster page and starting combat it ensure that the button for the correct task is in the correct place.
            this.GoToMonsterPage()
            this.StartCombat()
            ; Select the correct task minion and start combat.
            this.StartSlayerTaskCombat()
        }
    }

    GetNewSlayerTask() {
        GlobalLogger.WriteInfo("Getting new slayer task.")
        this.GoToSlayerPage()

        this.UiaElement.ElementFromPath({T:0, i:43}).Click() ; Click "Get New Task" button.
        if (this.SlayerTaskCount > 0) {
            durationString := Format("{1:i}", (A_TickCount - this.SlayerTaskStartTick) / 1000)
            GlobalLogger.WriteInfo("Slayer task completed. Count: [" . this.SlayerTaskCount . "] Completed After: [" . durationString . "] seconds.")
        }
        this.SlayerTaskCount += 1

        Sleep(1000)
    }

    GoToMonsterPage() {
        GlobalLogger.WriteDebug("Accessing monster page")
        this.UiaElement.ElementFromPath({T:20, i:19}).Click()
        Sleep(1000)
    }

    GoToSlayerPage() {
        GlobalLogger.WriteDebug("Accessing slayer page")
        this.UiaElement.ElementFromPath({T:26}, {T:26}, {T:5, i:13}).Click()
        Sleep(1000)
    }

    StartCombat() {
        GlobalLogger.WriteDebug("Attempting to start combat.")
        this.UiaElement.FindElement({Name:"Fight"}).Click() ; Find first button with name "Fight" and click it.
        Sleep(1000)

        return true
    }

    StartSlayerTaskCombat() {
        GlobalLogger.WriteInfo("Starting slayer task combat")
        this.AccessSlayerTaskMinionList()
        if (this.StartCombat()) {
            this.SlayerTaskStartTick := A_TickCount
            GlobalLogger.WriteDebug("Slayer task started at tick: " . A_TickCount)
        }
    }

    AccessSlayerTaskMinionList() {
        GlobalLogger.WriteDebug("Clicking task type to get list of task minions")
        if (this.UiaElement.ElementExist({Name:"Slayer Monster Category"})) {
            this.UiaElement.ElementExist({Name:"Slayer Monster Category"}).Click()
            Sleep(1000)
        } else {
            GlobalLogger.WriteError("Slayer task type button not found. Unable to continue.")
            throw Error("Slayer task type button not found. Unable to continue.")
        }
    }

    NewTaskAvailable() {
        GlobalLogger.WriteInfo("Checking if new slayer task available")
        return this.FindImageByName(530, 1250, 840, 1350, "getTask.png")
    }

    ActivateSkillBoost() {
        GlobalLogger.WriteInfo("Activating Skill Boost")
        this.UiaElement.ElementFromPath({T:6, i:10}).Click()
    }

    ActivateCombatBoost() {
        GlobalLogger.WriteInfo("Activating Combat Boost")
        this.UiaElement.ElementFromPath({T:6, i:11}).Click()
    }

    ActivateBoosts() {
        this.DisplayToolTip("Activating Boosts")
        this.ActivateCombatBoost()
        this.ActivateSkillBoost()
        Sleep(3000)
    }

    Dispose() {
        this.HideToolTip()
    }
}
