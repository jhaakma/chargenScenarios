local common = require('mer.chargenScenarios.common')
local logger = common.createLogger("chargenMenuController")
local scenarioSelector = require('mer.chargenScenarios.component.ScenarioSelector')
local Scenario = require("mer.chargenScenarios.component.Scenario")
local Tooltip = require("mer.chargenScenarios.util.Tooltip")
local backgroundsInterop = include('mer.characterBackgrounds.interop')

---@return ChargenScenariosScenario?
local function getSelectedScenario()
    return tes3.player.tempData.selectedChargenScenario
end

local function setScenario(scenario)
    tes3.player.tempData.selectedChargenScenario = scenario
end

local function nameChosen()
    return tes3.player.tempData.chargenScenariosNameChosen
end

local function setNameChosen()
    tes3.player.tempData.chargenScenariosNameChosen = true
end

local function raceChosen()
    return tes3.player.tempData.chargenScenariosRaceChosen
end

local function setRaceChosen()
    tes3.player.tempData.chargenScenariosRaceChosen = true
end

local function birthsignChosen()
    return tes3.player.tempData.chargenScenariosBirthsignChosen
end

local function setBirthsignChosen()
    tes3.player.tempData.chargenScenariosBirthsignChosen = true
end

local function classChosen()
    return tes3.player.tempData.chargenScenariosClassChosen
end

local function setClassChosen()
    tes3.player.tempData.chargenScenariosClassChosen = true
end

local characterBackgroundsConfig = include("mer.characterBackgrounds.config")
local function characterBackgroundsActive()
    return backgroundsInterop
        and characterBackgroundsConfig
        and characterBackgroundsConfig.mcm.enableBackgrounds
end

local function openScenarioMenu()
    scenarioSelector.createScenarioMenu{
        scenarioList = Scenario.registeredScenarios,
        onScenarioSelected = function(scenario)
            logger:debug("Clicked scenario: %s", scenario.name)
            setScenario(scenario)
        end,
        onOkayButton = function()
            logger:debug("Okay button pressed")
            if getSelectedScenario() then
                --Return to stat review
                tes3.runLegacyScript{ command = "EnableStatReviewMenu"} ---@diagnostic disable-line
            else
                logger:error("No scenario selected")
            end
        end,
        currentScenario = getSelectedScenario()
    }
end

local function returnToStatsMenu()
    local selectedScenario = getSelectedScenario()
    if selectedScenario and not selectedScenario:checkRequirements() then
        tes3.messageBox("Scenario Requirements no longer met. Please select again.")
        openScenarioMenu()
    else
        tes3.runLegacyScript{ command = "EnableStatReviewMenu"} ---@diagnostic disable-line
    end
end

local function registerTooltip(block, name, description)
    local onTooltip = function()
        Tooltip.createTooltip{
            header = name,
            text = description
        }
    end
    block:register("help", onTooltip)
    for _, element in ipairs(block.children) do
        element:register("help", onTooltip)
    end
end

local function createStatsButtonLabel(parent, name)
    local nameBlock = parent:createBlock()
    nameBlock.paddingLeft = 5
    nameBlock.paddingTop = 5
    nameBlock.autoHeight = true
    nameBlock.widthProportional = 1.0

    local nameLabel = nameBlock:createLabel{ text = name }
    nameLabel.text = name
    nameLabel.wrapText = true
    nameLabel.widthProportional = 1
    nameLabel.justifyText = "right"
end


local function createScenarioButton(parent)
    local block = parent:createBlock()
    block.widthProportional = 1.0
    block.autoHeight = true

    local button = block:createButton{ text = "Scenario"}
    button:register("mouseClick", function()
        parent:getTopLevelMenu():destroy()
        openScenarioMenu()
    end)

    local scenario = getSelectedScenario()
    local scenarioName = scenario and scenario.name or ""
    createStatsButtonLabel(block, scenarioName)

    local scenarioDescription = scenario and scenario.description or ""
    registerTooltip(block, scenarioName, scenarioDescription)
end


local function createBackgroundButton(parent)

    if not characterBackgroundsActive() then return end
    local block = parent:createBlock()
    block.widthProportional = 1.0
    block.autoHeight = true

    local button = block:createButton{ text = "Background"}
    button:register("mouseClick", function()
        tes3ui.leaveMenuMode()
        parent:getTopLevelMenu():destroy()
        timer.delayOneFrame(function()
            event.trigger("CharacterBackgrounds:OpenPerksMenu")
        end)
    end)
    local background = backgroundsInterop.getCurrentBackground()
    createStatsButtonLabel(block, background and background:getName() or "None")
    if background then
        registerTooltip(block, background:getName(), background:getDescription())
    end
