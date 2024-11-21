
local common = require('mer.chargenScenarios.common')
local logger = common.createLogger("ChargenController")
local controls = require('mer.chargenScenarios.util.Controls')

local defaultTopics = {
    "duties",
    "background",
	"specific place",
	"someone in particular",
	"services",
	"my trade",
	"little secret",
	"latest rumors",
	"little advice",
}

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
        tes3.runLegacyScript{ command = command} ---@diagnostic disable-line
    end
    --unlock door to census office
    tes3.runLegacyScript{ command = '"CharGen Door Hall"->Unlock'} ---@diagnostic disable-line
end

local function clearInitialInventory()
    local shoes = tes3.getObject("common_shoes_01")
    tes3.player.mobile:unequip{item = shoes}
    tes3.player.object.inventory:removeItem{
        item = shoes
    }
    local shirt = tes3.getObject("common_shirt_01")
    tes3.player.mobile:unequip{item = shirt}
    tes3.player.object.inventory:removeItem{
        item = shirt
    }
    local pants = tes3.getObject("common_pants_01")
    tes3.player.mobile:unequip{item = pants}
    tes3.player.object.inventory:removeItem{
        item = pants
    }
end

local function startChargen()
    --clearInitialInventory()
    tes3.worldController.weatherController:switchImmediate(0)
    --Set Chargen State
    logger:debug("Setting chargen state to 'start'")
    tes3.findGlobal("CharGenState").value = 10
    --Disable Controls
    logger:debug("Disabling controls")
    controls.disableControls()
    --Disable NPCs
    logger:debug("Disabling Vanilla Chargen stuff")
    disableChargenStuff()

    --Move Player to Chargen Cell
    logger:debug("Moving player to chargen cell")
    tes3.positionCell(table.copy(
        common.config.chargenLocation,
        ---@type tes3.positionCell.params
        {
            forceCellChange = true
        })
    )
    --Add topics
    for _, topic in ipairs(defaultTopics) do
        tes3.addTopic{
            topic = topic,
            updateGUI = false
        }
    end

    timer.start{
        type = timer.simulate,
        duration = 1,
        callback = function()
            logger:debug("Opening stat review menu")
            tes3.runLegacyScript{ command = "EnableRaceMenu"}
        end
    }

end

---@param e loadedEventData
local function startChargenOnLoad(e)
    if common.modEnabled() and e.newGame then
        logger:debug("Starting Chargen")
        startChargen()
    end
end
event.register("loaded", startChargenOnLoad)

--[[
    Prevent vanilla chargen scripts from running,
]]
---@type string[]
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

local function blockChargenScripts()
    if common.config.mcm.enabled then
        logger:debug("Overriding Chargen Scripts")
        for _, scriptId in pairs(chargenScripts) do
            mwse.overrideScript(scriptId, function()
                mwscript.stopScript{script = scriptId} ---@diagnostic disable-line
            end)
        end
    end
end
blockChargenScripts()