#IfWinActive, ahk_exe ScratchInc.exe

class ScratchInterface {
    window := "ScratchInc.exe"
    scratchArea := New ScratchArea()
    menuList := [
        ; Ordered by priority
        , New MonopolyMenu()
        , New CorporationMenu()
        , New StoreMenu()
        , New LoyaltyMenu(True)
        , New PointsMenu()]

    playGame() {
        while True {
            this.scratchArea.Clear()
            for key, menuItem in this.menuList {
                menuItem.Activate()
            }
            this.scratchArea.getNewCard()
        }
    }
}

class ScratchArea {
    leftX := 725
    topY := 200
    rightX := 1850
    bottomY := 1225
    width := 150
    delay := 75

    cardReadyX := 1750
    cardReadyY := 1200
    cardReadyColor := "0x3E305E"

    __New() {
        this.newCardButton := New Button(1300, 1300, "0x000000", "0x121212", True, "New Card Button")
    }


    clear() {
        currentY := this.bottomY

        while currentY > this.topY {
            ClickWait(this.leftX, currentY, 0, this.delay)
            ClickWait(this.rightX, currentY, 0, this.delay)
            currentY -= this.width
            ClickWait(this.rightX, currentY, 0, this.delay)
            ClickWait(this.LeftX, currentY, 0, this.delay)
            currentY -= this.width
        }

        return True
    }

    clearLoop(loopCount:=1) {
        Loop %loopCount% {
            this.clear()
            this.getNewCard()
        }
    }

    getNewCard() {
        maxWait := 4000
        startTime := A_TickCount

        if (this.newCardButton.checkActive()) {
            this.newCardButton.activate()
        }

        ; wait for new card to be ready
        checkColor := "0x000000"
        while (checkColor != this.cardReadyColor and A_TickCount < startTime + maxWait ) {
            PixelGetColor, checkColor, this.cardReadyX, this.CardReadyY, RGB
            Sleep, 50
        }

        Sleep, 100
    }
}

class PointsMenu Extends Menu {
    openCoordX := 100
    openCoordY := 325
    closeCoordX := 1475
    closeCoordY := 165
    buttonMaxColor := "0x000648"
    upgradeReadyX := 78
    upgradeReadyY := 313
    upgradeReadyColor := "0x5473FB"

    yMod := 0
    prestigeActive := False

    buttonList := [
        ; Ordered by priority
        , New Button(1375, 460, this.buttonMaxColor, this.buttonNotActiveColor, True, "Increase Icon Grid Size")
        , New Button(1375, 550, this.buttonMaxColor, this.buttonNotActiveColor, True, "Increase Match Multi")
        , New Button(1375, 375, this.buttonMaxColor, this.buttonNotActiveColor, True, "Double Point Gain")
        , New Button(1375, 640, this.buttonMaxColor, this.buttonNotActiveColor, True, "Automate New Card")]

    prestigeButtonList := []

    activate() {
        this.TryUpgrade()
    }
}

class LoyaltyMenu Extends Menu {
    openCoordX := 100
    openCoordY := 525
    closeCoordX := 1480
    closeCoordY := 65
    buttonMaxColor := "0x3D1B77"
    upgradeReadyX := 90
    upgradeReadyY := 485
    upgradeReadyColor := "0xA955E0"

    buttonList := [
        ; Ordered by priority
        , New Button(1390, 675, this.buttonMaxColor, this.buttonNotActiveColor, True, "Reduce Point Doubler Cost")
        , New Button(1150, 600, this.buttonMaxColor, this.buttonNotActiveColor, True, "Chance of Bonus Star 1")
        , New Button(1225, 600, this.buttonMaxColor, this.buttonNotActiveColor, True, "Chance of Bonus Star 2")
        , New Button(1295, 600, this.buttonMaxColor, this.buttonNotActiveColor, True, "Chance of Bonus Star 3")
        , New Button(1370, 600, this.buttonMaxColor, this.buttonNotActiveColor, True, "Chance of Bonus Star 4")
        , New Button(1445, 600, this.buttonMaxColor, this.buttonNotActiveColor, True, "Chance of Bonus Star 5")
        , New Button(1245, 490, this.buttonMaxColor, this.buttonNotActiveColor, True, "Increase Grid")
        , New Button(1425, 490, this.buttonMaxColor, this.buttonNotActiveColor, True, "Match Multi")
        , New Button(1355, 400, this.buttonMaxColor, this.buttonNotActiveColor, True, "Triple Point Gain")
        , New Button(1400, 865, this.buttonMaxColor, this.buttonNotActiveColor, True, "Unlock Auto Scratching")
        , New Button(1400, 950, this.buttonMaxColor, this.buttonNotActiveColor, True, "Increase Auto Speed")
        , New Button(1400, 1025, this.buttonMaxColor, this.buttonNotActiveColor, True, "Increase Auto Scratch Size")]

    prestigeButtonList := [New Button(1425, 225, this.buttonMaxColor, this.buttonNotActiveColor, True, "Prestige Loyalty")]

    checkPrestigeAvailable() {
        ; Using same coordinate for checkUpgrade
        PixelGetColor checkColor, this.upgradeReadyX, this.upgradeReadyY, RGB
        return (checkColor = this.upgradeReadyColor)
    }

    activate() {
        this.tryUpgrade()
        this.tryPrestige()
        this.tryUpgrade()
    }
}

class StoreMenu Extends Menu {
    openCoordX := 100
    openCoordY := 675
    closeCoordX := 1475
    closeCoordY := 65
    buttonMaxColor := "0x095016"
    upgradeReadyX := 93
    upgradeReadyY := 653
    upgradeReadyColor := "0x5FD44A"
    prestigeActive := 1
    yMod := 0

