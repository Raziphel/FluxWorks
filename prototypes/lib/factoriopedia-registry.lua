local Registry = {}
Registry.__index = Registry

function Registry.new(content)
  return setmetatable({
    content = content,
    descriptions = {},
    simulations = {},
  }, Registry)
end

function Registry:set_description(prototype_type, prototype_name, locale_key, locale_section)
  local prototype = data.raw[prototype_type] and data.raw[prototype_type][prototype_name]
  if not prototype then return end

  locale_section = locale_section or "fw-factoriopedia"
  self.descriptions[prototype_type] = self.descriptions[prototype_type] or {}
  self.descriptions[prototype_type][prototype_name] = locale_section .. "." .. locale_key
  prototype.factoriopedia_description = { locale_section .. "." .. locale_key }
end

function Registry:set_simulation(prototype_type, prototype_name, simulation_key)
  local prototype = data.raw[prototype_type] and data.raw[prototype_type][prototype_name]
  local simulation = self.content.simulations[simulation_key]
  if not prototype or not simulation then return end

  self.simulations[prototype_type] = self.simulations[prototype_type] or {}
  self.simulations[prototype_type][prototype_name] = simulation_key
  prototype.factoriopedia_simulation = simulation
end

local function contains_locale_key(value, expected_locale)
  if value == expected_locale then return true end
  if type(value) ~= "table" then return false end

  for _, part in ipairs(value) do
    if contains_locale_key(part, expected_locale) then return true end
  end
  return false
end

function Registry:assert_autoplace_control_label(control_name)
  local control = data.raw["autoplace-control"] and data.raw["autoplace-control"][control_name]
  if not control then
    error("Missing FluxWorks autoplace control for worldgen validation: " .. control_name)
  end

  local expected_locale = "autoplace-control-names." .. control_name
  if type(control.localised_name) ~= "table" then
    error("FluxWorks autoplace control is missing structured localised_name: " .. control_name)
  end
  if not contains_locale_key(control.localised_name, expected_locale) then
    error("FluxWorks autoplace control label drifted from its locale key: " .. control_name)
  end
end

function Registry:assert_resource_worldgen_entry(resource_name, control_name)
  if not (self.descriptions.resource and self.descriptions.resource[resource_name]) then
    error("Missing FluxWorks Factoriopedia resource description: " .. resource_name)
  end
  if not (self.simulations.resource and self.simulations.resource[resource_name]) then
    error("Missing FluxWorks Factoriopedia resource simulation: " .. resource_name)
  end
  self:assert_autoplace_control_label(control_name)
end

return Registry
