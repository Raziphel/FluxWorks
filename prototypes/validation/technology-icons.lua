local forbidden_icon_prefixes = {
  "__Krastorio2Assets__/",
}

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
  end
end
