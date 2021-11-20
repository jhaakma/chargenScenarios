local interop = require("mer.chargenScenarios.interop")

local common = require('mer.chargenScenarios.common')
require('mer.chargenScenarios.controllers.chargenController')
require('mer.chargenScenarios.controllers.menuController')
--Do MCM
require('mer.chargenScenarios.mcm')

for _, scenario in ipairs(common.config.scenarios) do
    --Register scenarios
    interop.registerScenario(scenario)
end