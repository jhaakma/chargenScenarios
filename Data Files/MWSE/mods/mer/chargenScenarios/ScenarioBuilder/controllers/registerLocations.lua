--[[
    To use this
]]
local common = require('mer.chargenScenarios.common')
local function addLocation(locationToAdd, name)
    common.mcmConfig.locations[name] = locationToAdd
    common.log:debug("Storing location: %s", name)
    common.log:debug(json.encode(locationToAdd))
    common.log:debug("player position: ")
    common.log:debug(json.encode(tes3.player.position))
    common.log:debug("player orientation: ")
    common.log:debug(json.encode(tes3.player.orientation))
    common.saveConfig()
end

local function registerLocation()
    local location = {
        position = {
            math.floor(tes3.player.position.x),
            math.floor(tes3.player.position.y),
            math.floor(tes3.player.position.z),
        },
        orientation = {
            math.floor(tes3.player.orientation.x),
            math.floor(tes3.player.orientation.y),
            math.floor(tes3.player.orientation.z),
        },
        cell = tes3.player.cell.id
    }
    timer.delayOneFrame(function()
        local menuId = tes3ui.registerID("Location_Register_Menu")
        local menu = tes3ui.createMenu{ id = menuId, fixedFrame = true }
        menu.minWidth = 400
        menu.alignX = 0.5
        menu.alignY = 0
        menu.autoHeight = true
        local name = { name = ""}
        mwse.mcm.createTextField(
            menu,
            {
                label = "Enter name of location:",
                variable = mwse.mcm.createTableVariable{
                    id = "name",
                    table = name
                },
                callback = function()
                    if common.mcmConfig.locations[name.name] then
                        common.messageBox{
                            message = "Location with this id already exists.",
                            buttons = {
                                {
                                    text = "Overwrite",
                                    callback = function()
                                        addLocation(location, name.name)
                                        tes3ui.leaveMenuMode(menuId)
                                        tes3ui.findMenu(menuId):destroy()
                                    end
                                },
                                {
                                    text = "Rename",
                                    callback = function()
                                        tes3ui.leaveMenuMode(menuId)
                                        tes3ui.findMenu(menuId):destroy()
                                        registerLocation()
                                    end,
                                },
                                {
                                    text = "Cancel",
                                    callback = function()
                                        tes3ui.leaveMenuMode(menuId)
                                        tes3ui.findMenu(menuId):destroy()
                                    end
                                }
                            }
                        }
                    else
                        addLocation(location, name.name)
                        tes3ui.leaveMenuMode(menuId)
                        tes3ui.findMenu(menuId):destroy()
                    end
                end
            }
        )
        tes3ui.enterMenuMode(menuId)
    end)
end




---@param e keyDownEventData
local function onKeyDown(e)
    if common.mcmConfig.registerLocationsEnabled then
        if common.isKeyPressed(e, common.mcmConfig.registerLocationsHotKey) then
            common.messageBox{
                message = "Register current position/orientation/cell as a starting location?",
                buttons = {
                    {
                        text = "Yes",
                        callback = registerLocation
                    },
                    {
                        text = "Cancel"
                    }
                }
            }
        end
    end
end
event.register("keyDown", onKeyDown)

