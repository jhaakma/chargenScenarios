
local common = require("mer.chargenScenarios.common")
local logger = common.createLogger("Feature:Curses")
local ExtraFeatures = require("mer.chargenScenarios.component.ExtraFeatures")


---@class ChargenScenarios.CurseFeature.Curse
---@field name string The name of the curse
---@field spellId string? The spell ID of the curse
---@field startScript string? The script to run when the curse is applied
---@field stopScript string? The script to run when the curse is removed

local curses = {
    {
        name = "Lycanthropy",
        spellId = "werewolf blood"
    },
    {
        name = "Vampire (Aundae Clan)",
        spellId = "vampire blood aundae",
        startScript = "vampire_aundae_pc",
    },
    {
        name = "Vampire (Berne Clan)",
        spellId = "vampire blood berne",
        startScript = "vampire_berne_pc",
    },
    {
        name = "Vampire (Quarra Clan)",
        spellId = "vampire blood quarra",
        startScript = "vampire_quarra_pc",
    },
}


---@class ChargenScenarios.CurseFeature
local CurseFeature = {
    ---@type ChargenScenarios.CurseFeature.Curse
    currentCurse = nil,
}

---@param e ChargenScenarios.ExtraFeature.callbackParams
---@return tes3ui.showMessageMenu.params.button
function CurseFeature.createButtonForCurse(e, curse)
    return {
        text = curse.name,
        callback = function()
            logger:debug("Selected curse: %s", curse.name)
            CurseFeature.currentCurse = curse
            CurseFeature.createCurseMenu(e)
        end,
    }
end

---@param e ChargenScenarios.ExtraFeature.callbackParams
function CurseFeature.createCurseMenu(e)
    local buttons = {}
    for _, curse in ipairs(curses) do
        table.insert(buttons, CurseFeature.createButtonForCurse(e, curse))
    end

    table.insert(buttons, {
        text = "Random",
        callback = function()
            local validCurses = table.copy(curses)
            if CurseFeature.currentCurse then
                for i, curse in ipairs(validCurses) do
                    if curse.name == CurseFeature.currentCurse.name then
                        table.remove(validCurses, i)
                        break
                    end
                end
            end
            local randomCurse = validCurses[math.random(#validCurses)]
            logger:debug("Randomly selected curse: %s", randomCurse.name)
            CurseFeature.currentCurse = randomCurse
            CurseFeature.createCurseMenu(e)
        end,
    })

    table.insert(buttons, {
        text = "Reset",
        callback = function()
            logger:debug("Cleared curse")
            CurseFeature.currentCurse = nil
            CurseFeature.createCurseMenu(e)
        end,
    })


    table.insert(buttons, {
        text = "Ok",
        callback = function()
            e.goBack()
        end,
    })

    local currentCurse = CurseFeature.currentCurse
    local message = string.format("Selected: %s", currentCurse and currentCurse.name or "None")

    tes3ui.showMessageMenu{
        header = "Choose a Curse:",
        message = message,
        buttons = buttons,
    }
end

function CurseFeature.onStart()
    local curse = CurseFeature.currentCurse
    if not curse then
        logger:debug("No curse selected")
        return
    end

    logger:debug("Applying curse: %s", curse.name)

    if curse.spellId then
        logger:debug("- Adding spell: %s", curse.spellId)
        tes3.addSpell{
            reference = tes3.player,
            spell = curse.spellId,
        }
    end
    if curse.startScript then
        logger:debug("- Starting script: %s", curse.startScript)
        ---@diagnostic disable-next-line: deprecated
        mwscript.startScript{
            script = curse.startScript,
        }
    end
end

function CurseFeature.getTooltip()
    if not CurseFeature.currentCurse then
        return
    end
    return string.format("Curse: %s", CurseFeature.currentCurse.name)
end

function CurseFeature.isActive()
    return CurseFeature.currentCurse ~= nil
end


---@type ChargenScenarios.ExtraFeature
local feature = {
    id = "curses",
    name = "Vampirism/Lycanthropy",
    callback = CurseFeature.createCurseMenu,
    onStart = CurseFeature.onStart,
    getTooltip = CurseFeature.getTooltip,
    isActive = CurseFeature.isActive,
}
ExtraFeatures.registerFeature(feature)

event.register("loaded", function()
    CurseFeature.currentCurse = nil
end)