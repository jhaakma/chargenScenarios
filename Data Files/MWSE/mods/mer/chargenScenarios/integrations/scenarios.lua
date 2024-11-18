
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
        id = "vanilla",
        name = "--Vanilla--",
        description = "Start the game in the Seyda Neen Census and Excise Office.",
        location = {
            orientation = 2,
            position = {33,-87,194},
            cell = "Seyda Neen, Census and Excise Office"
        },
        onStart = function(self)
            tes3.worldController.weatherController:switchImmediate(tes3.weather.clear)
        end
    },
    {
        id = "hidingFromTheLaw",
        name = "Hiding from the Law",
        description = "You are a wanted criminal, hiding in the outskirts of the Ascadian Isles.",
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
            },
        }
    },
    {
        id = "pearlDiving",
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
                noSlotDuplicates = true,
            },
        }
    },

    {
        id = "huntingInGrazelands",
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
                id = "long bow",
                count = 1,
                noSlotDuplicates = true,
            },
            {
                id = "chitin arrow",
                count = 30,
            },
        }
    },
    {
        id = "workingInTheFields",
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
                noSlotDuplicates = true,
            },
        },
        requirements = requiresBeastRace,
    },
    {
        id = "gatheringMushrooms",
        name = "Gathering Mushrooms",
        description = "You are in the swamps of the Bitter Coast, searching for ingredients.",
        location = {
            position = {-44618, 29841, 598},
            orientation =2,
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
            },
        },
        onStart = function(self)
            tes3.worldController.weatherController:switchImmediate(tes3.weather.clear)
        end
    },
    {
        id = "graveRobbing",
        name = "Grave Robbing",
        description = "You are a grave robber looting an ancestral tomb.",
        locations = {
            { --Andalen Ancestral Tomb
                position = {878, -1008, 258},
                orientation =-1,
                cell = "Andalen Ancestral Tomb"
            },
            { --Andalor Ancestral Tomb
                position = {3065, 2881, 386},
                orientation =-2,
                cell = "Andalor Ancestral Tomb"
            },
            { --Andas Ancestral Tomb
                position = {763, -542, -702},
                orientation =-1,
                cell = "Andas Ancestral Tomb"
            },
            { --Andavel Ancestral Tomb
                position = {-5194, -601, 2050},
                orientation =-4,
                cell = "Andavel Ancestral Tomb"
            },
            { --Andrethi Ancestral Tomb
                position = {2617, 1182, -894},
                orientation =-2,
                cell = "Andrethi Ancestral Tomb"
            },
            { --Andules Ancestral Tomb
                position = {-900, 26, 257},
                orientation =0,
                cell = "Andules Ancestral Tomb"
            },
            { --Aran Ancestral Tomb
                position = {-2353, 5163, -190},
                orientation =3,
                cell = "Aran Ancestral Tomb"
            },
            { --Arethan Ancestral Tomb
                position = {-737, 1530, -30},
                orientation =-1,
                cell = "Arethan Ancestral Tomb"
            },
            { --Arys Ancestral Tomb
                position = {12802, -4140, -702},
                orientation =-1,
                cell = "Arys Ancestral Tomb"
            },
            { --Baram Ancestral Tomb
                position = {-2533, 248, 1442},
                orientation =-4,
                cell = "Baram Ancestral Tomb"
            },
            { --Dareleth Ancestral Tomb
                position = {3802, -3038, 1602},
                orientation =-2,
                cell = "Dareleth Ancestral Tomb"
            },
            { --Dreloth Ancestral Tomb
                position = {0, 1907, 130},
                orientation =3,
                cell = "Dreloth Ancestral Tomb"
            },
            { --Drinith Ancestral Tomb
                position = {-300, -4552, 2722},
                orientation =-4,
                cell = "Drinith Ancestral Tomb"
            },
            { --Falas Ancestral Tomb
                position = {-2705, -1280, 1282},
                orientation =1,
                cell = "Falas Ancestral Tomb"
            },
            { --Helan Ancestral Tomb
                position = {-1776, 380, 258},
                orientation =1,
                cell = "Helan Ancestral Tomb"
            },
            { --Heran Ancestral Tomb
                position = {-17, 2755, 258},
                orientation =3,
                cell = "Heran Ancestral Tomb"
            },
            { --Hlaalu Ancestral Tomb
                position = {-249, 1261, 386},
                orientation =3,
                cell = "Hlaalu Ancestral Tomb"
            },
            { --Hlervi Ancestral Tomb
                position = {3202, -876, 1058},
                orientation =-2,
                cell = "Hlervi Ancestral Tomb"
            },
            { --Hlervu Ancestral Tomb
                position = {9, 2544, -510},
                orientation =3,
                cell = "Hlervu Ancestral Tomb"
            },
            { --Indalen Ancestral Tomb
                position = {-487, -97, 2466},
                orientation =3,
                cell = "Indalen Ancestral Tomb"
            },
            { --Lleran Ancestral Tomb
                position = {995, -958, 98},
                orientation =0,
                cell = "Lleran Ancestral Tomb"
            },
            { --Norvayn Ancestral Tomb
                position = {-1156, -1793, 1666},
                orientation =1,
                cell = "Norvayn Ancestral Tomb"
            },
            { --Releth Ancestral Tomb
                position = {2690, 901, 386},
                orientation =-2,
                cell = "Releth Ancestral Tomb"
            },
            { --Rethandus Ancestral Tomb
                position = {-3160, -100, 1410},
                orientation =-4,
                cell = "Rethandus Ancestral Tomb"
            },
            { --Sadryn Ancestral Tomb
                position = {703, -639, 34},
                orientation =0,
                cell = "Sadryon Ancestral Tomb"
            },
            { --Samarys Ancestral Tomb
                position = {-2272, 992, 258},
                orientation =1,
                cell = "Samarys Ancestral Tomb"
            },
            { --Sandas Ancestral Tomb
                position = {1660, 7, 258},
                orientation =-2,
                cell = "Sandas Ancestral Tomb"
            },
            { --Sarys Ancestral Tomb
                position = {7028, 4415, 14914},
                orientation =-2,
                cell = "Sarys Ancestral Tomb"
            },
            { --Tharys Ancestral Tomb
                position = {2092, 272, -190},
                orientation =-2,
                cell = "Tharys Ancestral Tomb"
            },
            { --Thelas Ancestral Tomb
                position = {374, 3176, 770},
                orientation =3,
                cell = "Thelas Ancestral Tomb"
            },
            { --Uveran Ancestral Tomb
                position = {1934, -1559, 1695},
                orientation =-4,
                cell = "Uveran Ancestral Tomb"
            },
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
                count = 1,
                noDuplicates = true,
            },
            {
                id = "probe_apprentice_01",
                count = 1,
                noDuplicates = true,
            },
        },
    },
    {
        id = "magesGuild",
        name = "Faction: Mages Guild",
        description = "You are an associate of the Mages Guild.",
        onStart = function()
            local mageGuild = tes3.getFaction("Mages Guild")
            mageGuild.playerJoined = true
            mageGuild.playerRank = 0
        end,
        locations = {
            {
                position = {14, 187, -252},
                orientation =-4,
                name = "Vivec",
                cell = "Vivec, Guild of Mages"
            },
            {
                position = {370, -584, -761},
                orientation =-4,
                name = "Balmora",
                cell = "Balmora, Guild of Mages"
            },
            {
                position = {695, 537, 404},
                orientation =0,
                name = "Caldera",
                cell = "Caldera, Guild of Mages"
            },
            {
                position = {186, 542, 66},
                orientation =0,
                name = "Sadrith Mora",
                cell = "Sadrith Mora, Wolverine Hall: Mage's Guild"
            },
        },
        items = {
            {
                id = "bookskill_Alchemy2",
                count = 1,
                noDuplicates = true,
            },
        },
    },
    {
        id = "fightersGuild",
        name = "Faction: Fighters Guild",
        description = "You are an associate of the Fighters Guild.",
        onStart = function()
            local fightersGuild = tes3.getFaction("Fighters Guild")
            fightersGuild.playerJoined = true
            fightersGuild.playerRank = 0
        end,
        locations = {
            {
                position = {-901, -379, -764},
                orientation =0,
                name = "Ald-Rhun",
                cell = "Ald-ruhn, Guild of Fighters"
            },
            {
                position = {304, 293, -377},
                orientation =0,
                name = "Balmora",
                cell = "Balmora, Guild of Fighters"
            },
            {
                position = {306, -222, 3},
                orientation =-1,
                name = "Sadrith Mora",
                cell = "Sadrith Mora, Wolverine Hall: Fighter's Guild"
            },
            {
                position = {179, 822, -508},
                orientation =-2,
                name = "Vivec",
                cell = "Vivec, Guild of Fighters"
            },
        },
        items = {
            {
                id = "p_restore_health_s",
                count = 4,
            },
        }
    },
    {
        id = "lumberjack",
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
        id = "prisoner",
        name = "Imprisoned",
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
        id = "shipwrecked",
        name = "Shipwrecked",
        description = "You are the sole survivor of a shipwreck.",
        locations = {
            {  --abandoned shipwreck - OAAB
                name = "Abandoned Shipwreck",
                position = {9256, 187865, 79},
                orientation = 2,
                requirements = requiresOaabShipwreck,
            },
            {  --Lonesome shipwreck - OAAB
                name = "Lonesome Shipwreck",
                position = {112247, 127534, 30},
                orientation = -2,
                requirements = requiresOaabShipwreck,
            },
            {  --neglected shipwreck - OAAB
                name = "Neglected Shipwreck",
                position = {4049, 4179, 79},
                orientation = -3,
                cell = "Neglected Shipwreck, Cabin",
                requirements = requiresOaabShipwreck,
            },
            {  --prelude shipwreck - OAAB
                name = "Prelude Shipwreck",
                position = {4170, 4245, 63},
                orientation = -3,
                cell = "Prelude Shipwreck, Cabin",
                requirements = requiresOaabShipwreck,
            },
            {  --remote shipwreck - OAAB
                name = "Remote Shipwreck",
                position = {-8307, -84454, 93},
                orientation =-2,
                requirements = requiresOaabShipwreck,
            },
            {  --shunned shipwreck - OAAB
                name = "Shunned Shipwreck",
                position = {-74895, 14527, -29},
                orientation =-3,
                requirements = requiresOaabShipwreck,
            },
            { -- abandoned shipwreck - Vanilla
                name = "Abandoned Shipwreck",
                position = {-1, -185, -26},
                orientation =-4,
                requirements = excludesOaabShipwreck,
                cell = "Abandoned Shipwreck, Cabin"
            },
            { -- derelict shipwreck - Vanilla
                name = "Derelict Shipwreck",
                position = {-51690, 152197, 256},
                orientation =2,
                requirements = excludesOaabShipwreck,
            },
            { -- deserted shipwreck - Vanilla
                name = "Deserted Shipwreck",
                position = {74492, -85701, 29},
                orientation =-4,
                requirements = excludesOaabShipwreck,
            },
            { -- lonely shipwreck - Vanilla
                name = "Lonely Shipwreck",
                position = {154892, -6903, 51},
                orientation =2,
                requirements = excludesOaabShipwreck,
            },
            { -- lost shipwreck - Vanilla
                name = "Lost Shipwreck",
                position = {127245, 94761, 71},
                orientation =2,
                requirements = excludesOaabShipwreck,
            },
            { -- remote shipwreck - Vanilla
                name= "Remote Shipwreck",
                position = {-7894, -84541, 90},
                orientation =2,
                requirements = excludesOaabShipwreck,
            },
            { -- shunned shipwreck - Vanilla
                name= "Shunned Shipwreck",
                position = {-75958, 14512, -20},
                orientation =1,
                requirements = excludesOaabShipwreck,
            },
            { -- strange shipwreck - Vanilla
                name= "Strange Shipwreck",
                position = {4172, 4017, 15651},
                orientation =-1,
                requirements = excludesOaabShipwreck,
                cell = "Strange Shipwreck, Cabin"
            },
            { -- unchartered shipwreck - Vanilla
                name= "Unchartered Shipwreck",
                position = {4221, 4034, 15466},
                orientation =-1,
                requirements = excludesOaabShipwreck,
                cell = "Unchartered Shipwreck, Cabin"
            },
            { -- unexplored shipwreck - Vanilla
                name= "Unexplored Shipwreck",
                position = {-40235, -55708, 79},
                orientation =-1,
                requirements = excludesOaabShipwreck,
            },
            { -- unknown shipwreck - Vanilla
                name= "Unknown Shipwreck",
                position = {132532, 37476, 338},
                orientation =-2,
                requirements = excludesOaabShipwreck,
            },
        },
        items = {
            {
                ids = booze,
                count = 2
            },
        }
    },
    {
        id = "khuulCamping",
        name = "Camping",
        description = "You are setting up camp near Khuul.",
        location = {
            position = {-78170, 143029, 427},
            orientation = 349,
        },
        items = {
            { ids = cookingPots },
            {
                id = "ashfall_firewood",
                count = 4
            },
            {
                id = "ashfall_tent_base_m",
                noDuplicates = true,
            },
            {
                id = "ashfall_woodaxe",
                noDuplicates = true,
            },
            {
                id = "ingred_hound_meat_01",
                count = 3
            },
            { id = "ashfall_flintsteel" },
        },
    },
    {
        id= "commoner",
        name = "Commoner",
        description = "You are working as a commoner in a tradehouse, Serving drinks and clearing tables.",
        locations = {
            {
                position = { 29, -384, -386 },
                orientation = 0,
                cell = "Maar Gan, Andus Tradehouse"
            },
            { --Gnisis, Madach Tradehouse
                position = {-57, 280, -125},
                orientation =-2,
                cell = "Gnisis, Madach Tradehouse"
            },
            { --Suran, Suran Tradehouse
                position = {4, 240, 519},
                orientation =0,
                cell = "Suran, Suran Tradehouse"
            },
            { --Bodrum, Varalaryn Tradehouse
                position = {413, -1613, -379},
                orientation =0,
                cell = "Bodrum, Varalaryn Tradehouse",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },
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
    {
        id = "pilgrimage",
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
                noSlotDuplicates = true,
            },
            {
                id = "ingred_muck_01",
                count = 2
            },
        }
    },
    {
        id = "shakingDownFargoth",
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
                id = "gold_001",
                count = 50, --enough to pay for stealing if you get caught pickpocketing fargoth while he's down
            },
        }
    },
    {
        id = "houseOfEarthlyDelights",
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
            },
        }
    },
    {
        id = "fishing",
        name = "Fishing",
        description = "You are fishing in the waters of Hla Oad.",
        locations = {
            {
                position = {-48464, -38956, 211},
                orientation =-2,
            },
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
            },
        }
    },
    {
        id = "eggFarmer",
        name = "Egg Farmer",
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
        id = "hauntedRoom",
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
                count = 70
            },
            {id = "silver dagger",}
        },
        onStart = function(self)
            tes3.messageBox("You are awakened by a noise from the other room.")
        end
    },
    {
        id = "bardInPelagiad",
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
            },
            {id = "expensive_pants_03", noDuplicates = true},
            {id = "extravagant_shirt_02", noDuplicates = true},
            {id = "expensive_shoes_02", noDuplicates = true},
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

