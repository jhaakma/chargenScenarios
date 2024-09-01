---@class ChargenScenariosItemPickInput
---@field id? string The id of the item
---@field ids? table<number, string> The ids of multiple items. If this is used instead of 'id', one will be chosen at random.
---@field alternative? string The item id to use if none of the ids are valid
---@field count? number The number of items to add. Default is 1
---@field requirements? ChargenScenariosRequirementsInput The requirements for the item
---@field noDuplicates? boolean If true, the same item will not be added if it is already in the player's inventory


local common = require("mer.chargenScenarios.common")
local logger = common.createLogger("ItemPick")
local Requirements = require("mer.chargenScenarios.component.Requirements")
local Validator = require("mer.chargenScenarios.util.validator")
--[[
    For specific items, use "id"
    To pick a random item from a list, use "ids"
]]

---@class ChargenScenariosItemPick
---@field ids table<number, string> the list of item ids the item pick is chosen from
---@field alternative? string the item id to use if none of the ids are valid
---@field count number the number of items to add to the player's inventory
---@field requirements? ChargenScenariosRequirements the requirements for the item pick
---@field noDuplicates? boolean if true, the same item will not be added if it is already in the player's inventory
local ItemPick = {
    schema = {
        name = "ItemPick",
        fields = {
            id = { type = "string", required = false },
            ids = { type = "table", childType = "string", required = false },
            count = { type = "number", default = 1, required = false },
            requirements = { type = Requirements.schema, required = false },
        }
    }
}

--Constructor
---@param data ChargenScenariosItemPickInput
---@return ChargenScenariosItemPick?
function ItemPick:new(data)
    if not data then return nil end
    ---Validate
    Validator.validate(data, self.schema)
    assert(data.id or data.ids, "ItemPick must have either an id or ids")
    local itemPick = {
        ids = data.id and {data.id} or data.ids,
        alternative = data.alternative,
        count = data.count or 1,
        requirements = data.requirements and Requirements:new(data.requirements),
        noDuplicates = data.noDuplicates
    }

    --go through ids and remove any where the object doesn't exist
    for i, id in ipairs(itemPick.ids) do
        if not tes3.getObject(id) then
            table.remove(itemPick.ids, i)
        end
    end
    if #itemPick.ids == 0 then
        return nil
    end

    ---Create ItemPick
    setmetatable(itemPick, self)
    self.__index = self
    return itemPick
end

---@return tes3object|tes3misc|tes3clothing|tes3armor|nil
function ItemPick:pick()
    if not self:checkRequirements() then
        return nil
    end
    --Find which items exist
    local validItems = {}
    for _, id in ipairs(self.ids) do
        local item = tes3.getObject(id)
        if item then
            table.insert(validItems, item)
        end
    end
    if #validItems == 0 then
        --try alternative
        if self.alternative then
            local item = tes3.getObject(self.alternative)
            if item then
                return item
            end
        end
        logger:debug("No valid items to pick from")
        return nil
    end

    --Pick an item
    local item
    if self.ids then
        while item == nil do
            item = table.choice(validItems)
        end
    end
    return item
end


function ItemPick:giveToPlayer()
    local addedItems = {}
    local added = 0
    while added < (self.count or 1) do
        local pickedItem = self:pick()
        if not pickedItem then
            logger:debug("No valid items to pick from")
            break
        end
        logger:debug("Picked Item: %s", pickedItem)
        table.insert(addedItems, pickedItem)

        if self.noDuplicates and tes3.player.object.inventory:contains(pickedItem) then
            logger:debug("Player already has item, skipping")
        else
            tes3.addItem{
                reference = tes3.player,
                item = pickedItem,
                count = 1,
                playSound = false,
            }
            if pickedItem.enchantCapacity then
                local isBoots = pickedItem.objectType == tes3.objectType.armor and pickedItem.slot == tes3.armorSlot.boots
                local isShoes = pickedItem.objectType == tes3.objectType.clothing and pickedItem.slot == tes3.clothingSlot.shoes
                local isHelmet = pickedItem.objectType == tes3.objectType.armor and pickedItem.slot == tes3.armorSlot.helmet
                local blockBeast = tes3.player.object.race.isBeast and (isBoots or isShoes or isHelmet)
                if not blockBeast then
                    tes3.equip{
                        item = pickedItem,
                        reference = tes3.player,
                        playSound = false,
                    }
                end
            end
        end
        added = added + 1
    end
    return addedItems
end

function ItemPick:checkRequirements()
    if self.requirements and not self.requirements:check() then
        return false
    end
    return true
end

return ItemPick