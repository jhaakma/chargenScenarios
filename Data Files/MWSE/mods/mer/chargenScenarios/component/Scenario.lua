---@class ChargenScenariosScenarioInput
---@field name string @The name of the Scenario. Will be displayed in the scenario selection menu.
---@field description string @The description of the Scenario. Will be displayed in the scenario selection menu.
---@field location ChargenScenariosLocationInput @The location that will be used for the scenario.
---@field locations table<number,ChargenScenariosLocationInput> @A list of locations. If used instead of 'location', one from this list will be randomly selected for the scenario.
---@field items table<number,ChargenScenariosItemPickInput> @A list of items that will be added to the player's inventory.
---@field spells table<number, ChargenScenariosSpellPickInput> @A list of spells that will be added to the player
---@field requirements ChargenScenariosRequirementsInput @The requirements that need to be met for this scenario to be used.
---@field introMessage string @The message to display when a scenario starts. Overwritten by location introMessage.
---@field doVanillaChargen boolean @If true, the vanilla chargen will be used.

---@class ChargenScenariosScenario
---methods:
---@field new                   function @constructor
---@field register              function @constructs and registers the scenario
---@field getStartingLocation   function @returns the starting location for the scenario. If a list of scenarios is provided, picks one at random
---@field moveToLocation        function @moves the player to the randomly selected location
---@field checkRequirements     function @returns true if the requirements are met, false otherwise
---@field addItems              function @adds items to the player's inventory. Overridden by location items
---@field getIntroMessage       function @returns the intro message for the scenario. Overridden by location introMessage
---@field doIntroMessage        function @displays the intro message for the scenario
---@field addClutter            function @adds clutter to the world. Overridden by location clutter
---@field addSpells             function @adds spells to the player. Overridden by location spells
---@field start                 function @Begin the scenario
---fields:
---@field name                  string @the name of the scenario
---@field description           string @the description of the scenario
---@field requirements          ChargenScenariosRequirements @the requirements for the scenario
---@field locations             table @the list of locations for the scenario
---@field itemList              ChargenScenariosItemList @the list of items for the scenario
---@field spellList             ChargenScenariosSpellList @the list of spells given to the player for this scenario. May include abilities, diseases etc
---@field clutter               table @the clutter for the scenario
---@field introMessage          string @the intro message for the scenario.
---@field doVanillaChargen      boolean @whether or not to do the vanilla chargen.

local common       = require("mer.chargenScenarios.common")
local ItemList     = require("mer.chargenScenarios.component.ItemList")
local Location     = require("mer.chargenScenarios.component.Location")
local Requirements = require("mer.chargenScenarios.component.Requirements")
local SpellPick    = require("mer.chargenScenarios.component.SpellPick")
local SpellList    = require("mer.chargenScenarios.component.SpellList")
local ItemPick     = require("mer.chargenScenarios.component.ItemPick")

---@type ChargenScenariosScenario
local Scenario = {
    schema = {
        name = "Scenario",
        fields = {
            name = { type = "string", required = true },
            description = { type = "string", required = true },
            --One of these two is required
            location = { type = Location.schema, required = false },
            locations = { type = "table", childType = Location.schema, required = false },
            --optionals:
            items = { type = "table", childType = ItemPick.schema, required = false },
            spells = { type = "table", childType = SpellPick.schema, required = false },
            requirements = { type = Requirements.schema, required = false },
            introMessage = { type = "string", required = false },
            doVanillaChargen = { type = "boolean", default = false, required = false },
        }
    }
}

--Constructor
---@param data ChargenScenariosScenarioInput
---@return ChargenScenariosScenario
function Scenario:new(data)
    local scenario = table.deepcopy(data)
    --Validate
    common.validator.validate(scenario, self.schema)
    assert(scenario.location or scenario.locations, "Scenario must have a location or a list of locations")
    --Build
    do--Create Locations
        scenario.locations = scenario.locations or {scenario.location}
        scenario.location = nil
        scenario.locations = common.convertListTypes(scenario.locations, Location)
    end
    --Convert items to ItemList
    scenario.itemList = scenario.items and ItemList:new(scenario.items)
    scenario.items = nil
    --Create Requiremeents
    scenario.requirements = Requirements:new(scenario.requirements)
    --convert spells to spellList
    scenario.spellList = scenario.spells and SpellList:new(scenario.spells)
    scenario.spells = nil
    --Create scenario
    setmetatable(scenario, self)
    self.__index = self
    return scenario
end

---@param data ChargenScenariosScenarioInput
---@return ChargenScenariosScenario
function Scenario:register(data)
    local scenario = self:new(data)
    common.log:debug("Adding %s to scenario list", scenario.name)
    table.insert(common.registeredScenarios, scenario)
    return scenario
end

---@return ChargenScenariosLocation
function Scenario:getStartingLocation()
    --Decide starting location once
    if self.decidedLocation then
        return self.decidedLocation
    end
    local validLocations = {}
    for _, location in ipairs(self.locations) do
        if location:checkRequirements() then
            table.insert(validLocations, location)
        end
    end
    if #validLocations == 0 then
        common.log:error("No valid locations for scenario %s", self.name)
        return nil
    end
    self.decidedLocation = table.choice(validLocations)
    return self.decidedLocation
end

function Scenario:moveToLocation()
    return self:getStartingLocation():moveTo()
end

--Check that required mods are installed and there is at least one valid location
function Scenario:checkRequirements()
    local hasValidLocation = false
    for _, location in ipairs(self.locations) do
        if location:checkRequirements() then
            hasValidLocation = true
        end
    end
    return hasValidLocation and self.requirements:check()
end

function Scenario:addItems()
    local locationItems = self:getStartingLocation():addItems()
    if locationItems then
        return locationItems
    elseif self.itemList then
        return self.itemList:addItems()
    end
end

---@return string|nil
function Scenario:getIntroMessage()
    local locationMessage = self:getStartingLocation():getIntroMessage()
    if locationMessage then
        return locationMessage
    elseif self.introMessage then
        return self.introMessage
    end
end

function Scenario:doIntroMessage()
    local message = self:getIntroMessage()
    if message then
        tes3.messageBox{
            message = message,
            buttons = {tes3.findGMST(tes3.gmst.sOK).value}
        }
    end
end

function Scenario:addClutter()
    local locationAddedClutter = self:getStartingLocation():addClutter()
    if locationAddedClutter then
        return locationAddedClutter
    elseif self.clutter then
        return self.clutter:addClutter()
    end
end

function Scenario:addSpells()
    if self.spellList then
        return self.spellList:addSpells()
    end
end

function Scenario:start()
    tes3.findGlobal("CharGenState").value = -1
    self:addClutter()
    self:moveToLocation()
    timer.start{
        duration = 0.5,
        callback = function()
            self:addItems()
            self:addSpells()
            self:doIntroMessage()
            common.enableControls()
        end,
    }
end

return Scenario