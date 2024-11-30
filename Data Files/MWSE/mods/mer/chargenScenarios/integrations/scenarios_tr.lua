
local Scenario = require("mer.chargenScenarios.component.Scenario")

---@type ChargenScenariosScenarioInput[]
local scenarios = {
    {
        id = "oldEbonheartAlley",
        name = "Old Ebonheart Alley",
        description = "You are playing dice in an alley in Old Ebonheart.",
        journalEntry = "I've been playing dice in an alley in Old Ebonheart.",
        location = {
            position = {61567, -150436, 1024},
            orientation = 0,
            cellId = "Old Ebonheart, Alley"
        },
        items = {
            {
                id = "gold_001",
                count = 25,
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
        }
    },
    {
        id = "firewatchCollege",
        name = "College of Firewatch",
        description = "You are a student at the College of Firewatch.",
        journalEntry = "I have just enrolled at the College of Firewatch.",
        location = {
            position = {5718, 3587, 12401},
            orientation = 0,
            cellId = "Firewatch, College"
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
        }
    },
    {
        id = "caravanGuard",
        name = "Caravan Guard",
        description = "You are guarding a caravan in Arvud.",
        journalEntry = "I am guarding a caravan in Arvud.",
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
        }
    },
    {
        id = "kemelZeRuins",
        name = "Kemel-Ze Ruins",
        description = "You are exploring the ruins of Kemel-Ze.",
        journalEntry = "I am exploring the ruins of Kemel-Ze.",
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
        },
    },
    {
        id = "dreynimSpa",
        name = "Dreynim Spa",
        description = "You are on holiday at Dreynim Spa.",
        journalEntry = "I am on holiday at Dreynim Spa. The baths are hot and the drinks are cold.",
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
        journalEntry = "I have just arrived at the Imperial settlement of Nivalis.",
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
        },
    },
    {
        id = "sadasPlantation",
        name = "Sadas Plantation",
        description = "You are a slave working on the Sadas Plantation.",
        journalEntry = "Master Sadas has me working on his plantation. I need to keep my head down.",
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
        journalEntry = "I am working as a dock worker in Andothren. The work is hard but the pay is... well, it's work.",
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
        id = "teynCensus",
        name = "Teyn Census Office",
        description = "You are being processed at the census office in Teyn.",
        journalEntry = "I have been processed at the census office in Teyn.",
        location = { --Teyn, Census and Excise Office
            position = {4321, 4372, 16322},
            orientation =3.13,
            cellId = "Teyn, Census and Excise Office"
        },
        items = {
            {
                id = "gold_001",
                count = 75,
            },
            {
                id = "T_IngFood_Bread_01",
                count = 1,
                noDuplicates = true,
            },
        },
    },
    {
        id = "unwelcomeVisitor",
        name = "Unwelcome Visitor",
        description = "You have wandered into the Andothren Council Club for a game of thirty-six. You feel the eyes of the patrons glaring at you. You should probably leave.",
        journalEntry = "I have wandered into the Andothren Council Club for a game of thirty-six. I should probably leave.",
        location =  { --Andothren, Council Club
            position = {4102, 3970, 12295},
            orientation =0.02,
            cellId = "Andothren, Council Club"
        },
        items = {
            {
                id = "t_com_dice_01",
                count = 2,
                noDuplicates = true,
            },
            {
                id = "gold_001",
                count = 100,
            },
            {
                id = "iron dagger",
                count = 1,
                noDuplicates = true,
            },
        },
        time = 21,
        onStart = function()
            -- Lower the disposition of nearby NPCs to reflect their distrust
            for ref in tes3.player.cell:iterateReferences(tes3.objectType.npc) do
                if ref and ref.mobile then
                    tes3.modDisposition{
                        reference = ref,
                        value = -20
                    }
                end
            end
        end,
    }

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
