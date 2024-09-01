--Controllers for the scenario builder
require('mer.chargenScenarios.ScenarioBuilder.controllers.registerLocations')
--MCM
local mcm = require('mer.chargenScenarios.ScenarioBuilder.mcm')
event.register("modConfigReady", mcm.registerModConfig)