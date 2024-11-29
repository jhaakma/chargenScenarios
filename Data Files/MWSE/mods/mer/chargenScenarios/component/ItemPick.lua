---@class (exact) ChargenScenariosItemPickInput
---@field description? string A description of the item. Required if using multiple ids
---@field id? string The id of the item
---@field ids? table<number, string> The ids of multiple items. If this is used instead of 'id', one will be chosen at random.
---@field alternative? string The item id to use if none of the ids are valid
---@field count? number The number of items to add. Only useful for random pick methods. Default is 1
---@field requirements? ChargenScenariosRequirementsInput The requirements for the item
---@field noDuplicates? boolean If true, the same item will not be added if it is already in the player's inventory
---@field noSlotDuplicates? boolean If true, the same item will not be added if an item of the same type is already in the player's inventory
---@field pickMethod? ChargenScenarios.ItemPickMethod The method for picking an item. Default is 'random'

---@alias ChargenScenarios.ItemPickItem tes3object|tes3misc|tes3clothing|tes3armor|tes3weapon
---@alias ChargenScenarios.ItemPickMethod
---|'random' #Pick a random item from the list
---|'bestForClass' #Pick the best item for the player's class
---|'bestForGenderRandom' #Picks random pants/skirt depending on gender
---|'bestForGenderFirst' #Picks first pants/skirt depending on gender
---|'firstValid' #Pick the first valid item. If count is > 1, the same item will be added multiple times
---|'all' #Add all valid items. If count is > 1, all items will be added multiple times

local common = require("mer.chargenScenarios.common")
local logger = common.createLogger("ItemPick")
local Requirements = require("mer.chargenScenarios.component.Requirements")
local Validator = require("mer.chargenScenarios.util.validator")
local GearManager = require("mer.chargenScenarios.component.GearManager")

---@class ChargenScenariosItemPick : ChargenScenariosItemPickInput
---@field id nil
---@field ids table<number, string> the list of item ids the item pick is chosen from
---@field resolvedItems? table<ChargenScenarios.ItemPickItem, number> the resolved items and their counts
---@field count number the number of items to add to the player's inventory
---@field requirements? ChargenScenariosRequirements the requirements for the item pick
local ItemPick = {
    schema = {
        name = "ItemPick",
        fields = {
            id = { type = "string", required = false },
            ids = { type = "table", childType = "string", required = false },
            count = { type = "number", default = 1, required = false },
            requirements = { type = Requirements.schema, required = false },
            noDuplicates = { type = "boolean", required = false },
            noSlotDuplicates = { type = "boolean", required = false },
            pickMethod = { type = "string", required = false },
        }
    }
}

