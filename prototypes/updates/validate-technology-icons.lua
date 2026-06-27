local function icon_key(technology)
  if technology.icon then
    return "icon:" .. technology.icon
  end

  if technology.icons then
    local parts = {}
    for index, layer in ipairs(technology.icons) do
      parts[index] = table.concat({
        layer.icon or "",
        tostring(layer.icon_size or ""),
        tostring(layer.scale or ""),
        tostring(layer.shift and layer.shift[1] or ""),
        tostring(layer.shift and layer.shift[2] or ""),
      }, "|")
    end
    return "icons:" .. table.concat(parts, ";")
  end

  return nil
end

local seen = {}

for name, technology in pairs(data.raw.technology or {}) do
  if string.sub(name, 1, 3) == "fw-" then
    local key = icon_key(technology)
    if key then
      local previous = seen[key]
      if previous then
        error("Duplicate FluxWorks technology icon asset usage: " .. previous .. " and " .. name .. " share " .. key)
      end
      seen[key] = name
    end
  end
end
