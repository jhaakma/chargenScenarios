---@class ChargenScenariosLocationInput
---@field position table<number, number> @The position where the player will be spawned
---@field rotation table<number, number> @The rotation where the player will be spawned
---@field cell string @The cell where the player will be spawned
---@field items table<number, ChargenScenariosItemPickInput> @The items to add to the player's inventory. Overrwrites items defined in parent scenario
---@field requirements ChargenScenariosRequirementsInput @The requirements that need to be met for this location to be used
---@field introMessage string @The message to display when a scenario starts this location is used. Overwrites introMessage defined in parent scenario
---@field clutter table<number, ChargenScenariosClutterInput> @The clutter to add to the world. Overwrites clutter defined in parent scenario

---@class ChargenScenariosLocation
---@field new function @constructor
---@field moveTo function @move the player to location
---@field addItems function @adds items to the player's inventory
---@field checkRequirements function @returns true if the requirements are met, false otherwise
---@field getIntroMessage function @returns the intro message for the location
---@field addClutter function @adds clutter to the world
---@field position table<number, number> @the position of the location
---@field orientation table<number, number> @the orientation of the location
---@field cell string @the cell of the location
---@field items ChargenScenariosItemList @the list of items that will be added to player inventory for this location
---@field requirements ChargenScenariosRequirements @the requirements for the location
---@field introMessage string @the intro message for the location
---@field clutter table<number, ChargenScenariosClutter> @the clutter for the location

local common = require("mer.chargenScenarios.common")
local ItemList = require("mer.chargenScenarios.component.ItemList")
local ItemPick = require("mer.chargenScenarios.component.ItemPick")
local Requirements = require("mer.chargenScenarios.component.Requirements")
local Clutter = require("mer.chargenScenarios.component.Clutter")

---@type ChargenScenariosLocation
local Location = {
    --input schema, not identical to final object structure
    schema = {
        name = "Location",
        fields = {
            position = { type = "table", childType = "number", required = true },
            orientation = { type = "table", childType = "number", required = true },
            cell = { type = "string", required = true },
            items = { type = "table", childType = ItemPick.schema, required = false },
            requirements = { type = Requirements.schema, required = false },
            introMessage = { type = "string", required = false },
            clutter = { type = "table", childType = Clutter.schema, required = false },
        }
    }
}

--Constructor
---@param data ChargenScenariosLocationInput
---@return ChargenScenariosLocation
function Location:new(data)
    local location = table.deepcopy(data)
    --Validate
    common.validator.validate(location, self.schema)
    --Build
    self.items = location.items and ItemList:new(location.items)
    self.requirements = Requirements:new(location.requirements)
    self.clutter = common.convertListTypes(self.clutter, Clutter)
    --Create Location
    setmetatable(location, self)
    self.__index = self
    return location
end

function Location:moveTo()
    common.log:debug("Moving to location: %s\n %s", self.cell, json.encode(self.position))
    return tes3.positionCell{
        reference = tes3.player,
        position = self.position,
        orientation = self.orientation,
        cell = self.cell
    }
end

function Location:addItems()
    if self.items then
        return self.items:addItems()
    end
end

function Location:checkRequirements()
    return self.requirements:check()
end

function Location:getIntroMessage()
    return self.introMessage
end

---@param self ChargenScenariosLocation
function Location.addClutter(self)
    if self.clutter and #self.clutter > 0 then
        local placedClutterReferences = {}
        for _, clutter in ipairs(self.clutter) do
            if clutter:checkRequirements() then
                local item = clutter:place()
                if item then
                    table.insert(placedClutterReferences, item)
                end
            end
        end
        return placedClutterReferences
    end
end

return Location