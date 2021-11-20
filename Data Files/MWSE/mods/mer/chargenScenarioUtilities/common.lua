local this  = {}
this.config = require("mer.chargenScenarioUtilities.config")
local modName = this.config.modName
---@type table
this.mcmConfig = mwse.loadConfig(this.config.modName, this.config.mcmDefaultValues)
this.registeredScenarios = {}

local logLevel = this.mcmConfig.logLevel
mwse.log("Setting up Logger with name %s", modName)
local logger = require("mer.chargenScenarios.util.logger")

this.log = logger.new{
    name = modName,
    logLevel = logLevel
}

function this.saveConfig()
    mwse.saveConfig(modName, this.mcmConfig)
end

local messageBoxId = tes3ui.registerID("CustomMessageBox_")
function this.messageBox(params)
    --[[
        button =
    ]]--
    local header = params.header
    local message = params.message
    local buttons = params.buttons
    local sideBySide = params.sideBySide

    local menu = tes3ui.createMenu{ id = messageBoxId, fixedFrame = true }
    menu:getContentElement().childAlignX = 0.5
    tes3ui.enterMenuMode(messageBoxId)
    if header then
        local headerLabel = menu:createLabel{id = tes3ui.registerID("SS20:MessageBox_Title"), text = header}
        headerLabel.color = tes3ui.getPalette("header_color")
    end
    if message then
        local messageLabel = menu:createLabel{id = tes3ui.registerID("SS20:MessageBox_Title"), text = message}
        messageLabel.wrapText = true
    end
    local buttonsBlock = menu:createBlock()
    buttonsBlock.borderTop = 4
    buttonsBlock.autoHeight = true
    buttonsBlock.autoWidth = true
    if sideBySide then
        buttonsBlock.flowDirection = "left_to_right"
    else
        buttonsBlock.flowDirection = "top_to_bottom"
        buttonsBlock.childAlignX = 0.5
    end
    for i, data in ipairs(buttons) do
        local doAddButton = true
        if data.showRequirements then
            if data.showRequirements() ~= true then
                doAddButton = false
            end
        end
        if doAddButton then
            --If last button is a Cancel (no callback), register it for Right Click Menu Exit
            local buttonId = tes3ui.registerID("CustomMessageBox_Button")
            if data.doesCancel then
                buttonId = tes3ui.registerID("CustomMessageBox_CancelButton")
            end

            local button = buttonsBlock:createButton{ id = buttonId, text = data.text}

            local disabled = false
            if data.requirements then
                if data.requirements() ~= true then
                    disabled = true
                end
            end

            if disabled then
                button.widget.state = 2
            else
                button:register( "mouseClick", function()
                    if data.callback then
                        data.callback()
                    end
                    menu:destroy()
                    tes3ui.leaveMenuMode()
                end)
            end

            if not disabled and data.tooltip then
                button:register( "help", function()
                    this.createTooltip(data.tooltip)
                end)
            elseif disabled and data.tooltipDisabled then
                button:register( "help", function()
                    this.createTooltip(data.tooltipDisabled)
                end)
            end
        end
    end
end

--Generic Tooltip with header and description
function this.createTooltip(e)
    local thisHeader, thisLabel = e.header, e.text
    local tooltip = tes3ui.createTooltipMenu()

    local outerBlock = tooltip:createBlock()
    outerBlock.flowDirection = "top_to_bottom"
    outerBlock.paddingTop = 6
    outerBlock.paddingBottom = 12
    outerBlock.paddingLeft = 6
    outerBlock.paddingRight = 6
    outerBlock.maxWidth = 300
    outerBlock.autoWidth = true
    outerBlock.autoHeight = true

    if thisHeader then
        local headerText = thisHeader
        local headerLabel = outerBlock:createLabel({ text = headerText })
        headerLabel.autoHeight = true
        headerLabel.width = 285
        headerLabel.color = tes3ui.getPalette("header_color")
        headerLabel.wrapText = true
        --header.justifyText = "center"
    end
    if thisLabel then
        local descriptionText = thisLabel
        local descriptionLabel = outerBlock:createLabel({ text = descriptionText })
        descriptionLabel.autoHeight = true
        descriptionLabel.width = 285
        descriptionLabel.wrapText = true
    end

    tooltip:updateLayout()
end

return this