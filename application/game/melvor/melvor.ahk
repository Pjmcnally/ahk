class MelvorInterface {
    __New() {
        CoordMode, Pixel, Client
        CoordMode, Mouse, Client

        this.color_empty := 0x42352D
        this.color_available := 0x6767E5
        this.color_active := 0xE5AC5C

        this.DataFile := "application\game\melvor\melvor_data.json"
        FileRead, json_data, % this.DataFile
        this.data := JSON.Load(json_data)
    }

    MineLoop() {
        ore_priority := ["Mithril", "Coal"]

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

}


#IfWinActive, Melvor Idle
1::melvor.MineLoop()

#IfWinActive ; End #IfWinActive for Diablo 3
