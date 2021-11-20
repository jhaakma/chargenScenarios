return {
    --Mod name will be used for the MCM menu as well as the name of the config .json file.
    modName = "Chargen Scenarios Utilities",
    --Description for the MCM sidebar
    modDescription =
[[
A set of utilities for Chargen Scenarios.
]],
    mcmDefaultValues = {
        registerLocationsEnabled = false,
        registerLocationsHotKey = {
            keyCode = tes3.scanCode.numpadEnter,
            isShiftDown = true
        },
        registerClutterHotKey = {
            keyCode = tes3.keybind.activate,
            isAltDown = true
        },
        locations = {},
        logLevel = "INFO"
    },
}