local common = require("mer.chargenScenarios.common")
local logger = common.createLogger("Scenario")
local Validator = require("mer.chargenScenarios.util.validator")
local Controls = require("mer.chargenScenarios.util.Controls")
local ItemList = require("mer.chargenScenarios.component.ItemList")
local Location = require("mer.chargenScenarios.component.Location")
local Requirements = require("mer.chargenScenarios.component.Requirements")
local SpellPick = require("mer.chargenScenarios.component.SpellPick")
local SpellList = require("mer.chargenScenarios.component.SpellList")
local ItemPick = require("mer.chargenScenarios.component.ItemPick")
local Clutter = require("mer.chargenScenarios.component.Clutter")
local ClutterList = require("mer.chargenScenarios.component.ClutterList")

---@class ChargenScenariosScenarioInput
---@field id string A unique ID for the scenario
---@field name string The name of the Scenario. Will be displayed in the scenario selection menu.
---@field description string The description of the Scenario. Will be displayed in the scenario selection menu.
---@field location nil|string|ChargenScenariosLocationInput The location of the scenario. If used instead of 'locations', this location will be used for the scenario.
---@field locations nil|string[]|ChargenScenariosLocationInput[] A list of locations. If used instead of 'location', one from this list will be randomly selected for the scenario.
---@field items nil|ChargenScenariosItemPickInput[] A list of items that will be added to the player's inventory.
---@field spells nil|ChargenScenariosSpellPickInput[] A list of spells that will be added to the player
---@field requirements nil|ChargenScenariosRequirementsInput The requirements that need to be met for this scenario to be used.
---@field clutter nil|string|ChargenScenariosClutterInput[] The clutter for the location. Can be a list of clutter data or a cluterList ID
---@field onStart nil|fun(self: ChargenScenariosScenario) Callback triggered when a scenario starts.

---@class (exact) ChargenScenariosScenario : ChargenScenariosScenarioInput
---@field requirements ChargenScenariosRequirements the requirements for the scenario
---@field locations ChargenScenariosLocation[] the list of locations for the scenario
---@field itemList? ChargenScenariosItemList the list of items for the scenario
---@field spellList? ChargenScenariosSpellList the list of spells given to the player for this scenario. May include abilities, diseases etc
---@field clutterList? ChargenScenariosClutterList the clutter for the location
---@field decidedLocation? ChargenScenariosLocation the index of the location that was decided for this scenario
---@field registeredScenarios table<string, ChargenScenariosScenario> the list of registered scenarios
local Scenario = {
    registeredScenarios = {},
}

--- Construct a new Scenario
---@param data ChargenScenariosScenarioInput
---@return ChargenScenariosScenario
function Scenario:new(data)

    --resolve location/locations
    local locationList = data.location and {data.location} or data.locations

    --Resolve clutter
    local clutter
    if type(data.clutter) == "string" then
        clutter = ClutterList.get(clutter)
    else
        clutter = data.clutter and ClutterList:new(data.clutter)
    end

    local scenario = {
        id = data.id,
        name = data.name,
        description = data.description,
        requirements = Requirements:new(data.requirements),
        locations = locationList and common.convertListTypes(locationList, Location) or {},
        itemList = data.items and ItemList:new(data.items),
        spellList = data.spells and SpellList:new(data.spells),
        clutterList = clutter,
        onStart = data.onStart,
    }
    --Create scenario
    setmetatable(scenario, { __index = Scenario })

    event.register("loaded", function()
        scenario.decidedLocation = nil
    end)

    return scenario --[[@as ChargenScenariosScenario]]
end

--- Register a new scenario
---@param data ChargenScenariosScenarioInput
---@return ChargenScenariosScenario
function Scenario:register(data)
    local scenario = self:new(data)
    logger:debug("Adding %s to scenario list", scenario.name)
    Scenario.registeredScenarios[scenario.id] = scenario
    return scenario
end

--- Add a location to the scenario
---@param locationInput ChargenScenariosLocationInput
function Scenario:addLocation(locationInput)
    local location = Location:new(locationInput)
    table.insert(self.locations, location)
end

