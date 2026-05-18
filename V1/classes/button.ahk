class Button {
    static colorStatusConstraints := [{name: "ColorStatusMustInclude", compareValue: ["Active", "Inactive"], compareMethod: "includes"}]
    static toolTipCount := 1

    __New(settings) {
        this.name := setting.validate("name", settings)
        this.leftX := setting.validate("leftX", settings)
        this.rightX := setting.validate("rightX", settings)
        this.topY := setting.validate("topY", settings)
        this.botY := setting.validate("botY", settings)
        this.clickLocation := setting.validate("clickLocation", settings)
        this.showToolTip := setting.validate("showToolTip", settings, true)
        this.searchColor := setting.validate("searchColor", settings)
        this.colorStatus := setting.validate("colorStatus", settings, "Active", button.colorStatusConstraints)

        Button["toolTipCount"] += 1
        this.toolTipNumber := Button.toolTipCount
    }

    buttonActive {
        get {
            PixelSearch, OutX, OutY, this.leftX, this.leftY, this.topY, this.botY, this.searchColor, 0, Fast RGB
            return (ErrorLevel = 0)
        }
    }

    displayToolTip() {
        if (this.showToolTip) {
            ToolTip, % this.Name, this.rightX, this.topY, this.toolTipNumber
        }
    }

    hideToolTip() {
        ToolTip, , , , this.toolTipNumber
    }
}
