---@class ChargenScenariosItemPickInput
---@field id string @The id of the item
---@field ids table<number, string> @The ids of multiple items. If this is used instead of 'id', one will be chosen at random.
---@field count number @The number of items to add
---@field requirements ChargenScenariosRequirementsInput @The requirements for the item


---@class ChargenScenariosItemPick
---@field new function @constructor
---@field pick function @returns a random item from the list
---@field checkRequirements function @returns true if the requirements are met, false otherwise
---@field ids table<number, string> @the list of item ids the item pick is chosen from
---@field count number @the number of items to add to the player's inventory
---@field requirements ChargenScenariosRequirements @the requirements for the item pick

local common = require("mer.chargenScenarios.common")
local Requirements = require("mer.chargenScenarios.component.Requirements")
--[[
    For specific items, use "id"
    To pick a random item from a list, use "ids"
]]

---@type ChargenScenariosItemPick
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
---@return ChargenScenariosItemPick
function ItemPick:new(data)
    if not data then return nil end
    local itemPick = table.deepcopy(data)
    ---Validate
    common.validator.validate(data, self.schema)
    assert(itemPick.id or itemPick.ids, "ItemPick must have either an id or ids")
    --Build
    if not itemPick.ids then
        itemPick.ids = { itemPick.id }
    end
    if itemPick.id then
        table.insert(itemPick.ids, itemPick.id)
        itemPick.id = nil
    end
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

---@return tes3reference|nil
function ItemPick:pick()
    local item
    if not self:checkRequirements() then
        return nil
    elseif self.ids then
        while not item do
            item = tes3.getObject(table.choice(self.ids))
        end
    end
    return item
end

function ItemPick:giveToPlayer()
    local addedItems = {}
    local added = 0
    while added < (self.count or 1) do
        local pickedItem = self:pick()
        if pickedItem then
            mwse.log("Picked Item: %s", pickedItem)
            table.insert(addedItems, pickedItem)
            tes3.addItem{
                reference = tes3.player,
                item = pickedItem,
                count = 1,
            }
            added = added + 1
        end
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