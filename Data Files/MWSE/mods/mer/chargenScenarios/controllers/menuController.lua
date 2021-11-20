local common = require('mer.chargenScenarios.common')
local scenarioSelector = require('mer.chargenScenarios.controllers.scenarioSelector')
local scenarioButtonId = tes3ui.registerID('chargenScenariosMenuButton')
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


local function createScenarioButton(parent)
    local block = parent:createBlock()
    block.widthProportional = 1.0
    block.autoHeight = true

    local scenarioLabel
    local button = block:createButton{ text = "Scenario"}
    button:register("mouseClick", function()
        parent:getTopLevelMenu():destroy()
        scenarioSelector.openScenarioSelector()
    end)

    local scenarioName = tes3.player.tempData.selectedChargenScenario and tes3.player.tempData.selectedChargenScenario.name or ""
    scenarioLabel = block:createLabel{
        id = tes3ui.registerID(scenarioButtonId),
        text = scenarioName
    }
    scenarioLabel.absolutePosAlignX = 1
    scenarioLabel.absolutePosAlignY = 0.5
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

    --Add scenario button
    createScenarioButton(parent)
    local okButton = menu:findChild("MenuStatReview_Okbutton")
    okButton:register("mouseClick", function(eMouseClick)
        if hasCompletedChargen() then
            okButton:forwardEvent(eMouseClick)
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

    common.log:debug("Enter RaceSex Menu")
    local okButton = e.element:findChild("MenuRaceSex_Okbutton")
    --hide back button
    e.element:findChild("MenuRaceSex_Backbutton").visible = false
    okButton:register("mouseClick", function(eMouseClick)
        common.log:debug("Clicked ok button, returning to stat review menu")
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
    common.log:debug("Enter CreateClass Menu")
    local okButton = e.element:findChild("MenuCreateClass_Okbutton")
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
    common.log:debug("Enter ChooseClass Menu")
    local okButton = e.element:findChild("MenuChooseClass_Okbutton")
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

    common.log:debug("Enter BirthSign Menu")
    local okButton = e.element:findChild("MenuBirthSign_Okbutton")
    --hide back button
    e.element:findChild("MenuBirthSign_Backbutton").visible = false
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
    common.log:debug("Enter Name Menu")
    local okButton = menu:findChild("MenuName_OkNextbutton")
    okButton:register("mouseClick", function(eMouseClick)
        common.log:debug("Clicked okNext button, returning to stat review menu")
        --trigger the stat review menu
        okButton:forwardEvent(eMouseClick)
        tes3.player.tempData.chargenScenariosNameChosen = true
        scenarioSelector.openScenarioSelector()
    end)

    --Prepopulate name option based on player race
    --if Name Generator mod is installed
    if raceBlockNames then
        common.log:debug("Come on man, global variables?")
        local race = tes3.player.object.race.name
        common.log:debug("Race: %s", race)
        for _, textSelect in ipairs(raceBlockNames:getContentElement().children) do
            common.log:debug(textSelect.text)
            if string.find(textSelect.text:lower(), race:lower()) then
                common.log:debug("Selecting %s", race)
                textSelect:triggerEvent("mouseClick")
                raceBlockNames.widget:contentsChanged()
                local generateButton = okButton.parent.children[1]
                if generateButton then
                    common.log:debug("Generating a random name")
                    generateButton:triggerEvent("mouseClick")
                end
                return
            end
        end
    end
end
event.register("uiActivated", modifyNameMenu, { filter = "MenuName", priority = -10})