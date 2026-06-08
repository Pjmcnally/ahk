/**
 * @class Diablo
 * This class is responsible for auto-casting skills in the Diablo series of games.
 * @param {(String)} window
 * The name of the game window. Use Window Spy to find.
 */
class Diablo {
    __New(window) {
        this.Window := window
        this.Skills := Map()
    }

    /**
     * @description `DisableAll`
     * Disables automation for all skills.
     * @returns {(String)}
     * Always returns an empty string.
     */
    DisableAll() {
        for key, val in this.Skills {
            val.Disable()
        }
    }

    /**
     * @description `GetSkill`
     * Gets a skill from the skill map. If the skill is not found it is initialized.
     * @param {(String)} key
     * The key of the skill to get.
     * @param {(String)} preReqKey
     * The key of the skill that must be active before the requested skill can be activated.
     * @returns {(DiabloSkill)}
     * The requested skill.
     */
    GetSkill(key, preReqKey:="") {
        ; If skill isn't found initialize it
        if (!(this.Skills.Has(key))) {
            this.Skills[key] := DiabloSkill(key, this.Window, preReqKey)
        }

        return this.Skills[key]
    }
}

/**
 * @class DiabloSkill
 * This class represents a skill in the Diablo series of games.
 * @param {(String)} key
 * The key of the skill to activate.
 * @param {(String)} window
 * The name of the game window. Use Window Spy to find.
 * @param {(String)} preReqKey
 * The key of the skill that must be active before the requested skill can be activated.
 */
class DiabloSkill {
    __New(key, window, preReqKey) {
        this.Active := false
        this.Key := key
        this.DefaultFreq := 1000
        this.Timer := ObjBindMethod(this, "UseSkill")
        this.Window := window
        this.PreReqKey := preReqKey
    }

    /**
     * @description `Toggle`
     * Toggles skill automation between active and inactive.
     * @param {(Number)} freq
     * The frequency in milliseconds between activations in milliseconds.
     * @returns {(String)}
     * Always returns an empty string.
     */
    Toggle(freq) {
        (this.Active) ? this.Disable() : this.Enable(freq)
    }

    /**
     * @description `Enable`
     * Enables automation for the skill.
     * @param {(Number)} freq
     * The frequency in milliseconds between activations in milliseconds.
     * @returns {(String)}
     * Always returns an empty string.
     */
    Enable(freq := "") {
        if (!this.Active) {
            this.Active := True
            this.UseSkill()  ; Trigger immediately

            ; Set frequency to default value if not provided
            if (!freq) {
                freq := this.defaultFreq
            }

            ; Activate timer
            timer := this.Timer  ; Not sure why this line is necessary but it is.
            SetTimer(timer,freq)
        }
    }

    /**
     * @description `Disable`
     * Disables automation for the skill.
     * @returns {(String)}
     * Always returns an empty string.
     */
    Disable() {
        if (this.Active) {
            this.Active := false

            ; Deactivate time
            timer := this.Timer
            SetTimer(timer,0)
        }
    }

    /**
     * @description `UseSkill`
     * Uses the skill. Presses the button in the active window.
     * If the game windows is not active or the prerequisite key is not pressed the skill will not be used.
     * @returns {(String)}
     * Always returns an empty string.
     */
    UseSkill() {
        if (WinActive(this.Window)) {
            if (!this.PreReqKey || GetKeyState(this.PreReqKey)) {
                Send(this.Key)
            }

        }
    }
}
