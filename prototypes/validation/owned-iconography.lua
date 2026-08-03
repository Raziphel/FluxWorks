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

local function assert_owned(name, icon)
  for _, prefix in ipairs(borrowed_prefixes) do
    if string.sub(icon or "", 1, #prefix) == prefix then
      error("FluxWorks player-facing prototype borrows vanilla iconography: " .. name .. " -> " .. icon)
    end
  end
end

for _, prototype_type in ipairs(checked_types) do
  for name, prototype in pairs(data.raw[prototype_type] or {}) do
    if string.sub(name, 1, 3) == "fw-" then
      assert_owned(prototype_type .. "/" .. name, prototype.icon)
      for _, layer in ipairs(prototype.icons or {}) do
        assert_owned(prototype_type .. "/" .. name, layer.icon)
      end
    end
  end
end
