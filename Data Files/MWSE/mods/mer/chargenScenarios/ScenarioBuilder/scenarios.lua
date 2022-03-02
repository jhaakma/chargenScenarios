--[[
    Add example scenarios for testing using the interop
]]
---@type ChargenScenariosInterop
local interop = include('mer.chargenScenarios.interop')
local common = require('mer.chargenScenarios.common')
local locations = common.mcmConfig.registeredLocations
local this = {}
this.registerScenarios = function()
    if interop then
        interop.registerScenario({
            name = "Shipwrecked",
            description = "You are the lone survivor of a shipwreck. Cold, wet and hungry, can you make it back to civilization alive?",
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
                locations.shipwreck_03,
            },
            introMessage = "You are the lone survivor of a shipwreck. Cold, wet and hungry, can you make it to shore alive?",
        })
        interop.registerScenario({
            name = "Diseased",
            description = "Riddled with disease, you have been cast out from society to struggle in the wilderness.",
            spells = {
                --Single existing spell
                { id = "brown rot" },
                --Random pick from list of existing spells
                { ids = {"ash-chancre"} },
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
                locations.shipwreck_03,
            },
            introMessage = "You are the lone survivor of a shipwreck. Cold, wet and hungry, can you make it to shore alive?",
        })
    end
end

return this