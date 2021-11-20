local ScenarioSelector = {}
local menuId = tes3ui.registerID("Mer_ScenarioSelectorMenu")
local descriptionHeaderID = tes3ui.registerID("Mer_ScenarioSelectorDescriptionHeader")
local descriptionID = tes3ui.registerID("Mer_ScenarioSelectorDescription")
local common = require("mer.chargenScenarios.common")

local function createHeading(parent)
    --HEADING
    local title = parent:createLabel{
        id = tes3ui.registerID("Mer_ScenarioSelectorMenu_heading"),
        text = "Select your Scenario:"
    }
    title.absolutePosAlignX = 0.5
    title.borderTop = 4
    title.borderBottom = 4

    return title
end

local function createOuterBlock(parent)
    local outerBlock = parent:createBlock()
    outerBlock.flowDirection = "top_to_bottom"
    outerBlock.autoHeight = true
    outerBlock.autoWidth = true
    return outerBlock
end

local function createInnerBlock(parent)
    local innerBlock = parent:createBlock()
    innerBlock.height = 350
    innerBlock.autoWidth = true
    innerBlock.flowDirection = "left_to_right"
    return innerBlock
end

local function createScenarioListBlock(parent)
    local scenarioListBlock = parent:createVerticalScrollPane{
        id = tes3ui.registerID("scenarioListBlock")
    }
    scenarioListBlock.layoutHeightFraction = 1.0
    scenarioListBlock.minWidth = 300
    scenarioListBlock.autoWidth = true
    scenarioListBlock.paddingAllSides = 4
    scenarioListBlock.borderRight = 6
    return scenarioListBlock
end

local function sortListAlphabetically(list)
    local alphabetSort = function(a, b)
        return string.lower(a.name) < string.lower(b.name)
    end
    local sortedList = {}
    for _, background in pairs(list) do
        table.insert(sortedList, background)
    end
    table.sort(sortedList, alphabetSort)
    return sortedList
end

local function populateScenarioList(listBlock, list)
    for _, scenario in ipairs(list) do
        local scenarioButton = listBlock:createButton{
            text = scenario.name,
            id = tes3ui.registerID("scenarioButton_" .. scenario.name)
        }
        scenarioButton.autoHeight = true
        scenarioButton.layoutWidthFraction = 1.0
        scenarioButton.paddingAllSides = 2
        scenarioButton.borderAllSides = 2
        if not scenario:checkRequirements() then
            scenarioButton.color = tes3ui.getPalette("disabled_color")
            scenarioButton.widget.idle = tes3ui.getPalette("disabled_color")
        end
        scenarioButton:register("mouseClick", function(e)
            tes3.player.tempData.selectedChargenScenario = scenario
        end)
    end
end

local function createDescriptionBlock(parent)
    local descriptionBlock = parent:createThinBorder()
    descriptionBlock.layoutHeightFraction = 1.0
    descriptionBlock.width = 300
    descriptionBlock.borderRight = 10
    descriptionBlock.flowDirection = "top_to_bottom"
    descriptionBlock.paddingAllSides = 10

    local descriptionHeader = descriptionBlock:createLabel{ id = descriptionHeaderID, text = ""}
    descriptionHeader.color = tes3ui.getPalette("header_color")

    local descriptionText = descriptionBlock:createLabel{id = descriptionID, text = ""}
    descriptionText.wrapText = true
    return descriptionText
end

local function createButtonsBlock(parent)
    local buttonBlock = parent:createBlock()
    buttonBlock.flowDirection = "left_to_right"
    buttonBlock.widthProportional = 1.0
    buttonBlock.autoHeight = true
    buttonBlock.childAlignX = 1.0
    return buttonBlock
end

local function createRandomiseButton(parent, listBlock)
    local randomButton = parent:createButton{ text = "Random"}
    randomButton.alignX = 1.0
    randomButton:register("mouseClick", function()
        local list = listBlock:getContentElement().children
        list[ math.random(#list) ]:triggerEvent("mouseClick")
    end)
    return randomButton
end

local function createOkButton(parent)
    local okButton = parent:createButton{ text = "Ok"}
    okButton.alignX = 1.0
    okButton:register("mouseClick", function()
        if tes3.player.tempData.selectedChargenScenario then
            common.log:debug("Selected scenario: " .. tes3.player.tempData.selectedChargenScenario.name)
            tes3ui.findMenu(menuId):destroy()
            --Return to stat review
            tes3.runLegacyScript{ command = "EnableStatReviewMenu"}
        end
    end)
    return okButton
end

function ScenarioSelector.openScenarioSelector()
    local menu = tes3ui.createMenu{ id = menuId, fixedFrame = true }
    local outerBlock = createOuterBlock(menu)
    --outer block
    local heading = createHeading(outerBlock)
    local innerBlock = createInnerBlock(outerBlock)
    --inner block
    local scenarioListBlock = createScenarioListBlock(innerBlock)
    local scenarioList = sortListAlphabetically(common.registeredScenarios)
    populateScenarioList(scenarioListBlock, scenarioList)
    local descriptionBlock = createDescriptionBlock(innerBlock)
    --Buttons
    local buttonsBlock = createButtonsBlock(outerBlock)
    createRandomiseButton(buttonsBlock, scenarioListBlock)
    createOkButton(buttonsBlock)

    menu:updateLayout()
    tes3ui.enterMenuMode(menuId)
end

return ScenarioSelector