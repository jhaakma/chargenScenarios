local UnitWind = include('unitwind.unitwind')
if not UnitWind then return end
UnitWind = UnitWind.new{
    enabled = doTest,
    highlight = true,
    afterTest = function()
        if tes3.player and tes3.player.testPlayerObject then
            tes3.player = nil
        end
    end,
}

local Scenario = require "mer.chargenScenarios.component.Scenario"
local doTest = false
local exitAfterUnits = false
local exitAfterInitialize = false
local exitAfterLoaded = false

--Basic scenario with just required fields
---@type ChargenScenariosScenarioInput
local successfulScenarioInput = {
    name = "Test Scenario",
    description = "Test scenario description",
    location = {
        position = { 0, 0, 0 },
        orientation = { 0, 0, 0 },
        cell = "West Gash Region",
        introMessage = "Test location intro message",
    },
}



UnitWind:start("Chargen Scenarios Unit Tests")
UnitWind:test("Canary test", function()
    UnitWind:expect(true).toBe(true)
end)
--interop
UnitWind:log("Testing interop")
UnitWind:test("Chargen Scenarios Interop is found", function()
    local interop = include('mer.chargenScenarios.interop')
    UnitWind:expect(interop).NOT.toBe(nil)
end)
UnitWind:test("registerScenario interop returns valid scenario", function()
    local interop = include('mer.chargenScenarios.interop')
    local input = table.deepcopy(successfulScenarioInput)
    local successfulScenario = interop.registerScenario(input)
    UnitWind:expect(successfulScenario).NOT.toBe(nil)
end)
--Scenario
UnitWind:log("Testing Scenario")
UnitWind:test("Scenario has all expected methods", function()
    local scenario = Scenario:new(successfulScenarioInput)
    UnitWind:expect(scenario).NOT.toBe(nil)
    UnitWind:expect(scenario.getStartingLocation).toBeType("function")
    UnitWind:expect(scenario.getIntroMessage).toBeType("function")
    UnitWind:expect(scenario.addItems).toBeType("function")
    UnitWind:expect(scenario.checkRequirements).toBeType("function")
    UnitWind:expect(scenario.moveToLocation).toBeType("function")
    UnitWind:expect(scenario.doIntroMessage).toBeType("function")
    UnitWind:expect(scenario.addClutter).toBeType("function")
    UnitWind:expect(scenario.addSpells).toBeType("function")
    UnitWind:expect(scenario.start).toBeType("function")
end)

--name
UnitWind:log("Testing name")
UnitWind:test("Scenario has correct name", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.name = "Test Scenario"
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario.name).toBe(input.name)
end)
UnitWind:test("Scenario:new() fails when name is missing", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.name = nil
    UnitWind:expect(function()
        Scenario:new(input)
    end).toFail()
end)

--description
UnitWind:log("Testing description")
UnitWind:test("Scenario has correct description", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.description = "Test scenario description"
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario.description).toBe(input.description)
end)
UnitWind:test("Scenario:new() fails when description is missing", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.description = nil
    UnitWind:expect(function()
        Scenario:new(input)
    end).toFail()
end)

