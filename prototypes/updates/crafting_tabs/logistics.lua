return function(Router)
  local set_order = Router.set_order
  local purge_prototype = Router.purge
  local move_item_and_recipe = Router.move_item_and_recipe

for _, name in pairs({
  "transport-belt",
  "fast-transport-belt",
  "express-transport-belt",
  "turbo-transport-belt",
  "underground-belt",
  "fast-underground-belt",
  "express-underground-belt",
  "turbo-underground-belt",
  "splitter",
  "fast-splitter",
  "express-splitter",
  "turbo-splitter",
}) do
  move_item_and_recipe(name, "fw-logistics-transport")
end

for _, entry in pairs({
  { "transport-belt", "a[belts]-a[transport-belt]" },
  { "fast-transport-belt", "a[belts]-b[fast-transport-belt]" },
  { "express-transport-belt", "a[belts]-c[express-transport-belt]" },
  { "turbo-transport-belt", "a[belts]-d[turbo-transport-belt]" },
  { "underground-belt", "a[belts]-e[underground-belt]" },
  { "fast-underground-belt", "a[belts]-f[fast-underground-belt]" },
  { "express-underground-belt", "a[belts]-g[express-underground-belt]" },
  { "turbo-underground-belt", "a[belts]-h[turbo-underground-belt]" },
  { "splitter", "b[splitters]-a[splitter]" },
  { "fast-splitter", "b[splitters]-b[fast-splitter]" },
  { "express-splitter", "b[splitters]-c[express-splitter]" },
  { "turbo-splitter", "b[splitters]-d[turbo-splitter]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "burner-inserter",
  "inserter",
  "long-handed-inserter",
  "fast-inserter",
  "filter-inserter",
  "bulk-inserter",
  "stack-inserter",
  "stack-filter-inserter",
}) do
  move_item_and_recipe(name, "fw-logistics-inserters")
end

for _, entry in pairs({
  { "burner-inserter", "a[inserters]-a[burner-inserter]" },
  { "inserter", "a[inserters]-b[inserter]" },
  { "long-handed-inserter", "a[inserters]-c[long-handed-inserter]" },
  { "fast-inserter", "a[inserters]-d[fast-inserter]" },
  { "filter-inserter", "a[inserters]-e[filter-inserter]" },
  { "bulk-inserter", "b[bulk]-a[bulk-inserter]" },
  { "stack-inserter", "b[bulk]-b[stack-inserter]" },
  { "stack-filter-inserter", "b[bulk]-c[stack-filter-inserter]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "pipe",
  "pipe-to-ground",
  "pump",
  "offshore-pump",
}) do
  move_item_and_recipe(name, "fw-logistics-fluid-handling")
end

for _, entry in pairs({
  { "pipe", "a[pipes]-a[pipe]" },
  { "pipe-to-ground", "a[pipes]-b[pipe-to-ground]" },
  { "pump", "b[pumps]-a[pump]" },
  { "offshore-pump", "b[pumps]-b[offshore-pump]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "rail",
  "locomotive",
  "cargo-wagon",
  "fluid-wagon",
  "artillery-wagon",
  "train-stop",
  "rail-signal",
  "rail-chain-signal",
  "rail-ramp",
  "rail-support",
}) do
  move_item_and_recipe(name, "fw-logistics-rail")
end

for _, entry in pairs({
  { "rail", "a[track]-a[rail]" },
  { "rail-ramp", "a[track]-b[rail-ramp]" },
  { "rail-support", "a[track]-c[rail-support]" },
  { "train-stop", "b[signals]-a[train-stop]" },
  { "rail-signal", "b[signals]-b[rail-signal]" },
  { "rail-chain-signal", "b[signals]-c[rail-chain-signal]" },
  { "locomotive", "c[trains]-a[locomotive]" },
  { "cargo-wagon", "c[trains]-b[cargo-wagon]" },
  { "fluid-wagon", "c[trains]-c[fluid-wagon]" },
  { "artillery-wagon", "c[trains]-d[artillery-wagon]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "wooden-chest",
  "iron-chest",
  "steel-chest",
  "passive-provider-chest",
  "active-provider-chest",
  "storage-chest",
  "buffer-chest",
  "requester-chest",
  "storage-tank",
}) do
  move_item_and_recipe(name, "fw-logistics-storage")
end

for _, entry in pairs({
  { "wooden-chest", "a[solid-storage]-a[wooden-chest]" },
  { "iron-chest", "a[solid-storage]-b[iron-chest]" },
  { "steel-chest", "a[solid-storage]-c[steel-chest]" },
  { "passive-provider-chest", "a[solid-storage]-d[passive-provider]" },
  { "active-provider-chest", "a[solid-storage]-e[active-provider]" },
  { "storage-chest", "a[solid-storage]-f[storage]" },
  { "buffer-chest", "a[solid-storage]-g[buffer]" },
  { "requester-chest", "a[solid-storage]-h[requester]" },
  { "storage-tank", "b[large-storage]-c[storage-tank]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, entry in ipairs({
  { "fw-phase-vault", "a[deep-storage]-a[phase-vault]" },
  { "fw-spectral-reservoir", "a[deep-storage]-b[spectral-reservoir]" },
}) do
  move_item_and_recipe(entry[1], "fw-logistics-deep-storage")
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "small-electric-pole",
  "medium-electric-pole",
  "big-electric-pole",
  "substation",
}) do
  move_item_and_recipe(name, "fw-logistics-power")
end

for _, entry in pairs({
  { "small-electric-pole", "a[power-distribution]-a[small-electric-pole]" },
  { "medium-electric-pole", "a[power-distribution]-b[medium-electric-pole]" },
  { "big-electric-pole", "a[power-distribution]-c[big-electric-pole]" },
  { "substation", "a[power-distribution]-d[substation]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

for _, name in pairs({
  "small-lamp",
  "red-wire",
  "green-wire",
  "constant-combinator",
  "arithmetic-combinator",
  "decider-combinator",
  "selector-combinator",
  "power-switch",
  "programmable-speaker",
  "display-panel",
}) do
  move_item_and_recipe(name, "fw-logistics-circuitry")
end

for _, entry in pairs({
  { "small-lamp", "a[signals]-a[small-lamp]" },
  { "red-wire", "a[signals]-b[red-wire]" },
  { "green-wire", "a[signals]-c[green-wire]" },
  { "constant-combinator", "b[combinators]-a[constant-combinator]" },
  { "arithmetic-combinator", "b[combinators]-b[arithmetic-combinator]" },
  { "decider-combinator", "b[combinators]-c[decider-combinator]" },
  { "selector-combinator", "b[combinators]-d[selector-combinator]" },
  { "power-switch", "c[logic]-a[power-switch]" },
  { "programmable-speaker", "c[logic]-b[programmable-speaker]" },
  { "display-panel", "c[logic]-c[display-panel]" },
}) do
  set_order("item", entry[1], entry[2])
  set_order("recipe", entry[1], entry[2])
end

-- Keep native AAI logistics prototypes in FluxWorks' catalog without copying
-- or renaming them. This also follows future AAI tiers automatically.
local aai_storage_mode_order = {
  ["passive-provider"] = "b[passive-provider]",
  ["active-provider"] = "c[active-provider]",
  storage = "d[storage]",
  buffer = "e[buffer]",
  requester = "f[requester]",
}

local aai_storage_size_order = {
  ["aai-strongbox"] = "a[strongbox]",
  ["aai-storehouse"] = "b[storehouse]",
  ["aai-warehouse"] = "c[warehouse]",
}

local function aai_storage_order(item_name, entity)
  local family
  for candidate, size_order in pairs(aai_storage_size_order) do
    if item_name == candidate or string.sub(item_name, 1, #candidate + 1) == candidate .. "-" then
      family = size_order
      break
    end
  end
  if not family then return nil end

  local mode_order = entity.logistic_mode and aai_storage_mode_order[entity.logistic_mode]
    or "a[passive-storage]"
  return "b[large-storage]-z[aai-storage]-" .. mode_order .. "-" .. family
end

for item_name, item in pairs(data.raw.item or {}) do
  local place_result = item.place_result
  if place_result then
    local is_loader = (data.raw.loader and data.raw.loader[place_result])
      or (data.raw["loader-1x1"] and data.raw["loader-1x1"][place_result])
    local is_storage = (data.raw.container and data.raw.container[place_result])
      or (data.raw["logistic-container"] and data.raw["logistic-container"][place_result])
    if mods["aai-loaders"] and is_loader then
      move_item_and_recipe(item_name, "fw-logistics-transport")
      local order = "b[splitters]-z[aai-loader]-" .. (item.order or item_name)
      set_order("item", item_name, order)
      set_order("recipe", item_name, order)
    elseif mods["aai-containers"] and is_storage then
      local order = aai_storage_order(item_name, is_storage)
      if order then
        move_item_and_recipe(item_name, "fw-logistics-storage")
        set_order("item", item_name, order)
        set_order("recipe", item_name, order)
      end
    end
  end
end
end
