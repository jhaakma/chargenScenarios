
---@type table<string, ChargenScenariosItemPickInput>
local ItemPicks = {
    gold = {
        id = "gold_001",
    },
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
        pickMethod = "bestForClass",
        ammo = {
            { weaponId = "chitin short bow", ammoId = "chitin arrow", count = 40 }
        }
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
            "common_robe_01",
            "common_robe_02",
            "common_robe_02_h",
            "common_robe_02_hh",
            "common_robe_02_rr",
            "common_robe_03",
            "common_robe_03_a",
            "common_robe_03_b",
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
        noListDuplicates = true,
    },
    fishingPole = {
        description = "Fishing Pole",
        ids = {
            "mer_fishing_pole_01",
            "misc_de_fishing_pole"
        },
        pickMethod = 'firstValid',
        noListDuplicates = true,
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
        noListDuplicates = true,
    },
    lute = {
        description = "Lute",
        ids = {
            "misc_de_lute_01",
            "t_imp_lute_01",
            "t_com_lute_01",
            "ab_mus_delutethin",
        },
        noListDuplicates = true,
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
    meat = {
        description = "Meat",
        ids = {
            "ingred_hound_meat_01",
            "ingred_crab_meat_01",
            "ingred_rat_meat_01",
            "ashfall_meat_sfish",
            "ashfall_meat_kag"
        },
        pickOneOnly = true
    },
    fancyOutfit = {
        description = "Fancy Outfit",
        ids = {
            "expensive_pants_03",
            "extravagant_shirt_02",
            "expensive_shoes_02",
        },
        noDuplicates = true,
        pickMethod = "all",
    }
}

---@class (exact) ChargenScenarios.Util.ItemPicks
---@field gold ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
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
---@field meat ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
---@field fancyOutfit ChargenScenariosItemPickInput | fun(count): ChargenScenariosItemPickInput
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