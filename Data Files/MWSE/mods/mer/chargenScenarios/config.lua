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
        position = {4200,3965,15520},
        orientation = {0, 0, 180},
        cell = "CREL Start"
    },
    scenarios = {

        --default
        {
            name = "No Scenario",
            description = "Start the game normally, without a scenario.",
            location = {
                    position = {61, -135, 24},
                    orientation = {0, 0, 340},
                    cell = "Imperial Prison Ship"
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
    }
}

return config