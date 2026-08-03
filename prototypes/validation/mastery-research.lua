local expected = {
  ["fw-yellow-spectrum-calibration"] = { effects = 1 },
  ["fw-red-spectrum-calibration"] = { effects = 4 },
  ["fw-green-spectrum-calibration"] = { effects = 3 },
  ["fw-unified-spectrum-control"] = { effects = 3 },
  ["fw-spectral-recovery-theory"] = { effects = 1 },
  ["fw-actinide-closure"] = { effects = 7 },
  ["fw-rift-network-synchronization"] = { effects = 1 },
  ["fw-flux-synthesis-mastery"] = { effects = 6, max_level = "infinite" },
  ["fw-spectral-reservoir-density"] = { effects = 1, max_level = 20 },
  ["fw-rift-transfer-harmonics"] = { effects = 1, max_level = "infinite" },
  ["fw-convergence-research"] = { effects = 1, max_level = "infinite" },
  ["fw-shattered-planet-yield"] = { effects = 6, max_level = "infinite" },
}

local seen_icons = {}
for name, contract in pairs(expected) do
  local technology = data.raw.technology and data.raw.technology[name]
  if not technology then error("FluxWorks mastery research is missing " .. name) end
  if #(technology.effects or {}) ~= contract.effects then
    error(name .. " mastery effect coverage drifted: expected " .. contract.effects .. ", got " .. #(technology.effects or {}))
  end
  if contract.max_level and technology.max_level ~= contract.max_level then
    error(name .. " mastery level contract drifted")
  end
  if seen_icons[technology.icon] then
    error(name .. " reuses mastery technology art from " .. seen_icons[technology.icon])
  end
  seen_icons[technology.icon] = name

  for _, effect in ipairs(technology.effects or {}) do
    if effect.type == "change-recipe-productivity" then
      if not (data.raw.recipe and data.raw.recipe[effect.recipe]) then
        error(name .. " improves missing recipe " .. tostring(effect.recipe))
      end
    end
  end
end
