local common = require('mer.chargenScenarios.common')
local scenarioSelector = require('mer.chargenScenarios.controllers.scenarioSelector')
local scenarioLabelId = tes3ui.registerID('chargenScenariosMenuButtonLabel')
local backgroundLabelId = tes3ui.registerID('chargenScenariosMenuBackgroundLabel')
    --[[
        EnableRaceMenu
        EnableClassMenu
        EnableBirthMenu
        EnableNameMenu
        EnableStatReviewMenu
    ]]


local function returnToStatsMenu()
    tes3.runLegacyScript{ command = "EnableStatReviewMenu"}
end

local function openScenarioMenu()
    scenarioSelector.createScenarioMenu{
        scenarioList = common.registeredScenarios,
        onScenarioSelected = function(scenario)
            common.log:debug("Clicked scenario: %s", scenario.name)
            tes3.player.tempData.selectedChargenScenario = scenario
        end,
        onOkayButton = function()
            common.log:debug("Okay button pressed")
            if tes3.player.tempData.selectedChargenScenario then
                --Return to stat review
                tes3.runLegacyScript{ command = "EnableStatReviewMenu"}
            else
                common.log:error("No scenario selected")
            end
        end,
        currentScenario = tes3.player.tempData.selectedChargenScenario
    }
end

local createTooltip = require("mer.chargenScenarios.util.tooltip")

local function registerTooltip(block, name, description)
    local onTooltip = function()
        createTooltip{
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

    local scenarioName = tes3.player.tempData.selectedChargenScenario and tes3.player.tempData.selectedChargenScenario.name or ""
    createStatsButtonLabel(block, scenarioName)

    local scenarioDescription = tes3.player.tempData.selectedChargenScenario and tes3.player.tempData.selectedChargenScenario.description or ""
    registerTooltip(block, scenarioName, scenarioDescription)
end





local function createBackgroundButton(parent)
    local backgroundsInterop = include('mer.characterBackgrounds.interop')
    if not backgroundsInterop then return end
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
    return tes3.player.tempData.chargenScenariosNameChosen
        and tes3.player.tempData.chargenScenariosRaceChosen
        and tes3.player.tempData.chargenScenariosBirthsignChosen
        and tes3.player.tempData.chargenScenariosClassChosen
        and tes3.player.tempData.selectedChargenScenario
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
        if hasCompletedChargen() then
            okButton:forwardEvent(eMouseClick)
            tes3.runLegacyScript{ script = "RaceCheck" }
            tes3.player.tempData.selectedChargenScenario:start()
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
    local menu = e.element
    --hide back button
    menu:findChild("MenuRaceSex_Backbutton").visible = false
    --OK button should trigger the class menu
    local okButton = menu:findChild("MenuRaceSex_Okbutton")
    okButton:register("mouseClick", function(eMouseClick)
        --trigger the stat review menu
        okButton:forwardEvent(eMouseClick)
        tes3.player.tempData.chargenScenariosRaceChosen = true
        if not tes3.player.tempData.chargenScenariosClassChosen then
            tes3.runLegacyScript{ command = "EnableClassMenu"}
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
    common.log:debug("Enter CreateClass Menu")
    --OK button should trigger the birth sign menu
    local okButton = menu:findChild("MenuCreateClass_Okbutton")
    okButton:register("mouseClick", function(eMouseClick)
        common.log:debug("Clicked ok button, returning to stat review menu")
        --trigger the stat review menu
        okButton:forwardEvent(eMouseClick)
        tes3.player.tempData.chargenScenariosClassChosen = true
        if not tes3.player.tempData.chargenScenariosBirthsignChosen then
            tes3.runLegacyScript{ command = "EnableBirthMenu"}
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
        common.log:debug("Clicked ok button, returning to stat review menu")
        okButton:forwardEvent(eMouseClick)
        tes3.player.tempData.chargenScenariosClassChosen = true
        if not tes3.player.tempData.chargenScenariosBirthsignChosen then
            tes3.runLegacyScript{ command = "EnableBirthMenu"}
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
        common.log:debug("Clicked ok button, returning to stat review menu")
        --trigger the stat review menu
        okButton:forwardEvent(eMouseClick)
        tes3.player.tempData.chargenScenariosBirthsignChosen = true
        if not tes3.player.tempData.chargenScenariosNameChosen then
            tes3.runLegacyScript{ command = "EnableNameMenu"}
        else
            returnToStatsMenu()
        end
    end)
end
event.register("uiActivated", modifyBirthSignMenu, { filter = "MenuBirthSign"})



local function selectRandomName(menu)
    local okButton = menu:findChild("MenuName_OkNextbutton")
    local race = tes3.player.object.race.name
    common.log:debug("Race: %s", race)
    for _, textSelect in ipairs(raceBlockNames:getContentElement().children) do
        common.log:debug(textSelect.text)
        if string.find(textSelect.text:lower(), race:lower()) then
            common.log:debug("Selecting %s", race)
            textSelect:triggerEvent("mouseClick")
            raceBlockNames.widget:contentsChanged()
            local sexButton = menu:findChild("NameGenerator:sexBlock").children[1]
            if sexButton and tes3.player.object.female then
                sexButton:triggerEvent("mouseClick")
            end
            local generateButton = okButton.parent.children[1]
            if generateButton then
                common.log:debug("Generating a random name")
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
        if tes3.player.data.merBackgrounds and not tes3.player.tempData.chargenScenariosNameChosen then
            common.log:debug("Backgrounds is active, opening perks menu")
            timer.delayOneFrame(function()
                event.trigger("CharacterBackgrounds:OpenPerksMenu")
            end)
        else
            common.log:debug("Clicked okNext button, returning to stat review menu")
        end
        tes3.player.tempData.chargenScenariosNameChosen = true
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
    common.log:debug("Background selected, opening scenario menu")
    if not tes3.player.tempData.selectedChargenScenario then
        openScenarioMenu()
    else
        common.log:debug("Scenario already selected, skipping scenario menu")
        returnToStatsMenu()
    end
end
event.register("CharacterBackgrounds:OkayMenuClicked", openScenarioSelectorOnBackgroundsFinish)
