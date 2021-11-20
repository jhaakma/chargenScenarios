
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
            name = "Imperial Prisoner (vanilla)",
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
    }
}

return config