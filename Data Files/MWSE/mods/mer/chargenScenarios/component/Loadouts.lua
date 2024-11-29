local common = require("mer.chargenScenarios.common")
local logger = common.createLogger("Loadout")
local ItemList = require("mer.chargenScenarios.component.ItemList")

---@class ChargenScenarios.Loadouts
local Loadouts = {
    ---@type table<string, fun():ChargenScenariosItemList>
    registeredLoadouts = {}
}

---@param e { id: string, callback: fun():ChargenScenariosItemList }
function Loadouts.register(e)
    logger:debug("Registering loadout %s", e.id)
    Loadouts.registeredLoadouts[e.id] = function()
        return e.callback()
    end
end

---Get a loadout by id
---@param id string
---@return ChargenScenariosItemList?
function Loadouts.get(id)
    return Loadouts.registeredLoadouts[id]()
end

---@return ChargenScenariosItemList[]
function Loadouts.getLoadouts()
    logger:debug("Getting loadouts")
    local loadouts = {}
    for _, callback in pairs(Loadouts.registeredLoadouts) do
        table.insert(loadouts, callback())
    end
    logger:debug("- Returned %s loadouts", #loadouts)
    return loadouts
end

function Loadouts.doItems()
    logger:debug("Adding loadout items")
    local loadouts = Loadouts.getLoadouts()
    for _, itemList in ipairs(loadouts) do
        itemList:doItems()
    end
    logger:debug("Added loadout items")
end


local function playerRaceCanEquip(item)
    if tes3.player.object.race.isBeast then
        return item.isUsableByBeasts ~= false
    else
        return true
    end
end

---@param item ChargenScenarios.ItemPickItem
local function isEquippableType(item)
    return item.objectType == tes3.objectType.armor
        or item.objectType == tes3.objectType.clothing
        or item.objectType == tes3.objectType.weapon
end

---@param item ChargenScenarios.ItemPickItem
local function playerCanEquip(item)
    return isEquippableType(item)
        and playerRaceCanEquip(item)
end

---@param armor tes3armor
local function getArmorValue(armor)
    return armor.armorRating
end

---@param item ChargenScenarios.ItemPickItem
local function getOtherValue(item)
    return item.value
end

local function getWeaponValue(weapon)
    return weapon.chopMax + weapon.slashMax + weapon.thrustMax
end

function Loadouts.getBestItemInSlot(targetItemType, slot)
    local bestItem = nil
    local bestValue = 0
    for _, stack in pairs(tes3.player.object.inventory) do
        local validSlot = slot == nil or stack.object.slot == slot
        if validSlot then
            local itemType = stack.object.objectType
            if itemType == targetItemType then
                local value = 0
                if itemType == tes3.objectType.armor then
                    value = getArmorValue(stack.object)
                elseif itemType == tes3.objectType.weapon then
                    value = getWeaponValue(stack.object)
                else
                    value = getOtherValue(stack.object)
                end
                if value > bestValue then
                    bestItem = stack.object
                    bestValue = value
                end
            end
        end
    end
    return bestItem
end

function Loadouts.equipBestItemForEachSlot()
    logger:debug("Equipping best item for each slot")
    --armor
    for _, slot in pairs(tes3.armorSlot) do
        local item = Loadouts.getBestItemInSlot(tes3.objectType.armor, slot)
        if item then
            if playerCanEquip(item) then
                logger:debug("Equipping best armor %s to player", item.id)
                tes3.equip{
                    item = item,
                    reference = tes3.player,
                }
            else
                logger:debug("Beast - cannot equip best armor %s", item.id)
            end
        end
    end
    --clothing
    for _, slot in pairs(tes3.clothingSlot) do
        local item = Loadouts.getBestItemInSlot(tes3.objectType.clothing, slot)
        if item then
            if playerCanEquip(item) then
                logger:debug("Equipping best armor %s to player", item.id)
                tes3.equip{
                    item = item,
                    reference = tes3.player,
                }
            else
                logger:debug("Beast - cannot equip best armor %s", item.id)
            end
        end
    end
    --weapon
    local item = Loadouts.getBestItemInSlot(tes3.objectType.weapon)
    if item then
        logger:debug("Equipping best weapon %s to player", item.id)
        tes3.equip{
            item = item,
            reference = tes3.player,
        }
    end
end

function Loadouts.addAndEquipCommonClothing()
    logger:debug("Adding and equipping common clothing")
    local items = {
        {
            id = "common_pants_01",
            objectType = tes3.objectType.clothing,
            slot = tes3.clothingSlot.pants,
        },
        {
            id = "common_shoes_01",
            objectType = tes3.objectType.clothing,
            slot = tes3.clothingSlot.shoes,
            alt = {
                objectType = tes3.objectType.armor,
                slot = tes3.armorSlot.boots
            }
        },
        {
            id = "common_shirt_01",
            objectType = tes3.objectType.clothing,
            slot = tes3.clothingSlot.shirt,
        }
    }

    for _, item in ipairs(items) do
        local hasItem = tes3.getEquippedItem{
            actor = tes3.player,
            objectType = item.objectType,
            slot = item.slot
        }
        if not hasItem and item.alt then
            hasItem = tes3.getEquippedItem{
                actor = tes3.player,
                objectType = item.alt.objectType,
                slot = item.alt.slot
            }
        end

        if not hasItem then
            local item = tes3.getObject(item.id)
            local canEquip = true
            if tes3.player.object.race.isBeast then
                canEquip = item.isUsableByBeasts ~= false
                logger:debug("Beast - can equip %s: %s", item.id, canEquip)
            end
            if canEquip then
                logger:debug("Equipping deafult %s to player", item.id)
                tes3.addItem{
                    reference = tes3.player,
                    item = item.id
                }
                tes3.equip{
                    item = item,
                    reference = tes3.player,
                }
            else
                logger:debug("Beast - cannot equip deafult %s", item.id)
            end
        end
    end
end

return Loadouts