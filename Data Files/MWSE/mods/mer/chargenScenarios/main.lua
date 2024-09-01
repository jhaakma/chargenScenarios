local enabled = true
if not enabled then
    return
end


local common = require('mer.chargenScenarios.common')
local logger = common.createLogger("main")
--Do MCM
require('mer.chargenScenarios.mcm')

event.register("initialized", function()
    common.initAll("mer\\chargenScenarios\\integrations")
    common.initAll("mer\\chargenScenarios\\modules")
    logger:info("Initialized v^%s", common.getVersion())
end)


--Run Unit tests
require('mer.chargenScenarios.test.unitTests')
require('mer.chargenScenarios.test.initializedTests')
require('mer.chargenScenarios.test.gameLoadedTests')
