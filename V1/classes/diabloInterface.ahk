class DiabloInterface {
    __New(window) {
        this.Window := window
        this.Skills := {}
    }

    DisableAll() {
        for key, val in this.Skills {
            val.Disable()
        }

        Send {Numpad0 Up}
    }

    GetSkill(key, preReqKey:="") {
        ; If skill isn't found initialize it
        if (!(this.Skills.hasKey(key))) {
            this.Skills[key] := new DiabloSkill(key, this.Window, preReqKey)
        }

        return this.Skills[key]
    }
}

class DiabloSkill {
    __New(key, window, preReqKey) {
        this.Active := false
        this.Key := key
        this.DefaultFreq := 1000
        this.Timer := ObjBindMethod(this, "UseSkill")
        this.Window := window
        this.PreReqKey := preReqKey
    }

    Toggle(freq) {
        (this.Active) ? this.Disable() : this.Enable(freq)
    }

    Enable(freq:="") {
        if (!this.Active) {
            this.Active := True
            this.UseSkill()  ; Trigger immediately

            ; Set frequency to default value if not provided
            if (!freq) {
                freq := this.defaultFreq
            }

            ; Activate timer
            timer := this.Timer  ; Not sure why this line is necessary but it is.
            SetTimer, % timer, % freq,
        }
    }

    Disable() {
        if (this.Active) {
            this.Active := false

            ; Deactivate time
            timer := this.Timer
            setTimer, % timer, OFF
        }
    }

    UseSkill() {
        if (WinActive(this.Window)) {
            if (!this.PreReqKey || GetKeyState(this.PreReqKey)) {
                Send, % this.Key
            }

        }
    }
}
