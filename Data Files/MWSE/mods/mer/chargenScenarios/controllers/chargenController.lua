
local common = require('mer.chargenScenarios.common')

local function startChargen()
    local weatherController = tes3.worldController.weatherController
    weatherController:switchImmediate(0)
    --Set Chargen State
    common.log:debug("Setting chargen state to 'start'")
    tes3.findGlobal("CharGenState").value = 10
    --Disable Controls
    common.log:debug("Disabling controls")
    common.disableControls()
    --Move Player to Chargen Cell
    common.log:debug("Moving player to chargen cell")
    tes3.positionCell(common.config.chargenLocation)
    --Open Stat Review Menu
    timer.start{
        type = timer.simulate,
        duration = 1,
        callback = function()
            common.log:debug("Opening stat review menu")
            tes3.runLegacyScript{ command = "EnableRaceMenu"}
        end
    }
end

---@param e loadedEventData
local function startChargenOnLoad(e)
    if common.modEnabled() and e.newGame then
        common.log:debug("Starting Chargen")
        startChargen()

    end
end
event.register("loaded", startChargenOnLoad)

--[[
    Prevent vanilla chargen script from running,
    and set the weather to clear.
]]
local function setVanillaChargenScriptOnLoad()
    if common.modEnabled() then
        common.log:debug("Overriding Chargen Script")
        mwse.overrideScript("CharGen", function() end)
        --set to clear weather

    end
end
event.register("load", setVanillaChargenScriptOnLoad)
