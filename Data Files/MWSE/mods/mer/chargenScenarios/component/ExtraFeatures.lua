
---@class ChargenScenarios.ExtraFeatures
local ExtraFeatures = {
    registeredFeatures = {}
}

---@class ChargenScenarios.ExtraFeature.callbackParams
---@field goBack fun(success: boolean) call this in a back button to return to Extra Features Menu

---@class ChargenScenarios.ExtraFeature
---@field id string
---@field name string
---@field getTooltip? fun():string? -- Shown in tooltip on the Finalise menu
---@field showFeature? fun():boolean -- function to call to determine if the feature should be shown
---@field callback fun(e: ChargenScenarios.ExtraFeature.callbackParams) -- function to call when the feature is selected
---@field onStart fun() -- function to call when the feature is selected and the game starts
---@field isActive fun():boolean

---@param feature ChargenScenarios.ExtraFeature
function ExtraFeatures.registerFeature(feature)
    assert(feature.id, "No id provided")
    assert(feature.name, "No name provided")
    assert(feature.callback, "No callback provided")
    assert(ExtraFeatures.registeredFeatures[feature.id] == nil, "Feature already registered")
    ExtraFeatures.registeredFeatures[feature.id] = feature
end

---@return ChargenScenarios.ExtraFeature[] activeFeatures
function ExtraFeatures.getActiveFeatures()
    local available = ExtraFeatures.getAvailableFeatures()
    local activeFeatures = {}
    for _, feature in pairs(available) do
        if feature.isActive == nil or feature:isActive() then
            table.insert(activeFeatures, feature)
        end
    end
    table.sort(activeFeatures, function(a, b)
        return a.name < b.name
    end)
    return activeFeatures
end

---@return ChargenScenarios.ExtraFeature[] activeFeatures
function ExtraFeatures.getAvailableFeatures()
    local activeFeatures = {}
    for _, feature in pairs(ExtraFeatures.registeredFeatures) do
        if feature.showFeature == nil or feature:showFeature() then
            table.insert(activeFeatures, feature)
        end
    end
    table.sort(activeFeatures, function(a, b)
        return a.name < b.name
    end)
    return activeFeatures
end

---@return tes3ui.showMessageMenu.params.button[]
function ExtraFeatures.getFeatureButtons(okCallback)
    local buttons = {}
    local activeFeatures = ExtraFeatures.getAvailableFeatures()
    for _, feature in pairs(activeFeatures) do
        ---@type tes3ui.showMessageMenu.params.button
        local button = {
            text = feature.name,
            callback = function()
                feature.callback{
                    goBack = function(success)
                        ExtraFeatures.openMenu{
                            okCallback = okCallback,
                        }
                    end,
                }
            end,
        }
        table.insert(buttons, button)
    end
    table.insert(buttons, {
        text = "Ok",
        callback = okCallback,
    })
    return buttons
end

function ExtraFeatures.openMenu(e)
    local availableFeatures = ExtraFeatures.getAvailableFeatures()
    local featureButtons = ExtraFeatures.getFeatureButtons(e.okCallback)
    if #availableFeatures == 0 then
        featureButtons = {
            {
                text = "No extra features available",
                callback = e.okCallback,
            },
        }
    elseif #availableFeatures == 1 then
        availableFeatures[1].callback{
            goBack = function(success)
                e.okCallback()
            end,
        }
    else
        tes3ui.showMessageMenu{
            header = "Extra Features",
            buttons = featureButtons,
        }
    end
end

function ExtraFeatures.onStart()
    for _, feature in pairs(ExtraFeatures.registeredFeatures) do
        if feature.onStart then
            feature.onStart()
        end
    end
end

function ExtraFeatures.getTooltip()
    local tooltip = ""
    local activeFeatures = ExtraFeatures.getActiveFeatures()
    for _, feature in pairs(activeFeatures) do
        local featureTooltip = feature.getTooltip and feature.getTooltip()
        if featureTooltip then
            tooltip = tooltip .. featureTooltip .. "\n"
        end
    end
    if tooltip == "" then
        tooltip = "No extra features selected."
    else
        --remove last newline
        tooltip = tooltip:sub(1, -2)
    end
    return {
        header = "Extra Features",
        description = tooltip,
    }
end

return ExtraFeatures