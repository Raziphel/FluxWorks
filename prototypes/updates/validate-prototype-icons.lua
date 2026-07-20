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
local forbidden_icon_prefixes = {
  "__base__/",
  "__space-age__/",
  "__quality__/",
  "__elevated-rails__/",
}

local function assert_fluxworks_art(prototype_type, name, prototype)
  local layers = prototype.icons or (prototype.icon and { { icon = prototype.icon } }) or {}
  for _, layer in ipairs(layers) do
    for _, prefix in ipairs(forbidden_icon_prefixes) do
      if string.sub(layer.icon or "", 1, #prefix) == prefix then
        error("FluxWorks identity borrows expansion artwork: " .. prototype_type .. "/" .. name .. " -> " .. layer.icon)
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
      local previous = seen[key]
      if previous then
        error("Duplicate FluxWorks prototype graphic: " .. previous .. " and " .. prototype_type .. "/" .. name)
      end
      seen[key] = prototype_type .. "/" .. name
    end
  end
end
