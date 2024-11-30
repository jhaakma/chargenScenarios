
local ItemPicks = {
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
        description = "Cuirass",
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
            "ashfall_woodaxe",
            "AB_w_ToolWoodAxe",
            "chitin war axe"
        },
        pickMethod = 'firstValid',
        noDuplicates = true,
    },
    fishingPole = {
        description = "Fishing Pole",
        ids = {
            "mer_fishing_pole_01",
            "misc_de_fishing_pole"
        },
        pickMethod = 'firstValid',
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
    },
    knife = {
        description = "Knife",
        ids = {
            "AB_w_CookKnifeBone",
            "T_Com_Var_Cleaver_01"
        },
        pickMethod = 'firstValid',
        noDuplicates = true,
    },
    lute = {
        description = "Lute",
        id = "misc_de_lute_01",
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
    },
    booze = {
        description = "Booze",
        ids = {
            "potion_local_brew_01",
            "Potion_Cyro_Whiskey_01",
            "potion_local_liquor_01",
            "potion_comberry_wine_01",
            "potion_comberry_brandy_01",
            "potion_nord_mead"
        },
    },
    coinpurse = {
        id = "ab_misc_pursecoin",
        noDuplicates = true,
    },
}

---@class (exact) ChargenScenarios.Util.ItemPicks
---@field boots ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field cuirass ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field leftGauntlet ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field rightGauntlet ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field greaves ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field leftPauldron ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field rightPauldron ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field helm ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field shield ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field weapon ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field hood ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field robe ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field axe ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field fishingPole ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field fishMeat ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field knife ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field lute ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field soulGems ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field booze ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field coinpurse ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
local out = setmetatable({}, {
    __index = function(self, key)
        local itemList = table.deepcopy(ItemPicks[key])
        itemList.count = 1
        local func = function(t, count)
            if count then itemList.count = count end
            return itemList
        end
        return setmetatable(itemList, {__call = func})
    end
})

return out