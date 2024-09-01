
local Scenario = require("mer.chargenScenarios.component.Scenario")

local booze = {
    "potion_local_brew_01",
    "Potion_Cyro_Whiskey_01",
    "potion_local_liquor_01",
    "potion_comberry_wine_01",
    "potion_comberry_brandy_01",
    "potion_nord_mead"
}

local requiresBeastRace = {
    races = {"Argonian", "Khajiit"}
}

local cookingPots = {
    "ashfall_cooking_pot",
    "ashfall_cooking_pot_steel",
    "ashfall_cooking_pot_iron",
}

local requiresOaabShipwreck = {
    plugins = {"OAAB - Shipwrecks.ESP"}
}

local excludesOaabShipwreck = {
    excludedPlugins = {"OAAB - Shipwrecks.ESP"},
}


---@type ChargenScenariosScenarioInput[]
local scenarios = {
    {
        name = "--Vanilla--",
        description = "Start the game in the Seyda Neen Census and Excise Office.",
        location = "vanillaStart",
        doVanillaChargen = true
    },
    {
        name = "Hiding from the Law",
        description = "You are a wanted criminal, hiding in the outskirts of the Ascadia Isles. You have a bounty on your head and a few stolen gems in you possession. Can you escape the law and make a new life for yourself?",
        location = {
             position = { 13078, -78339, 402},
             orientation = 217
        },
        onStart = function(self)
            tes3.player.mobile.bounty =
                tes3.mobilePlayer.bounty + 75
        end,
        items = {
            {
                ids = {
                    "ingred_diamond_01",
                    "ingred_emerald_01",
                    "ingred_ruby_01"
                },
                count = 2
            }
        }
    },
    {

        name = "Pearl Diving",
        description = "You are diving for pearls in the waters near Pelagiad",
        location = {
            position = {12481, -61011, -280},
            orientation = 0,
        },
        items = {
            {
                id = "ingred_pearl_01",
                count = 2,
            },
            {
                id = "chitin spear",
                count = 1,
                noDuplicates = true,
            }
        }
    },

    {
        name = "Hunting in the Grazelands",
        description = "You are a hunter, stalking your prey in the Grazelands.",
        location = {
            position = {74894, 124753, 1371},
            orientation = 0,
        },
        items = {
            {
                id = "ingred_hound_meat_01",
                count = 3
            },
            {
                id = "chitin short bow",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "chitin arrow",
                count = 30
            }
        }
    },
    {
        name = "Working in the Fields",
        description = "You are a lowly slave, toiling in the fields outside of Pelagiad.",
        location = {
            position = {13449, -57064, 136},
            orientation = 0,
        },
        items = {
            {
                id = "ingred_saltrice_01",
                count = 6
            },
            {
                id = "slave_bracer_right",
                count = 1,
                noDuplicates = true,
            },
        },
        requirements = requiresBeastRace,
    },
    {
        name = "Gathering Mushrooms",
        description = "You are in the swamps of the Bitter Coast, searching for ingredients.",
        location = {
            position = {-42653, 28795, 355},
            orientation = 0,
            cell = "-6,3"
        },
        items = {
            {
                id = "apparatus_a_mortar_01",
                count = 1,
                noDuplicates = true,
            },
            {
                ids = {
                    "ingred_bc_bungler's_bane",
                    "ingred_bc_hypha_facia",
                    "ingred_bc_coda_flower",
                    "ingred_bc_spore_pod",
                    "ingred_bc_ampoule_pod"
                },
                count = 4
            }
        },
        onStart = function(self)
            tes3.worldController.weatherController:switchImmediate(tes3.weather.clear)
        end
    },
    {
        name = "Grave Robbing",
        description = "You are a grave robber, looting the Tharys Ancestral Tomb near Balmora.",
        location = {
            position = {2043, 263, -164},
            orientation = 268,
            cell = "Tharys Ancestral Tomb"
        },
        items = {
            {
                id = "silver dagger",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "light_com_torch_01_256",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "pick_apprentice_01",
                count = 2
            },
            {
                id = "probe_apprentice_01",
                count = 1,
                noDuplicates = true,
            }
        },
    },
    {
        name = "Mage in Training",
        description = "You are a student in the Balmora Mages Guild.",
        location = {
            position = {505, -387, -752},
            orientation = 205,
            cell = "Balmora, Guild of Mages"
        },
        items = {
            {
                id = "bookskill_Alchemy2",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "common_robe_03",
                count = 1,
                noDuplicates = true,
            },
        },
    },
    {
        name = "Lumberjack",
        description = "You are gathering firewood in the wilderness.",
        location = {
            position = {38154, -53328, 931},
            orientation = 268,
            cell = "4,-7"
        },
        items = {
            {
                id = "ashfall_woodaxe_steel",
                alternative = "AB_w_ToolWoodAxe",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "ashfall_firewood",
                count = 4
            }
        },
    },
    {
        name = "Prisoner",
        description = "You are imprisoned in the Vivec Hlaalu Prison.",
        location = {
            position = {274, -214, -100},
            orientation = 0,
            cell = "Vivec, Hlaalu Prison Cells"
        },
        items = {
            {
                id = "key_vivec_hlaalu_cell",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "gold_001",
                count = 20
            }
        },
    },
    {
        name = "Shipwrecked",
        description = "You are the sole survivor of a shipwreck.",
        locations = {
            {  --abandoned shipwreck - OAAB
                position = {9256, 187865, 79},
                orientation = 2,
                requirements = requiresOaabShipwreck,
            },
            {  --loneseom shipwreck - OAAB
                position = {112247, 127534, 30},
                orientation = -2,
                requirements = requiresOaabShipwreck,
            },
            {  --neglected shipwreck - OAAB
                position = {4049, 4179, 79},
                orientation = -3,
                cell = "Neglected Shipwreck, Cabin",
                requirements = requiresOaabShipwreck,
            },
            {  --prelude shipwreck - OAAB
                position = {4170, 4245, 63},
                orientation = -3,
                cell = "Prelude Shipwreck, Cabin",
                requirements = requiresOaabShipwreck,
            },
            {  --remote shipwreck - OAAB
                position = {-8307, -84454, 93},
                orientation =-2,
                requirements = requiresOaabShipwreck,
            },
            {  --shunned shipwreck - OAAB
                position = {-74895, 14527, -29},
                orientation =-3,
                requirements = requiresOaabShipwreck,
            },
            { -- abandoned shipwreck - Vanilla
                position = {-1, -185, -26},
                orientation =-4,
                requirements = excludesOaabShipwreck,
                cell = "Abandoned Shipwreck, Cabin"
            },
            { -- derelict shipwreck - Vanilla
                position = {-51690, 152197, 256},
                orientation =2,
                requirements = excludesOaabShipwreck,
            },
            { -- deserted shipwreck - Vanilla
                position = {74492, -85701, 29},
                orientation =-4,
                requirements = excludesOaabShipwreck,
            },
            { -- lonely shipwreck - Vanilla
                position = {154892, -6903, 51},
                orientation =2,
                requirements = excludesOaabShipwreck,
            },
            { -- lost shipwreck - Vanilla
                position = {127245, 94761, 71},
                orientation =2,
                requirements = excludesOaabShipwreck,
            },
            { -- remote shipwreck - Vanilla
                position = {-7894, -84541, 90},
                orientation =2,
                requirements = excludesOaabShipwreck,
            },
            { -- shunned shipwreck - Vanilla
                position = {-75958, 14512, -20},
                orientation =1,
                requirements = excludesOaabShipwreck,
            },
            { -- strange shipwreck - Vanilla
                position = {4172, 4017, 15651},
                orientation =-1,
                requirements = excludesOaabShipwreck,
                cell = "Strange Shipwreck, Cabin"
            },
            { -- unchartered shipwreck - Vanilla
                position = {4221, 4034, 15466},
                orientation =-1,
                requirements = excludesOaabShipwreck,
                cell = "Unchartered Shipwreck, Cabin"
            },
            { -- unexplored shipwreck - Vanilla
                position = {-40235, -55708, 79},
                orientation =-1,
                requirements = excludesOaabShipwreck,
            },
            { -- unknown shipwreck - Vanilla
                position = {132532, 37476, 338},
                orientation =-2,
                requirements = excludesOaabShipwreck,
            },
        },
        items = {
            {
                ids = booze,
                count = 2
            }
        }
    },
    {
        name = "Khuul Camping",
        description = "You are setting up camp near Khuul.",
        location = {
            position = {-78170, 143029, 427},
            orientation = 349,
        },
        items = {
            {
                ids = cookingPots,
                count = 1
            },
            {
                id = "ashfall_firewood",
                count = 5
            },
            {
                id = "ashfall_tent_base_m",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "ashfall_woodaxe",
                count = 1,
                noDuplicates = true,
            }
        },
    },
    --[[        elseif ( button == 6 ) ;Working as a commoner in Maar Gan
            Player->PositionCell 29,-384,-386,0, "Maar Gan, Andus Tradehouse"
            Player->AddItem "gold_001", 35
            Player->AddItem "misc_com_bucket_01", 1
            Player->AddItem "misc_de_cloth10", 1
            Player->AddItem "misc_de_tankard_01", 1]]
    {
        name = "Working as a Commoner",
        description = "You are working as a commoner in the Andus Tradehouse in Maar Gan.",
        location = {
            position = {29, -384, -386},
            orientation = 0,
            cell = "Maar Gan, Andus Tradehouse"
        },
        items = {
            {
                id = "ab_misc_pursecoin",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "misc_com_bucket_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "misc_de_cloth10",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "misc_de_tankard_01",
                count = 1,
                noDuplicates = true,
            }
        }
    },
    --[[        elseif ( button == 7 )         ;Paying homage at the Fields of Kummu
            Player->PositionCell 14330,-33457,774,57, "1,-5"
            Player->RemoveItem "iron dagger", 1
            Player->RemoveItem "common_shirt_01", 1
            Player->AddItem "bk_PilgrimsPath", 1
            Player->AddItem "common_robe_01", 1
    ]]
    {
        name = "Pilgrimage",
        description = "You are paying homage at the Fields of Kummu.",
        location = {
            position = {14330, -33457, 774},
            orientation = 57,
        },
        items = {
            {
                id = "bk_PilgrimsPath",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "common_robe_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "ingred_muck_01",
                count = 2
            }
        }
    },
    {
        name = "Shaking Down Fargoth",
        description = "You are in Seyda Neen, shaking down Fargoth for all he's worth.",
        location = {
            position = {-10412, -71271, 298},
            orientation = 300,
        },
        onStart = function(self)
            tes3.equip{ reference = tes3.player, item = "iron dagger" }
            local fargoth = tes3.getReference("Fargoth")
            tes3.playAnimation{
                reference=fargoth,
                group=tes3.animationGroup.knockOut,
                startFlag = tes3.animationStartFlag.immediate,
                loopCount = 1
            }
            tes3.setStatistic{
                reference = fargoth,
                name = "fatigue",
                current = 1
            }
            fargoth.object.baseDisposition = 0
        end,
        items = {
            {
                id = "iron dagger",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "gold_001",
                count = 30, --enough to pay for stealing if you get caught pickpocketing fargoth while he's down
            }
        }
    },
    {
        name = "House of Earthly Delights",
        description = "You are enjoying the pleasures of Desele's House of Earthly Delights in Suran.",
        location = {
            position = {-30, -234, 188},
            orientation = 90,
            cell = "Suran, Desele's House of Earthly Delights"
        },
        items = {
            {
                id = "potion_local_brew_01",
                count = 1
            },
            {
                id = "ingred_moon_sugar_01",
                count = 2
            }
        }
    },
    {
        name = "Fishing in Hla Oad",
        description = "You are fishing in the waters of Hla Oad.",
        location ={
            position = {-48464, -38956, 211},
            orientation =-2,
        },
        items = {
            {
                id = "misc_de_fishing_pole",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "ingred_scales_01",
                count = 2
            },
            {
                id = "ingred_crab_meat_01",
                count = 2
            },
            {
                id = "gold_001",
                count = 5
            },
            {
                id = "mer_bug_spinner2",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "mer_fish_trout",
                count = 1
            },
            {
                id = "AB_w_CookKnifeBone",
                count = 1,
                noDuplicates = true,
            }
        }
    },
    {
        name = "Egg Farming",
        description = "You are farming Kwama Eggs in the Shulk Egg Mine.",
        location = {
            position = {4457, 3423, 12612},
            orientation = 0,
            cell = "Shulk Egg Mine, Mining Camp"
        },
        items = {
            {
                id = "miner's pick",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "food_kwama_egg_02",
                count = 2
            },
            {
                id = "food_kwama_egg_01",
                count = 5
            },
            {
                id = "p_restore_fatigue_c",
                count = 1
            }
        }
    },
    {
        name = "Haunted Room",
        description = "You are sleeping in a haunted room at the Gateway Inn in Sadrith Mora.",
        location = {
            position = {-219, -159, 276},
            orientation = 0,
            cell = "Sadrith Mora, Gateway Inn: South Wing"
        },
        items = {
            {
                id = "bk_hospitality_papers",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "gold_001",
                count = 10
            },
        },
        onStart = function(self)
            tes3.messageBox("You are awakened by a noise from the other room.")
        end
    },
    {
        name = "Bard in Pelagiad",
        description = "You are a bard in the Halfway Tavern in Pelagiad.",
        location = {
            position = {407, 236, 105},
            orientation = 0,
            cell = "Pelagiad, Halfway Tavern"
        },
        items = {
            {
                id = "bk_redbookofriddles",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "misc_de_lute_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "misc_de_drum_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "gold_001",
                count = 10
            }
        },
        onStart = function()
            local songController = include("mer.bardicInspiration.controllers.songController")
            if songController then
                songController.learnSong{
                    name = "Beneath the Mushroom Tree",
                    path = "mer_bard/beg/2.mp3",
                    difficulty = "beginner",
                }
            end
        end
    },

}


for _, scenario in ipairs(scenarios) do
    Scenario:register(scenario)
end

