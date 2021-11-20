---@class ChargenScenariosRequirementsInput
---@field plugins table<number, string> @A list of required plugins.
---@field classes table<number, string> @A list of required classes.


---@class ChargenScenariosRequirements
---@field new function @contructor
---@field checkClass function @checks whether the player is one of the eligible classes
---@field checkPlugins function @checks whether all the required plugins are loaded
---@field check function @checks whether all the requirements are met
---@field plugins table<number, string> @the list of plugins that are required
---@field classes table<number, string> @the list of classes that are eligible

local common = require("mer.chargenScenarios.common")

--[[
    Represents a set of requirements for a scenario or location.
]]
---@type ChargenScenariosRequirements
local Requirements = {
    schema = {
        name = "Requirements",
        fields = {
            plugins = { type = "table", childType = "string", required = false },
            classes = { type = "table", childType = "string", required = false },
        }
    }
}

--Constructor
---@param data ChargenScenariosRequirementsInput
---@return ChargenScenariosRequirements
function Requirements:new(data)
    local requirements = {}
    --If no data provided, return an empty requirements object where check() always returns true
    if data then
        requirements = table.deepcopy(data)
        common.validator.validate(requirements, self.schema)
    end
    setmetatable(requirements, self)
    self.__index = self
    return requirements
end

--Check player has a valid class
function Requirements:checkClass()
    if self.classes then
        local playerClass = tes3.player.object.class.id:lower()
        for _, class in ipairs(self.classes) do
            if class:lower() == playerClass then
                return true
            end
        end
    else
        return true
    end
    return false
end

--Check that all required plugins are installed
function Requirements:checkPlugins()
    if self.plugins then
        for _, plugin in ipairs(self.plugins) do
            if not tes3.isModActive(plugin) then
                return false
            end
        end
        return true
    else
        return true
    end
    return false
end

--Check that all requirements are met
function Requirements:check()
    return self:checkClass()
    and self:checkPlugins()
end

return Requirements