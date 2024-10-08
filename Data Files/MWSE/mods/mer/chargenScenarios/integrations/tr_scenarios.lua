
local Scenario = require("mer.chargenScenarios.component.Scenario")
local GearManager = require("mer.chargenScenarios.component.GearManager")

local boots = { ids = GearManager.gearLists.boots, noSlotDuplicates = true, pickBestForClass = true}
local cuirass = { ids = GearManager.gearLists.cuirass, noSlotDuplicates = true, pickBestForClass = true}
local leftGauntlets = { ids = GearManager.gearLists.leftGauntlet, noSlotDuplicates = true, pickBestForClass = true}
local rightGauntlets = { ids = GearManager.gearLists.rightGauntlet, noSlotDuplicates = true, pickBestForClass = true}
local greaves = { ids = GearManager.gearLists.greaves, noSlotDuplicates = true, pickBestForClass = true}
local leftPauldrons = { ids = GearManager.gearLists.leftPauldron, noSlotDuplicates = true, pickBestForClass = true}
local rightPauldrons = { ids = GearManager.gearLists.rightPauldron, noSlotDuplicates = true, pickBestForClass = true}
local helms = { ids = GearManager.gearLists.helm, noSlotDuplicates = true, pickBestForClass = true}
local shields = { ids = GearManager.gearLists.shield, noSlotDuplicates = true, pickBestForClass = true}
local weapons = { ids = GearManager.gearLists.weapon, noSlotDuplicates = true, pickBestForClass = true}
local hoods = { ids = GearManager.gearLists.hood, noSlotDuplicates = true, pickBestForClass = true}
local robes = { ids = GearManager.gearLists.robe, noSlotDuplicates = true, pickBestForClass = true}


---@type ChargenScenariosScenarioInput[]
local scenarios = {
    {
        id = "oldEbonheartAlley",
        name = "Old Ebonheart Alley",
        description = "You are playing dice in an alley in Old Ebonheart.",
        location = {
            position = {61567, -150436, 1024},
            orientation = 0,
            cell = "Old Ebonheart, Alley"
        },
        items = {
            {
                id = "gold_001",
                count = 5,
            },
            {
                id = "T_De_Drink_LiquorLlotham_01",
                count = 3
            },
            {
                id = "T_Com_Dice_01",
                count = 1,
                noDuplicates = true,
            },
            weapons,
            hoods,
        }
    },
    {
        id = "firewatchCollege",
        name = "College of Firewatch",
        description = "You are a student at the College of Firewatch.",
        location = {
            position = {5718, 3587, 12401},
            orientation = 0,
            cell = "Firewatch, College"
        },
        items = {
            {
                id = "gold_001",
                count = 100,
            },
            {
                id = "T_Sc_GuideToFirewatchTR",
                count = 1,
                noDuplicates = true,
            },
            robes,
        }
    },
    {
        id = "caravanGuard",
        name = "Caravan Guard",
        description = "You are guarding a caravan in Arvud.",
        location = {
            position = {-29151, -210575, 604},
            orientation = 0,
        },
        items = {
            {
                id = "T_De_Guarskin_Cuirass_01",
                count = 1,
                noSlotDuplicates = true,
            },
            weapons,
            boots,
        }
    },
    {
        id = "kemelZeRuins",
        name = "Kemel-Ze Ruins",
        description = "You are exploring the ruins of Kemel-Ze.",
        location = {
            position = {182058, -8715, 5104},
            orientation = 0,
        },
        items = {
            {
                id = "bk_tamrielicreligions",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "gold_001",
                count = 25,
            },
            {
                id = "silver dagger",
                count = 1,
                noDuplicates = true,
            },
            cuirass,
            boots
        },
    },
    {
        id = "dreynimSpa",
        name = "Dreynim Spa",
        description = "You are on holiday at Dreynim Spa.",
        location = {
            position = {240656, -176840, 709},
            orientation = 0,
        },
        items = {
            {
                id = "T_Com_Ep_Robe_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "T_Com_ClothRed_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "T_Com_Soap_01",
                count = 1,
                noDuplicates = true,
            },
        },
    },
    {
        id = "arrivingInNivalis",
        name = "Arriving in Nivalis",
        description = "You have just arrived at the Imperial settlement of Nivalis.",
        location = {
            position = {98094, 227955, 544},
            orientation = 90,
        },
        items = {
            {
                id = "fur_colovian_helm",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "gold_001",
                count = 55,
            },
            {

                id = "T_Imp_ColFur_Boots_01",
                count = 1,
                noSlotDuplicates = true,
            },
            weapons
        },
    },
    {
        id = "sadasPlantation",
        name = "Sadas Plantation",
        description = "You are a slave working on the Sadas Plantation.",
        location = {
            position = {291563, 144320, 424},
            orientation = 0,
        },
        items = {
            {
                id = "slave_bracer_right",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "pick_apprentice_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "T_Com_Farm_Pitchfork_01",
                count = 1,
                noDuplicates = true,
            },
        },
        requirements = {
            races = {"Argonian", "Khajiit"},
        },
    },
    {
        id = "workingOnTheDocks",
        name = "Working on the Docks",
        description = "You are a dock worker in Andothren.",
        location = {
            position = {3016, -125842, 544},
            orientation = 270,
        },
        items = {
            {
                id = "gold_001",
                count = 15,
            },
            {
                id = "T_Com_Mallet_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "misc_hook",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "T_Com_Var_Harpoon_01",
                count = 1,
                noDuplicates = true,
            },
        },
    },
    {
        id = "fishingAtDragonheadPoint",
        name = "Fishing at Dragonhead Point",
        description = "You are fishing at Dragonhead Point.",
        location = {
            position = {330424, -29432, 784},
            orientation = 0,
        },
        items = {
            {
                id = "T_Rga_FishingSpear_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "misc_de_fishing_pole",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "mer_meat_cod",
                alternative = "T_IngFood_FishCod_01",
                count = 2,
            },
            {
                id = "mer_bug_spinner2",
                count = 1,
            },
            {
                id = "mer_fish_cod",
                count = 1,
            },
            {
                id = "AB_w_CookKnifeBone",
                count = 1,
                noDuplicates = true,
            },
            weapons,
            boots,
            cuirass
        },
    },
}

for _, scenario in ipairs(scenarios) do
    if not scenario.requirements then
        scenario.requirements = {}
    end
    if not scenario.requirements.plugins then
        scenario.requirements.plugins = {}
    end
    table.insert(scenario.requirements.plugins, "TR_Mainland.esm")

    Scenario:register(scenario)
end