    buttonList := [
        ; Ordered by priority
        , New Button(1250, 425, this.buttonMaxColor, this.buttonNotActiveColor, True, "Triple Points")
        , New Button(1425, 425, this.buttonMaxColor, this.buttonNotActiveColor, True, "Chance of Bonus Star 1")
        , New Button(1450, 250, this.buttonMaxColor, this.buttonNotActiveColor, True, "Lease Store")]

    prestigeButtonList := [
        , New Button(1235, 250, this.buttonMaxColor, this.buttonNotActiveColor, True, "Get Shares")]


    checkPrestigeAvailable() {
        ImageSearch, outX, outY, 2495, 100, 2509, 200, *50 %A_ScriptDir%\..\application\game\scratch_inc\StoreMenuPrestige_2.png
        if (ErrorLevel = 0)
            return True

        ImageSearch, outX, outY, 2495, 100, 2509, 200, *50 %A_ScriptDir%\..\application\game\scratch_inc\StoreMenuPrestige_3.png
        if (ErrorLevel = 0)
            return True

        ImageSearch, outX, outY, 2495, 100, 2509, 200, *50 %A_ScriptDir%\..\application\game\scratch_inc\StoreMenuPrestige_4.png
        If (ErrorLevel = 0)
            return True

        return False
    }

    activate() {
        if (this.TryPrestige()) {
            this.Upgrade()
        } else {
            this.TryUpgrade()
        }
    }
}

class CorporationMenu Extends Menu {
    openCoordX := 100
    openCoordY := 835
    closeCoordX := 1475
    closeCoordY := 65
    upgradeReadyX := 94
    upgradeReadyY := 823
    upgradeReadyColor := "0xA9A9A9"

    yMod := 0
    prestigeActive := True

    buttonList := [
        ; Ordered by Priority
        , New Button(1230, 440, "0x000000", "0x2D2D35", True, "5x Points")
        , New Button(1440, 440, "0x000000", "0x2D2D35", True, "Increase Grid")
        , New Button(1440, 670, "0x000000", "0x2D2D35", True, "Increase Store Income")]

    prestigeButtonList := [New Button(1390, 265, "0x000000", "0x000000", True, "Prestige Corporation")]

    checkPrestigeAvailable() {
        readyColor := "0x716f77"
        PixelGetColor, readyTest1, 2512, 246, RGB
        PixelGetColor, readyTest2, 2512, 180, RGB

        return (readyTest1 = readyColor or readyTest2 = readyColor)
    }

    activate() {
        this.TryPrestige()
        this.TryUpgrade()
    }
}

class MonopolyMenu Extends Menu {
    openCoordX := 100
    openCoordY := 1000
    closeCoordX := 1480
    closeCoordY := 65

    buttonList := []
    prestigeButtonList := [New Button(1380, 255, "0x071020", "0x2D2D35", True, "Prestige Monopoly")]

    checkPrestigeAvailable() {
        readyColor := "0x1F1E32"
        PixelGetColor, readyTest1, 2515, 313, RGB
        PixelGetColor, readyTest2, 2515, 247, RGB

        return (readyTest1 = readyColor or readyTest2 = readyColor)
    }

    activate() {
        this.tryPrestige()
    }
}

class Menu {
    buttonNotActiveColor := "0x2D2D35"

    __New(prestigeActive:=True, yMod:=-50) {
        this.prestigeActive := prestigeActive
        this.yMod := yMod * !prestigeActive
    }

    close(delay:=500) {
        ClickWait(this.closeCoordX, this.closeCordY, 1, delay)
    }

    open(delay:=250) {
        ClickWait(this.openCoordX, this.openCoordY, 1, delay)
    }

    checkUpgradeAvailable() {
        PixelGetColor upgradeReadyColor, this.upgradeReadyX, this.upgradeReadyY, RGB
        return (upgradeReadyColor = this.upgradeReadyColor)
    }

    tryUpgrade() {
        if (this.checkUpgradeAvailable()) {
            this.upgrade()
            return True
        }

        return False
    }

    upgrade() {
        this.open()

        for key, obj in this.buttonList {
            if (obj.checkActive(this.yMod)) {
                obj.activateFull(this.yMod)
            }
        }

        this.close()
    }

    checkPrestigeAvailable() {
        return False
    }

    tryPrestige() {
        if (this.prestigeActive and this.checkPrestigeAvailable()) {
            this.prestige()
            return True
        }

        return False
    }

    prestige() {
        this.open()

        for key, obj in this.prestigeButtonList {
            obj.activate()
        }

        this.close()
    }
}

class Button {
    __New(coordX, coordY, maxColor, notActiveColor, enabled, description) {
        this.description := description
        this.coordX := coordX
        this.coordY := coordY
        this.maxColor := maxColor
        this.notActiveColor := notActiveColor
        this.enabled := enabled
    }

    checkActive(yMod:=0) {
        PixelGetColor, buttonColor, this.coordX, this.coordY + yMod, RGB
        return this.enabled and (buttonColor != this.maxColor) and (buttonColor != this.notActiveColor)
    }

    activate(delay:=50, yMod:=0) {
        ClickWait(this.coordX, this.CoordY + yMod, 1, delay)
    }

    activateFull(yMod:=0, maxWait:=1000) {
        startTime := A_TickCount
        while this.CheckActive(yMod) and (A_TickCount < (startTime + maxWait)) {
            this.activate(0, yMod)
        }
    }
}


F5::scratch.playGame()
F6::
    MsgBox, % A_TickCount
    return
F7::
    ; PixelGetColor, readyTest1, 2516, 313, RGB
    PixelGetColor, readyTest2xxx, 94, 823, RGB
    MsgBox, % readyTest2xxx
F9::Reload

#IfWinActive
