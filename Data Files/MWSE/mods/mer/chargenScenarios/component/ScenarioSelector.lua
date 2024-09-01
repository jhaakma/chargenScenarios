local ScenarioSelector = {}
local menuId = tes3ui.registerID("Mer_ScenarioSelectorMenu")
local descriptionHeaderID = tes3ui.registerID("Mer_ScenarioSelectorDescriptionHeader")
local descriptionID = tes3ui.registerID("Mer_ScenarioSelectorDescription")
local locationDropdownBlockID = tes3ui.registerID("Mer_ScenarioSelectorLocationDropdownBlock")
local common = require("mer.chargenScenarios.common")
local logger = common.createLogger("ScenarioSelector")

--[[
    ScenarioSelector Menu. UI only, game logic handled
    by events
]]

local function createHeading(parent)
    --HEADING
    local title = parent:createLabel{
        id = tes3ui.registerID("Mer_ScenarioSelectorMenu_heading"),
        text = "Select your Scenario:"
    }
    title.color = tes3ui.getPalette("header_color")
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
    scenarioListBlock.heightProportional = 1.0
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

---@param scenario ChargenScenariosScenario
local function onClickScenario(scenario)
    logger:debug("Clicked Scenario %s", scenario.name)
    local menu = tes3ui.findMenu(menuId)
    if not menu then return end
    local header = menu:findChild(descriptionHeaderID)
    header.text = scenario.name

    local description = menu:findChild(descriptionID)
    description.text = string.format("%s\n\n%s", scenario.description,
        scenario.requirements:getDescription())

    local okayButton = menu:findChild(tes3ui.registerID("Mer_ScenarioSelectorMenu_okayButton"))

    local scenarioValid = scenario:checkRequirements()

    if not scenarioValid then
        header.color = tes3ui.getPalette("disabled_color")
        okayButton.widget.state = 2
        okayButton.disabled = true

    else
        header.color = tes3ui.getPalette("header_color")
        okayButton.widget.state = 1
        okayButton.disabled = false
    end

    local locationDropdownBlock = menu:findChild(locationDropdownBlockID)
    locationDropdownBlock:destroyChildren()

    local validLocations = scenario:getValidLocations()
    if scenarioValid and #validLocations > 1 then

        local button = locationDropdownBlock:createButton{ text = "Location: " .. scenario:getStartingLocation():getName()}
        button:register("mouseClick", function()
            local selectLocationMenu = tes3ui.createMenu{ id = tes3ui.registerID("Mer_SelectLocationMenu"), fixedFrame = true }
            tes3ui.enterMenuMode(selectLocationMenu.id)
            local outerBlock = selectLocationMenu:createBlock()
            outerBlock.flowDirection = "top_to_bottom"
            outerBlock.autoHeight = true
            outerBlock.autoWidth = true

            local heading = outerBlock:createLabel{ text = "Select Location:"}
            heading.color = tes3ui.getPalette("header_color")

            local currentLocationText = outerBlock:createLabel{ text = scenario:getStartingLocation():getName()}

            local locationListBlock = outerBlock:createVerticalScrollPane{}
            local rowHeight = 23
            locationListBlock.minHeight = math.clamp(#validLocations * rowHeight, rowHeight*2, rowHeight*14)
            locationListBlock.minWidth = 300
            locationListBlock.autoWidth = true
            locationListBlock.paddingAllSides = 4
            locationListBlock.borderRight = 6

            for _, location in ipairs(validLocations) do
                local locationButton = locationListBlock:createTextSelect{
                    text = location:getName(),
                    id = tes3ui.registerID("locationButton_" .. location:getName())
                }
                locationButton.autoHeight = true
                locationButton.widthProportional = 1.0
                locationButton.paddingAllSides = 2
                locationButton.borderAllSides = 2
                locationButton:register("mouseClick", function()
                    scenario.decidedLocation = location
                    currentLocationText.text = location:getName()
                    button.text = "Location: " .. location:getName()
                end)
            end

            local buttonsBlock = outerBlock:createBlock()
            buttonsBlock.flowDirection = "left_to_right"
            buttonsBlock.widthProportional = 1.0
            buttonsBlock.autoHeight = true

            --randomise button
            local randomButton = buttonsBlock:createButton{ text = "Random"}
            randomButton:register("mouseClick", function()
                local index = math.random(#validLocations)
                local list = locationListBlock:getContentElement().children
                list[index]:triggerEvent("mouseClick")
            end)

            --okay button
            local okayButton = buttonsBlock:createButton{ text = "Ok"}
            okayButton:register("mouseClick", function()
                selectLocationMenu:destroy()
            end)

            selectLocationMenu:updateLayout()
        end)
    end

    description:updateLayout()
end

local function populateScenarioList(listBlock, list, onScenarioSelected, currentScenario)
    for _, scenario in ipairs(list) do
        if scenario:hasValidLocation() then
            local scenarioButton = listBlock:createTextSelect{
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
            scenarioButton:register("mouseClick", function()
                onClickScenario(scenario)
                onScenarioSelected(scenario)
            end)
            if scenario == currentScenario then
                timer.frame.delayOneFrame(function()
                    logger:debug("Crurent Scenario exists, triggering mouse click")
                    scenarioButton:triggerEvent("mouseClick")
                end)
            end
        else
            logger:warn("Scenario %s has no valid locations", scenario.name)
        end
    end
end

---@param parent tes3uiElement
local function createDescriptionBlock(parent)
    local descriptionBlock = parent:createThinBorder()
    descriptionBlock.heightProportional = 1.0
    descriptionBlock.width = 350
    descriptionBlock.borderRight = 10
    descriptionBlock.flowDirection = "top_to_bottom"
    descriptionBlock.paddingAllSides = 10

    local descriptionHeader = descriptionBlock:createLabel{ id = descriptionHeaderID, text = ""}
    descriptionHeader.color = tes3ui.getPalette("header_color")

    local descriptionText = descriptionBlock:createLabel{id = descriptionID, text = ""}
    descriptionText.wrapText = true
    descriptionText.heightProportional = 1.0


    local locationDropdownBlock = descriptionBlock:createBlock{ id = locationDropdownBlockID}
    locationDropdownBlock.autoHeight = true
    locationDropdownBlock.widthProportional = 1.0
    locationDropdownBlock.childAlignX = 0.5

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

local function createOkButton(parent, onOkayButton)
    local okButton = parent:createButton{ text = "Ok", id = tes3ui.registerID("Mer_ScenarioSelectorMenu_okayButton")}
    okButton.alignX = 1.0
    okButton:register("mouseClick", function()
        tes3ui.findMenu(menuId):destroy()
        onOkayButton()
    end)
    return okButton
end

function ScenarioSelector.createScenarioMenu(e)
    local scenarioList = sortListAlphabetically(table.values(e.scenarioList))
    local onScenarioSelected = e.onScenarioSelected
    local onOkayButton = e.onOkayButton
    local currentScenario = e.currentScenario

    local menu = tes3ui.createMenu{ id = menuId, fixedFrame = true }
    local outerBlock = createOuterBlock(menu)
    --outer block
    createHeading(outerBlock)
    local innerBlock = createInnerBlock(outerBlock)
    --inner block
    local scenarioListBlock = createScenarioListBlock(innerBlock)

    populateScenarioList(scenarioListBlock, scenarioList, onScenarioSelected, currentScenario)
    createDescriptionBlock(innerBlock)
    --Buttons
    local buttonsBlock = createButtonsBlock(outerBlock)
    createRandomiseButton(buttonsBlock, scenarioListBlock)
    createOkButton(buttonsBlock, onOkayButton)

    menu:updateLayout()
    tes3ui.enterMenuMode(menuId)
    scenarioListBlock:getContentElement().children[1]:triggerEvent("mouseClick")
end


return ScenarioSelector


