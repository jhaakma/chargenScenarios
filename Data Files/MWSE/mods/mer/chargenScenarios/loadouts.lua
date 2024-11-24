---@type ChargenScenariosItemPickInput[]
local loadouts = {
    {
        ids = {
            "netch_leather_boots",     --light
            "BM bear boots",           --medium
            "iron boots",              --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    {
        ids = {
            "netch_leather_cuirass",       --light
            "nordic_ringmail_cuirass",     --medium
            "iron_cuirass",                --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    {
        "netch_leather_gauntlet_left",     --light
        "bm bear left gauntlet",           --medium
        "iron_gauntlet_left",              --heavy
    },
    {
        ids = {
            "netch_leather_gauntlet_right",     --light
            "BM bear right gauntlet",           --medium
            "iron_gauntlet_right",              --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    {
        ids = {
            "netch_leather_greaves",      --light
            "imperial_chain_greaves",     --medium
            "iron_greaves",               --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    {
        ids = {
            "netch_leather_pauldron_left",     --light
            "BM Bear left Pauldron",           --medium
            "iron_pauldron_left",              --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    {
        ids = {
            "netch_leather_pauldron_right",     --light
            "BM Bear right Pauldron",           --medium
            "iron_pauldron_right",              --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    {
        ids = {
            "netch_leather_helm",           --light
            "imperial_chain_coif_helm",     --medium
            "iron_helmet",                  --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    {
        ids = {
            "netch_leather_shield",     --light
            "BM bear shield",           --medium
            "iron_shield",              --heavy
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    {
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
    {
        ids = {
            "AB_c_CommonHood01",
            "AB_c_CommonHood02",
            "AB_c_CommonHood02h",
            "AB_c_CommonHood03a",
            "AB_c_CommonHoodBlack"
        },
        noSlotDuplicates = true,
        pickMethod = "bestForClass"
    },
    {
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
        pickMethod = "bestForClass"
    },
}

return loadouts