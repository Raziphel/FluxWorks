local program=require("prototypes.overhaul.independent-programs")
local sw=(settings.startup or {})["fw-industrial-programs"]
local enabled=not(sw and sw.value==false)
local techs=data.raw.technology or {}
local recipes=data.raw.recipe or {}
local count=0
for _,g in ipairs(program.groups) do
  local name="fw-industrial-program-"..g.key
  local tech=techs[name]
  if enabled and tech then
    assert(tech.icons and tech.icons[1] and tech.icons[1].icon:find("fw-program-",1,true),
      "Independent research lost program artwork: "..name)
    assert((tech.prerequisites or {})[1]==g.prerequisite,"Program missing source field: "..name)
    for _,spec in ipairs(g.processes) do
      local recipe_name=name.."-"..spec.id
      local recipe=recipes[recipe_name]
      if recipe then
        assert(recipe.enabled==false and recipe.allow_productivity==false,
          "Industrial program cannot bypass research: "..recipe_name)
        assert(#(recipe.ingredients or {})<=6,"Industrial program too broad: "..recipe_name)
        local fluids=0
        for _,ingredient in ipairs(recipe.ingredients or {}) do
          assert(ingredient.amount and ingredient.amount>0,"Invalid source amount: "..recipe_name)
          if ingredient.type=="fluid" then fluids=fluids+1 end
        end
        assert(fluids<=2,"Industrial program exceeds physical fluid ports: "..recipe_name)
        local has_unlock=false
        for _,effect in ipairs(tech.effects or {}) do
          if effect.type=="unlock-recipe" and effect.recipe==recipe_name then
            has_unlock=true
          end
        end
        assert(has_unlock,"Industrial research missing process unlock: "..recipe_name)
        count=count+1
      end
    end
  end
end
if not enabled then assert(count==0,"Program recipes present while setting disabled") end
log("FluxWorks standalone: validated "..count.." industrial program processes")
return true
