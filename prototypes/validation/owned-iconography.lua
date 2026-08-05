local checked_types = {
  "item", "tool", "ammo", "capsule", "module", "armor", "gun",
  "item-with-entity-data", "item-with-tags", "selection-tool",
  -- Crafting tabs intentionally retain the familiar category illustrations
  -- declared by crafting-tab-layout.lua.
  "recipe", "technology", "fluid", "resource", "lightning",
}

local borrowed_prefixes = {
  "__base__/graphics/",
  "__space-age__/graphics/",
}

-- Harvester conversions deliberately use the destination item's icon. They are
-- conversions, not new materials, so replacing familiar ore art with a custom
-- crushed or processed variant makes the recipe misleading.
local harvester_conversion_recipes = {}
local harvester_chain = {
  "coal", "copper-ore", "iron-ore", "lead-ore", "tin-ore",
  "bauxite-ore", "silicon-ore", "titanium-ore", "uranium-ore",
}
for index = 1, #harvester_chain - 1 do
  local from = harvester_chain[index]
  local to = harvester_chain[index + 1]
  harvester_conversion_recipes["fw-" .. from .. "-to-" .. to] = true
  harvester_conversion_recipes["fw-" .. to .. "-to-" .. from] = true
end

local function assert_owned(name, icon, allow_borrowed)
  if allow_borrowed then
    return
  end
  for _, prefix in ipairs(borrowed_prefixes) do
    if string.sub(icon or "", 1, #prefix) == prefix then
      error("FluxWorks player-facing prototype borrows vanilla iconography: " .. name .. " -> " .. icon)
    end
  end
end

for _, prototype_type in ipairs(checked_types) do
  for name, prototype in pairs(data.raw[prototype_type] or {}) do
    if string.sub(name, 1, 3) == "fw-" then
      local allow_borrowed = prototype_type == "recipe" and harvester_conversion_recipes[name]
      assert_owned(prototype_type .. "/" .. name, prototype.icon, allow_borrowed)
      for _, layer in ipairs(prototype.icons or {}) do
        assert_owned(prototype_type .. "/" .. name, layer.icon, allow_borrowed)
      end
    end
  end
end
