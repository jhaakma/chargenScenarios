---@class ChargenScenariosSpellList
---@field new function @constructor
---@field doSpells function @Resolves each itemPick and adds it to the player's inventory
---@field spells table<number, ChargenScenariosSpellPick> @the list of spells to add to the player's inventory

local common = require("mer.chargenScenarios.common")
local SpellPick = require("mer.chargenScenarios.component.SpellPick")
--[[
    For specific spells, use "id"
    To pick a random spell from a list, use "ids"
]]

---@type ChargenScenariosSpellList
local SpellList = {
    schema = {
        name = "SpellList",
        fields = {
            spells = { type = "table", childType = SpellPick.schema, required = true },
        }
    }
}

--Constructor
---@param data table<number, ChargenScenariosSpellPickInput>
---@return ChargenScenariosSpellList
function SpellList:new(data)
    local spellList = { spells = table.deepcopy(data)}
    ---validate
    common.validator.validate(spellList, self.schema)
    ---Build
    spellList.spells = common.convertListTypes(spellList.spells, SpellPick)
    setmetatable(spellList, self)
    self.__index = self
    return spellList
end

function SpellList:addSpell(spell)
    local spellPick = SpellPick:new(spell)
    table.insert(self.spells, spellPick)
end

function SpellList:doSpells()
    if self.spells and #self.spells > 0 then
        for _, spell in ipairs(self.spells) do
            common.log:debug("Picking spell")
            local pick = spell:pick()
            common.log:debug("Picked spell: %s", pick.id)
            if pick then
                timer.delayOneFrame(function()
                    common.log:debug("Adding spell %s", pick)
                    tes3.addSpell{
                        reference = tes3.player,
                        spell = pick
                    }
                end)

            end
        end
        return true
    else
        return false
    end
end

return SpellList
