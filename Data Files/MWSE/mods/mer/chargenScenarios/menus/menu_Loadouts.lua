--[[
    Gear Selector Menu

    - Show each gear list as checkboxes
]]

local common = require("mer.chargenScenarios.common")
local logger = common.createLogger("LoadoutsMenu")
local ChargenMenu = require("mer.chargenScenarios.component.ChargenMenu")
local ItemList = require("mer.chargenScenarios.component.ItemList")
local Menu = require("mer.chargenScenarios.util.Menu")
local LoadoutUI = require("mer.chargenScenarios.util.Loadout")
local Loadouts = require("mer.chargenScenarios.component.Loadouts")


---@class ChargenScenarios.LoadoutsMenu
local LoadoutsMenu = {
    MENU_ID = "ChargenScenarios:LoadoutsMenu",
    LOADOUT_LIMIT_LABEL_ID = "ChargenScenarios_LoadoutsMenu_limitLabel",
}

---@type ChargenScenarios.ChargenMenu.config
local menu = {
    id = "loadoutsMenu",
    name = "Loadouts",
    priority = -1500,
    buttonLabel = "Items",
    getButtonValue = function(self)
        return "Select Starting Gear"
    end,
    createMenu = function(self)
        LoadoutsMenu.open{
            okCallback = function()
                self:okCallback()
            end
        }
    end,
    onStart = function(self)
        timer.start{
            duration = 0.5,
            callback = function()
                Loadouts.doItems()
                Loadouts.equipBestItemForEachSlot()
                Loadouts.addAndEquipCommonClothing()
            end
        }
    end
}
ChargenMenu.register(menu)

local function getNumActiveLoadouts(loadouts)
    local active = 0
    for _, itemList in ipairs(loadouts) do
        if itemList.active and not itemList.defaultActive then
            active = active + 1
        end
    end
    return active
end

local function updateLimitLabel(loadouts)
    local limit = common.config.mcm.itemPackageLimit
    local activeLoadouts = getNumActiveLoadouts(loadouts)
    local text = string.format("Active Loadouts: %s/%s", activeLoadouts, limit)
    local label = tes3ui.findMenu(LoadoutsMenu.MENU_ID):findChild(LoadoutsMenu.LOADOUT_LIMIT_LABEL_ID)
    label.text = text
end

---@param e { parent: tes3uiElement, loadouts: ChargenScenarios.ItemList[] }
local function createLimitLabel(e)
    local subheading = Menu.createSubheading{
        parent = e.parent,
        id = LoadoutsMenu.LOADOUT_LIMIT_LABEL_ID,
        text = "Active Loadouts: 0/3"
    }
    updateLimitLabel(e.loadouts)
    return subheading
end


---Sorts lists with defaultActive first, then alphabetically
---@param a ChargenScenarios.ItemList
---@param b ChargenScenarios.ItemList
local function sortLoadouts(a, b)
    if a.defaultActive == b.defaultActive then
        return a.name < b.name
    else
        return a.defaultActive
    end
end

---@param e { parent: tes3uiElement, loadouts: ChargenScenarios.ItemList[] }
local function createLoadoutList(e)
    local scrollPane = e.parent:createVerticalScrollPane{
        id = "ChargenScenarios_LoadoutsMenu_scrollPane",
    }
    scrollPane.minHeight = 400
    scrollPane.widthProportional = 1.0
    scrollPane.heightProportional = nil

    local canClick = function(itemList)
        local limit = common.config.mcm.itemPackageLimit
        local active = getNumActiveLoadouts(e.loadouts)
        if itemList.active then return true end
        return active < limit
    end

    local onClick = function()
        updateLimitLabel(e.loadouts)
    end

    table.sort(e.loadouts, sortLoadouts)
    for _, itemList in ipairs(e.loadouts) do
        LoadoutUI.createLoadoutRow{
            parent = scrollPane,
            itemList = itemList,
            canClick = canClick,
            onClick = onClick,
        }
    end
end

---@param e {scenario: ChargenScenariosScenario, okCallback: function}
function LoadoutsMenu.open(e)
    logger:debug("Opening Loadouts Menu")

    local loadouts = Loadouts.getLoadouts()
    --for each itemList, if defaultActive then set active to true
    for _, itemList in ipairs(loadouts) do
        itemList.active = itemList.defaultActive
    end

    local menu = tes3ui.createMenu{ id = LoadoutsMenu.MENU_ID, fixedFrame = true }
    local outerBlock = Menu.createOuterBlock{
        id = "ChargenScenarios_LoadoutsMenu_outerBlock",
        parent = menu
    }
    outerBlock.minWidth = 400
    --heading
    Menu.createHeading{
        parent = outerBlock,
        text = "Starting Equipment"
    }
    --subheading - limits
    createLimitLabel{
        parent = outerBlock,
        loadouts = loadouts
    }

    createLoadoutList{
        parent = outerBlock,
        loadouts = loadouts
    }

    local buttonsBlock = Menu.createButtonsBlock{
        id = "ChargenScenarios_LoadoutsMenu_buttonsBlock",
        parent = outerBlock,
    }
    --Ok button
    Menu.createButton{
        id = "ChargenScenarios_LoadoutsMenu_okayButton",
        parent = buttonsBlock,
        text = "Ok",
        callback = function()
            tes3ui.findMenu(LoadoutsMenu.MENU_ID):destroy()
            e.okCallback()
        end
    }

    menu:updateLayout()
end

