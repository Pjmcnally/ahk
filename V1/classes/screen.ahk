class Screen {
    __New(settings) {
        this.name := setting.validate("name", settings)
        this.activateButton := setting.validate("activateButton", settings)
        this.buttonList := setting.validate(("buttons", settings))
    }

    activate() {
        this.ActivateButton.Click()
    }
}