--location
UnitWind:log("Testing location")
UnitWind:test("A single input location is moved to a list", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.location = {
        position = { 0, 0, 0 },
        orientation = { 0, 0, 0 },
        cell = "West Gash Region",
        introMessage = "Test location intro message",
    }
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(#successfulScenario.locations).toBe(1)
end)
UnitWind:test("A list of locations are registered correctly", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.locations = {
        {
            position = { 0, 0, 0 },
            orientation = { 0, 0, 0 },
            cell = "West Gash Region",
            introMessage = "Test location intro message",
        },
        {
            position = { 0, 0, 0 },
            orientation = { 0, 0, 0 },
            cell = "West Gash Region",
            introMessage = "Test location intro message",
        },
    }
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(#successfulScenario.locations).toBe(2)
end)
UnitWind:test("Scenario:getStartingLocation returns the location", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.locations = {
        {
            position = { 0, 0, 0 },
            orientation = { 0, 0, 0 },
            cell = "West Gash Region",
            introMessage = "Test location intro message",
        },
    }
    local successfulScenario = Scenario:new(input)
    local location = successfulScenario:getStartingLocation()
    UnitWind:expect(location).NOT.toBe(nil)
    UnitWind:expect(location.cell).toBe(input.locations[1].cell)
    UnitWind:expect(location:getIntroMessage()).toBe(input.locations[1].introMessage)
end)
UnitWind:test("Scenario:new() fails when location is missing", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.location = nil
    input.locations = nil
    UnitWind:expect(function()
        Scenario:new(input)
    end).toFail()
end)
UnitWind:test("Scenario:new() fails when location does not have a position", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.location.position = nil
    UnitWind:expect(function()
        Scenario:new(input)
    end).toFail()
end)
UnitWind:test("Scenario:new() fails when location does not have an orientation", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.location.orientation = nil
    UnitWind:expect(function()
        Scenario:new(input)
    end).toFail()
end)
UnitWind:test("Scenario:new() fails when location does not have a cell", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.location.cell = nil
    UnitWind:expect(function()
        Scenario:new(input)
    end).toFail()
end)

--items
UnitWind:log("Testing Items")
UnitWind:test("Scenario has correct itemList", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.items = {
        {
            id = "testItem",
            count = 1,
        },
        {
            id = "testItem2",
            count = 2,
        },
    }
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(#successfulScenario.itemList.items).toBe(2)
    UnitWind:expect(successfulScenario.itemList.addItems).toBeType("function")
    UnitWind:log(successfulScenario.itemList.items[1].ids[1])
    UnitWind:log(input.items[1].id)
    UnitWind:expect(successfulScenario.itemList.items[1].ids[1]).toBe(input.items[1].id)
end)

--introMessage
UnitWind:log("Testing Intro Message")
UnitWind:test("Scenario has correct intro message", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.introMessage = "Test scenario intro message"
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario.introMessage).toBe(input.introMessage)
end)
UnitWind:test("Scenario:getIntroMessage returns location.introMessage if it exists", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.introMessage = "Test scenario intro message"
    input.location.introMessage = "Test location intro message"
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario:getIntroMessage()).toBe(input.location.introMessage)
end)
UnitWind:test("Scenario:getIntroMessage returns the scenario intro message when the location.introMessage is nil", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.introMessage = "Test scenario intro message"
    input.location.introMessage = nil
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario:getIntroMessage()).toBe(input.introMessage)
end)
--requirements
UnitWind:log("Testing Requirements")
UnitWind:test("Scenario:checkRequirements returns true when there are no requirements", function()
    local input = table.deepcopy(successfulScenarioInput)
    input.requirements = nil
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario:checkRequirements()).toBe(true)
end)
UnitWind:test("Scenario:checkRequirements returns true when an existing plugin is required", function()
    local input = table.deepcopy(successfulScenarioInput)
    ---@type ChargenScenariosRequirementsInput
    input.requirements = {
            plugin = "Morrowind.ESP",
    }
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario:checkRequirements()).toBe(true)
end)
UnitWind:test("Scenario:checkRequirements returns false when a non-existent plugin is required", function()
    local input = table.deepcopy(successfulScenarioInput)
    ---@type ChargenScenariosRequirementsInput
    input.requirements = {
        plugins = {"ThisPluginDoesNotExist"},
    }
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario:checkRequirements()).toBe(false)
end)
UnitWind:test("Scenario:checkRequirements returns true when a valid player class is required", function()
    local input = table.deepcopy(successfulScenarioInput)
    ---@type ChargenScenariosRequirementsInput
    input.requirements = {
        classes = {"ValidClass"},
    }
    tes3.player = {
        testPlayerObject = true,
        object = {
            class = {
                id = "ValidClass",
            }
        },
    }
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario:checkRequirements()).toBe(true)
    tes3.player = nil
end)
UnitWind:test("Scenario:checkRequirements returns false when an invalid player class is required", function()
    local input = table.deepcopy(successfulScenarioInput)
    ---@type ChargenScenariosRequirementsInput
    input.requirements = {
        classes = {"InvalidClass"},
    }
    tes3.player = {
        testPlayerObject = true,
        object = {
            class = {
                id = "ValidClass",
            }
        },
    }
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario:checkRequirements()).toBe(false)
    tes3.player = nil
end)
UnitWind:test("Scenario:checkRequirements returns true when the player race does exist in the race list", function()
    local input = table.deepcopy(successfulScenarioInput)
    ---@type ChargenScenariosRequirementsInput
    input.requirements = {
        races = { "Dark Elf", "Breton" },
    }
    tes3.player = {
        testPlayerObject = true,
        object = {
            race = {
                id = "Dark Elf",
            }
        },
    }
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario:checkRequirements()).toBe(true)
    tes3.player = nil
end)
UnitWind:test("Scenario:checkRequirements returns false when the player race does not exist in the race list", function()
    local input = table.deepcopy(successfulScenarioInput)
    ---@type ChargenScenariosRequirementsInput
    input.requirements = {
        races = { "Dark Elf", "Breton" },
    }
    tes3.player = {
        testPlayerObject = true,
        object = {
            race = {
                id = "High Elf",
            }
        },
    }
    local successfulScenario = Scenario:new(input)
    UnitWind:expect(successfulScenario:checkRequirements()).toBe(false)
    tes3.player = nil
end)

UnitWind:finish(exitAfterUnits)


local function runInitializedTests()
    UnitWind:start("Initialised integration tests")
    --Spells
    UnitWind:log("Testing Spells")
    UnitWind:test("Populates the spellList with the provided spells", function()
        ---@type ChargenScenariosScenarioInput
        local input = table.deepcopy(successfulScenarioInput)
        input.spells = {
            {
                id = "testspell_restorefatigue",
                name = "TEST_SPELL",
                effects = {
                    {
                        id = tes3.effect.restoreFatigue,
                        duration = 10,
                        min = 5,
                        max = 5
                    },
                }
            },
            {id = "chills"},
        }
        local successfulScenario = Scenario:new(input)
        UnitWind:expect(successfulScenario.addSpells).toBeType("function")
        local spell1 = successfulScenario.spellList.spells[1]
        UnitWind:expect(spell1.ids[1]).toBe(input.spells[1].id)
        UnitWind:expect(spell1.name).toBe(input.spells[1].name)
        UnitWind:expect(spell1.effects[1].id).toBe(input.spells[1].effects[1].id)

        local spell2 = successfulScenario.spellList.spells[2]
        UnitWind:expect(spell2.ids[1]).toBe(input.spells[2].id)
    end)
    UnitWind:finish(exitAfterInitialize)
end
event.register("initialized", runInitializedTests, { priority = exitAfterInitialize and 1000 or -1000 })