end

local function hasCompletedChargen()
    return nameChosen()
        and raceChosen()
        and birthsignChosen()
        and classChosen()
        and getSelectedScenario()
end

--MenuStatReview_Okbutton
--MenuStatReview_BackButton
local function modifyStatReviewMenu(e)
    if (not e.newlyCreated) then
        return
    end

    local menu = e.element
    --hide back button
    menu:findChild("MenuStatReview_BackButton").visible = false
    local parent = menu:findChild("MenuStatReview_birth_layout").parent

    --Adding a button causes clipping so we need make the whole thing a bit bigger
    --This means fucking with a few vanilla menu elements to get it all lined up
    parent.parent.parent.autoHeight = true
    local scrollPane = menu:findChild("MenuStatReview_scroll_pane")
    scrollPane.maxHeight = nil
    scrollPane.parent.heightProportional = 1

    --Add scenario and background button
    createBackgroundButton(parent)
    createScenarioButton(parent)
    --OK button should trigger the scenario to start
    local okButton = menu:findChild("MenuStatReview_Okbutton")
    okButton:register("mouseClick", function(eMouseClick)
        local scenario = getSelectedScenario()
        if scenario and hasCompletedChargen() then
            if not scenario:checkRequirements() then
                tes3.messageBox("Scenario Requirements no longer met. Please select again.")
                menu:destroy()
                openScenarioMenu()
            else
                okButton:forwardEvent(eMouseClick)
                tes3.runLegacyScript{ script = "RaceCheck" } ---@diagnostic disable-line
                scenario:start()
            end
        else
            tes3.messageBox("You must complete the character generation process before you can continue.")
        end
    end)
    menu:updateLayout()
end
event.register("uiActivated", modifyStatReviewMenu, { filter = "MenuStatReview"})

--[[
    When the RaceSex menu is opened, override the Ok button
    to trigger the statReviewMenu again
]]
---@param e uiActivatedEventData
local function modifyRaceSexMenu(e)
    if (not e.newlyCreated) then
        return
    end

    logger:debug("Modifying racesex menu")
    local menu = e.element
    --hide back button
    menu:findChild("MenuRaceSex_Backbutton").visible = false

    --override OK button
    local okButton = menu:findChild("MenuRaceSex_Okbutton")
    okButton:register("mouseClick", function(eMouseClick)
        menu:destroy()

        setRaceChosen()
        if not classChosen() then
            tes3.runLegacyScript{ command = "EnableClassMenu"} ---@diagnostic disable-line
        else
            returnToStatsMenu()
        end
    end)
end
event.register("uiActivated", modifyRaceSexMenu, { filter = "MenuRaceSex"})

--[[
    Class has three different menus, we need to override the Ok and back buttons
    for each one
]]
---@param e uiActivatedEventData
local function modifyClassChoiceMenu(e)
    if (not e.newlyCreated) then
        return
    end

    local menu = e.element
    --Create title and move to top of menu
    local title = menu:createLabel{ text = "Choose Your Class"}
    title.widthProportional = 1.0
    title.justifyText = "center"
    title.wrapText = true
    title.color = tes3ui.getPalette("header_color")
    menu:getContentElement():reorderChildren( 1, -1, 1)
    --hide back button
    e.element:findChild("MenuClassChoice_Backbutton").visible = false
    --hide question button
    menu:findChild("MenuClassChoice_Questionbutton").visible = false
    --Rename text of pick class button to "Pick from Class List"
    menu:findChild("MenuClassChoice_PickClassbutton").text = "Pick from Class List"
    --Rename text of create class button to "Create Custom Class"
    menu:findChild("MenuClassChoice_CreateClassbutton").text = "Create Custom Class"
end
event.register("uiActivated", modifyClassChoiceMenu, { filter = "MenuClassChoice"})

---@param e uiActivatedEventData
local function modifyCreateClassMenu(e)
    if (not e.newlyCreated) then
        return
    end

    local menu = e.element
    logger:debug("Enter CreateClass Menu")
    --OK button should trigger the birth sign menu
    local okButton = menu:findChild("MenuCreateClass_Okbutton")
    okButton:register("mouseClick", function(eMouseClick)
        logger:debug("Clicked ok button, returning to stat review menu")
        --trigger the stat review menu
        okButton:forwardEvent(eMouseClick)
        setClassChosen()
        if not birthsignChosen() then
            tes3.runLegacyScript{ command = "EnableBirthMenu"} ---@diagnostic disable-line
        else
            returnToStatsMenu()
        end
    end)
