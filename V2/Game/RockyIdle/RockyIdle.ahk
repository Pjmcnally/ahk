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

    RunFarm() {
        this.DisplayToolTip("Running AutoFarm")
        GlobalLogger.WriteInfo("AutoFarm process started")

        while (this.CheckForAvailableHarvest()) {
            this.CycleFarm()
        }

        inactive := this.CheckInactiveFarm()
        for (farmType in inactive) {
            this.GoToFarmingPage(farmType)
            this.PlantFarm([farmType])
        }

        GlobalLogger.WriteInfo("AutoFarm process complete")
    }

    CheckForAvailableHarvest() {
        GlobalLogger.WriteInfo("Checking for available harvests.")
        return this.UiaElement.ElementExist({Name:"Done"})
    }

    CycleFarm() {
        GlobalLogger.WriteInfo("Harvesting and replanting farm.")
        this.HarvestFromSideBar()
        this.PlantFarm(["Bush", "Tree"])
    }

    HarvestFromSideBar() {
        this.UiaElement.ElementFromPath({Name:"Done"}).Click()
        Sleep(1000)

        this.UiaElement.ElementFromPath({Name:"Claim All"}).Click()
        Sleep(1000)
    }

    PlantFarm(types) {
        if (types.Includes("Bush")) {
            this.PlantBushes()
        }

        if (types.Includes("Tree")) {
            this.PlantTrees()
        }
    }

    CheckInactiveFarm() {
        GlobalLogger.WriteInfo("Checking sidebar for missing farming types.")
        inactive := []

        if (!this.UiaElement.ElementExist({Name: "Bushes", T:20})) {
            GlobalLogger.WriteWarn("No active bushes found. Adding to inactive list.")
            inactive.Push("Bush")
        }

        if (!this.UiaElement.ElementExist({Name: "Trees", T:20})) {
            GlobalLogger.WriteWarn("No active trees found. Adding to inactive list.")
            inactive.Push("Tree")
        }

        return inactive
    }


    GoToFarmingPage(type := "") {
        GlobalLogger.WriteDebug("Activating farming page")
        this.UiaElement.FindElement({T:26}, {T:26}, {T:5, i:10}).Click()

        if (type) {
            GlobalLogger.WriteDebug("Access page for type: " . type)
        }

        if (type = "Bush") {
            this.UiaElement.FindElement({T:0, i:38}).Click()
        } else if (type = "Tree") {
            this.UiaElement.FindElement({T:0, i:39}).Click()
        }
    }

    PlantBushes() {
        activeBushes := [
            76, ; Gooseberry
            84, ; Blueberry
            92, ; Strawberry
            100, ; Blackberry
            108 ; Salmonberry
        ]

        randomBush := activeBushes.GetRandom()

        if (this.UiaElement.ElementExist({T:20, I:randomBush})) {
            GlobalLogger.WriteDebug("Planting bush with ID: " . randomBush)
            this.UiaElement.FindElement({T:20, I:randomBush}).Click()
        }
    }

    PlantTrees() {
        activeTrees := [
            56, ; Pine
            66, ; Ebony
            76, ; Eucalyptus
            86, ; Baobab
            96 ; Canary
        ]

        randomTree := activeTrees.GetRandom()

        if (this.UiaElement.ElementExist({T:20, I:randomTree})) {
            GlobalLogger.WriteDebug("Planting tree with ID: " . randomTree)
            this.UiaElement.FindElement({T:20, I:randomTree}).Click()
        }
    }


    RunSlayer() {
        this.DisplayToolTip("Running AutoSlayer - Tasks Completed: [" . this.SlayerTaskCount . "]")
        GlobalLogger.WriteInfo("Starting AutoSlayer process")
        if (this.CheckSlayerActive()) {
            this.CheckForStaleSlayerTask()
        } else {
            this.GetNewSlayerTask()
            this.StartSlayerTaskCombat()
        }

        GlobalLogger.WriteInfo("AutoSlayer process complete")
        Sleep(3000)
    }

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
