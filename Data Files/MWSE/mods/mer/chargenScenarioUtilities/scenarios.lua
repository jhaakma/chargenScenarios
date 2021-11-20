--[[
    Add example scenarios for testing using the interop
]]
---@type ChargenScenariosInterop
local interop = include('mer.chargenScenarios.interop')

local common = require('mer.chargenScenarioUtilities.common')
local locations = common.mcmConfig.locations
if interop then
    ---@type ChargenScenariosScenarioInput
    local scenario = {
        name = "Shipwrecked",
        description = "You are the lone survivor of a shipwreck. Cold, wet and hungry, can you make it back to civilization alive?",
        spells = {
            --Single existing spell
            { id = "brown rot" },
            --Random pick from list of existing spells
            { ids = { "vampiric touch", "ash-chancre" } },
            --custom spell
            {
                name = "Custom Spell",
                id = "testcustomspell",
                spellType = tes3.spellType.spell,
                effects = {
                    {
                        id = tes3.effect.damageHealth,
                        range = tes3.effectRange.touch,
                        magnitude = -10,
                        area = tes3.effectRange.self,
                        duration = 5,
                        min = 5,
                        max = 5,
                        skill = tes3.skill.alteration,
                        attribute = tes3.attribute.intelligence,
                    }
                }
            }
        },
        items = {
            {
                id = "ingred_rat_meat_01",
                count = 3
            },
            {
                ids = {
                    "misc_com_bottle_01",
                    "misc_com_bottle_02",
                    "misc_com_bottle_03",
                    "misc_com_bottle_04",
                    "misc_com_bottle_05",
                    "misc_com_bottle_06",
                    "misc_com_bottle_07",
                },
                count = 2,
            },
            {
                ids = {
                    "misc_de_cloth10",
                    "misc_de_cloth11",
                },
                count = 1
            }
        },
        locations = {
            locations.shipwreck_01,
            locations.shipwreck_02,
        },
        introMessage = "You are the lone survivor of a shipwreck. Cold, wet and hungry, can you make it to shore alive?",
    }

    interop.registerScenario(scenario)
end

