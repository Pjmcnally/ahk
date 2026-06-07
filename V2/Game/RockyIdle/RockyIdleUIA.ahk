/* Status: This currently doesn't work. It is in the middle of a refactor from image based search to UIA integration.

At this time mods have been released for the game which do what I am trying to do here but better. I am abandoning this
project for now. However, I want to keep this code as a way to remember how to use UIA as I may wish to use it for
other projects.
*/

; Directives
#Requires AutoHotkey v2.0

; Includes
#Include "%A_LineFile%\..\..\..\Lib\Internal"
#Include "Array.ahk"
#Include "Logger.ahk"
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
/**
 * @description `RunRockyIdle`
 * Runs the Rocky Idle automation with the specified tasks.
 * @param {(Array)} taskList
 * The list of tasks to run.
 * @returns {(String)}
 * Always returns an empty string.
 */
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
/**
 * @class RockyIdle
 * This class is responsible for running the Rocky Idle automation.
 */
class RockyIdle {
    __New() {
        this.UiaElement := UIA.ElementFromChromium("ahk_exe Rocky Idle.exe")
        this.TaskList := []
        this.SlayerTaskCount := 0
        this.SlayerTaskStartTick := 0
        this.SlayerTaskTimeout := 2 * 60 * 1000 ; 2 minutes (in milliseconds)
        this.BaseImagePath := A_WorkingDir . "\Game\RockyIdle\Images"
    }

