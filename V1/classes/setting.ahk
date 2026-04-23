Class setting {
    validate(settingName, settingObject, default := "", constraints := "") {
        settingDefined := false

        ; Confirm setting value is specified in setting object
        if (settingObject.HasKey(settingName)) {
            settingValue := settingObject[settingName]
            settingDefined := true
        } else {
            if (default != "") {
                settingValue := default
                settingDefined := true
            }
        }

        if (settingDefined = false) {
            throw settingName . " is required and not defined"
        }

        for index, constraint in constraints {
            compareClass := "bigA"
            compareMethod :=  constraint["compareMethod"]
            test := %compareClass%[compareMethod]
            if isFunc(%compareClass%[compareMethod]) {
                if (%compareClass%[compareMethod](constraint.compareValue, settingValue)) {
                    ; Do nothing
                } else {
                    throw settingName . " failed check against constraint. Constraint Name = " . constraint.name
                }
            }
            else {
                throw "Invalid comparison method provided. Constraint Name = " . constraint.name
            }
        }

        return settingValue
    }
}
