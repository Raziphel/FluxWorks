local Item=require("__razi_lib__/lib/item")
local Technology=require("__razi_lib__/lib/technology")
local IndustrialIcons=require("prototypes.lib.industrial-icons")
-- Spectrum Industries: alternative production routes, not another science ladder.
-- Each process is unlocked by an existing engineering technology and runs in
-- existing FluxWorks machinery. No new mandatory intermediates or global edits.
--
-- A single registration pass is intentionally cheap, even with large planet packs.
local spectra = {
  purple = "fw-purple-flux",
  yellow = "fw-yellow-flux",
  red = "fw-red-flux",
  green = "fw-green-flux",
}

local function find_item(name)
  local found=Item.optional(name)
  if found then return found:raw(),name end
  -- Preserve the original K2SO alias fallback for non-FluxWorks outputs.
  if name:sub(1,3)~="fw-" and name:sub(1,3)~="kr-" then
    return find_item("kr-"..name)
  end
end

local function resolve_ingredients(entries)
  local ingredients, liquid_count = {}, 0
  for _, source in ipairs(entries) do
    local ingredient = table.deepcopy(source)
    if ingredient.type == "fluid" then
      if not (data.raw.fluid and data.raw.fluid[ingredient.name]) then
        return
      end
      liquid_count = liquid_count + 1
    else
      local _, resolved = find_item(ingredient.name)
      if not resolved then return end
      ingredient.name = resolved
    end
    ingredients[#ingredients + 1] = ingredient
  end
  -- Our synthesis plant and arc foundry each have two input fluid boxes.
  if liquid_count > 2 then return end
  return ingredients
end

local function item(name, amount)
  return {type = "item", name = name, amount = amount}
end

local function fluid(name, amount)
  return {type = "fluid", name = name, amount = amount}
end

local processes = {
  -- PURPLE: upgrade high-value components rather than conjure raw materials.
  {
    id = "circuit-annealing", spectrum = "purple",
    technology = "fw-flux-phase-engineering", category = "fw-flux-synthesis",
    time = 12, product = "processing-unit", yield = 4,
    inputs = {item("advanced-circuit", 8), item("fw-sensor-package", 3),
      item("electronic-circuit", 12), fluid(spectra.purple, 65)},
  },
  {
    id = "superconductor-alignment", spectrum = "purple",
    technology = "fw-superconductive-systems", category = "fw-flux-synthesis",
    time = 10, product = "superconductor", yield = 8,
    inputs = {item("copper-cable", 40), item("fw-stabilized-flux-crystal", 2),
      fluid(spectra.purple, 60)},
  },
  {
    id = "lattice-weaving", spectrum = "purple",
    technology = "fw-flux-resonance", category = "fw-flux-synthesis",
    time = 12, product = "fw-flux-lattice", yield = 5,
    inputs = {item("fw-stabilized-flux-crystal", 4), item("fw-metal-mesh", 4),
      fluid(spectra.purple, 50), fluid(spectra.yellow, 30)},
  },

  -- YELLOW: precise chemical and electronic manufacturing.
  {
    id = "polymer-catalysis", spectrum = "yellow",
    technology = "fw-flux-chemical-synthesis", category = "fw-flux-synthesis",
    time = 10, product = "plastic-bar", yield = 14,
    inputs = {item("coal", 8), item("fw-resin", 3),
      fluid(spectra.yellow, 35), fluid("sulfuric-acid", 20)},
  },
  {
    id = "battery-electroforming", spectrum = "yellow",
    technology = "fw-fulgora-electrochemistry", category = "fw-flux-synthesis",
    time = 11, product = "battery", yield = 8,
    inputs = {item("copper-plate", 6), item("iron-plate", 6),
      item("fw-salt", 2), fluid(spectra.yellow, 28), fluid("sulfuric-acid", 30)},
  },
  {
    id = "sensor-photolithography", spectrum = "yellow",
    technology = "fw-sensor-integration", category = "fw-flux-synthesis",
    time = 13, product = "fw-sensor-package", yield = 4,
    inputs = {item("fw-circuit-substrate", 5), item("fw-lens-array", 2),
      item("fw-capacitor", 2), fluid(spectra.yellow, 42)},
  },

  -- RED: costly energy, dense output, serious industrial throughput.
  {
    id = "arc-steel-reduction", spectrum = "red",
    technology = "fw-flux-metallurgy", category = "fw-arc-smelting",
    time = 9, product = "steel-plate", yield = 4,
    inputs = {item("iron-plate", 12), item("fw-carbon", 5),
      fluid(spectra.red, 34)},
  },
  {
    id = "structural-flux-casting", spectrum = "red",
    technology = "fw-vulcanus-industrial-symbiosis", category = "fw-arc-smelting",
    time = 16, product = "low-density-structure", yield = 3,
    inputs = {item("copper-plate", 36), item("steel-plate", 6),
      item("fw-resin", 6), item("fw-cermet", 2), fluid(spectra.red, 75)},
  },
  {
    id = "propellant-intensification", spectrum = "red",
    technology = "fw-propellant-synthesis", category = "fw-flux-synthesis",
    time = 12, product = "rocket-fuel", yield = 3,
    inputs = {item("solid-fuel", 20), item("fw-gunpowder", 4),
      fluid(spectra.red, 60), fluid("light-oil", 40)},
  },

  -- GREEN: convert renewable biomass and waste into useful factory inputs.
  {
    id = "resin-bioreclamation", spectrum = "green",
    technology = "fw-flux-green-cultivation", category = "fw-flux-synthesis",
    time = 10, product = "fw-resin", yield = 6,
    inputs = {item("spoilage", 18), item("nutrients", 12),
      fluid(spectra.green, 35)},
  },
  {
    id = "carbon-fiber-cultivation", spectrum = "green",
    technology = "fw-gleba-regenerative-symbiosis", category = "fw-flux-synthesis",
    time = 13, product = "carbon-fiber", yield = 5,
    inputs = {item("yumako-mash", 20), item("fw-resin", 3),
      fluid(spectra.green, 45)},
  },
  {
    id = "bioflux-fermentation", spectrum = "green",
    technology = "fw-flux-green-propagation", category = "fw-flux-synthesis",
    time = 15, product = "bioflux", yield = 2,
    inputs = {item("spoilage", 20), item("nutrients", 16),
      item("fw-nutrient-bed", 2), fluid(spectra.green, 45)},
  },

  -- Dual-spectrum processes reward shared logistics without creating another
  -- tier of intermediates. Both coloured inputs are always consumed.
  {
    id = "chromatic-cermet", spectrum = "red", partner = "yellow",
    technology = "fw-cross-planetary-industrial-convergence",
    category = "fw-arc-smelting", time = 18,
    product = "fw-cermet", yield = 6,
    inputs = {item("steel-plate", 8), item("copper-plate", 14),
      item("fw-carbon", 4), fluid(spectra.red, 40), fluid(spectra.yellow, 30)},
  },
  {
    id = "chromatic-resonance", spectrum = "purple", partner = "green",
    technology = "fw-cross-planetary-industrial-convergence",
    category = "fw-flux-synthesis", time = 20,
    product = "fw-resonance-substrate", yield = 4,
    inputs = {item("fw-circuit-substrate", 4), item("fw-flux-lattice", 3),
      item("fw-sensor-package", 2), fluid(spectra.purple, 45),
      fluid(spectra.green, 50)},
  },
}

local added = 0
for index, spec in ipairs(processes) do
  local recipe_name = "fw-spectrum-" .. spec.id
  local technology = data.raw.technology and data.raw.technology[spec.technology]
  local product, product_name = find_item(spec.product)
  local ingredients = resolve_ingredients(spec.inputs)
  local category = data.raw["recipe-category"] and data.raw["recipe-category"][spec.category]
  local icons = product and IndustrialIcons.spectrum(product,spec.spectrum,spec.partner,"catalog")

  if technology and product and category and ingredients and icons then
    if not (data.raw.recipe and data.raw.recipe[recipe_name]) then
      local preferred_subgroup = "fw-flux-" .. spec.spectrum
      local subgroup = data.raw["item-subgroup"][preferred_subgroup]
        and preferred_subgroup or product.subgroup or "intermediate-product"
      data:extend({{
        type = "recipe", name = recipe_name, icons = icons,
        localised_name = {"recipe-name." .. recipe_name},
        localised_description = {"recipe-description." .. recipe_name},
        category = spec.category, subgroup = subgroup,
        order = ("z[spectrum-industries]-%02d"):format(index),
        enabled = false, energy_required = spec.time,
        allow_productivity = false, auto_recycle = false,
        ingredients = ingredients,
        results = {item(product_name, spec.yield)},
        main_product = product_name,
      }})
    end
    Technology.get(spec.technology):unlock(recipe_name)
    added = added + 1
  else
    log("FluxWorks Spectrum Industries: skipping " .. recipe_name .. " (missing optional prototype)")
  end
end

log("FluxWorks Spectrum Industries: " .. added .. " industrial alternatives registered")
