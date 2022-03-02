local common = require('mer.chargenScenarios.common')
local interop = require("mer.chargenScenarios.interop")
require('mer.chargenScenarios.controllers.chargenController')
require('mer.chargenScenarios.controllers.chargenMenuController')
--Do MCM
require('mer.chargenScenarios.mcm')
for _, scenario in ipairs(common.config.scenarios) do
    --Register scenarios
    interop.registerScenario(scenario)
end

--Run Unit tests
require('mer.chargenScenarios.test.unitTests')
require('mer.chargenScenarios.test.initializedTests')
require('mer.chargenScenarios.test.gameLoadedTests')
