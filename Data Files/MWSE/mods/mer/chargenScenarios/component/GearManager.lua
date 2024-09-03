local common = require("mer.chargenScenarios.common")
local logger = common.createLogger("GearManager")

---@class (exact) ChargenScenarios.GearManager
---@field gearLists table<string, string[]> Lists of starter gear that can be used in conjunction with ItemPick.pickBestForClass
---@field getBestItemForClass fun(itemIds: string[]): tes3object? Get the best item for the player's class from a list of item ids
local GearManager = {}

GearManager.gearLists = {
    boots = {
        "netch_leather_boots", --light
        "BM bear boots", --medium
        "iron boots", --heavy
    },
    cuirass = {
        "netch_leather_cuirass", --light
        "nordic_ringmail_cuirass", --medium
        "iron_cuirass", --heavy
    },
    leftGauntlet = {
        "netch_leather_gauntlet_left", --light
        "bm bear left gauntlet", --medium
        "iron_gauntlet_left", --heavy
    },
    rightGauntlet = {
        "netch_leather_gauntlet_right", --light
        "BM bear right gauntlet", --medium
        "iron_gauntlet_right", --heavy
    },
    greaves = {
        "netch_leather_greaves", --light
        "imperial_chain_greaves", --medium
        "iron_greaves", --heavy
    },
    leftPauldron = {
        "netch_leather_pauldron_left", --light
        "BM Bear left Pauldron", --medium
        "iron_pauldron_left", --heavy
    },
    rightPauldron = {
        "netch_leather_pauldron_right", --light
        "BM Bear right Pauldron", --medium
        "iron_pauldron_right", --heavy
    },
    helm = {
        "netch_leather_helm", --light
        "imperial_chain_coif_helm", --medium
        "iron_helmet", --heavy
    },
    shield = {
        "netch_leather_shield", --light
        "BM bear shield", --medium
        "iron_shield", --heavy
    },
    weapon = {
        "iron tanto", --short blade
        "AB_w_IronRapier", --long blade
        "AB_w_ChitinHalberd", --spear
        "iron war axe", --axe
        "AB_w_ChitinMace", --blunt
        "chitin short bow", --marksman
    },
    --Some random clothing lists
    hood = {
        "AB_c_CommonHood01",
        "AB_c_CommonHood02",
        "AB_c_CommonHood02h",
        "AB_c_CommonHood03a",
        "AB_c_CommonHoodBlack"
    },
    robe = {
        "common_robe_02",
        "common_robe_03",
        "common_robe_04",
        "common_robe_05",
        "common_robe_05_a",
        "common_robe_05_b",
        "common_robe_05_c",
    }
}


local armorRatingToSkillMapping = {
    [tes3.armorWeightClass.light] = tes3.skill.lightArmor,
    [tes3.armorWeightClass.medium] = tes3.skill.mediumArmor,
    [tes3.armorWeightClass.heavy] = tes3.skill.heavyArmor,
}

---@param item tes3weapon|tes3armor|tes3item
local function getSkillForItem(item)
    if item.objectType == tes3.objectType.weapon then
        return item.skill.id
    elseif item.objectType == tes3.objectType.armor then
        return armorRatingToSkillMapping[item.weightClass]
            or tes3.skill.unarmored
    end
end

---@param itemIds tes3item[]
---@return tes3object?
function GearManager.getBestItemForClass(itemIds)

    ---Matches major skill = 2 points
    ---Matches minor skill = 1 point
    local class = tes3.player.object.class
    logger:debug("Picking item for class %s", class.name)

    local majorItems = {}
    local minorItems = {}
    local miscItems = {}

    local majorSkills = table.invert(class.majorSkills)
    local minorSkills = table.invert(class.minorSkills)
    for _, item in ipairs(itemIds) do

        --get relevant skill
        local skill = getSkillForItem(item)
        logger:debug(" - Item: %s, skill: %s", item and item.id or "nil", skill or "nil")

        --Insert into appropriate list
        if skill and majorSkills[skill] then
            table.insert(majorItems, item)
        elseif skill and minorSkills[skill] then
            table.insert(minorItems, item)
        else
            table.insert(miscItems, item)
        end
    end

    --Pick from best list
    local choice
    if #majorItems > 0 then
        logger:debug("Found major skills")
        choice =  table.choice(majorItems)
    elseif #minorItems > 0 then
        logger:debug("Found minor skills")
        choice = table.choice(minorItems)
    elseif #miscItems > 0 then
        choice = table.choice(miscItems)
    end
    logger:debug("Picked %s for class %s", choice and choice.id or "nothing", class.name)
    return choice
end


return GearManager