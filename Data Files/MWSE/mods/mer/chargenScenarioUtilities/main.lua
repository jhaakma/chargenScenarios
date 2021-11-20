require('mer.chargenScenarioUtilities.registerLocations')
require('mer.chargenScenarioUtilities.registerClutter')
require('mer.chargenScenarioUtilities.scenarios')
require('mer.chargenScenarioUtilities.unitTests')
local common = require('mer.chargenScenarioUtilities.common')
local config = common.config
local modName = config.modName
local mcmConfig = common.mcmConfig
--MCM MENU
local function registerModConfig()
    local template = mwse.mcm.createTemplate{ name = modName }
    template:saveOnClose(modName, mcmConfig)
    template:register()

    local settings = template:createSideBarPage("Settings")
    settings.description = config.modDescription


    local registerLocationsCategory = settings:createCategory("Register Locations Utility")

    registerLocationsCategory:createOnOffButton{
        label = string.format("Enable %s", modName),
        description = "Turn the Register Locations Utility on or off. When enabled, you can press a hotkey to register your current location as a starting position for a scenario. You will be prompted to give the location a unique name, and it will be saved to  Morrowind/Data Files/MWSE/config/Chargen Scenario Utilities.json.",
        variable = mwse.mcm.createTableVariable{id = "registerLocationsEnabled", table = mcmConfig}
    }

    registerLocationsCategory:createKeyBinder{
        label = "Hot Key",
        description = "Press this key to register your current location as a scenario starting position.",
        variable = mwse.mcm.createTableVariable{ id = "registerLocationsHotKey", table = mcmConfig},
        allowCombinations = true,
    }

    settings:createDropdown{
        label = "Log Level",
        description = "Set the logging level for common.log:debug. Keep on INFO unless you are debugging.",
        options = {
            { label = "TRACE", value = "TRACE"},
            { label = "DEBUG", value = "DEBUG"},
            { label = "INFO", value = "INFO"},
            { label = "ERROR", value = "ERROR"},
            { label = "NONE", value = "NONE"},
        },
        variable = mwse.mcm.createTableVariable{
            id = "logLevel",
            table = mcmConfig
        },
        callback = function(self)
            common.log:setLogLevel(self.variable.value)
        end
    }
end
event.register("modConfigReady", registerModConfig)
