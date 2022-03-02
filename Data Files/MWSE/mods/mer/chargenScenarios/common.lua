local this  = {}
this.config = require("mer.chargenScenarios.config")
this.validator = require("mer.chargenScenarios.util.validator")
local modName = this.config.modName
this.mcmConfig = mwse.loadConfig(this.config.modName, this.config.defaultConfig)---@type "table"
this.saveConfig = function()
    mwse.saveConfig(this.config.modName, this.mcmConfig)
end

---@type table<number, ChargenScenariosScenario>
this.registeredScenarios = {}

local logLevel = this.mcmConfig.logLevel
mwse.log("Setting up Logger with name %s", modName)
local logger = require("logging.logger")

this.log = logger.new{
    name = modName,
    logLevel = logLevel
}

function this.modEnabled()
    return this.mcmConfig.enabled == true
end

this.messageBox = require("mer.chargenScenarios.util.messageBox")
this.createTooltip = require("mer.chargenScenarios.util.tooltip")

this.isKeyPressed = function(pressed, expected)
    return (
        pressed.keyCode == expected.keyCode
         and not not pressed.isShiftDown == not not expected.isShiftDown
         and not not pressed.isControlDown == not not expected.isControlDown
         and not not pressed.isAltDown == not not expected.isAltDown
         and not not pressed.isSuperDown == not not expected.isSuperDown
    )
end

local function setControlsDisabled(state)
    tes3.mobilePlayer.controlsDisabled = state
    tes3.mobilePlayer.jumpingDisabled = state
    tes3.mobilePlayer.attackDisabled = state
    tes3.mobilePlayer.magicDisabled = state
    tes3.mobilePlayer.mouseLookDisabled = state
end
function this.disableControls()
    setControlsDisabled(true)
end

function this.enableControls()
    tes3.runLegacyScript{command = "EnableInventoryMenu"}
    tes3.runLegacyScript{ command = "EnablePlayerControls" }
    tes3.runLegacyScript{ command = "EnablePlayerJumping" }
    tes3.runLegacyScript{ command = "EnablePlayerViewSwitch" }
    tes3.runLegacyScript{ command = "EnableVanityMode" }
    tes3.runLegacyScript{ command = "EnablePlayerFighting" }
    tes3.runLegacyScript{ command = "EnablePlayerMagic" }
    tes3.runLegacyScript{ command = "EnableStatsMenu" }
    tes3.runLegacyScript{ command = "EnableMagicMenu" }
    tes3.runLegacyScript{ command = "EnableMapMenu" }
    tes3.runLegacyScript{ command = "EnablePlayerLooking" }
end

function this.convertListTypes(list, classType)
    if list == nil then
        return nil
    end
    local newList = {}
    for _, item in ipairs(list) do
        local newItem = classType:new(item)
        table.insert(newList, newItem)
    end
    return newList
end

return this