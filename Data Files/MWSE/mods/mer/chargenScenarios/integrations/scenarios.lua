
local Scenario = require("mer.chargenScenarios.component.Scenario")
local itemPicks = require("mer.chargenScenarios.util.itemPicks")

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
            cellId = "Seyda Neen, Census and Excise Office"
        },
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
                description = "Stolen gems",
                ids = {
                    "ingred_diamond_01",
                    "ingred_emerald_01",
                    "ingred_ruby_01"
                },
                count = 3
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
            {
                id = "gold_001",
                count = 25,
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
            itemPicks.coinpurse,
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
            itemPicks.coinpurse,
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
                description = "Mushrooms",
                ids = {
                    "ingred_bc_bungler's_bane",
                    "ingred_bc_hypha_facia",
                    "ingred_bc_coda_flower",
                    "ingred_bc_spore_pod",
                    "ingred_bc_ampoule_pod"
                },
                count = 4
            },
            {
                id = "gold_001",
                count = 25,
            },
        },
    },
    {
        id = "graveRobbing",
        name = "Grave Robbing",
        description = "You are a grave robber looting an ancestral tomb.",
        locations = {
            { --Andalen Ancestral Tomb
                position = {878, -1008, 258},
                orientation =-1,
                cellId = "Andalen Ancestral Tomb"
            },
            { --Andalor Ancestral Tomb
                position = {3065, 2881, 386},
                orientation =-2,
                cellId = "Andalor Ancestral Tomb"
            },
            { --Andas Ancestral Tomb
                position = {763, -542, -702},
                orientation =-1,
                cellId = "Andas Ancestral Tomb"
            },
            { --Andavel Ancestral Tomb
                position = {-5194, -601, 2050},
                orientation =-4,
                cellId = "Andavel Ancestral Tomb"
            },
            { --Andrethi Ancestral Tomb
                position = {2617, 1182, -894},
                orientation =-2,
                cellId = "Andrethi Ancestral Tomb"
            },
            { --Andules Ancestral Tomb
                position = {-900, 26, 257},
                orientation =0,
                cellId = "Andules Ancestral Tomb"
            },
            { --Aran Ancestral Tomb
                position = {-2353, 5163, -190},
                orientation =3,
                cellId = "Aran Ancestral Tomb"
            },
            { --Arethan Ancestral Tomb
                position = {-737, 1530, -30},
                orientation =-1,
                cellId = "Arethan Ancestral Tomb"
            },
            { --Arys Ancestral Tomb
                position = {12802, -4140, -702},
                orientation =-1,
                cellId = "Arys Ancestral Tomb"
            },
            { --Baram Ancestral Tomb
                position = {-2533, 248, 1442},
                orientation =-4,
                cellId = "Baram Ancestral Tomb"
            },
            { --Dareleth Ancestral Tomb
                position = {3802, -3038, 1602},
                orientation =-2,
                cellId = "Dareleth Ancestral Tomb"
            },
            { --Dreloth Ancestral Tomb
                position = {0, 1907, 130},
                orientation =3,
                cellId = "Dreloth Ancestral Tomb"
            },
            { --Drinith Ancestral Tomb
                position = {-300, -4552, 2722},
                orientation =-4,
                cellId = "Drinith Ancestral Tomb"
            },
            { --Falas Ancestral Tomb
                position = {-2705, -1280, 1282},
                orientation =1,
                cellId = "Falas Ancestral Tomb"
            },
            { --Helan Ancestral Tomb
                position = {-1776, 380, 258},
                orientation =1,
                cellId = "Helan Ancestral Tomb"
            },
            { --Heran Ancestral Tomb
                position = {-17, 2755, 258},
                orientation =3,
                cellId = "Heran Ancestral Tomb"
            },
            { --Hlaalu Ancestral Tomb
                position = {-249, 1261, 386},
                orientation =3,
                cellId = "Hlaalu Ancestral Tomb"
            },
            { --Hlervi Ancestral Tomb
                position = {3202, -876, 1058},
                orientation =-2,
                cellId = "Hlervi Ancestral Tomb"
            },
            { --Hlervu Ancestral Tomb
                position = {9, 2544, -510},
                orientation =3,
                cellId = "Hlervu Ancestral Tomb"
            },
            { --Indalen Ancestral Tomb
                position = {-487, -97, 2466},
                orientation =3,
                cellId = "Indalen Ancestral Tomb"
            },
            { --Lleran Ancestral Tomb
                position = {995, -958, 98},
                orientation =0,
                cellId = "Lleran Ancestral Tomb"
            },
            { --Norvayn Ancestral Tomb
                position = {-1156, -1793, 1666},
                orientation =1,
                cellId = "Norvayn Ancestral Tomb"
            },
            { --Releth Ancestral Tomb
                position = {2690, 901, 386},
                orientation =-2,
                cellId = "Releth Ancestral Tomb"
            },
            { --Rethandus Ancestral Tomb
                position = {-3160, -100, 1410},
                orientation =-4,
                cellId = "Rethandus Ancestral Tomb"
            },
            { --Sadryn Ancestral Tomb
                position = {703, -639, 34},
                orientation =0,
                cellId = "Sadryon Ancestral Tomb"
            },
            { --Samarys Ancestral Tomb
                position = {-2272, 992, 258},
                orientation =1,
                cellId = "Samarys Ancestral Tomb"
            },
            { --Sandas Ancestral Tomb
                position = {1660, 7, 258},
                orientation =-2,
                cellId = "Sandas Ancestral Tomb"
            },
            { --Sarys Ancestral Tomb
                position = {7028, 4415, 14914},
                orientation =-2,
                cellId = "Sarys Ancestral Tomb"
            },
            { --Tharys Ancestral Tomb
                position = {2092, 272, -190},
                orientation =-2,
                cellId = "Tharys Ancestral Tomb"
            },
            { --Thelas Ancestral Tomb
                position = {374, 3176, 770},
                orientation =3,
                cellId = "Thelas Ancestral Tomb"
            },
            { --Uveran Ancestral Tomb
                position = {1934, -1559, 1695},
                orientation =-4,
                cellId = "Uveran Ancestral Tomb"
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
            itemPicks.coinpurse,
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
                cellId = "Vivec, Guild of Mages"
            },
            {
                position = {370, -584, -761},
                orientation =-4,
                name = "Balmora",
                cellId = "Balmora, Guild of Mages"
            },
            {
                position = {695, 537, 404},
                orientation =0,
                name = "Caldera",
                cellId = "Caldera, Guild of Mages"
            },
            {
                position = {186, 542, 66},
                orientation =0,
                name = "Sadrith Mora",
                cellId = "Sadrith Mora, Wolverine Hall: Mage's Guild"
            },

            { --Akamora, Guild of Mages
                name = "Akamora",
                position = {78, -447, -382},
                orientation =-1,
                cellId = "Akamora, Guild of Mages",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },
            { --Almas Thirr, Guild of Mages
                name = "Almas Thirr",
                position = {222, -215, -62},
                orientation =-3,
                cellId = "Almas Thirr, Guild of Mages",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },


            { --Andothren, Guild of Mages
                name = "Andothren",
                position = {7847, 4297, 15203},
                orientation =0,
                cellId = "Andothren, Guild of Mages",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },


            { --Firewatch, Guild of Mages
                name = "Firewatch",
                position = {5188, 2511, 10842},
                orientation =-2,
                cellId = "Firewatch, Guild of Mages",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },


            { --Helnim, Guild of Mages
                name = "Helnim",
                position = {4730, 3631, 12660},
                orientation =2,
                cellId = "Helnim, Guild of Mages",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },


            { --Old Ebonheart, Guild of Mages
                name = "Old Ebonheart",
                position = {4295, 4496, 15234},
                orientation =2,
                cellId = "Old Ebonheart, Guild of Mages",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },
        },
        items = {
            {
                id = "bookskill_Alchemy2",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "gold_001",
                count = 25,
            },
            itemPicks.robe,
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
                cellId = "Ald-ruhn, Guild of Fighters"
            },
            {
                position = {304, 293, -377},
                orientation =0,
                name = "Balmora",
                cellId = "Balmora, Guild of Fighters"
            },
            {
                position = {306, -222, 3},
                orientation =-1,
                name = "Sadrith Mora",
                cellId = "Sadrith Mora, Wolverine Hall: Fighter's Guild"
            },
            {
                position = {179, 822, -508},
                orientation =-2,
                name = "Vivec",
                cellId = "Vivec, Guild of Fighters"
            },


            { --Akamora, Guild of Fighters
                name = "Akamora",
                position = {4431, 4280, 12674},
                orientation =-4,
                cellId = "Akamora, Guild of Fighters",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },
            { --Almas Thirr, Guild of Fighters
                name = "Almas Thirr",
                position = {4168, 4355, 14979},
                orientation =-4,
                cellId = "Almas Thirr, Guild of Fighters",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },
            { --Andothren, Guild of Fighters
                name = "Andothren",
                position = {2399, 4231, 14983},
                orientation =3,
                cellId = "Andothren, Guild of Fighters",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },
            { --Firewatch, Guild of Fighters
                name = "Firewatch",
                position = {4160, 3752, 15714},
                orientation =-2,
                cellId = "Firewatch, Guild of Fighters",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },
            { --Helnim, Guild of Fighters
                name = "Helnim",
                position = {5597, 4024, 15970},
                orientation =3,
                cellId = "Helnim, Guild of Fighters",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },
            { --Old Ebonheart, Guild of Fighters
                name = "Old Ebonheart",
                position = {3928, 324, 11714},
                orientation =1,
                cellId = "Old Ebonheart, Guild of Fighters",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },
        },
        items = {
            {
                id = "p_restore_health_s",
                count = 4,
            },
            {
                id = "gold_001",
                count = 25,
            },
        }
    },
    {
        id = "thievesGuild",
        name = "Faction: Thieves Guild",
        description = "You are a freshly recruited Toad of the Thieves Guild, hiding out with your fellow thieves at the South Wall Cornerclub in Balmora.",
        location = { --Balmora, South Wall Cornerclub
            position = {255, -21, -250},
            orientation = 0 ,
            cellId = "Balmora, South Wall Cornerclub"
        },
        items = {
            {
                id = "probe_apprentice_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "pick_apprentice_01",
                count = 2,
            },
            itemPicks.coinpurse,
        },
        onStart = function()
            local topics = {
                "join the Thieves Guild",
                "jobs",
                "advancement",
                "price on your head"
            }
            for _, topic in ipairs(topics) do
                tes3.addTopic{ topic = topic }
            end
            local thievesGuild = tes3.getFaction("Thieves Guild")
            thievesGuild.playerJoined = true
            thievesGuild.playerRank = 0
        end,
    },
    {
        id = "imperialCult",
        name = "Faction: Imperial Cult",
        description = "You are a layman of the Imperial Cult.",
        location = { --Ebonheart, Imperial Chapels
            position = {366, -638, 2},
            orientation =0,
            cellId = "Ebonheart, Imperial Chapels"
        },
        items = {
            {
                id = "bk_formygodsandemperor",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "common_robe_01",
                count = 1,
                noSlotDuplicates = true,
            },
            {
                id = "gold_001",
                count = 25,
            },
        },
        onStart = function()
            local topics = {
                "Imperial cult",
                "lay member",
                "join the Imperial Cult",
                "requirements",
                "blessings",
                "services"
            }
            for _, topic in ipairs(topics) do
                tes3.addTopic{ topic = topic }
            end
            local imperialCult = tes3.getFaction("Imperial Cult")
            imperialCult.playerJoined = true
            imperialCult.playerRank = 0
            tes3.updateJournal{ id = "IC0_ImperialCult", index = 1, showMessage = false }
            tes3.updateJournal{ id = "IC_guide", index = 2, showMessage = false }
        end,
    },
    {
        id = "imperialLegion",
        name = "Faction: Imperial Legion",
        description = "You are a recruit of the Imperial Legion, awaiting orders in Gnisis.",
        location = { --Gnisis, Madach Tradehouse
            position = {103, 1043, -894},
            orientation = 1,
            cellId = "Gnisis, Madach Tradehouse"
        },
        items = {
            {
                id = "imperial_chain_cuirass",
                count = 1,
                noDuplicates = true,
            }
        },
        onStart = function()
            local topics = {
                "join the Imperial Legion",
                "orders",
                "advancement",
                "requirements"
            }
            for _, topic in ipairs(topics) do
                tes3.addTopic{ topic = topic }
            end
            local legion = tes3.getFaction("Imperial Legion")
            legion.playerJoined = true
            legion.playerRank = 0
            tes3.equip{ reference = tes3.player, item = "imperial_chain_cuirass" }
        end,
    },
    {
        id = "moragTong",
        name = "Faction: Morag Tong",
        description = "You have been given a writ of execution by the Morag Tong. You must carry out this lawful murder in order to be accepted into the ancient guild of assassins.",
        location =     { --Vivec, Arena Hidden Area
            position = {684, 508, 2},
            orientation =3,
            cellId = "Vivec, Arena Hidden Area"
        },
        items = {
            {
                id = "writ_oran",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "sc_ondusisunhinging",
                count = 1
            },
            {
                id = "probe_apprentice_01",
                count = 1,
            },
            {
                id = "cruel viperblade",
                count = 1,
                noDuplicates = true,
            },
            {
                description = "Morag Tong Helm",
                ids = {
                    "morag_tong_helm",
                    "ab_a_moragtonghelm01",
                    "ab_a_moragtonghelm02",
                    "ab_a_moragtonghelm03",
                    "ab_a_moragtonghelm04",
                },
                count = 1,
                noDuplicates = true,
            },
            {
                id = "netch_leather_cuirass",
                count = 1,
                noSlotDuplicates = true,
            }
        },
        onStart = function()
            local topics = {
                "join the Morag Tong",
                "Feruren Oran",
                "writ",
            }
            for _, topic in ipairs(topics) do
                tes3.addTopic{ topic = topic }
            end
            local moragTong = tes3.getFaction("Morag Tong")
            moragTong.playerJoined = true
            moragTong.playerRank = 0
            tes3.updateJournal{ id = "MT_WritOran", index = 10, showMessage = false }
        end,
    },
    {
        id = "houseTelvanni",
        name = "Faction: House Telvanni",
        description = "You are a hireling of House Telvanni, waiting in attendance of the Mouths at the Council Hall in Sadrith Mora.",
        location =     { --Sadrith Mora, Telvanni Council House
            position = {47, -232, 201},
            orientation =-1,
            cellId = "Sadrith Mora, Telvanni Council House"
        },
        items = {
            itemPicks.robe,
            itemPicks.soulGems(3)
        },
        onStart = function()
            local topics = {
                "join House Telvanni",
                "chores",
                "advancement",
                "rules",
                "requirements"
            }
            for _, topic in ipairs(topics) do
                tes3.addTopic{ topic = topic }
            end
            local telvanni = tes3.getFaction("Telvanni")
            telvanni.playerJoined = true
            telvanni.playerRank = 0
        end,
    },
    {
        id = "houseHlaalu",
        name = "Faction: House Hlaalu",
        description = "You are a hireling of House Hlaalu, ready to take up your first order of business in Balmora.",
        location =     { --Balmora, Hlaalu Council Manor
            position = {-120, 655, 7},
            orientation =-4,
            cellId = "Balmora, Hlaalu Council Manor"
        },
        items = {
            {
                id = "misc_inkwell",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "misc_quill",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "sc_paper plain",
                count = 3,
            }
        },
        onStart = function()
            local topics = {
                "join House Hlaalu",
                "House Hlaalu",
                "Hlaalu councilors",
                "business",
                "advancement"
            }
            for _, topic in ipairs(topics) do
                tes3.addTopic{ topic = topic }
            end
            local hlaalu = tes3.getFaction("Hlaalu")
            hlaalu.playerJoined = true
            hlaalu.playerRank = 0
        end,
    },
    {
        id = "houseRedoran",
        name = "Faction: House Redoran",
        description = "You are a hireling of House Redoran, waiting in attendance of the Councilors at the Redoran Council Hall in Ald'ruhn.",
        location = { --Ald-ruhn, Redoran Council Entrance
            position = {749, 763, -126},
            orientation =0,
            cellId = "Ald-ruhn, Redoran Council Entrance"
        },
        items = {
            {
                id = "bonemold_gah-julan_helm",
                count = 1,
                noSlotDuplicates = true,
            }
        },
        onStart = function()
            local topics = {
                "join House Redoran",
                "duties",
                "advancement"
            }
            for _, topic in ipairs(topics) do
                tes3.addTopic{ topic = topic }
            end
            local redoran = tes3.getFaction("Redoran")
            redoran.playerJoined = true
            redoran.playerRank = 0
        end,
    },
    {
        id = "ashlander",
        name = "Ashlander",
        description = "You live with a small group of Ashlanders in a yurt on the plains of the West Gash.",
        location = { --Massahanud Camp, Sargon's Yurt
            position = {4256, 4014, 15698},
            orientation =-1,
            cellId = "Massahanud Camp, Sargon's Yurt"
        },
        items = {
            {
                id = "ingred_wickwheat_01",
                count = 3,
            },
            {
                id = "ingred_hackle-lo_leaf_01",
                count = 2,
            },
            {
                id = "ashfall_tent_ashl_m",
                noDuplicates = true,
            },
        },
        onStart = function (self)
            --Add disposition to nearby Ashlanders
            local friends = {
                "manabi kummimmidan",
                "yahaz ashurnasaddas",
                "sargon santumatus",
                "teshmus assebiriddan"
            }
            for _, id in ipairs(friends) do
                local friendRef = tes3.getReference(id)
                if friendRef then
                    if tes3.modDisposition then
                        tes3.modDisposition{
                            reference = friendRef,
                            value = 40
                        }
                    end
                end
            end
            --Find the nearest active_de_bedroll and remove ownership
            local closetBedroll = nil
            local closestDistance = 999999
            for ref in tes3.player.cell:iterateReferences(tes3.objectType.activator) do
                if ref.object.id == "active_de_bedroll" then
                    local distance = tes3.player.position:distance(ref.position)
                    if distance < closestDistance then
                        closetBedroll = ref
                        closestDistance = distance
                    end
                end
            end
            if closetBedroll then
                mwse.log("Removing ownership from bedroll")
                closetBedroll.itemData.owner = nil
                closetBedroll.modified = true
            end
        end
    },
    {
        id = "lumberjack",
        name = "Lumberjack",
        description = "You are gathering firewood in the wilderness.",
        location = {
            position = {38154, -53328, 931},
            orientation = 268,
            cellId = "4,-7"
        },
        items = {
            itemPicks.axe,
            {
                id = "ashfall_firewood",
                count = 4
            },
            {
                id = "gold_001",
                count = 25,
            },
        },
    },
    {
        id = "prisoner",
        name = "Imprisoned",
        description = "You are imprisoned in the Vivec Hlaalu Prison.",
        location = {
            position = {274, -214, -100},
            orientation = 0,
            cellId = "Vivec, Hlaalu Prison Cells"
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
                cellId = "Neglected Shipwreck, Cabin",
                requirements = requiresOaabShipwreck,
            },
            {  --prelude shipwreck - OAAB
                name = "Prelude Shipwreck",
                position = {4170, 4245, 63},
                orientation = -3,
                cellId = "Prelude Shipwreck, Cabin",
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
                cellId = "Abandoned Shipwreck, Cabin"
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
                position = {127322, 94621, -50},
                orientation = 2,
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
                cellId = "Strange Shipwreck, Cabin"
            },
            { -- unchartered shipwreck - Vanilla
                name= "Unchartered Shipwreck",
                position = {4221, 4034, 15466},
                orientation =-1,
                requirements = excludesOaabShipwreck,
                cellId = "Unchartered Shipwreck, Cabin"
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
            itemPicks.booze(4),
            itemPicks.coinpurse,
            {
                id = "t_com_compass_01",
                count = 1,
                noDuplicates = true,
            }
        }
    },
    {
        id = "khuulCamping",
        name = "Camping",
        description = "You are camping out in the wilderness.",
        locations = {
            {
                position = {-78170, 143029, 427},
                orientation = 349,
            },
        },
        items = {
            {
                description = "Cooking Pot",
                ids = cookingPots
            },
            {
                id = "ashfall_firewood",
                count = 4
            },
            {
                id = "ashfall_tent_base_m",
                noDuplicates = true,
            },
            itemPicks.axe,
            {
                id = "ingred_hound_meat_01",
                count = 3
            },
            {
                id = "ashfall_flintsteel"
            },
            itemPicks.coinpurse,
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
                cellId = "Maar Gan, Andus Tradehouse"
            },
            { --Gnisis, Madach Tradehouse
                position = {-57, 280, -125},
                orientation =-2,
                cellId = "Gnisis, Madach Tradehouse"
            },
            { --Suran, Suran Tradehouse
                position = {4, 240, 519},
                orientation =0,
                cellId = "Suran, Suran Tradehouse"
            },
            { --Bodrum, Varalaryn Tradehouse
                position = {413, -1613, -379},
                orientation =0,
                cellId = "Bodrum, Varalaryn Tradehouse",
                requirements = {
                    plugins = { "TR_Mainland.esm" }
                }
            },
        },
        items = {
            itemPicks.coinpurse,
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
            itemPicks.coinpurse,
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
            cellId = "Suran, Desele's House of Earthly Delights"
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
            {
                id = "gold_001",
                count = 50,
            },
        },
        time = 18,
    },
    {
        id = "fishing",
        name = "Fishing",
        description = "You are a humble fisherman, casting your line into the waters of Morrowind.",
        locations = {
            { --Hla Oad
                name = "Hla Oad",
                position = {-48464, -38956, 211},
                orientation =-2,
            },
            {
                name = "Dragonhead Point",
                position = {330424, -29432, 784},
                orientation = 0,
                requirements = {
                    plugins = {"TR_Mainland.esm"},
                },
            },
            { --Seyda Neen Outskirts
                name = "Seyda Neen Outskirts",
                position = {39, -76175, 113},
                orientation =-2,
            },
            { --South of Ald Velothi
                name = "South of Ald Velothi",
                position = {-74003, 106003, 37},
                orientation =0,
            },
            { --Azura's Coast
                name = "Azura's Coast",
                position = {142783, -54841, 26},
                orientation =-2,
            },
        },
        items = {
            itemPicks.fishingPole,
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
                count = 15
            },
            {
                id = "mer_bug_spinner2",
                count = 1,
                noDuplicates = true,
            },
            itemPicks.fishMeat(3),
            itemPicks.knife,
        },
        time = 17,
    },
    {
        id = "eggFarmer",
        name = "Egg Farmer",
        description = "You are farming Kwama Eggs in the Shulk Egg Mine.",
        location = {
            position = {4457, 3423, 12612},
            orientation = 0,
            cellId = "Shulk Egg Mine, Mining Camp"
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
            },
            {
                id = "gold_001",
                count = 20,
            },
        }
    },
    {
        id = "hauntedRoom",
        name = "Haunted Room",
        description = "You are sleeping in a haunted room at the Gateway Inn in Sadrith Mora.",
        location = {
            position = {-219, -159, 276},
            orientation = 0,
            cellId = "Sadrith Mora, Gateway Inn: South Wing"
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
        time = 19,
        onStart = function(self)
            tes3.messageBox("You are awakened by a noise from the other room.")
        end
    },
    {
        id = "bard",
        name = "Performer",
        description = "You are a bard performing in a tavern",
        locations = {
            { --Ald-ruhn, Ald Skar Inn
                position = {556, -1140, 2},
                orientation =-3,
                cellId = "Ald-ruhn, Ald Skar Inn"
            },
            { --Balmora, Lucky Lockup
                position = {190, 1244, -505},
                orientation =-3,
                cellId = "Balmora, Lucky Lockup"
            },
            { --Caldera, Shenk's Shovel
                position = {254, -299, 130},
                orientation =-1,
                cellId = "Caldera, Shenk's Shovel"
            },
            { --Dagon Fel, The End of the World
                position = {-111, 330, 386},
                orientation =-2,
                cellId = "Dagon Fel, The End of the World"
            },
            { --Ebonheart, Six Fishes
                position = {202, 565, 2},
                orientation =-4,
                cellId = "Ebonheart, Six Fishes"
            },
            { --Gnisis, Madach Tradehouse
                position = {24, 646, -126},
                orientation =-4,
                cellId = "Gnisis, Madach Tradehouse"
            },
            { --Maar Gan, Andus Tradehouse
                position = {186, 33, 2},
                orientation =-1,
                cellId = "Maar Gan, Andus Tradehouse"
            },
            { --Molag Mar, The Pilgrim's Rest
                position = {-508, -375, 2},
                orientation =-1,
                cellId = "Molag Mar, The Pilgrim's Rest"
            },
            {  --Pelagiad
                position = {407, 236, 105},
                orientation = 0,
                cellId = "Pelagiad, Halfway Tavern"
            },
            { --Sadrith Mora, Gateway Inn
                position = {4009, 4318, 766},
                orientation =0,
                cellId = "Sadrith Mora, Gateway Inn"
            },
            { --Suran, Desele's House of Earthly Delights
                position = {324, -247, 7},
                orientation =-2,
                cellId = "Suran, Desele's House of Earthly Delights"
            },
            { --Tel Mora, The Covenant
                position = {1315, -364, 606},
                orientation =0,
                cellId = "Tel Mora, The Covenant"
            },
            { --Vivec, The Lizard's Head
                position = {-231, -9, -126},
                orientation =1,
                cellId = "Vivec, The Lizard's Head"
            },

            --TR
            { --Aimrah, The Sailors' Inn
                position = {3768, 3434, 14681},
                orientation =-1,
                cellId = "Aimrah, The Sailors' Inn"
            },

            { --Hunted Hound Inn
                position = {4206, 3500, 15554},
                orientation =-2,
                cellId = "Hunted Hound Inn"
            },


            { --The Inn Between
                position = {3838, 4137, 14466},
                orientation =0,
                cellId = "The Inn Between"
            },


            { --Akamora, The Laughing Goblin
                position = {3059, 3518, 130},
                orientation =1,
                cellId = "Akamora, The Laughing Goblin"
            },


            { --Almas Thirr, Limping Scrib
                position = {654, -543, 2},
                orientation =-1,
                cellId = "Almas Thirr, Limping Scrib"
            },


            { --Andothren, The Dancing Cup
                position = {4306, 4122, 13959},
                orientation =1,
                cellId = "Andothren, The Dancing Cup"
            },


            { --Bodrum, Varalaryn Tradehouse
                position = {831, -1390, -382},
                orientation =-3,
                cellId = "Bodrum, Varalaryn Tradehouse"
            },


            { --Bosmora, The Starlight Inn
                position = {4095, 5119, 15558},
                orientation =3,
                cellId = "Bosmora, The Starlight Inn"
            },


            { --Firewatch, The Queen's Cutlass
                position = {6271, 3678, 16258},
                orientation =0,
                cellId = "Firewatch, The Queen's Cutlass"
            },


            { --Helnim, The Red Drake
                position = {4465, 4135, 14850},
                orientation =-2,
                cellId = "Helnim, The Red Drake"
            },


            { --Necrom, Pilgrim's Respite
                position = {3692, 2306, 12162},
                orientation =1,
                cellId = "Necrom, Pilgrim's Respite"
            },


            { --Old Ebonheart, The Moth and Tiger
                position = {-809, 387, 2},
                orientation =1,
                cellId = "Old Ebonheart, The Moth and Tiger"
            },


            { --Port Telvannis, The Lost Crab Tavern
                position = {3934, 4538, 14114},
                orientation =-4,
                cellId = "Port Telvannis, The Lost Crab Tavern"
            },


            { --Ranyon-ruhn, The Dancing Jug
                position = {4263, 4003, 15170},
                orientation =-1,
                cellId = "Ranyon-ruhn, The Dancing Jug"
            },


            { --Sailen, The Toiling Guar
                position = {3298, 3754, 11266},
                orientation =1,
                cellId = "Sailen, The Toiling Guar"
            },


            { --Tel Ouada, The Magic Mudcrab
                position = {-749, -956, -510},
                orientation =-1,
                cellId = "Tel Ouada, The Magic Mudcrab"
            },


            { --Vhul, The Howling Hound
                position = {3639, 3889, 15554},
                orientation =0,
                cellId = "Vhul, The Howling Hound"
            },


        },
        items = {
            {
                id = "bk_redbookofriddles",
                count = 1,
                noDuplicates = true,
            },
            itemPicks.lute,
            {
                id = "misc_de_drum_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "gold_001",
                count = 45
            },
            {id = "expensive_pants_03", noDuplicates = true},
            {id = "extravagant_shirt_02", noDuplicates = true},
            {id = "expensive_shoes_02", noDuplicates = true},
        },
        time = 17,
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
    {
        id = "necromancer",
        name = "Necromancer's Apprentice",
        description = "You are an apprentice studying the dark arts of necromancy in a secluded cave.",
        locations = {
            { --Yesamsi
                position = {-930, -405, 272},
                orientation =0,
                cellId = "Yesamsi"
            },
        },
        items = {
            {
                id = "sc_summonskeletalservant",
                count = 3
            },
            {
                id = "sc_summonflameatronach",
                count = 3
            },
            {
                id = "ab_c_commonhoodblack",
                pickMethod = "firstValid",
                count = 1,
            },
            {
                description = "Robe",
                ids = {
                    "ab_c_commonrobeblack",
                    "common_robe_01",
                },
                pickMethod = "firstValid",
                count = 1,
            },
        },
        time = 18,
        spells = {
            { id = "summon scamp" }
        },
        onStart = function ()
            --pacify creatures and NPCs
            for ref in tes3.player.cell:iterateReferences(tes3.objectType.creature) do
                if ref.mobile ~= nil then
                    mwse.log("Pacifying creature %s", ref.object.name)
                    ref.mobile.fight = 0
                end
            end
            for ref in tes3.player.cell:iterateReferences(tes3.objectType.npc) do
                if ref.mobile ~= nil then
                    mwse.log("Pacifying NPC %s", ref.object.name)
                    ref.mobile.fight = 0
                end
            end
        end
    },
    {
        id = "skoomaAddict",
        name = "Skooma Addict",
        description = "You are a skooma addict, spending an evening in the Suran Tradehouse. With only one bottle of skooma left, you need to find your next fix.",
        location = { --Suran, Suran Tradehouse
            position = {101, 543, 519},
            orientation =3,
            cellId = "Suran, Suran Tradehouse"
        },
        items = {
            {
                id = "apparatus_a_spipe_01",
                count = 1,
                noDuplicates = true,
            },
            {
                id = "ingred_moon_sugar_01",
                count = 3
            },
            {
                id = "potion_skooma_01",
                count = 1
            },
        },
        time = 21,
        onStart = function()
            timer.delayOneFrame(function()
                tes3.equip{
                    item = "potion_skooma_01",
                    reference = tes3.player,
                }
            end)
        end
    },
    {
        id = "library",
        name = "Studying in the Library",
        description = "You are immersed in study at the Library of Vivec, surrounded by ancient tomes and scrolls.",
        location = { --Vivec, Library of Vivec
            position = {-509, 1713, -126},
            orientation = 1.5,
            cellId = "Vivec, Library of Vivec"
        },
        items = {
            {
                id = "bk_BriefHistoryEmpire3",
                noDuplicates = true,
            },
            {
                id = "common_robe_03_a",
                noSlotDuplicates = true,
            },
            {
                id = "gold_001",
                count = 50
            },
        },
    },
    {
        id = "lostInAshlands",
        name = "Lost in the Ashlands",
        description = "A sudden ash storm has left you disoriented and lost in the Ashlands.",
        location =  { --Ashlands
            position = {5173, 129314, 801},
            orientation = 2.41,
        },
        items = {
            {
                id = "torch",
                noDuplicates = true,
            },
            itemPicks.coinpurse,
            { --robe
                id = "common_robe_01",
                noSlotDuplicates = true,
            },
            { --hood
                id = "ab_c_commonhoodblack",
                noSlotDuplicates = true,
            },
            --Some ashfall gear
            {
                id = "ashfall_firewood",
                count = 3
            },
            {
                id = "ashfall_tent_base_m",
                noDuplicates = true,
            },
            {
                id = "ashfall_flintsteel"
            },
            {
                id = "ashfall_woodaxe_steel",
                noSlotDuplicates = true,
            },
            {
                id = "ashfall_waterskin",
                noDuplicates = true,
                data = {
                    waterAmount = 30
                }
            }
        },
        weather = tes3.weather.ash,
        time = 20,
    }
}


for _, scenario in ipairs(scenarios) do
    Scenario:register(scenario)
end

