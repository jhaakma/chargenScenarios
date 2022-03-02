--Controllers for the scenario builder
require('mer.chargenScenarios.ScenarioBuilder.controllers.registerLocations')
require('mer.chargenScenarios.ScenarioBuilder.controllers.registerClutter')
--Register existing scenarios
require('mer.chargenScenarios.ScenarioBuilder.scenarios').registerScenarios()

--MCM
local mcm = require('mer.chargenScenarios.ScenarioBuilder.mcm')
event.register("modConfigReady", mcm.registerModConfig)