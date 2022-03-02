---@class ChargenScenariosRequirementsInput
---@field plugins table<number, string> @A list of required plugins
---@field classes table<number, string> @A list of required classes
---@field races table<number, string> @A list of required races

---@class ChargenScenariosRequirements
---@field new function @contructor
---@field addPlugin function @Add a new plugin requirement
---@field addClass function @Add a new class requirement
---@field addRace function @Add a new race requirement
---@field checkPlugins function @checks whether all the required plugins are loaded
---@field checkClass function @checks whether the player is one of the eligible classes
---@field checkRace function @checks whether the player is one of the eligible races
---@field check function @checks whether all the requirements are met
---@field plugins table<number, string> @the array of plugins that are required
---@field classes table<string, boolean> @the dictionary of classes that are eligible
---@field races table<string, boolean> @the dictionary of races that are elegible

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
            races = { type = "table", childType = "string", required = false },
        }
    }
}

local function convertArrayToDict(tbl)
    local dict = {}
    for _, val in ipairs(tbl) do
        dict[val:lower()] = true
    end
    return dict
end

--Constructor
---@param data ChargenScenariosRequirementsInput
---@return ChargenScenariosRequirements
function Requirements:new(data)
    local requirements = {}
    --If no data provided, return an empty requirements object where check() always returns true
    if data then
        requirements.plugins = data.plugins or {}
        requirements.classes = convertArrayToDict(data.classes or {})
        requirements.races = convertArrayToDict(data.races or {})
    end
    setmetatable(requirements, self)
    self.__index = self
    return requirements
end

local function addRequirement(self, requirementType, value)
    local requirementTypes = {
        plugins = true,
        classes = true,
        races = true
    }
    assert(type(requirementType) == "string", "requirementType must be a string")
    assert(requirementTypes[requirementType],
        string.format("%s is not a valid requirement type. Available options are: %s.",
            requirementType, table.concat(table.keys(requirementTypes), ", ")))
    assert(type(value) == "string", string.format("% needs to be a string", requirementType))
    self[requirementType][value:lower()] = true
end

function Requirements:addPlugin(plugin)
    addRequirement(self, "plugins", plugin)
end

function Requirements:addClass(class)
    addRequirement(self, "classes", class)
end

function Requirements:addRace(race)
    addRequirement(self, "races", race)
end

function Requirements:checkPlugins()
    if self.plugins and #self.plugins > 0 then
        for _, plugin in ipairs(self.plugins) do
            if not tes3.isModActive(plugin) then
                return false
            end
        end
    end
    return true
end

function Requirements:checkClass()
    if self.classes and table.size(self.classes) > 0 then
        local playerClass = tes3.player.object.class.id:lower()
        return self.classes[playerClass] == true
    end
    return true
end

function Requirements:checkRace()
    if self.races and table.size(self.races) > 0 then
        local playerRace = tes3.player.object.race.id:lower()
        return self.races[playerRace] == true
    end
    return true
end

function Requirements:check()
    return self:checkPlugins()
    and self:checkClass()
    and self:checkRace()
end

return Requirements