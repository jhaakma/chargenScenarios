local Scenario = require("mer.chargenScenarios.component.Scenario")

---@class ChargenScenariosInterop
---@field registerScenario function @Register a scenario with the chargen system

---@type ChargenScenariosInterop
local interop = {}

---@param data ChargenScenariosScenarioInput
---@return ChargenScenariosScenario
interop.registerScenario = function(data)
    local scenario = Scenario:register(data)
    return scenario
end

---@param scenarioList table<number, ChargenScenariosScenarioInput>
interop.registerScenarios = function(scenarioList)
    local registeredScenarios = {}
    for _, data in ipairs(scenarioList) do
        local scenario = interop.registerScenario(data)
        table.insert(registeredScenarios, scenario)
    end
    return registeredScenarios
end

return interop