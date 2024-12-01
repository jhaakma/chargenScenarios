local common = require('mer.chargenScenarios.common')
local logger = common.createLogger("mcm")
local ChargenMenu = require("mer.chargenScenarios.component.ChargenMenu")
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

    settings:createSlider{
        label = "Item Package Limit",
        description = "The maximum number of item packages that can be selected. Default: 3.",
        min = 1,
        max = 20,
        variable = mwse.mcm.createTableVariable{
            id = 'itemPackageLimit',
            table = config.mcm
        },
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

    --A page for enabling/disabling each registered menu
    local menuSettings = template:createSideBarPage("Menu Settings")
    menuSettings.description = "Enable or disable each menu."

    for _, menu in pairs(ChargenMenu.registeredMenus) do
        menuSettings:createYesNoButton{
            label = menu.name,
            description = string.format("Enable the %s menu.", menu.buttonLabel),
            variable = mwse.mcm.createTableVariable{
                id = menu:getMcmId(),
                table = config.mcm,
            }
        }
    end

end
event.register("initialized", registerModConfig, { priority = -500})