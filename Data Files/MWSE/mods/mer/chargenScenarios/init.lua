local common = require("mer.chargenScenarios.common")
local Scenario = require("mer.chargenScenarios.component.Scenario")
local Loadouts = require("mer.chargenScenarios.component.Loadouts")
local ItemList = require("mer.chargenScenarios.component.ItemList")

local itemPicks = require("mer.chargenScenarios.util.itemPicks")


---@class ChargenScenariosInterop
local interop = {
    Scenario = Scenario,
    Loadouts = Loadouts,
    ItemList = ItemList,
    itemPicks = itemPicks,
    --read only
    enabled = setmetatable({}, {
        __index = function()
            return common.config.mcm.enabled
        end,
        __newindex = function()
            error("Cannot modify ChargenScenariosInterop.enabled")
        end
    })
}

interop.registerLoadout = Loadouts.register

---@param data ChargenScenariosScenarioInput
---@return ChargenScenariosScenario
function interop.registerScenario(data)
    local scenario = Scenario:register(data)
    return scenario
end

---@param scenarioList table<number, ChargenScenariosScenarioInput>
function interop.registerScenarios(scenarioList)
    local registeredScenarios = {}
    for _, data in ipairs(scenarioList) do
        local scenario = interop.registerScenario(data)
        table.insert(registeredScenarios, scenario)
    end
    return registeredScenarios
end

return interop