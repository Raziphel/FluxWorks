local prototype_types = {
  "item", "tool", "fluid", "module", "ammo", "capsule", "armor",
}

local function layer_key(layer)
  local shift = layer.shift or {}
  local tint = layer.tint or {}
  return table.concat({
    layer.icon or "",
    tostring(layer.icon_size or ""),
    tostring(layer.scale or ""),
    tostring(shift[1] or ""),
    tostring(shift[2] or ""),
    tostring(tint.r or tint[1] or ""),
    tostring(tint.g or tint[2] or ""),
    tostring(tint.b or tint[3] or ""),
    tostring(tint.a or tint[4] or ""),
  }, "|")
end

local function icon_key(prototype)
  if prototype.icon then
    return "icon:" .. prototype.icon
  end
  local layers = {}
  for index, layer in ipairs(prototype.icons or {}) do
    layers[index] = layer_key(layer)
  end
  return #layers > 0 and ("icons:" .. table.concat(layers, ";")) or nil
end

local seen = {}
local shared_fallback_icons = {
  ["__FluxWorksAssets__/graphics/icons/items/crystallized-flux.png"] = true,
  ["__FluxWorksAssets__/graphics/icons/items/fw-resonance-substrate.png"] = true,
  ["__FluxWorksAssets__/graphics/icons/items/fw-logic-matrix.png"] = true,
  ["__FluxWorksAssets__/graphics/icons/items/fw-model-lattice.png"] = true,
  ["__FluxWorksAssets__/graphics/icons/items/fw-quantum-computer.png"] = true,
  ["__FluxWorksAssets__/graphics/icons/items/fw-thermal-buffer.png"] = true,
  ["__FluxWorksAssets__/graphics/icons/items/fw-control-rod-assembly.png"] = true,
  ["__FluxWorksAssets__/graphics/icons/items/fw-harvester-head.png"] = true,
  ["__FluxWorksAssets__/graphics/icons/items/fluid-memory-storage/fluid-memory-unit.png"] = true,
  ["__FluxWorksAssets__/graphics/icons/items/deep-storage-unit/memory-unit.png"] = true,
}
local forbidden_icon_prefixes = {
  "__Krastorio2Assets__/",
}

local function assert_fluxworks_art(prototype_type, name, prototype)
  local layers = prototype.icons or (prototype.icon and { { icon = prototype.icon } }) or {}
  for _, layer in ipairs(layers) do
    for _, prefix in ipairs(forbidden_icon_prefixes) do
      if string.sub(layer.icon or "", 1, #prefix) == prefix then
        error("FluxWorks identity still depends on removed third-party artwork: " .. prototype_type .. "/" .. name .. " -> " .. layer.icon)
      end
    end
  end
end

for _, prototype_type in ipairs(prototype_types) do
  for name, prototype in pairs(data.raw[prototype_type] or {}) do
    if string.sub(name, 1, 3) == "fw-" then
      assert_fluxworks_art(prototype_type, name, prototype)
      local key = icon_key(prototype)
      if not key then
        error("FluxWorks prototype has no explicit visual identity: " .. prototype_type .. "/" .. name)
      end
      local official_fallback = string.sub(key, 1, #"icon:__base__/") == "icon:__base__/"
        or string.sub(key, 1, #"icon:__space-age__/") == "icon:__space-age__/"
      local shared_fallback = prototype.icon and shared_fallback_icons[prototype.icon]
      local previous = not official_fallback and not shared_fallback and seen[key]
      if previous then
        error("Duplicate FluxWorks prototype graphic: " .. previous .. " and " .. prototype_type .. "/" .. name)
      end
      if not official_fallback and not shared_fallback then
        seen[key] = prototype_type .. "/" .. name
      end
    end
  end
end
