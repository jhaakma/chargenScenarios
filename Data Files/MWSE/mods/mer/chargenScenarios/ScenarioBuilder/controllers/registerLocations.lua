--[[
    To use this
]]
local common = require('mer.chargenScenarios.common')
local logger = common.createLogger("registerLocations")
local Controls = require("mer.chargenScenarios.util.Controls")
local Location = require("mer.chargenScenarios.component.Location")


local luaLocationTemplate = [[
    ["${id}"] = {
        position = {${posx}, ${posy}, ${posz}},
        orientation =${orz},
        cell = "${cell}"
    },
]]


local function addLocation(locationToAdd, name)
    logger:info("Location: ")
    local locationString = luaLocationTemplate:
        gsub("${id}", name):
        gsub("${posx}", locationToAdd.position[1]):
        gsub("${posy}", locationToAdd.position[2]):
        gsub("${posz}", locationToAdd.position[3]):
        gsub("${orz}", locationToAdd.orientation[3])
    if tes3.player.cell.isInterior then
        locationString = locationString:gsub("${cell}", locationToAdd.cell.id)
    else
        locationString = locationString:gsub("${cell}", "nil")
    end
    mwse.log(locationString)
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
        cell = tes3.player.cell
    }
    timer.delayOneFrame(function()
        local menuId = tes3ui.registerID("Location_Register_Menu")
        local menu = tes3ui.createMenu{ id = menuId, fixedFrame = true }
        menu.minWidth = 400
        menu.alignX = 0.5 ---@diagnostic disable-line
        menu.alignY = 0 ---@diagnostic disable-line
        menu.autoHeight = true
        local t = { name = ""}
        mwse.mcm.createTextField(
            menu,
            {
                label = "Enter name of location:",
                variable = mwse.mcm.createTableVariable{
                    id = "name",
                    table = t
                },
                callback = function()
                    if Location.get(t.name) then
                        tes3ui.showMessageMenu{
                            message = "Location with this id already exists.",
                            buttons = {
                                {
                                    text = "Overwrite",
                                    callback = function()
                                        addLocation(location, t.name)
                                        tes3ui.leaveMenuMode()
                                        tes3ui.findMenu(menuId):destroy()
                                    end
                                },
                                {
                                    text = "Rename",
                                    callback = function()
                                        tes3ui.leaveMenuMode()
                                        tes3ui.findMenu(menuId):destroy()
                                        registerLocation()
                                    end,
                                },
                                {
                                    text = "Cancel",
                                    callback = function()
                                        tes3ui.leaveMenuMode()
                                        tes3ui.findMenu(menuId):destroy()
                                    end
                                }
                            }
                        }
                    else
                        addLocation(location, t.name)
                        tes3ui.leaveMenuMode()
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
    if common.config.mcm.registerLocationsEnabled then
        if Controls.isKeyPressed(e, common.config.mcm.registerLocationsHotKey) then
            tes3ui.showMessageMenu{
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

