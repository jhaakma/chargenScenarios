local createTooltip = require("mer.chargenScenarios.util.tooltip")
local function populateButtons(e)
    local buttons = e.buttons
    local buttonsBlock = e.buttonsBlock
    local menu = e.menu
    local startIndex = e.startIndex
    local endIndex = e.endIndex

    buttonsBlock:destroyChildren()

    for i = startIndex, math.min(endIndex, #buttons) do
        local data = buttons[i]
        local doAddButton = true
        if data.showRequirements then
            if data.showRequirements() ~= true then
                doAddButton = false
            end
        end
        if doAddButton then
            --If last button is a Cancel (no callback), register it for Right Click Menu Exit
            local buttonId = tes3ui.registerID("CustomMessageBox_Button")

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
                    tes3ui.leaveMenuMode()
                    menu:destroy()
                end)
            end

            if not disabled and data.tooltip then
                button:register( "help", function()
                    createTooltip(data.tooltip)
                end)
            elseif disabled and data.tooltipDisabled then
                button:register( "help", function()
                    createTooltip(data.tooltipDisabled)
                end)
            end
        end

    end
    menu:updateLayout()
end
local messageBoxId = tes3ui.registerID("CustomMessageBox")

local function messageBox(params)
    local function enable(button)
        button.disabled = false
        button.widget.state = 1
        button.color = tes3ui.getPalette("normal_color")
    end

    local function disable(button)
        button.disabled = true
        button.widget.state = 2
        button.color = tes3ui.getPalette("disabled_color")
    end
    local maxButtonsPerColumn = params.maxButtons or 30
    local message = params.message
    local buttons = params.buttons
    --create menu
    local menu = tes3ui.createMenu{ id = messageBoxId, fixedFrame = true }
    menu:getContentElement().maxWidth = 400
    do
        menu:getContentElement().childAlignX = 0.5
        tes3ui.enterMenuMode(messageBoxId)
        local label = menu:createLabel{id = tes3ui.registerID("Ashfall:MessageBox_Title"), text = message}
        label.wrapText = true
    end

    --create button block
    local buttonsBlock = menu:createBlock()
    do
        buttonsBlock.flowDirection = "top_to_bottom"
        buttonsBlock.autoHeight = true
        buttonsBlock.autoWidth = true
        buttonsBlock.childAlignX = 0.5
    end

    --populate initial buttons
    local startIndex, endIndex = 1, maxButtonsPerColumn
    populateButtons{ buttons= buttons, menu = menu, buttonsBlock = buttonsBlock, startIndex = startIndex, endIndex = endIndex}

    --add next/previous buttons
    if #buttons > maxButtonsPerColumn then
        local arrowButtonsBlock = menu:createBlock()
        arrowButtonsBlock.flowDirection = "left_to_right"
        arrowButtonsBlock.borderTop = 4
        arrowButtonsBlock.autoHeight = true
        arrowButtonsBlock.autoWidth = true

        local prevButton = arrowButtonsBlock:createButton{ text = "<-Prev" }
        disable(prevButton)
        local nextButton = arrowButtonsBlock:createButton{ text = "Next->" }

        prevButton:register("mouseClick", function()
            --move start index back, check if disable prev button
            startIndex = startIndex - maxButtonsPerColumn
            if startIndex <= 1 then
                disable(prevButton)
            end

            --move endIndex back, check if enable next button
            endIndex = endIndex - maxButtonsPerColumn
            if endIndex <= #buttons then
                enable(nextButton)
            end

            populateButtons{ buttons= buttons, menu = menu, buttonsBlock = buttonsBlock, startIndex = startIndex, endIndex = endIndex}
        end)

        nextButton:register("mouseClick", function()
            --move start index forward, check if enable prev  button
            startIndex = startIndex + maxButtonsPerColumn
            if startIndex >= 1 then
                enable(prevButton)
            end

            --move endIndex forward, check if disable next button
            endIndex = endIndex + maxButtonsPerColumn
            if endIndex >= #buttons then
                disable(nextButton)
            end

            populateButtons{ buttons= buttons, menu = menu, buttonsBlock = buttonsBlock, startIndex = startIndex, endIndex = endIndex}
        end)
    end

    -- add cancel button
    if params.doesCancel then
        local buttonId = tes3ui.registerID("CustomMessageBox_CancelButton")
        local cancelButton = menu:createButton{ id = buttonId, text = tes3.findGMST(tes3.gmst.sCancel).value }
        cancelButton:register( "mouseClick", function()
            tes3ui.leaveMenuMode()
            menu:destroy()
            if params.cancelCallback then
                timer.frame.delayOneFrame(params.cancelCallback)
            end
        end)
    end
    menu:updateLayout()
end

return messageBox