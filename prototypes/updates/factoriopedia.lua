local function set_factoriopedia_description(prototype_type, prototype_name, locale_key)
  if not (data.raw[prototype_type] and data.raw[prototype_type][prototype_name]) then
    return
  end
  data.raw[prototype_type][prototype_name].factoriopedia_description = { "fw-factoriopedia." .. locale_key }
end

-- Rocket reusability entries
set_factoriopedia_description("item", "incomplete-rocket-part", "incomplete-rocket-part")
set_factoriopedia_description("item", "rocket-chunk", "rocket-chunk-item")
set_factoriopedia_description("item", "remnant-beacon", "remnant-beacon-item")
set_factoriopedia_description("item", "fw-rocket-avionics", "fw-rocket-avionics-item")
set_factoriopedia_description("item", "fw-rocket-heatshield", "fw-rocket-heatshield-item")
set_factoriopedia_description("asteroid", "used-rocket-asteroid", "used-rocket-asteroid")
set_factoriopedia_description("asteroid-chunk", "rocket-chunk", "rocket-chunk-asteroid")
set_factoriopedia_description("radar", "remnant-beacon", "remnant-beacon-entity")
set_factoriopedia_description("recipe", "incomplete-rocket-part", "incomplete-rocket-part-recipe")
set_factoriopedia_description("recipe", "rocket-chunk-processing", "rocket-chunk-processing-recipe")
set_factoriopedia_description("recipe", "remnant-beacon", "remnant-beacon-recipe")
set_factoriopedia_description("recipe", "fw-rocket-avionics", "fw-rocket-avionics-recipe")
set_factoriopedia_description("recipe", "fw-rocket-heatshield", "fw-rocket-heatshield-recipe")
set_factoriopedia_description("technology", "rocket-chunk-processing", "rocket-chunk-processing-technology")
set_factoriopedia_description("technology", "remnant-beacon", "remnant-beacon-technology")

-- FluxWorks entries
set_factoriopedia_description("item", "fw-crystalised-flux", "fw-crystalised-flux-item")
set_factoriopedia_description("item", "fw-flux-quarry", "fw-flux-quarry-item")
set_factoriopedia_description("item", "fw-rocket-engine", "fw-rocket-engine-item")
set_factoriopedia_description("item", "fw-transformer-core", "fw-transformer-core-item")
set_factoriopedia_description("item", "fw-flux-resonance-cell", "fw-flux-resonance-cell-item")
set_factoriopedia_description("item", "fw-flux-phase-manifold", "fw-flux-phase-manifold-item")
set_factoriopedia_description("item", "fw-flux-condenser", "fw-flux-condenser-item")
set_factoriopedia_description("resource", "fw-crystalised-flux", "fw-crystalised-flux-resource")
set_factoriopedia_description("resource", "fw-metallic-deposit", "fw-metallic-deposit-resource")
set_factoriopedia_description("resource", "fw-mineral-deposit", "fw-mineral-deposit-resource")
set_factoriopedia_description("resource", "fw-carbonic-deposit", "fw-carbonic-deposit-resource")
set_factoriopedia_description("recipe", "fw-flux-quarry", "fw-flux-quarry-recipe")
set_factoriopedia_description("recipe", "fw-flux-condenser", "fw-flux-condenser-recipe")
set_factoriopedia_description("mining-drill", "fw-flux-quarry", "fw-flux-quarry-entity")
set_factoriopedia_description("assembling-machine", "fw-flux-condenser", "fw-flux-condenser-entity")
set_factoriopedia_description("fluid", "fw-purple-flux", "fw-purple-flux-fluid")
set_factoriopedia_description("technology", "fw-comminution", "fw-comminution-technology")
set_factoriopedia_description("technology", "fw-flux-extraction", "fw-flux-extraction-technology")
set_factoriopedia_description("technology", "fw-flux-mining-productivity", "fw-flux-mining-productivity-technology")
set_factoriopedia_description("technology", "fw-material-foundations", "fw-material-foundations-technology")
set_factoriopedia_description("technology", "fw-systems-integration", "fw-systems-integration-technology")
set_factoriopedia_description("technology", "fw-flux-resonance", "fw-flux-resonance-technology")
set_factoriopedia_description("technology", "fw-flux-synthesis", "fw-flux-synthesis-technology")
