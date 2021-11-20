
local common = require('mer.chargenScenarios.common')

local chargenObjects = {
    "CharGen Boat",
    "CharGen Boat Guard 1",
    "CharGen Boat Guard 2",
    "CharGen Dock Guard",
    "CharGen_cabindoor",
    "CharGen_chest_02_empty",
    "CharGen_crate_01",
    "CharGen_crate_01_empty",
    "CharGen_crate_01_misc01",
    "CharGen_crate_02",
    "CharGen_lantern_03_sway",
    "CharGen_ship_trapdoor",
    "CharGen_barrel_01",
    "CharGen_barrel_02",
    "CharGenbarrel_01_drinks",
    "CharGen_plank",
    "CharGen StatsSheet",
}
local function disableChargenStuff()
    --Disable chargen objects
    for _, id in ipairs(chargenObjects) do
        local command = string.format('"%s"->Disable', id)
        tes3.runLegacyScript{ command = command}
    end
    --unlock door to census office
    tes3.runLegacyScript{ command = '"CharGen Door Hall"->Unlock'}
end

local function startChargen()
    local weatherController = tes3.worldController.weatherController
    weatherController:switchImmediate(0)
    --Set Chargen State
    common.log:debug("Setting chargen state to 'start'")
    tes3.findGlobal("CharGenState").value = 10
    --Disable Controls
    common.log:debug("Disabling controls")
    common.disableControls()
    --Disable NPCs
    common.log:debug("Disabling Vanilla Chargen stuff")
    disableChargenStuff()

    --Move Player to Chargen Cell
    common.log:debug("Moving player to chargen cell")
    tes3.positionCell(common.config.chargenLocation)
    --Open Stat Review Menu

    --"bk_a1_1_caiuspackage"

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
    Prevent vanilla chargen scripts from running,
]]
local chargenScripts = {
    "CharGen",
    "CharGen_ring_keley",
    "ChargenBed",
    "ChargenBoatNPC",
    "CharGenBoatWomen",
    "CharGenClassNPC",
    "CharGenCustomsDoor",
    "CharGenDagger",
    "CharGenDialogueMessage",
    "CharGenDoorEnterCaptain",
    "CharGenFatigueBarrel",
    "CharGenDoorExit",
    "CharGenDoorExitCaptain",
    "CharGenDoorGuardTalker",
    "CharGenJournalMessage",
    "CharGenNameNPC",
    "CharGenRaceNPC",
    "CharGenStatsSheet",
    "CharGenStuffRoom",
    "CharGenWalkNPC",
}

local function setVanillaChargenScriptOnLoad()
    if common.modEnabled() then
        common.log:debug("Overriding Chargen Scripts")
        for _, script in pairs(chargenScripts) do
            mwse.overrideScript(script, function() end)
        end
    end
end
event.register("load", setVanillaChargenScriptOnLoad)