---@type table<ChargenScenarios.ItemPickMethod, fun(items: ChargenScenarios.ItemPickItem[]): ChargenScenarios.ItemPickItem[] >
ItemPick.pickMethods = {
    random = function(items)
        local choice = table.choice(items)
        return { choice }
    end,
    bestForClass = function(items)
        local choice = GearManager.getBestItemForClass(items)
        return { choice }
    end,
    bestForGenderRandom = function(items)
        local validItems = {}
        for _, item in ipairs(items) do
            local slot = tes3.player.object.female and tes3.clothingSlot.skirt or tes3.clothingSlot.pants
            if item.slot == slot then
                table.insert(validItems, item)
            end
        end
        if #validItems == 0 then
            return {}
        end
        local choice = table.choice(validItems)
        return { choice }
    end,
    bestForGenderFirst = function(items)
        local validItems = {}
        for _, item in ipairs(items) do
            local slot = tes3.player.object.female == true
                and tes3.clothingSlot.skirt
                or tes3.clothingSlot.pants
            if item.slot == slot then
                table.insert(validItems, item)
            end
        end
        if #validItems == 0 then
            return {}
        end
        local choice = validItems[1]
        return { choice }
    end,
    firstValid = function(items)
        local choice = items[1]
        return { choice }
    end,
    all = function(items)
        return items
    end
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
        noDuplicates = data.noDuplicates,
        noSlotDuplicates = data.noSlotDuplicates,
        pickMethod = data.pickMethod or "random",
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

function ItemPick:getDescription()
    local description = self.description
    if not self.description then
        local item = tes3.getObject(self.ids[1])
        if item then
            description = item.name
        else
            description = "Unknown item"
        end
    end
    return description
end

--Get a lit of all valid items
---@return ChargenScenarios.ItemPickItem[]
function ItemPick:getValidItems()
    local validItems = {}
    for _, id in ipairs(self.ids) do
        local item = tes3.getObject(id)
        if item then
            table.insert(validItems, item)
        end
    end
    return validItems
end

---@return ChargenScenarios.ItemPickItem[]|nil
function ItemPick:pick()
    if not self:checkRequirements() then
        return nil
    end
    --Find which items exist
    local validItems = self:getValidItems()
    if #validItems == 0 then
        logger:debug("No valid items found")
        return nil
    end
    --Pick an item
    if not self.ids then return nil end
    local pickedItems = self.pickMethods[self.pickMethod](validItems)
    return pickedItems
end



---@param item ChargenScenarios.ItemPickItem
local function isEquippableType(item)
    return item.objectType == tes3.objectType.armor
        or item.objectType == tes3.objectType.clothing
        or item.objectType == tes3.objectType.weapon
end

---Check if the player has an item of the same type and slot/weapontype
---@param item tes3clothing|tes3armor|tes3weapon
local function playerHasSameItemType(item)
    if not isEquippableType(item) then return false end
    local player = tes3.player
    for _, stack in pairs(player.object.inventory) do
        if stack.object.objectType == item.objectType then
            if item.objectType == tes3.objectType.armor or item.objectType == tes3.objectType.clothing then
                if stack.object.slot == item.slot then
                    return true
                end
            elseif item.objectType == tes3.objectType.weapon then
                if stack.object.type == item.type then
                    return true
                end
            end
        end
    end
    return false
end


function ItemPick:giveToPlayer()
    self:resolveItems()
    for item, count in pairs(self.resolvedItems) do
        if self.noDuplicates and tes3.player.object.inventory:contains(item) then
            logger:debug("Player already has item, skipping %s", item)
        elseif self.noSlotDuplicates and playerHasSameItemType(item) then
            logger:debug("Player already has item of same type, skipping %s", item)
        elseif tes3.player.object.race.isBeast and item.isUsableByBeasts == false then
            logger:debug("Beast cannot use %s, adding gold value instead", item)
            tes3.addItem{
                reference = tes3.player,
                item = "gold_001",
                count = item.value,
                playSound = false,
            }
        else
            logger:debug("Adding item to player inventory: %s", item)
            tes3.addItem{
                reference = tes3.player,
                item = item,
                count = count,
                playSound = false,
            }
        end
    end
end

---Reset the resolved items
function ItemPick:reset()
    self.resolvedItems = nil
end

---Resolves the ids into items. Call before using self.resolvedItems
function ItemPick:resolveItems()
    if self.resolvedItems then
        return self.resolvedItems
    end
    self.resolvedItems = {}
    local added = 0
    --If there's only one item in the list, then add them all at once
    --If there's multiple items, pick and add one at a time
    local hasMultipleItems = #self.ids > 1
    local numAddedPerLoop = hasMultipleItems and 1 or self.count
    while added < (self.count or 1) do
        local pickedItems = self:pick()
        if pickedItems == nil or #pickedItems == 0 then
            logger:debug("No valid items to pick from")
            break
        end
        for _, pickedItem in ipairs(pickedItems) do
            logger:debug("Picked item: %s", pickedItem)
            self.resolvedItems[pickedItem] = self.resolvedItems[pickedItem]
                and (self.resolvedItems[pickedItem] + numAddedPerLoop)
                or numAddedPerLoop
            added = added + numAddedPerLoop
        end
    end
end


function ItemPick:checkRequirements()
    if self.requirements and not self.requirements:check() then
        return false
    end
    return true
end

return ItemPick