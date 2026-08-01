local Recipe = require("__razi_lib__/lib/recipe")
local Tech = require("__razi_lib__/lib/technology")

local add_incomplete = settings.startup["enable-incomplete-rocket-parts"].value

local function has_unlock_effect(effects, recipe_name)
    for _, effect in pairs(effects or {}) do
        if effect.type == "unlock-recipe" and effect.recipe == recipe_name then
            return true
        end
    end
    return false
end

if add_incomplete then
    Recipe:get("rocket-part"):setIngredients({
        {type = "item", name = "rocket-fuel", amount = 1},
        {type = "item", name = "incomplete-rocket-part", amount = 1}
    })

    local rocket_silo_tech = Tech:get("rocket-silo")
    if not has_unlock_effect(rocket_silo_tech.effects, "incomplete-rocket-part") then
        table.insert(rocket_silo_tech.effects, {type = "unlock-recipe", recipe = "incomplete-rocket-part"})
    end
end
