local enabled = true
if not enabled then
    return
end


local common = require('mer.chargenScenarios.common')
local logger = common.createLogger("main")
--Do MCM
require('mer.chargenScenarios.mcm')

event.register("initialized", function()
    tes3.getObject("player").inventory:removeItem{item = tes3.getObject("common_shoes_01")}
    tes3.getObject("player").inventory:removeItem{item = tes3.getObject("common_shirt_01")}
    tes3.getObject("player").inventory:removeItem{item = tes3.getObject("common_pants_01")}
    common.initAll("mer\\chargenScenarios\\integrations")
    common.initAll("mer\\chargenScenarios\\modules")
    logger:info("Initialized v^%s", common.getVersion())
    event.trigger("ChargenScenarios:Initialized")
end)


--Run Unit tests
require('mer.chargenScenarios.test.unitTests')
require('mer.chargenScenarios.test.initializedTests')
require('mer.chargenScenarios.test.gameLoadedTests')
