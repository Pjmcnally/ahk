class Screen {
    __New(settings) {
        this.name := settings.validate("name", settings)
        this.activateButton := settings.validate("activateButton", settings)
        this.buttonList := settings.validate(("buttons", settings))
    }

    activate() {
        this.ActivateButton.Click()
    }
}
