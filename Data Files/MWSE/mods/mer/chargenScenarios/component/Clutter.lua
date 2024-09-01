local common = require("mer.chargenScenarios.common")
local Requirements = require("mer.chargenScenarios.component.Requirements")
local Validator = require("mer.chargenScenarios.util.validator")

---@class ChargenScenariosClutterInput
---@field id string @The id of the clutter object.
---@field ids table<number, string> @The list of clutter object ids. If used instead of 'id', one will be chosen at random from this list.
---@field position table<number, number> @The position the clutter object will be placed at.
---@field orientation table<number, number> @The orientation the clutter object will be placed at.
---@field cell string @The cell the clutter object will be placed in.
---@field scale number @The scale of the clutter object.
---@field requirements ChargenScenariosRequirementsInput @The requirements for the clutter object.

---@class ChargenScenariosClutter
---@field ids table<number, string> @the list of item ids the clutter is chosen from
---@field position table<number, number> @the position where the clutter will be placed
---@field orientation table<number, number> @the orientation where the clutter will be placed
---@field cell string @the cell where the clutter will be placed
---@field scale number @the scale the clutter will be placed at
---@field requirements ChargenScenariosRequirements @the requirements for the clutter
---@field chosenItem? tes3object @the cached item that was chosen
local Clutter = {}

--Constructor
---@param data ChargenScenariosClutterInput
---@return ChargenScenariosClutter
function Clutter:new(data)
    ---Validate
    assert(data.id or data.ids, "Scenario must have an id or a list of ids")

    ---@type ChargenScenariosClutter
    local clutter = {
        ids = data.id and {data.id} or data.ids,
        position = data.position,
        orientation = data.orientation,
        cell = data.cell,
        scale = data.scale,
        requirements = Requirements:new(data.requirements)
    }
    self.__index = self
    table.insert(common.registeredClutters, clutter)
    return clutter
end

---@return tes3object|nil
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
        local obj = self:getObject() --[[@as tes3misc]]
        if obj then
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
end

return Clutter