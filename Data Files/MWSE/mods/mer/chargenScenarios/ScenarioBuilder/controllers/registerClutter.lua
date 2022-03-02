--[[
    Perform a tes3.rayTest and get the object the player
    is looking at. Ask the player if they want to
    register that object as clutter associated
    with either a location or a scenario
]]
local common = require('mer.chargenScenarios.common')
local clutterGroups = common.mcmConfig.registeredClutterGroups
local currentClutterGroup



local function addClutter(clutterData)
    assert(currentClutterGroup)
    table.insert(clutterGroups[currentClutterGroup], clutterData)
    common.saveConfig()
end

local function addClutterGroup(name)
    clutterGroups[name] = {}
    currentClutterGroup = name
    tes3.messageBox(string.format("Added Clutter Group: ", name))
    common.saveConfig()
end


local function selectClutterGroup()
    local menuId = tes3ui.registerID("ClutterGroup_Select_Menu")
    local menu = tes3ui.createMenu{ id = menuId, fixedFrame = true }
    menu.minWidth = 400
    menu.alignX = 0.5
    menu.alignY = 0
    menu.autoHeight = true
    local titleLabel = menu:createLabel{ text = "Select Clutter Group" }
    local listBlock = menu:createBlock()
    listBlock.autoHeight = true
    listBlock.widthProportional = 1.0
    listBlock.flowDirection = "top_to_bottom"
    for name, _ in pairs(clutterGroups) do
        local button = listBlock:createTextSelect{ text = name }
        button.widthProportional = 1.0
        button:register("mouseClick", function()
            currentClutterGroup = name
            tes3ui.leaveMenuMode(menuId)
            tes3ui.findMenu(menuId):destroy()
        end)
    end
end

local function createClutterGroupPrompt()
    local menuId = tes3ui.registerID("ClutterGroup_Register_Menu")
    local menu = tes3ui.createMenu{ id = menuId, fixedFrame = true }
    menu.minWidth = 400
    menu.alignX = 0.5
    menu.alignY = 0
    menu.autoHeight = true
    local nameTable = {}
    mwse.mcm.createTextField( menu,  {
        label = 'Enter name of group:',
        variable = mwse.mcm.createTableVariable {
            id = 'name',
            table = nameTable
        },
        callback = function()
            local name = nameTable.name:lower()
            if common.mcmConfig.registeredClutterGroups[name] then
                common.messageBox {
                    message = 'Clutter Group already exists.',
                    buttons = {
                        {
                            text = 'Back',
                            callback = function()
                                createClutterGroupPrompt()
                                tes3ui.leaveMenuMode(menuId)
                                tes3ui.findMenu(menuId):destroy()
                            end
                        }
                    }
                }
            else
                addClutterGroup(name)
                tes3ui.leaveMenuMode(menuId)
                tes3ui.findMenu(menuId):destroy()
            end
        end
    })
end

local function getClutterData(reference)
    return {
        reference = reference.baseObject.id:lower(),
        position = {
            math.round(reference.position.x, 2),
            math.round(reference.position.y, 2),
            math.round(reference.position.z, 2),
        },
        orientation = {
            math.round(reference.orientation.x, 2),
            math.round(reference.orientation.y, 2),
            math.round(reference.orientation.z, 2),
        },
        cell = reference.cell.id
    }
end

local function registerClutterPrompt()
    --cast rayTest from the player's eyes
    local result =
        tes3.rayTest {
        position = tes3.getPlayerEyePosition(),
        direction = tes3.getPlayerEyeVector(),
        maxDistance = tes3.getPlayerActivationDistance(),
        ignore = tes3.player
    }
    if result and result.reference then
        local clutterData = getClutterData(result.reference)
        local title = 'No Clutter Group Selected'
        if currentClutterGroup then
            title = string.format('Current Clutter Group: %s', currentClutterGroup)
        end
        common.messageBox {
            message = title,
            buttons = {
                {
                    text = string.format('Add to %s', currentClutterGroup or "Clutter Group"),
                    callback = function()
                        addClutter(clutterData)
                    end,
                    requirements = function()
                        return currentClutterGroup ~= nil
                    end,
                    tooltipDisabled = 'Create or select a clutter group first'
                },
                {
                    text = 'Create New Clutter Group',
                    callback = function()
                        createClutterGroupPrompt()
                    end
                },
                {
                    text = 'Select Clutter Group',
                    callback = function()
                        selectClutterGroup()
                    end
                },
                {
                    text = 'Cancel'
                }
            }
        }
    end
end

---@param e keyDownEventData
local function onKeyDown(e)
    if common.mcmConfig.registerLocationsEnabled then
        if common.isKeyPressed(e, common.mcmConfig.registerClutterHotKey) then
            registerClutterPrompt()
        end
    end
end
event.register('keyDown', onKeyDown)