end
event.register("uiActivated", modifyCreateClassMenu, { filter = "MenuCreateClass"})

---@param e uiActivatedEventData
local function modifyChooseClassMenu(e)
    if (not e.newlyCreated) then
		return
	end

    local menu = e.element
    --OK button should trigger the birth sign menu
    local okButton = menu:findChild("MenuChooseClass_Okbutton")
    okButton:register("mouseClick", function(eMouseClick)
        logger:debug("Clicked ok button, returning to stat review menu")
        okButton:forwardEvent(eMouseClick)
        setClassChosen()
        if not birthsignChosen() then
            tes3.runLegacyScript{ command = "EnableBirthMenu"} ---@diagnostic disable-line
        else
            returnToStatsMenu()
        end
    end)
end
event.register("uiActivated", modifyChooseClassMenu, { filter = "MenuChooseClass"})


--[[
    When the BirthSign menu is opened, override the Ok button
    to trigger the statReviewMenu again
    and hide the back button
]]
---@param e uiActivatedEventData
local function modifyBirthSignMenu(e)
    if (not e.newlyCreated) then
		return
	end

    local menu = e.element
    local okButton = e.element:findChild("MenuBirthSign_Okbutton")
    --hide back button
    menu:findChild("MenuBirthSign_Backbutton").visible = false
    okButton:register("mouseClick", function(eMouseClick)
        logger:debug("Clicked ok button, returning to stat review menu")
        --trigger the stat review menu
        okButton:forwardEvent(eMouseClick)
        setBirthsignChosen()
        if not nameChosen() then
            tes3.runLegacyScript{ command = "EnableNameMenu"} ---@diagnostic disable-line
        else
            returnToStatsMenu()
        end
    end)
end
event.register("uiActivated", modifyBirthSignMenu, { filter = "MenuBirthSign"})


local function selectRandomName(menu)
    local okButton = menu:findChild("MenuName_OkNextbutton")
    local race = tes3.player.object.race.name
    logger:debug("Race: %s", race)
    for _, textSelect in ipairs(raceBlockNames:getContentElement().children) do
        logger:debug(textSelect.text)
        if string.find(textSelect.text:lower(), race:lower()) then
            logger:debug("Selecting %s", race)
            textSelect:triggerEvent("mouseClick")
            raceBlockNames.widget:contentsChanged()
            local sexButton = menu:findChild("NameGenerator:sexBlock").children[1]
            if sexButton and tes3.player.object.female then
                sexButton:triggerEvent("mouseClick")
            end
            local generateButton = okButton.parent.children[1]
            if generateButton then
                logger:debug("Generating a random name")
                if tes3.player.object.name:lower() == "player" then
                    generateButton:triggerEvent("mouseClick")
                else
                    local nameFIeld = menu:findChild(tes3ui.registerID("MenuName_NameSpace"))
                    nameFIeld.text = tes3.player.object.name
                end
            end
            return
        end
    end
end

--[[
    When the name menu is opened, override the Ok button
    to trigger the statReviewMenu again
]]
---@param e uiActivatedEventData
local function modifyNameMenu(e)
    if (not e.newlyCreated) then
		return
	end

    local menu = e.element
    --Ok button should trigger the statReviewMenu
    local okButton = menu:findChild("MenuName_OkNextbutton")
    okButton:register("mouseClick", function(eMouseClick)

        okButton:forwardEvent(eMouseClick)

        --If character backgrounds is installed, trigger the perks menu
        if nameChosen() then
            returnToStatsMenu()
        elseif characterBackgroundsActive() then
            logger:debug("Backgrounds is active, opening perks menu")
            timer.delayOneFrame(function()
                event.trigger("CharacterBackgrounds:OpenPerksMenu")
            end)
        else
            logger:debug("Backgrounds not active, going to scenario menu")
            openScenarioMenu()
        end
        setNameChosen()
    end)

    --Prepopulate name option based on player race
    --if Name Generator mod is installed
    --Only if no name has been chosen yet
    if raceBlockNames then
        selectRandomName(menu)
    end
end
event.register("uiActivated", modifyNameMenu, { filter = "MenuName", priority = -10})


local function openScenarioSelectorOnBackgroundsFinish()
    logger:debug("Background selected, opening scenario menu")
    if not getSelectedScenario() then
        openScenarioMenu()
    else
        logger:debug("Scenario already selected, skipping scenario menu")
        returnToStatsMenu()
    end
end
event.register("CharacterBackgrounds:OkayMenuClicked", openScenarioSelectorOnBackgroundsFinish)
