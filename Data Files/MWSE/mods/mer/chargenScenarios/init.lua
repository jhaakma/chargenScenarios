local Scenario = require("mer.chargenScenarios.component.Scenario")
local Loadouts = require("mer.chargenScenarios.component.Loadouts")
local ItemList = require("mer.chargenScenarios.component.ItemList")

---@class ChargenScenariosInterop
local interop = {
    ItemList = ItemList
}

---@param data { id: string, callback: fun():ChargenScenariosItemList }
function interop.registerLoadout(data)
    Loadouts.register(data)
end

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