---@class ChargenScenariosItemList
---@field new function @constructor
---@field addItems function @Resolves each itemPick and adds it to the player's inventory
---@field items table<number, ChargenScenariosItemPick> @the list of items to add to the player's inventory

local common = require("mer.chargenScenarios.common")
local ItemPick = require("mer.chargenScenarios.class.ItemPick")
--[[
    For specific items, use "id"
    To pick a random item from a list, use "ids"
]]

---@type ChargenScenariosItemList
local ItemList = {
    schema = {
        name = "ItemList",
        fields = {
            items = { type = "table", childType = ItemPick.schema, required = true },
        }
    }
}

--Constructor
---@param data table<number, ChargenScenariosItemPickInput>
---@return ChargenScenariosItemList
function ItemList:new(data)
    local itemList = {items = table.deepcopy(data)}
    ---validate
    common.validator.validate(itemList, self.schema)
    ---Build
    itemList.items = common.convertListTypes(itemList.items, ItemPick)
    setmetatable(itemList, self)
    self.__index = self
    return itemList
end

function ItemList:addItems()
    if self.items and #self.items > 0 then
        for _, item in ipairs(self.items) do
            if item:checkRequirements() then
                item:giveToPlayer()
            end
        end
        return true
    else
        return false
    end
end

return ItemList
