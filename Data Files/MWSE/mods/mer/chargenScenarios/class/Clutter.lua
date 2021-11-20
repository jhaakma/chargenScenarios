---@class ChargenScenariosClutterInput
---@field id string @The id of the clutter object.
---@field ids table<number, string> @The list of clutter object ids. If used instead of 'id', one will be chosen at random from this list.
---@field position table<number, number> @The position the clutter object will be placed at.
---@field orientation table<number, number> @The orientation the clutter object will be placed at.
---@field cell string @The cell the clutter object will be placed in.
---@field scale number @The scale of the clutter object.
---@field requirements ChargenScenariosRequirementsInput @The requirements for the clutter object.

---@class ChargenScenariosClutter
---@field new function @constructor
---@field getObject function @picks an item from the list and returns its object
---@field checkRequirements function @returns true if the requirements are met, false otherwise
---@field place function @Places the object in the world
---@field ids table<number, string> @the list of item ids the clutter is chosen from
---@field position table<number, number> @the position where the clutter will be placed
---@field orientation table<number, number> @the orientation where the clutter will be placed
---@field cell string @the cell where the clutter will be placed
---@field scale number @the scale the clutter will be placed at
---@field requirements ChargenScenariosRequirements @the requirements for the clutter
---@field chosenItem string @the cached item that was chosen

local common = require("mer.chargenScenarios.common")
local Requirements = require("mer.chargenScenarios.class.Requirements")

---@type ChargenScenariosClutter
local Clutter = {
    schema = {
        name = "Clutter",
        fields = {
            id = { type = "string", required = false },
            ids = { type = "table", childType = "string", required = false },
            position = { type = "table", childType = "number", required = true },
            orientation = { type = "table", childType = "number", required = true },
            cell = { type = "string", required = true },
            scale = { type = "number",  required = false},
            requirements = { type = Requirements.schema, required = false },
        }
    }
}

--Constructor
---@param data ChargenScenariosClutterInput
---@return ChargenScenariosClutter
function Clutter:new(data)
    local clutter = table.deepcopy(data)
    ---Validate
    common.validator.validate(clutter, self.schema)
    assert(clutter.id or clutter.ids, "Scenario must have an id or a list of ids")
    --Build
    do --ids
        clutter.ids = clutter.ids or {clutter.id}
        clutter.id = nil
    end
    clutter.requirements = Requirements:new(clutter.requirements)
    --Create Clutter
    self.__index = self
    table.insert(common.registeredClutters, clutter)
    return clutter
end

---@return tes3object
function Clutter:getObject()
    if self.chosenItem then
        return self.chosenItem
    end
    if self:checkRequirements() then
        local validItems = {}
        for _, id in ipairs(self.ids) do
            local item = tes3.getObject(id)
            if item then
                table.insert(validItems, item)
            end
        end
        if #validItems == 0 then
            return nil
        end
        self.chosenItem = table.choice(validItems)
        return self.chosenItem
    end
end

function Clutter:checkRequirements()
    if self.requirements then
        return self.requirements:check()
    end
    return true
end

function Clutter:place()
    if self:checkRequirements() then
        local obj = self:getObject()
        local reference = tes3.createReference{
            object = obj,
            position = self.position,
            orientation = self.orientation,
            cell = self.cell
        }
        if self.scale then
            reference.scale = self.scale
        end
        return reference
    end
end

return Clutter