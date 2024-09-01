local common = require('mer.chargenScenarios.common')
local logger = common.createLogger("mcm")
local config = common.config
local modName = config.modName

local function registerModConfig()
    local template = mwse.mcm.createTemplate{ name = modName }
    template:saveOnClose(modName, config.mcm)
    template:register()

    local settings = template:createSideBarPage("Settings")
    settings.description = config.modDescription


    settings:createYesNoButton{
        label = string.format("Enable %s", modName),
        description = "Turn off to revert to vanilla character generation.",
        variable = mwse.mcm.createTableVariable{
            id = 'enabled',
            table = config.mcm
        }
    }

    settings:createDropdown{
        label = "Log Level",
        description = "Set the logging level for all Loggers.",
        options = {
            { label = "TRACE", value = "TRACE"},
            { label = "DEBUG", value = "DEBUG"},
            { label = "INFO", value = "INFO"},
            { label = "ERROR", value = "ERROR"},
            { label = "NONE", value = "NONE"},
        },
        variable =  mwse.mcm.createTableVariable{ id = "logLevel", table = config.mcm},
        callback = function(self)
            for _, logger in pairs(common.loggers) do
                logger:setLogLevel(self.variable.value)
            end
        end
    }


end
event.register("modConfigReady", registerModConfig)