local add_incomplete = settings.startup["enable-incomplete-rocket-parts"].value

if add_incomplete then
    data.raw.recipe["rocket-part"].ingredients = {
        {type = "item", name = "rocket-fuel", amount = 1},
        {type = "item", name = "incomplete-rocket-part", amount = 1}
    }
    
    table.insert(data.raw.technology["rocket-silo"].effects, {type="unlock-recipe", recipe = "incomplete-rocket-part"})
end


