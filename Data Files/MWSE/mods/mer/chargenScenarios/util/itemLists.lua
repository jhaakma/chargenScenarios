---@class (exact) ChargenScenarios.Util.ItemLists
---@field boots ChargenScenariosItemPickInput
---@field cuirass ChargenScenariosItemPickInput
---@field leftGauntlet ChargenScenariosItemPickInput
---@field rightGauntlet ChargenScenariosItemPickInput
---@field greaves ChargenScenariosItemPickInput
---@field leftPauldron ChargenScenariosItemPickInput
---@field rightPauldron ChargenScenariosItemPickInput
---@field helm ChargenScenariosItemPickInput
---@field shield ChargenScenariosItemPickInput
---@field weapon ChargenScenariosItemPickInput
---@field hood ChargenScenariosItemPickInput
---@field robe ChargenScenariosItemPickInput
---@field axe ChargenScenariosItemPickInput
---@field fishingPole ChargenScenariosItemPickInput
---@field fishMeat ChargenScenariosItemPickInput
---@field knife ChargenScenariosItemPickInput
---@field lute ChargenScenariosItemPickInput
---@field soulGems ChargenScenariosItemPickInput
local loadouts = {
    boots = {
        description = "Boots",
        ids = {
            "netch_leather_boots",     --light
            "BM bear boots",           --medium
            "iron boots",              --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    cuirass = {
        ids = {
            "netch_leather_cuirass",       --light
            "nordic_ringmail_cuirass",     --medium
            "iron_cuirass",                --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    leftGauntlet = {
        description = "Left Gauntlet",
        ids = {
            "netch_leather_gauntlet_left",     --light
            "bm bear left gauntlet",           --medium
            "iron_gauntlet_left",              --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    rightGauntlet = {
        description = "Right Gauntlet",
        ids = {
            "netch_leather_gauntlet_right",     --light
            "BM bear right gauntlet",           --medium
            "iron_gauntlet_right",              --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    greaves = {
        description = "Greaves",
        ids = {
            "netch_leather_greaves",      --light
            "imperial_chain_greaves",     --medium
            "iron_greaves",               --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    leftPauldron = {
        description = "Left Pauldron",
        ids = {
            "netch_leather_pauldron_left",     --light
            "BM Bear left Pauldron",           --medium
            "iron_pauldron_left",              --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    rightPauldron = {
        description = "Right Pauldron",
        ids = {
            "netch_leather_pauldron_right",     --light
            "BM Bear right Pauldron",           --medium
            "iron_pauldron_right",              --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    helm = {
        description = "Helm",
        ids = {
            "netch_leather_helm",           --light
            "imperial_chain_coif_helm",     --medium
            "iron_helmet",                  --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    shield = {
        description = "Shield",
        ids = {
            "netch_leather_shield",     --light
            "BM bear shield",           --medium
            "iron_shield",              --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    weapon = {
        description = "Weapon",
        ids = {
            "iron tanto",             --short blade
            "AB_w_IronRapier",        --long blade
            "AB_w_ChitinHalberd",     --spear
            "iron war axe",           --axe
            "AB_w_ChitinMace",        --blunt
            "chitin short bow",       --marksman
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    hood = {
        description = "Hood",
        ids = {
            "AB_c_CommonHood01",
            "AB_c_CommonHood02",
            "AB_c_CommonHood02h",
            "AB_c_CommonHood03a",
            "AB_c_CommonHoodBlack"
        },
        noSlotDuplicates = true,
        pickMethod = "random"
    },
    robe = {
        description = "Robe",
        ids = {
            "common_robe_02",
            "common_robe_03",
            "common_robe_04",
            "common_robe_05",
            "common_robe_05_a",
            "common_robe_05_b",
            "common_robe_05_c",
        },
        noSlotDuplicates = true,
        pickMethod = "random"
    },
    axe = {
        description = "Axe",
        ids = {
            "ashfall_woodaxe_steel",
            "AB_w_ToolWoodAxe",
            "chitin war axe"
        },
        pickMethod = 'firstValid',
        count = 1,
        noDuplicates = true,
    },
    fishingPole = {
        description = "Fishing Pole",
        ids = {
            "mer_fishing_pole_01",
            "misc_de_fishing_pole"
        },
        pickMethod = 'firstValid',
        count = 1,
        noDuplicates = true,
    },
    fishMeat = {
        description = "Fish Meat",
        ids = {
            "mer_fish_trout",
            "T_IngFood_FishBrowntrout_01",
            "AB_IngCrea_SfMeat_01",
        },
        pickMethod = 'firstValid',
        count = 1
    },
    knife = {
        description = "Knife",
        ids = {
            "AB_w_CookKnifeBone",
            "T_Com_Var_Cleaver_01"
        },
        pickMethod = 'firstValid',
        count = 1,
        noDuplicates = true,
    },
    lute = {
        description = "Lute",
        ids = {
            "mer_lute",
            "misc_de_lute_01"
        },
        pickMethod = 'firstValid',
        count = 1,
        noDuplicates = true,
    },
    soulGems = {
        description = "Soul Gem",
        ids = {
            "misc_soulgem_common",
            "misc_soulgem_lesser",
            "misc_soulgem_petty",
        },
        pickMethod = 'random',
        count = 3,
    }
}



return loadouts