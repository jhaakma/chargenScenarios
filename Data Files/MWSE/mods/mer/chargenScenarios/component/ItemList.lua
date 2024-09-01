local common = require("mer.chargenScenarios.common")
local ItemPick = require("mer.chargenScenarios.component.ItemPick")
local Validator = require("mer.chargenScenarios.util.validator")

---@class ChargenScenariosItemList
---@field items table<number, ChargenScenariosItemPick> @the list of items to add to the player's inventory
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
    Validator.validate(itemList, self.schema)
    ---Build
    itemList.items = common.convertListTypes(itemList.items, ItemPick)
    setmetatable(itemList, self)
    self.__index = self
    return itemList
end

function ItemList:doItems()
    if self.items and table.size(self.items) > 0 then
        mwse.log("Doing items")
        for _, itemPick in ipairs(self.items) do
            if itemPick:checkRequirements() then
                mwse.log("requirements met, adding to inventory")
                itemPick:giveToPlayer()
            end
        end
        return true
    else
        return false
    end
end

return ItemList
