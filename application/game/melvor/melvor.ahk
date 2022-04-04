class MelvorInterface {
    __New() {
        CoordMode, Pixel, Client
        CoordMode, Mouse, Client

        this.color_empty := 0x42352D
        this.color_available := 0x6767E5
        this.color_active := 0xE5AC5C

        /*
        this.DataFile := "application\game\melvor\melvor_data.json"
        FileRead, json_data, % this.DataFile
        this.data := JSON.Load(json_data)
        */

        ; Mastery upgrade data
        this.mastery_column_a := 920
        this.mastery_column_b := 1475
        this.mastery_start_y := 270
        this.mastery_diff_y := 72
        this.mastery_upgrade_color := 0x77A829
        this.mastery_cursor_x := 0
        this.mastery_cursor_y := 0

        this.UpgradeAllMasteryTimer := ObjBindMethod(this, "UpgradeAllMastery")
        this.UpgradeCursorMasteryTimer := ObjBindMethod(this, "UpgradeCursorMastery")
    }

    MineLoop() {
        ore_priority := ["Mithril", "Coal", "Dragonite"]

        while(true) {
            WinActivate ahk_exe Melvor Idle.exe
            WinWaitActive ahk_exe Melvor Idle.exe

            for i, x in ore_priority {
                if (this.OreAvailable(x)) {
                    this.mine(x)
                    Break
                }
            }

            Sleep, 1000
        }
    }

    GetColor(x, y) {
        PixelGetColor, c, x, y
        return c
    }

    OreIsActive(name) {
        ore := this.data["mining"][name]
        x := ore["x"] + 150
        y := ore["y"] - 127

        ; msgBox, % this.GetColor(x, y)
        MouseMove % x, % y
        Sleep, 100
        return this.GetColor(x, y) == this.color_active
    }

    Mine(name) {
        if (!this.OreIsActive(name)) {
            ore := this.data["mining"][name]
            x := ore["x"]
            y := ore["y"]
            Click, %x%, %y%
        }
    }

    OreAvailable(name) {
        ore := this.data["mining"][name]
        x := ore["x"]
        y := ore["y"]

        MouseMove % x, % y
        Sleep, 100
        return this.GetColor(x, y) == this.color_available
    }

    KeepAwake() {
        while (true) {
            Random, x, 500, 1000
            MouseMove, x, x
            Sleep, 10000
        }
    }

    UpgradeAllMastery() {
        current_y := this.mastery_start_y

        While (current_y < 550) { ; TODO update this to window size
            this.UpgradeMastery(this.Mastery_column_a, current_y)
            this.UpgradeMastery(this.mastery_column_b, current_y)

            current_y += this.mastery_diff_y
        }
    }

    UpgradeMastery(x, y) {
        MouseMove x, y

        Sleep, 500
        PixelGetColor c, x, y
        if (c == this.mastery_upgrade_color) {
            Click
        }
        Sleep, 500
    }

    UpgradeCursorMastery() {
        MouseMove, this.mastery_cursor_x + 20, this.mastery_cursor_y + 20 ; To prevent system from locking due to being idle.
        Sleep, 200
        this.UpgradeMastery(this.mastery_cursor_x, this.mastery_cursor_y)
    }

    EnableUpgradeAllMastery() {
        this.UpgradeAllMastery()  ; Trigger immediately

        ; Activate timer
        timer := this.UpgradeAllMasteryTimer  ; Not sure why this line is necessary but it is.
        SetTimer, % timer, % 10000,
    }

    EnableUpgradeCursorMastery() {
        ; Get and save current mouse location
        MouseGetPos x, y
        this.mastery_cursor_x := x
        this.mastery_cursor_y := y

        ; Trigger immediately
        this.UpgradeCursorMastery()

        ; Activate timer
        timer := this.UpgradeCursorMasteryTimer  ; Not sure why this line is necessary but it is.
        SetTimer, % timer, % 5000,
    }

    RepeatClick() {
        MouseGetPos x, y

        While (True) {
            MouseMove x + 20, y + 20
            Sleep, 1000

            MouseMove x, y
            Click
            Sleep 10000
        }
    }

}


#IfWinActive, Melvor Idle

^1::melvor.MineLoop()
^2::melvor.KeepAwake()
^3::melvor.EnableUpgradeAllMastery()
^4::melvor.EnableUpgradeCursorMastery()
^5::melvor.RepeatClick()

#IfWinActive ; End #IfWinActive
