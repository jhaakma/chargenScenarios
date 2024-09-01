local Location = require("mer.chargenScenarios.component.Location")



local locations = {
    ["vanillaStart"] = {
        orientation = 2,
        position = {33,-87,194},
        cell = "Seyda Neen, Census and Excise Office"
    },

}

for id, location in pairs(locations) do
    Location.register(id, location)
end