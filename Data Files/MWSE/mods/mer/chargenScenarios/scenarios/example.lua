
local interop = require('mer.chargenScenarios.interop')

interop.registerRandomlist{
    type = "location",
    listId = "randomTavern",
    list = {
        {
            position = {61, 135, 24},
            orientation = {0, 0, 340},
            cell = "Ald-ruhn, Ald Skar Inn"
        },
        {
            position = {61, 135, 24},
            orientation = {0, 0, 340},
            cell = "Pelagiad, Halfway Tavern"
        }
    }
}

interop.registerRandomList{
    type = "object",
    listId = "randomBooze",
    list = {
        "potion_local_brew_01",
        "potion_comberry_brandy_01",
        "potion_comberry_wine_01",
        "potion_local_liquor_01",
        "potion_cyro_whiskey_01",
        "potion_cyro_brandy_01",
        "potion_nord_mead",
    }
}

interop.registerScenario{
    name = "Patron",
    description = "Begin the game as a patron in a random tavern.",
    location = "randomTavern",
    journal = {
        --TODO
        --For adding a starting quest
    },
    items = {
        { id = "randomBooze", count = 3 }
    }
}