    /**
     * @description `Run`
     * Runs the Rocky Idle automation with the specified tasks.
     * @param {(Array)} taskList
     * The list of tasks to run.
     * @returns {(String)}
     * Always returns an empty string.
     */
    Run(TaskList) {
        this.TaskList := TaskList
        Logger.WriteInfo("Initializing Rocky Idle automation with tasks: [" . TaskList.Join(", ") . "]")

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
                    Logger.WriteWarn("No function mapped for task: " . task)
                }
            }

            this.DisplayToolTip("Paused")
            Sleep(2000)
        }
    }

    /**
     * @description `DisplayToolTip`
     * Displays a tooltip with the current status of the automation.
     * @param {(String)} Status
     * The current status of the automation.
     * @returns {(Void)}
     */
    DisplayToolTip(Status) {
        ToolTip("Automation Active with mode(s): [" . this.TaskList.Join(", ") . "]. Current Status: [" . Status . "]", 10, 10)
    }

    /**
     * @description `HideToolTip`
     * Hides the tooltip.
     * @returns {(String)}
     * Always returns an empty string.
     */
    HideToolTip() {
        ToolTip()
    }

    ;#region Farming
    /**
     * @description `RunFarm`
     * Runs the farming automation.
     * @returns {(String)}
     * Always returns an empty string.
     */
    RunFarm() {
        this.DisplayToolTip("Running AutoFarm")
        Logger.WriteInfo("AutoFarm process started")

        while (this.CheckForAvailableHarvest()) {
            this.CycleFarm()
        }

        inactive := this.CheckInactiveFarm()
        for (farmType in inactive) {
            this.GoToFarmingPage(farmType)
            this.PlantFarm([farmType])
        }

        Logger.WriteInfo("AutoFarm process complete")
    }

    /**
     * @description `CheckForAvailableHarvest`
     * Checks if there are any available harvests.
     * @returns {(Boolean)}
     * Returns true if there are available harvests, false otherwise.
     */
    CheckForAvailableHarvest() {
        Logger.WriteInfo("Checking for available harvests.")
        return this.UiaElement.ElementExist({Name:"Done"})
    }

    /**
     * @description `CycleFarm`
     * Cycles the farm by harvesting and replanting.
     * @returns {(String)}
     * Always returns an empty string.
     */
    CycleFarm() {
        Logger.WriteInfo("Harvesting and replanting farm.")
        this.HarvestFromSideBar()
        this.PlantFarm(["Bush", "Tree"])
    }

    /**
     * @description `HarvestFromSideBar`
     * Harvests all available harvests from the side bar.
     * @returns {(String)}
     * Always returns an empty string.
     */
    HarvestFromSideBar() {
        this.UiaElement.ElementFromPath({Name:"Done"}).Click()
        Sleep(1000)

        this.UiaElement.ElementFromPath({Name:"Claim All"}).Click()
        Sleep(1000)
    }

    /**
     * @description `PlantFarm`
     * Plants the specified types of farm.
     * @param {(Array)} types
     * The types of farm to plant. Allowed values are "Bush" and "Tree".
     * @returns {(String)}
     * Always returns an empty string.
     */
    PlantFarm(types) {
        if (types.Includes("Bush")) {
            this.PlantBushes()
        }

        if (types.Includes("Tree")) {
            this.PlantTrees()
        }
    }

    /**
     * @description `CheckInactiveFarm`
     * Checks the sidebar for any inactive farming types.
     * @returns {(Array)}
     * Returns an array of inactive farming types. If no inactive types are found, an empty array is returned.
     */
    CheckInactiveFarm() {
        Logger.WriteInfo("Checking sidebar for missing farming types.")
        inactive := []

        if (!this.UiaElement.ElementExist({Name: "Bushes", T:20})) {
            Logger.WriteWarn("No active bushes found. Adding to inactive list.")
            inactive.Push("Bush")
        }

        if (!this.UiaElement.ElementExist({Name: "Trees", T:20})) {
            Logger.WriteWarn("No active trees found. Adding to inactive list.")
            inactive.Push("Tree")
        }

        return inactive
    }

    /**
     * @description `GoToFarmingPage`
     * Goes to the farming page.
     * @param {(String)} type
     * The type of farming to access. If not specified, the default farming page is accessed.
     * @returns {(String)}
     * Always returns an empty string.
     */
    GoToFarmingPage(type := "") {
        Logger.WriteDebug("Activating farming page")
        this.UiaElement.FindElement({T:26}, {T:26}, {T:5, i:10}).Click()

        if (type) {
            Logger.WriteDebug("Access page for type: " . type)
        }

        if (type = "Bush") {
            this.UiaElement.FindElement({T:0, i:38}).Click()
        } else if (type = "Tree") {
            this.UiaElement.FindElement({T:0, i:39}).Click()
        }
    }

    /**
     * @description `PlantBushes`
     * Plants bushes. The planted bushes are randomly selected from a list of active bushes.
     * @returns {(String)}
     * Always returns an empty string.
     */
    PlantBushes() {
        activeBushes := [
            76, ; Gooseberry
            84, ; Blueberry
            92, ; Strawberry
            100, ; Blackberry
            108 ; Salmonberry
        ]

        randomBush := activeBushes.GetRandomItem()

        if (this.UiaElement.ElementExist({T:20, I:randomBush})) {
            Logger.WriteDebug("Planting bush with ID: " . randomBush)
            this.UiaElement.FindElement({T:20, I:randomBush}).Click()
        }
    }

    /**
     * @description `PlantTrees`
     * Plants trees. The planted trees are randomly selected from a list of active trees.
     * @returns {(String)}
     * Always returns an empty string.
     */
    PlantTrees() {
        activeTrees := [
            56, ; Pine
            66, ; Ebony
            76, ; Eucalyptus
            86, ; Baobab
            96 ; Canary
        ]

        randomTree := activeTrees.GetRandomItem()

        if (this.UiaElement.ElementExist({T:20, I:randomTree})) {
            Logger.WriteDebug("Planting tree with ID: " . randomTree)
            this.UiaElement.FindElement({T:20, I:randomTree}).Click()
        }
    }
    ;#endregion Farming

    ;#region Slayer
    /**
     * @description `RunSlayer`
     * Runs the slayer automation.
     * @returns {(String)}
     * Always returns an empty string.
     */
    RunSlayer() {
        this.DisplayToolTip("Running AutoSlayer - Tasks Completed: [" . this.SlayerTaskCount . "]")
        Logger.WriteInfo("Starting AutoSlayer process")
        if (this.CheckSlayerActive()) {
            this.CheckForStaleSlayerTask()
        } else {
            this.GetNewSlayerTask()
            this.StartSlayerTaskCombat()
        }

        Logger.WriteInfo("AutoSlayer process complete")
        Sleep(3000)
    }

    /**
     * @description `CheckSlayerActive`
     * Checks if there is an active slayer task.
     * @returns {(Boolean)}
     * Returns true if an active slayer task is found, false otherwise.
     */
    CheckSlayerActive() {
        Logger.WriteDebug("Checking if Slayer is active")
        slayerActive := this.UiaElement.ElementExist({Name:"Slayer Monster Category"})

        if (slayerActive) {
            Logger.WriteDebug("Slayer is active.")
        } else {
            Logger.WriteDebug("Slayer is not active.")
        }

        return slayerActive
    }

    /**
     * @description `CheckForStaleSlayerTask`
     * Checks if there is a stale slayer task. A task is considered stale if it has been running for longer than the timeout.
     * @returns {(String)}
     * Always returns an empty string.
     */
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

    /**
     * @description `GetNewSlayerTask`
     * Gets a new slayer task.
     * @returns {(String)}
     * Always returns an empty string.
     */
    GetNewSlayerTask() {
        Logger.WriteInfo("Getting new slayer task.")
        this.GoToSlayerPage()

        this.UiaElement.ElementFromPath({T:0, i:43}).Click() ; Click "Get New Task" button.
        if (this.SlayerTaskCount > 0) {
            durationString := Format("{1:i}", (A_TickCount - this.SlayerTaskStartTick) / 1000)
            Logger.WriteInfo("Slayer task completed. Count: [" . this.SlayerTaskCount . "] Completed After: [" . durationString . "] seconds.")
        }
        this.SlayerTaskCount += 1

        Sleep(1000)
    }

    /**
     * @description `GoToMonsterPage`
     * Goes to the monster page.
     * @returns {(String)}
     * Always returns an empty string.
     */
    GoToMonsterPage() {
        Logger.WriteDebug("Accessing monster page")
        this.UiaElement.ElementFromPath({T:20, i:19}).Click()
        Sleep(1000)
    }

    /**
     * @description `GoToSlayerPage`
     * Goes to the slayer page.
     * @returns {(String)}
     * Always returns an empty string.
     */
    GoToSlayerPage() {
        Logger.WriteDebug("Accessing slayer page")
        this.UiaElement.ElementFromPath({T:26}, {T:26}, {T:5, i:13}).Click()
        Sleep(1000)
    }

    /**
     * @description `StartCombat`
     * Starts combat.
     * @returns {(Boolean)}
     * Returns true if combat is started, false otherwise.
     */
    StartCombat() {
        Logger.WriteDebug("Attempting to start combat.")
        this.UiaElement.FindElement({Name:"Fight"}).Click() ; Find first button with name "Fight" and click it.
        Sleep(1000)

        return true
    }

    /**
     * @description `StartSlayerTaskCombat`
     * Starts the slayer task combat.
     * @returns {(String)}
     * Always returns an empty string.
     */
    StartSlayerTaskCombat() {
        Logger.WriteInfo("Starting slayer task combat")
        this.AccessSlayerTaskMinionList()
        if (this.StartCombat()) {
            this.SlayerTaskStartTick := A_TickCount
            Logger.WriteDebug("Slayer task started at tick: " . A_TickCount)
        }
    }

    /**
     * @description `AccessSlayerTaskMinionList`
     * Accesses the slayer task minion list.
     * @returns {(String)}
     * Always returns an empty string.
     */
    AccessSlayerTaskMinionList() {
        Logger.WriteDebug("Clicking task type to get list of task minions")
        if (this.UiaElement.ElementExist({Name:"Slayer Monster Category"})) {
            this.UiaElement.ElementExist({Name:"Slayer Monster Category"}).Click()
            Sleep(1000)
        } else {
            Logger.WriteError("Slayer task type button not found. Unable to continue.")
            throw Error("Slayer task type button not found. Unable to continue.")
        }
    }
    ;#endregion Slayer

    ;#region Boosts
    /**
     * @description `ActivateSkillBoost`
     * Activates the skill boost.
     * @returns {(String)}
     * Always returns an empty string.
     */
    ActivateSkillBoost() {
        Logger.WriteInfo("Activating Skill Boost")
        this.UiaElement.ElementFromPath({T:6, i:10}).Click()
    }

    /**
     * @description `ActivateCombatBoost`
     * Activates the combat boost.
     * @returns {(String)}
     * Always returns an empty string.
     */
    ActivateCombatBoost() {
        Logger.WriteInfo("Activating Combat Boost")
        this.UiaElement.ElementFromPath({T:6, i:11}).Click()
    }

    /**
     * @description `ActivateBoosts`
     * Activates both the skill and combat boosts.
     * @returns {(String)}
     * Always returns an empty string.
     */
    ActivateBoosts() {
        this.DisplayToolTip("Activating Boosts")
        this.ActivateCombatBoost()
        this.ActivateSkillBoost()
        Sleep(3000)
    }
    ;#endregion

    /**
     * @description `Dispose`
     * Disposes of the Rocky Idle automation.
     * @returns {(String)}
     * Always returns an empty string.
     */
    Dispose() {
        this.HideToolTip()
    }
}
