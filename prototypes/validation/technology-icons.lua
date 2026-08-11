local forbidden_icon_prefixes = {
  "__Krastorio2Assets__/",
  "__aai-industry__/",
}

local seen_active_icons = {}

for name, technology in pairs(data.raw.technology or {}) do
  if string.sub(name, 1, 3) == "fw-" then
    local layers = technology.icons or (technology.icon and { { icon = technology.icon } }) or {}
    if #layers == 0 then
      error("FluxWorks technology has no explicit visual identity: " .. name)
    end
    if #layers > 1 then
      error("FluxWorks technology uses pasted-on icon overlays: " .. name)
    end

    for _, layer in ipairs(layers) do
      for _, prefix in ipairs(forbidden_icon_prefixes) do
        if string.sub(layer.icon or "", 1, #prefix) == prefix then
          error("FluxWorks technology still depends on removed third-party artwork: "
            .. name .. " -> " .. layer.icon)
        end
      end
    end

    if technology.hidden ~= true and technology.enabled ~= false then
      local icon = layers[1].icon
      local previous = icon and seen_active_icons[icon]
      if previous then
        error("Active FluxWorks technologies share one graphic: " .. previous .. " and " .. name .. " -> " .. icon)
      end
      if icon then seen_active_icons[icon] = name end
    end
  end
end
