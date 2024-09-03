
local common = require("mer.chargenScenarios.common")
local ChargenMenu = require("mer.chargenScenarios.component.ChargenMenu")
local characterBackgroundsConfig = include("mer.characterBackgrounds.config")
local backgroundsInterop = include('mer.characterBackgrounds.interop')
local scenarioSelector = require('mer.chargenScenarios.component.ScenarioSelector')
local Scenario = require("mer.chargenScenarios.component.Scenario")
local logger = common.createLogger("Menus")

---@type ChargenScenarios.ChargenMenu.config[]
local menus = {
    {
        id = "characterBackgrounds",
        priority = 100,
        buttonLabel = "Background",
        getButtonValue = function(self)
            local background = backgroundsInterop.getCurrentBackground()
            return background and background:getName() or "None"
        end,
        createMenu = function(self)
            backgroundsInterop.openMenu{
                okCallback = function()
                    logger:debug("Backgrounds menu closed, calling okCallback")
                    self:okCallback()
                end
            }
        end,
        isActive = function(self)
            return backgroundsInterop
                and characterBackgroundsConfig
                and characterBackgroundsConfig.mcm.enableBackgrounds
        end,
        getTooltip = function(self)
            local background = backgroundsInterop.getCurrentBackground()
            return background and {
                header = background:getName(),
                description = background:getDescription()
            } or {
                header = "Background",
                description = "Choose a background for your character."
            }
        end
    },
    {
        id = "chargenScenarios",
        priority = -1000,
        buttonLabel= "Scenarios",
        getButtonValue = function(self)
            local scenario = self:getSelectedScenario()
            return scenario and scenario.name or "None"
        end,
        createMenu = function(self)
            scenarioSelector.createScenarioMenu{
                scenarioList = Scenario.registeredScenarios,
                onScenarioSelected = function(scenario)
                    logger:debug("Clicked scenario: %s", scenario.name)
                    self.setSelectedScenario(scenario)
                end,
                onOkayButton = function()
                    self:okCallback()
                end,
                currentScenario = self.getSelectedScenario()
            }
        end,
        validate = function(self)
            local scenario = self.getSelectedScenario()
            return scenario and scenario:checkRequirements()
        end,
        isActive = function(self)
            return true
        end,
        onStart = function(self)
            local scenario = self.getSelectedScenario()
            if scenario then
                logger:debug("Starting scenario: %s", scenario.name)
                scenario:start()
            end
        end
    }
}

for _, menu in ipairs(menus) do
    ChargenMenu.register(menu)
end