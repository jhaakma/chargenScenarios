
local config = {
    modName = "Chargen Scenarios",
    modDescription = [[
        Overhauls the character generation.
    ]],
    defaultLocation = {
        position = {61, 135, 24},
        orientation = {0, 0, 340},
        cell = "Imperial Prison Ship"
    },
    chargenLocation = {
        position = {61, 135, 1000},
        orientation = {0, 0, 340},
        cell = "Imperial Prison Ship"
    },
    scenarios = {
        --default
        {
            name = "--Vanilla--",
            description = "Start the game in the Seyda Neen Census and Excise Office, without a scenario.",
            location = {
                orientation = {0,0,1.6740349531174},
                position = {33,-87,194},
                cell = "Seyda Neen, Census and Excise Office"
            },
            doVanillaChargen = true
        },
    }
}

config.defaultConfig = {
    enabled = true,
    logLevel = "INFO",
    startingLocation = config.defaultLocation,
    startingLocations = {
        vanilla = config.defaultLocation,
    },
    registerLocationsEnabled = false,
    registerLocationsHotKey = {
        keyCode = tes3.scanCode.numpadEnter,
        isShiftDown = true
    },
    registerClutterEnabled = false,
    registerClutterHotKey = {
        keyCode = tes3.scanCode.e,
        isAltDown = true
    },
    --Testing
    doTests = false,
    exitAfterUnitTests = false,
    exitAfterIntegrationTests = false,

    registeredClutterGroups = {},
    registeredLocations = {}
}

return config