--- Add an item to the scenario
---@return ChargenScenariosLocation?
function Scenario:getStartingLocation()
    if not self.locations then
        logger:error("Scenario %s has no locations", self.name)
    end
    --Decide starting location once
    if self.decidedLocation then
        return self.decidedLocation
    end
    local validLocations = self:getValidLocations()
    if #validLocations == 0 then
        logger:error("No valid locations for scenario %s", self.name)
        return nil
    end
    self.decidedLocation = table.choice(validLocations)
    return self.decidedLocation
end

---@return ChargenScenariosLocation[]
function Scenario:getValidLocations()
    local validLocations = {}
    for _, location in pairs(self.locations) do
        if location:isValid() then
            table.insert(validLocations, location)
        end
    end
    return validLocations
end

--- Move the player to the starting location
function Scenario:moveToLocation()
    if not self.locations then
        logger:error("Scenario %s has no locations", self.name)
    end
    return self:getStartingLocation():moveTo()
end

--- Check if the scenario can be used
---@return boolean
function Scenario:checkRequirements()
    return self.requirements:check()
end

--- Check if the scenario has a valid location
---@return boolean
function Scenario:hasValidLocation()
    if not self.locations then
        logger:error("Scenario %s has no locations", self.name)
        return false
    end
    return #self:getValidLocations() > 0
end

function Scenario:isVisible()
    return self:hasValidLocation()
        and self.requirements:checkPlugins()
        and self.requirements:checkExcludedPlugins()
end

function Scenario:addAndEquipCommonClothing()
    logger:debug("Adding and equipping common clothing")
    local items = {
        {
            id = "common_pants_01",
            objectType = tes3.objectType.clothing,
            slot = tes3.clothingSlot.pants,
        },
        {
            id = "common_shoes_01",
            objectType = tes3.objectType.clothing,
            slot = tes3.clothingSlot.shoes,
            alt = {
                objectType = tes3.objectType.armor,
                slot = tes3.armorSlot.boots
            }
        },
        {
            id = "common_shirt_01",
            objectType = tes3.objectType.clothing,
            slot = tes3.clothingSlot.shirt,
        }
    }

    for _, item in ipairs(items) do
        local hasItem = tes3.getEquippedItem{
            actor = tes3.player,
            objectType = item.objectType,
            slot = item.slot
        }
        if not hasItem and item.alt then
            hasItem = tes3.getEquippedItem{
                actor = tes3.player,
                objectType = item.alt.objectType,
                slot = item.alt.slot
            }
        end

        if not hasItem then
            local item = tes3.getObject(item.id)
            local canEquip = true
            if tes3.player.object.race.isBeast then
                canEquip = item.isUsableByBeasts ~= false
                logger:debug("Beast - can equip %s: %s", item.id, canEquip)
            end
            if canEquip then
                logger:debug("Equipping deafult %s to player", item.id)
                tes3.addItem{
                    reference = tes3.player,
                    item = item.id
                }
                tes3.equip{
                    item = item,
                    reference = tes3.player,
                }
            else
                logger:debug("Beast - cannot equip deafult %s", item.id)
            end
        end
    end
end

--- Add the items for this scenario to the player's inventory
function Scenario:doItems()
    local locationItems = self:getStartingLocation():doItems()
    local didItems
    if locationItems then
        didItems = locationItems
    elseif self.itemList then
        didItems = self.itemList:doItems()
    end
    self:addAndEquipCommonClothing()
    return didItems
end

--- Do the location and scenario callbacks
function Scenario:doIntro()
    if self.onStart then
        self:onStart()
    end
    local location = self:getStartingLocation()
    if location and location.onStart then
        location:onStart()
    end
end

--- Place the clutter for this scenario
---@return tes3reference[]|nil
function Scenario:doClutter()
    local locationAddedClutter = self:getStartingLocation():doClutter()
    if locationAddedClutter then
        return locationAddedClutter
    elseif self.clutterList then
        return self.clutterList:doClutter()
    end
end

--- Give the player spells for this scenario
function Scenario:doSpells()
    if self.spellList then
        return self.spellList:doSpells()
    end
end

--- Start the scenario
function Scenario:start()
    self:doClutter()
    self:moveToLocation()
    timer.delayOneFrame(function()
        self:doSpells()
        self:doItems()
        self:doIntro()
    end)
end

return Scenario